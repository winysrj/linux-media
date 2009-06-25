Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57524 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbZFYMbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 08:31:32 -0400
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 073EE3814F2
	for <linux-media@vger.kernel.org>; Thu, 25 Jun 2009 08:31:36 -0400 (EDT)
Message-Id: <1245933095.4412.1322111679@webmail.messagingengine.com>
From: "Daniel" <zhennian@fastmail.fm>
To: "linux-media" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: DVICO Fusion Dual Express DVB-T - Australian Channel Problems
Date: Thu, 25 Jun 2009 22:31:35 +1000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I've been working to get my DVICO Fusion Express DVB-T (rev 02)
PCIe tv capture card working for a few months now.

I've had some success with the
[1]http://linuxtv.org/hg/~stoth/v4l-dvb-cx23885 repository on
linuxtv.org, managing to get the remote to work and most channels
to tune reasonably reliably. Thanks to Steve for the great work
on this.

Im using the xc3028-v27.fw firmware file and kernel version
2.6.28-13-generic under jaunty.

lspci entry is:-
04:00.0 Multimedia video controller [0400]: Conexant Systems,
Inc. CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)

After some troubleshooting, it seems that channels tune fine
after a reload of the module, but otherwise the card will not
re-tune to another channel. You can tune once on each of the
receivers before they lock out and the module needs to be
reloaded.

I know my reception is fine because the WinFast DTV1000 in the
same machine is rock solid on all channels.

# modprobe cx23885
# tzap -a 1 -c channels.conf "SC10 Canberra"
using '/dev/dvb/adapter1/frontend0' and
'/dev/dvb/adapter1/demux0'
reading channels from file '/home/daniel/.me-tv/channels.conf'
tuning to 177500000 Hz
video pid 0x0161, audio pid 0x0162
status 00 | signal 5d6c | snr 0000 | ber 00000000 | unc 00000000
|
status 1e | signal b844 | snr f5f5 | ber 00000000 | unc 00000000
| FE_HAS_LOCK
status 1e | signal b834 | snr f5f5 | ber 00000000 | unc 00000000
| FE_HAS_LOCK
status 1e | signal b834 | snr f5f5 | ber 00000000 | unc 00000000
| FE_HAS_LOCK
status 1e | signal b840 | snr f5f5 | ber 00000000 | unc 00000000
| FE_HAS_LOCK
# rmmod cx23885
# modprobe cx23885
# tzap -a 1 -c channels.conf "ABC2"
using '/dev/dvb/adapter1/frontend0' and
'/dev/dvb/adapter1/demux0'
reading channels from file '/home/daniel/.me-tv/channels.conf'
tuning to 205625000 Hz
video pid 0x0903, audio pid 0x0904
status 00 | signal ae00 | snr 0000 | ber 00000000 | unc 00000000
|
status 1e | signal ba80 | snr f8f8 | ber 00000000 | unc 00000000
| FE_HAS_LOCK
status 1e | signal bad4 | snr f6f6 | ber 00000000 | unc 00000000
| FE_HAS_LOCK
status 1e | signal bacc | snr f6f6 | ber 00000000 | unc 00000000
| FE_HAS_LOCK

I noticed on some lists that someone has claimed success with the
main v4l-dvb repositorty, but this does not tune at all for me.

Daniel C

-- 
http://www.fastmail.fm - Email service worth paying for. Try it for free

