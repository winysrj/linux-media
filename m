Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1K66xn-0000mV-K5
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 18:44:54 +0200
Received: from PCTL ([194.250.18.140]) (authenticated)
	by smtp01.msg.oleane.net (MTA) with ESMTP id m5AGimoM008832
	for <linux-dvb@linuxtv.org>; Tue, 10 Jun 2008 18:44:48 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 10 Jun 2008 18:44:46 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAkkyE7yn9y0ia0xQ592ACdAEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Subject: [linux-dvb] Bug report: Wrong bandwidth returned in dib3000mc and
	dib7000m
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

This report describes a small bug in dib3000mc and dib7000m with DVB-T tuners.
The problem does not exist with dib7000p.

In both faulty drivers, when reading back the tuning info (ioctl FE_GET_FONTEND),
the returned value is incorrect for the bandwidth parameter. All other returned
values are correct.

With dib7000p, the returned value for bandwidth is correct.

Distro: Fedora 8
Kernel: 2.6.24.7-92.fc8
Linux DVB: hg update June 9 2008
DIB firmware: dvb-usb-dib0700-1.10.fw

The source code for a test program is included at the end of this report.
It take two optional parameters: the frontend device name and a frequency.
The program tunes on the specified frequency, leaving all other tuning
parameters to "auto". After ensuring the signal is locked, the current
tuning parameters are read and displayed.

This program was tested on the following three devices:

1) Pinnacle 72e 1100 (DiBcom 7000PC)
2) Hauppauge Nova-T 500 (DiBcom 3000MC/P)
3) Hauppauge Nova-T Stick rev 70001 (DiBcom 7000MA/MB/PA/PB/MC)

In all cases, the returned values are the expected enumeration values,
according to the specified transport (french DTTV network), except
for the bandwidth:

1) BANDWIDTH_8_MHZ -> OK
2) BANDWIDTH_AUTO -> actual bandwidth not returned
3) 8000 -> integer value instead of enum BANDWIDTH_8_MHZ

Complete output and source code follow.

Regards,
-Thierry

-------------------------------------------------------------------------------
Testing a Pinnacle 72e 1100

Frontend: /dev/dvb/adapter3/frontend0
Hardware: DiBcom 7000PC
Carrier frequency:  474000000 Hz
Spectral inversion: 2  <- enum INVERSION_AUTO
Bandwidth:          0  <- enum BANDWIDTH_8_MHZ
High priority FEC:  2  <- enum FEC_2_3
Low priority FEC:   1  <- enum FEC_1_2
Constellation:      3  <- enum QAM_64
Transmission mode:  1  <- enum TRANSMISSION_MODE_8K
Guard interval:     0  <- enum GUARD_INTERVAL_1_32
Hierarchy:          0  <- enum HIERARCHY_NONE

Testing an Hauppauge Nova-T 500 (second tuner)

Frontend: /dev/dvb/adapter1/frontend0
Hardware: DiBcom 3000MC/P
Carrier frequency:  474000000 Hz
Spectral inversion: 2
Bandwidth:          3  <- enum BANDWIDTH_AUTO, expected BANDWIDTH_8_MHZ
High priority FEC:  2
Low priority FEC:   1
Constellation:      3
Transmission mode:  1
Guard interval:     0
Hierarchy:          0

Testing an Hauppauge Nova-T Stick rev 70001

Frontend: /dev/dvb/adapter2/frontend0
Hardware: DiBcom 7000MA/MB/PA/PB/MC
Carrier frequency:  474000000 Hz
Spectral inversion: 2
Bandwidth:          8000  <- integer value, not enum, expected BANDWIDTH_8_MHZ
High priority FEC:  2
Low priority FEC:   1
Constellation:      3
Transmission mode:  1
Guard interval:     0
Hierarchy:          0

-------------------------------------------------------------------------------
Source code:

// syntax: tunetest [frontend-name [frequency]]
// default frequency: 474 Mhz, ie UHF channel 21, ie first UHF channel

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <linux/dvb/frontend.h>


int main (int argc, char* argv[])
{
    const char* name = argc >= 2 ? argv[1] : "/dev/dvb/adapter0/frontend0";
    int freq = argc >= 3 ? atoi (argv[2]) : 474000000;

    int fd, count;
    fe_status_t status;
    struct dvb_frontend_info info;
    struct dvb_frontend_parameters params;

    // Open frontend
    if ((fd = open (name, O_RDWR)) < 0) {
        perror (name);
        return EXIT_FAILURE;
    }

    // Get frontend type, make sure it is DVB-T
    if (ioctl (fd, FE_GET_INFO, &info) < 0) {
        perror ("ioctl FE_GET_INFO");
        return EXIT_FAILURE;
    }
    printf ("Frontend: %s\n", name);
    printf ("Hardware: %s\n", info.name);
    if (info.type != FE_OFDM) {
        return EXIT_FAILURE;
    }

    // Tune to frequency, auto-demodulate
    params.frequency = freq;
    params.inversion = INVERSION_AUTO;
    params.u.ofdm.bandwidth = BANDWIDTH_AUTO;
    params.u.ofdm.code_rate_HP = FEC_AUTO;
    params.u.ofdm.code_rate_LP = FEC_AUTO;
    params.u.ofdm.constellation = QAM_AUTO;
    params.u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
    params.u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
    params.u.ofdm.hierarchy_information = HIERARCHY_AUTO;

    if (ioctl (fd, FE_SET_FRONTEND, &params) < 0) {
        perror ("ioctl FE_SET_FONTEND");
        return EXIT_FAILURE;
    }

    // Wait at most 5 seconds until signal is locked
    status = 0;
    for (count = 5; count > 0 && (status & FE_HAS_LOCK) == 0; --count) {
        if (ioctl (fd, FE_READ_STATUS, &status) < 0) {
            perror ("ioctl FE_READ_STATUS");
            return EXIT_FAILURE;
        }
        sleep (1);
    }
    if ((status & FE_HAS_LOCK) == 0) {
        fprintf (stderr, "no signal\n");
        return EXIT_FAILURE;
    }

    // Get current tuning info
    if (ioctl (fd, FE_GET_FRONTEND, &params) < 0) {
        perror ("ioctl FE_GET_FONTEND");
        return EXIT_FAILURE;
    }
    printf ("Carrier frequency:  %u Hz\n", params.frequency);
    printf ("Spectral inversion: %d\n", params.inversion);
    printf ("Bandwidth:          %d\n", params.u.ofdm.bandwidth);
    printf ("High priority FEC:  %d\n", params.u.ofdm.code_rate_HP);
    printf ("Low priority FEC:   %d\n", params.u.ofdm.code_rate_LP);
    printf ("Constellation:      %d\n", params.u.ofdm.constellation);
    printf ("Transmission mode:  %d\n", params.u.ofdm.transmission_mode);
    printf ("Guard interval:     %d\n", params.u.ofdm.guard_interval);
    printf ("Hierarchy:          %d\n", params.u.ofdm.hierarchy_information);

    close (fd);

    return EXIT_SUCCESS;
}


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
