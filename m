Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43848 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751317AbdGQVb7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 17:31:59 -0400
Date: Tue, 18 Jul 2017 00:31:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp <philipp.guendisch@fau.de>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com, jeremy.lefaure@lse.epita.fr, fabf@skynet.be,
        rvarsha016@gmail.com, chris.baller@gmx.de, robsonde@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: Re: [PATCH v2 2/2] staging: atomisp2: hmm: Alignment code (rebased)
Message-ID: <20170717213153.jxaxi2awd32ip43j@valkosipuli.retiisi.org.uk>
References: <20170711152758.3azqdhfyeiyagtv7@valkosipuli.retiisi.org.uk>
 <1499928943-9133-1-git-send-email-philipp.guendisch@fau.de>
 <1499928943-9133-2-git-send-email-philipp.guendisch@fau.de>
 <20170713154510.qtbeuhw3lsw55zod@valkosipuli.retiisi.org.uk>
 <43B470FF-66D0-49D5-9944-01799E48805E@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43B470FF-66D0-49D5-9944-01799E48805E@fau.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 13, 2017 at 09:26:50PM +0200, Philipp wrote:
> 
> > On 13. Jul 2017, at 17:45, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > 
> > On Thu, Jul 13, 2017 at 08:55:43AM +0200, Philipp Guendisch wrote:
> >> This patch fixed code alignment to open paranthesis.
> >> Semantic should not be affected by this patch.
> >> 
> >> It has been rebased on top of media_tree atomisp branch
> >> 
> >> Signed-off-by: Philipp Guendisch <philipp.guendisch@fau.de>
> >> Signed-off-by: Chris Baller <chris.baller@gmx.de>
> > 
> > Hi Philipp,
> > 
> > Neither of the patches still applies?
> > 
> > Are you sure you rebased them on the atomisp branch?
> > 
> > -- 
> > Regards,
> > 
> > Sakari Ailus
> > e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
> 
> Hi Ailus,
> 
> Unfortunately I dont know exactly why the patches did not apply.
> 
> I tried a rebase with:
> 
> "git remote add sailus-mediatree git://linuxtv.org/sailus/media_tree.git <git://linuxtv.org/sailus/media_tree.git>
> git fetch sailus-mediatree
> git checkout atomisp”
> 
> Maybe I took too much time for rebasing and some patches were accepted between my ‘git pull’ and 'git send-email'
> 
> I did another git pull right now and have seen the pathches are already in the commit history.
> 
> So I think it's time to give you a huge THANK YOU!

You're welcome, and thank you for the cleanup patches!

This was my mistake actually; I thought the patches didn't apply but I
ended up trying to apply them... twice. That's what you get when you have
too many atomisp patches. :-o

> 
> If I got it wrong and threre is still some work to do for the two patches please let me know 
> and I will try to fix it.
> 
> PS: I am totally new to kernel development yet.

Cleanup patches are a really good way to start, besides fixing small issues
here and there. :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
