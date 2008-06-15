Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hu-out-0506.google.com ([72.14.214.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1K7qz4-0002pV-DL
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 14:05:23 +0200
Received: by hu-out-0506.google.com with SMTP id 23so6563920huc.11
	for <linux-dvb@linuxtv.org>; Sun, 15 Jun 2008 05:05:18 -0700 (PDT)
Message-ID: <de8cad4d0806150505k6b865dedq359d278ab467c801@mail.gmail.com>
Date: Sun, 15 Jun 2008 08:05:17 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] cx18 - dmesg errors and ir transmit
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

I use SageTV and upon launch it initializes the adapters resulting in
the following error messages in dmesg:

[   36.371502] compat_ioctl32: VIDIOC_G_EXT_CTRLSioctl32(java:7613):
Unknown cmd fd(13) cmd(c0185647){t:'V';sz:24} arg(caafeaf0) on
/dev/video1
[   36.373068] compat_ioctl32: VIDIOC_S_AUDIOioctl32(java:7613):
Unknown cmd fd(13) cmd(40345622){t:'V';sz:52} arg(caaffbfc) on
/dev/video1
[   29.311447] compat_ioctl32: VIDIOC_G_EXT_CTRLSioctl32(java:7613):
Unknown cmd fd(18) cmd(c0185647){t:'V';sz:24} arg(caafeaf0) on
/dev/video0
[   29.312857] compat_ioctl32: VIDIOC_S_AUDIOioctl32(java:7613):
Unknown cmd fd(18) cmd(40345622){t:'V';sz:52} arg(caaffbfc) on
/dev/video0

I contacted SageTV about the error and was told they don't affect
anything, but I would like to make sure that is the case.

Also, I have noticed a new message in dmesg indicating that ir
transmitters may now be accessible? Is there anything I need to do to
make use of them?

tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter

Thanks!

Brandon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
