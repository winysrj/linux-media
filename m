Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53820 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbbKLRlz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 12:41:55 -0500
Date: Thu, 12 Nov 2015 15:41:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Alec Leamas <leamas.alec@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re:
Message-ID: <20151112154150.33a1979a@recife.lan>
In-Reply-To: <5644CD07.6020303@gmail.com>
References: <CABUpJt8ofQphD47-sVYmVjSbqJ91vEDyZk_hdnhc_RL+f95iog@mail.gmail.com>
	<5644AD42.4060904@users.sourceforge.net>
	<20151112152022.4f212b97@recife.lan>
	<5644CD07.6020303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 12 Nov 2015 18:31:51 +0100
Alec Leamas <leamas.alec@gmail.com> escreveu:

> On 12/11/15 18:20, Mauro Carvalho Chehab wrote:
> > Em Thu, 12 Nov 2015 18:16:18 +0300
> > Alberto Mardegan <mardy@users.sourceforge.net> escreveu:
> 
> > Complaining doesn't help at all. We don't read the mailing list to
> > check for new patches. Instead, we look for them at:
> > 	https://patchwork.linuxtv.org/project/linux-media/list/
> > 
> > All patches that goes to the ML are automatically stored there, and will be
> > handled by one of the (sub-)maintainers. 
> 
> > However, if the emailer breaks the patch (with was the case of the
> > "tv tuner max2165..." patch), patchwork won't recognize it as a
> > patch, and we'll only see the e-mail by accident.
> 
> Ah... that explains why nobody cares about my patch[1]... Is there any
> way around picky emailers? 

Use a good one ;) Here, I use claws-mail, with works fine if configured
to send text-only e-mails and to not break long lines.

Another alternative is to use git to send the email with something like:

	git send-email HEAD~1 --annotate

That requires some setup at the .git/config file:
	https://git-scm.com/docs/git-send-email

As you use gmail, you could add at the .git/config:

[sendemail]
    smtpEncryption = tls
    smtpServer = smtp.gmail.com
    smtpUser = yourname@gmail.com
    smtpServerPort = 587

> Is putting the patch in an attachment OK?

No, because it doesn't make easy for people to reply with comments.

Regards,
Mauro
