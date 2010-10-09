Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1981 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab0JIJsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 05:48:00 -0400
From: Joris van Rantwijk <jorispubl@xs4all.nl>
To: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 1/2] IR/lirc: further ioctl portability fixups
Date: Sat, 9 Oct 2010 11:47:25 +0200
Cc: linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net
References: <20101008211235.GF5165@redhat.com>
In-Reply-To: <20101008211235.GF5165@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010091147.25562.jorispubl@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, October 08, 2010 23:12:35 Jarod Wilson wrote:
> I've dropped the .compat_ioctl addition from Joris' original patch,
> as I swear the non-compat definition should now work for both 32-bit
> and 64-bit userspace. Technically, I think we still need/want a
> Signed-off-by: from Joris here. Joris? (And sorry for the lengthy
> delay in getting a reply to you).

No. I just tested the patch and it does not work without .compat_ioctl.
I get this error:

[  313.614017] ioctl32(irrecord:4490): Unknown cmd fd(4) cmd(80046900 {t:'i';sz:4} arg(080705e8) on /dev/lirc0
irrecord: could not get hardware features
irrecord: this device driver does not support the new LIRC interface
irrecord: major number of /dev/lirc0 is 252
irrecord: LIRC major number is 61
irrecord: check if /dev/lirc0 is a LIRC device
irrecord: could not init hardware (lircd running ? --> close it, check permissions)

On the other hand it works fine when .compat_ioctl is added to ir_lirc_codec.c and lirc_dev.c and 
lirc_serial.c.

Regards,
Joris.
