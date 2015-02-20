Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46239 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbbBTBgq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 20:36:46 -0500
Date: Thu, 19 Feb 2015 23:36:41 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 3.19] si2168 fix
Message-ID: <20150219233641.72340a03@recife.lan>
In-Reply-To: <54E68430.6010607@iki.fi>
References: <54C0CCEF.8080500@iki.fi>
	<54E68430.6010607@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 20 Feb 2015 02:47:44 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Mauro
> Did that patch went to stable? I see you have committed original patch 
> from patchwork, but there is no stable tag.

It went upstream, but I'm unsure if it arrived for 3.19 or 3.20.

That's the upstream changeset:

$ git show 551c33e729f6 
commit 551c33e729f654ecfaed00ad399f5d2a631b72cb
Author: Jurgen Kramer <gtmkramer@xs4all.nl>
Date:   Mon Dec 8 05:30:44 2014 -0300

    [media] Si2168: increase timeout to fix firmware loading
    
    Increase si2168 cmd execute timeout to prevent firmware load failures. Tests
    shows it takes up to 52ms to load the 'dvb-demod-si2168-a30-01.fw' firmware.
    Increase timeout to a safe value of 70ms.
    
    Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
    Reviewed-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Weird, it is missing the Cc tag on its commit message. I double-checked
re-applying it on a scratch branch: my scripts are properly recognizing
the Cc tag.

I've no idea what happened. Perhaps you've added this patch on some other
branch that you asked me to pull?

Anyway, now the proper solution is to send this patch directly to
stable@vger.kernel.org, C/C the mailing list.

Regards,
Mauro

> 
> 
> On 01/22/2015 12:11 PM, Antti Palosaari wrote:
> > That patch must go also stable v3.16+ as tagged Cc.
> >
> > regards
> > Antti
> >
> > The following changes since commit
> > 2c0108e1c02f9fc95f465adc4d2ce1ad8688290a:
> >
> >    [media] omap3isp: Correctly set QUERYCAP capabilities (2015-01-21
> > 21:09:11 -0200)
> >
> > are available in the git repository at:
> >
> >    git://linuxtv.org/anttip/media_tree.git si2168_fix
> >
> > for you to fetch changes up to a85385413c60602b529a1555146c4e81a5935e98:
> >
> >    si2168: increase timeout to fix firmware loading (2015-01-22 12:06:20
> > +0200)
> >
> > ----------------------------------------------------------------
> > Jurgen Kramer (1):
> >        si2168: increase timeout to fix firmware loading
> >
> >   drivers/media/dvb-frontends/si2168.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> 
> 
> https://patchwork.linuxtv.org/patch/27382/
> 
> 
> 
> commit 551c33e729f654ecfaed00ad399f5d2a631b72cb
> Author: Jurgen Kramer <gtmkramer@xs4all.nl>
> Date:   Mon Dec 8 05:30:44 2014 -0300
> 
>      [media] Si2168: increase timeout to fix firmware loading
> 
>      Increase si2168 cmd execute timeout to prevent firmware load 
> failures. Tests
>      shows it takes up to 52ms to load the 'dvb-demod-si2168-a30-01.fw' 
> firmware.
>      Increase timeout to a safe value of 70ms.
> 
>      Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
>      Reviewed-by: Antti Palosaari <crope@iki.fi>
>      Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Antti
> 
> 
> 
> 
> 
