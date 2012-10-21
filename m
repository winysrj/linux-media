Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0129.b.hostedemail.com ([64.98.42.129]:46772 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753285Ab2JUL7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 07:59:39 -0400
Date: Sun, 21 Oct 2012 11:59:36 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bp@alien8.de
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	security@kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Message-ID: <121566322.100103.1350820776893.JavaMail.mail@webmail20>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic>
 <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
 <20121021002424.GA16247@liondog.tnic>
 <1798605268.19162.1350784641831.JavaMail.mail@webmail17>
 <20121021110851.GA6504@liondog.tnic>
Subject: Re: Re: Re: Re: Re: A reliable kernel panic (3.6.2) and system
 crash when visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 21, 2012, Borislav Petkov wrote:
>
> On Sun, Oct 21, 2012 at 01:57:21AM +0000, Artem S. Tashkinov wrote:
> > The freeze happens on my *host* Linux PC. For an experiment I decided
> > to check if I could reproduce the freeze under a virtual machine - it
> > turns out the Linux kernel running under it also freezes.
>
> I know that - but a freeze != oops - at least not necessarily. Which
> means it could very well be a different issue now that vbox is gone.
>
> Or, it could be the same issue with different incarnations: with vbox
> you get the corruptions and without it, you get the freezes. I'm
> assuming you do the same flash player thing in both cases?
>
> Here's a crazy idea: can you try to reproduce it in KVM?

OK, dismiss VBox altogether - it has a very buggy USB implementation, thus
it just hangs when trying to access my webcam.

What I've found out is that my system crashes *only* when I try to enable
usb-audio (from the same webcam) - I still have no idea how to capture a
panic message, but I ran

"while :; do dmesg -c; done" in xterm, then I got like thousands of messages
and I photographed my monitor:

http://imageshack.us/a/img685/9452/panicz.jpg

list_del corruption. prev->next should be ... but was ...

I cannot show you more as I have no serial console to use :( and the kernel
doesn't have enough time to push error messages to rsyslog and fsync
/var/log/messages
