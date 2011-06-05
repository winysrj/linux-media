Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:14141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab1FEMFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jun 2011 08:05:37 -0400
Message-ID: <4DEB710B.4090704@redhat.com>
Date: Sun, 05 Jun 2011 09:05:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
CC: linux-media@vger.kernel.org,
	"Igor M. Liplianin" <liplianin@tut.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: XC4000: setting registers
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com> <4DEA4B6A.70602@mailbox.hu>
In-Reply-To: <4DEA4B6A.70602@mailbox.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Istvan,

Em 04-06-2011 12:12, istvan_v@mailbox.hu escreveu:
> This patch implements setting the registers in xc4000_set_params()
> and xc4000_set_analog_params(). A new register is defined which enables
> filtering of the composite video output (this is needed to avoid bad
> picture quality with some boards).
> 
> Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>
> 

This one breaks compilation:

drivers/media/common/tuners/xc4000.c: In function ‘xc4000_set_analog_params’:
drivers/media/common/tuners/xc4000.c:1340: error: ‘type’ undeclared (first use in this function)
drivers/media/common/tuners/xc4000.c:1340: error: (Each undeclared identifier is reported only once
drivers/media/common/tuners/xc4000.c:1340: error: for each function it appears in.)
make[3]: ** [drivers/media/common/tuners/xc4000.o] Erro 1
make[2]: ** [drivers/media/common/tuners] Erro 2
make[1]: ** [drivers/media/common] Erro 2
make: ** [drivers/media/] Erro 2

We should not allow that a patch in the middle of a series to break the compilation,
as this breaks git bisect command. I fixed it with a hack.

All patches you've sent were added at my experimental tree, including the one that
added a card type inside the struct.

I had to rebase the tree with:

git filter-branch -f --env-filter '{ GIT_AUTHOR_NAME="Istvan Varga"; GIT_AUTHOR_EMAIL="istvan_v@mailbox.hu"; export GIT_AUTHOR_NAME;}' ^3be84e2e789af734a35ad0559c2d7c4931d0fe91^ HEAD 

As your emails are being sent without your name on it (from is: istvan_v@mailbox.hu <istvan_v@mailbox.hu>).

I didn't made any review of them. Please let me know when you finish submitting
the patches for me to do a review at the resulting code.

Ah, I'd appreciate if you could fix your emails. It takes me some time to
reformat the patches, as you're sending the patches as attachments, but my
email scripts aren't ready for patches with multiple mime types. Patchwork
might help, but it also got only 4 patches from you (not sure if this is due
to patchwork bugs or due to the attachments). It also helps if you could add
[PATCH] at the email subject. I'm setting a backup process due to the constant
patchwork failures, but my alternative logic relies on having [PATCH] at the
subject logic, to move the patches into a separate mail directory.

thanks,
Mauro.

