Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0062.b.hostedemail.com ([64.98.42.62]:54634 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753228Ab2JUMaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 08:30:17 -0400
Date: Sun, 21 Oct 2012 12:30:15 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: zonque@gmail.com
Cc: bp@alien8.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, security@kernel.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Message-ID: <317435358.100327.1350822615555.JavaMail.mail@webmail20>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic>
 <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
 <20121021002424.GA16247@liondog.tnic>
 <1798605268.19162.1350784641831.JavaMail.mail@webmail17>
 <20121021110851.GA6504@liondog.tnic>
 <121566322.100103.1350820776893.JavaMail.mail@webmail20>
 <5083E4AA.3060807@gmail.com>
Subject: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 21, 2012, Daniel Mack wrote: 

> A hint at least. How did you enable the audio record exactly? Can you
> reproduce this with arecord?
> 
> What chipset are you on? Please provide both "lspci -v" and "lsusb -v"
> dumps. As I said, I fail to reproduce that issue on any of my machines.

All other applications can read from the USB audio without problems, it's
just something in the way Adobe Flash polls my audio input which causes
a crash.

Just video capture (without audio) works just fine in Adobe Flash.

Only and only when I choose to use 

USB Device 0x46d:0x81d my system crashes in Adobe Flash.

See the screenshot:

https://bugzilla.kernel.org/attachment.cgi?id=84151

My hardware information can be fetched from here:

https://bugzilla.kernel.org/show_bug.cgi?id=49181

On a second thought that can be even an ALSA crash or pretty much
anything else.
