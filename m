Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <geir.inge@gmail.com>) id 1JVu7o-0003hN-Mg
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 20:45:35 +0100
Received: by wa-out-1112.google.com with SMTP id m28so5886421wag.13
	for <linux-dvb@linuxtv.org>; Sun, 02 Mar 2008 11:45:23 -0800 (PST)
Message-ID: <ab58b93b0803021145j34f4ad49s980e4a30a97d20de@mail.gmail.com>
Date: Sun, 2 Mar 2008 20:45:22 +0100
From: "Geir Inge" <geir.inge@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] scan fails to detect pid's for streams
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

Hi

I run a system with a Nova-T-500 card, ubuntu server (gutsy).

scan picks up the cannels and outputs a tzap format file.

When I try to zap to a channel I get a lock, but no data is available
on /dev/dvb/adapter0/dvr0

Here is the output from tzap:

$ tzap -r nrk2
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 722000000 Hz
video pid 0x0000, audio pid 0x0000
status 0f | signal 913f | snr 0000 | ber 001fffff | unc 00000025 |
status 1f | signal 913c | snr 0000 | ber 00000000 | unc 00000006 | FE_HAS_LOCK

As you can see it tunes to pid 0 for both audio and video

Here is the channel data from the channel.conf file:

NRK2:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:102

This is the output written by scan for this channel:

0x0000 0x0066: pmt_pid 0x010d NTV -- NRK2 (running)

Please advice

GIH

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
