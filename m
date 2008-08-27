Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KYF7u-0005SW-IB
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 09:07:35 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6800245ZROSQE1@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 27 Aug 2008 03:07:00 -0400 (EDT)
Date: Wed, 27 Aug 2008 03:06:59 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <ed347ce40808262255s6bfc4f58ne2c8c00f56f95e44@mail.gmail.com>
To: David Schollmeyer <dschollmeyer@gmail.com>
Message-id: <48B4FD13.9030703@linuxtv.org>
MIME-version: 1.0
References: <ed347ce40808262255s6bfc4f58ne2c8c00f56f95e44@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 DVB Configuration
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

David Schollmeyer wrote:
> Hi,
> 
> I have the Hauppauge HVR-1800 that I am trying to get setup. I can get
> the tuner to work on NTSC analog with my local cable provider (Cox
> Communications - Phoenix, AZ). I am trying to get the ATSC/QAM tuner
> to work with Cox as well. From what I've read, I should be able to get
> all of the unencrypted DTV local channels from Cox but I cannot figure
> out how to do so.
> 
> Following the steps at
> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device, I
> created the following channels.conf file:
> KASW-DT:537000000:QAM_256:33:36
> KSAZ-DT:537000000:QAM_256:49:52
> KNXV-DT:555000000:QAM_256:33:36
> KPHO-DT:555000000:QAM_256:49:52
> KAET-DT-1:567000000:QAM_256:33:34
> KPNX-DT:567000000:QAM_256:49:52
> KAET-DT-2:567000000:QAM_256:67:70
> 
> I've tried running azap 'KAET-DT-2' gives:
> 
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 567000000 Hz
> video pid 0x0043, audio pid 0x0046
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> ...
> 

This looks normal. I do this in NY with Cablevision with the HVR1800 and 
it's working very well for me (and others).

> Any help on what may be wrong would be appreciated.


Chances are the streams you expect to see are encrypted. It's difficult 
to say without looking at the packets. mplayer cannot play encrypted 
streams. The other possibility is that you have the audio and video pids 
set incorrectly in your channels.conf file, this would also cause 
mplayer not to be able to play the stream correctly.

Try some other frequencies.

Also run dvbtraffic to see the packet traffic distribution across the 
pids. The video pids will have a lot more packets per second than audio, 
this may help you diagnose the problem.

I assume the channel names, pid values and service numbers in your 
channels.conf are accurate. Did this come as a result of running the 
scan app, or something else?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
