Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:13479 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3JNOHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 10:07:54 -0400
Date: Mon, 14 Oct 2013 11:07:48 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Tom Gundersen <teg@jklm.no>
Cc: "Juan J. Garcia de Soria" <skandalfo@gmail.com>,
	David =?UTF-8?B?SMOk?= =?UTF-8?B?cmRlbWFu?= <david@hardeman.nu>,
	Sean Young <sean@mess.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: WPC8769L (WEC1020) support in winbond-cir?
Message-id: <20131014110748.366ea45e@samsung.com>
In-reply-to: <CAG-2HqX-TO7h8zJ6F01r2LfRVjQtb0pK_1wKGsYVKzB0zC7TQA@mail.gmail.com>
References: <CAG-2HqX-TO7h8zJ6F01r2LfRVjQtb0pK_1wKGsYVKzB0zC7TQA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

Em Mon, 14 Oct 2013 15:16:20 +0200
Tom Gundersen <teg@jklm.no> escreveu:

> Hi David and Juan,
> 
> I'm going through the various out-of-tree LIRC drivers to see if we
> can stop shipping them in Arch Linux [0]. So far it appears we can
> drop all except for lirc_wpc8769l [1] (PnP id WEC1020).

Please copy the Linux Media ML to all Remote Controller drivers. There's
where we're discussing those drivers. No need to c/c linux-input.

Yeah, both lirc_atiusb and lirc_i2c were now obsoleted by upstream
non-staging drivers. I suggest to just drop it from Arch Linux.

Not sure about lirc_wpc8769l. David/Sean/Juan can have a better view.

Btw, there are also a number of lirc staging drivers under
drivers/staging/media/lirc/. We'd love some help trying to convert them
to use the rc core, moving them out of staging.

> 
> I noticed the comment in windownd-cir [2]:
> 
>  *  Currently supports the Winbond WPCD376i chip (PNP id WEC1022), but
>  *  could probably support others (Winbond WEC102X, NatSemi, etc)
>  *  with minor modifications.
> 
> What are your thoughts on adding support for WEC1020 upstream? Is
> anyone interested in doing this work (I sadly don't have the correct
> device, so can't really do it myself)?

> 
> Cheers,
> 
> Tom
> 
> [0]: <https://mailman.archlinux.org/pipermail/arch-dev-public/2013-October/025541.html>
> [1]: <http://sourceforge.net/p/lirc/git/ci/master/tree/drivers/lirc_wpc8769l/>
> [2]: <https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/media/rc/winbond-cir.c#n5>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Regards,
Mauro
