Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35975 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbKVNqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2015 08:46:19 -0500
Received: by oiww189 with SMTP id w189so96213736oiw.3
        for <linux-media@vger.kernel.org>; Sun, 22 Nov 2015 05:46:18 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 22 Nov 2015 13:46:18 +0000
Message-ID: <CAK2bqVK_oHK1F9Us5Vc_9JCPz2TVm+P3rjX-6U7WFoW9aJB0Sg@mail.gmail.com>
Subject: VRC-1100 Vista MCE Remote Control: 05a4:9881
From: Chris Rankin <rankincj@googlemail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-dvb@linuxtv.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've bought a VRC-110 MCE IR remote control (USB IDs 05a4:9881) to
replace a broken Hauppauge RC5 remote, and have *finally* managed to
get it working with VDR. However, this has involved doing things like
writing a userspace "muxing" device to unify the IR's separate
keyboard and mouse devices, writing several custom udev rules,
tweaking the values in /etc/vdr/remote.conf and configuring Xorg to
ignore all the new input devices. This was *considerably* more work
than I was expecting to need to do for an IR which other people seem
to be using quite happily already.

Can anyone with one of these IRs tell me how they've managed to use it please?

Everything would have been simplified enormously if this IR had been
picked up by the mceusb driver, and not by the generic usbhid. Is this
possible, please?

Thanks for any help here,
Cheers,
Chris
