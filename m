Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.232])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JprMU-0001CL-AZ
	for linux-dvb@linuxtv.org; Sat, 26 Apr 2008 22:51:11 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2790929rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 26 Apr 2008 13:51:06 -0700 (PDT)
Message-ID: <d9def9db0804261351l7cb47ad7s457f67db5b423cb2@mail.gmail.com>
Date: Sat, 26 Apr 2008 22:51:05 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steffen Schulz" <pepe_ml@gmx.net>
In-Reply-To: <20080426202638.GA27566@cbg.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080426141433.GA14917@cbg.dyndns.org>
	<d9def9db0804261236l527b7deew67d1c9df4ea66460@mail.gmail.com>
	<20080426202638.GA27566@cbg.dyndns.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] crash with terratec cinergy hybrid XS [0ccd:0042]
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

On 4/26/08, Steffen Schulz <pepe_ml@gmx.net> wrote:
> On 080426 at 21:40, Markus Rechberger wrote:
> > you might try
> >
> > hg clone http://mcentral.de/hg/~mrec/em28xx-new
> >
> > this is a full inkernel driver.
>
>
> To resolve dependencies, I manually compiled and copied the drivers
> in the subdirectories, too. The driver seems to load okay, but I'm
> unable to scan channels:
>
> | root@# scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/de-Ruhrgebiet >
> .tzap/channels.conf
> |
> | scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/de-Ruhrgebiet
> | using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> | initial transponder 538000000 0 2 9 1 1 3 0
> | initial transponder 586000000 0 2 9 1 1 3 0
> | initial transponder 722000000 0 2 9 1 1 3 0
> | initial transponder 746000000 0 2 9 1 1 3 0
> | initial transponder 690000000 0 2 9 1 1 3 0
> | initial transponder 506000000 0 2 9 1 1 2 0
> | initial transponder 674000000 0 2 9 1 1 3 0
> | initial transponder 778000000 0 2 9 1 1 2 0
> | >>> tune to:
> 538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> | WARNING: >>> tuning failed!!!
> | >>> tune to:
> 538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> (tuning failed)
> | WARNING: >>> tuning failed!!!
>
> channels.conf is empty. dmesg:
>
> | Linux video capture interface: v2.00
> | em28xx v4l2 driver version 0.0.1 loaded
> | em28xx new video device (0ccd:0042): interface 0, class 255
> | em28xx: device is attached to a USB 2.0 bus
> | em28xx #0: Alternate settings: 8
> | em28xx #0: Alternate setting 0, max size= 0
> | em28xx #0: Alternate setting 1, max size= 0
> | em28xx #0: Alternate setting 2, max size= 1448
> | em28xx #0: Alternate setting 3, max size= 2048
> | em28xx #0: Alternate setting 4, max size= 2304
> | em28xx #0: Alternate setting 5, max size= 2580
> | em28xx #0: Alternate setting 6, max size= 2892
> | em28xx #0: Alternate setting 7, max size= 3072
> | input: em2880/em2870 remote control as /devices/virtual/input/input20
> | em28xx-input.c: remote control handler attached
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 ff
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 ff
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 fb
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 7b
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 79
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 79
> | manual gpio
> | ------ on off command -----
> | writing gpio: 04 04
> | manual gpio
> | trying to set disabled gpio? (00)
> | unable to attach tuner

cd xc3028
make
insmod xc3028-tuner.ko

and replug your device.

Markus
> | em28xx #0: V4L2 VBI device registered as /dev/vbi0
> | em28xx #0: V4L2 device registered as /dev/video0
> | em28xx #0: Found Terratec Hybrid XS
> | em28xx audio device (0ccd:0042): interface 1, class 1
> | em28xx audio device (0ccd:0042): interface 2, class 1
> | usbcore: registered new interface driver em28xx
> | em2880-dvb.c: DVB Init
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 7b
> | ts1 on
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 7a
> | tuner on
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 7a
> | demod reset
> | manual gpio
> | ------ resetting ---------
> | writing gpio: 04 04
> | writing gpio: 04 0c
> | DVB: registering new adapter (em2880 DVB-T)
> | DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
> | Em28xx: Initialized (Em2880 DVB Extension) extension
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 7a
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 7a
> | manual gpio
> | ------ on off command -----
> | writing gpio: 08 7a
>
>
> --
>        #
>  (o_  #                                                +49/1781384223
>  //\-x                                        gpg --recv-key A04D7875
>  V_/_    Use the source, Tux!             mailto: pepe@cbg.dyndns.org
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
