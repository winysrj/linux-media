Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55291 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbbBPMvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 07:51:51 -0500
Date: Mon, 16 Feb 2015 12:49:42 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Recent commit introduces compiler Error in some platforms
Message-ID: <20150216124942.GB23673@biggie>
References: <20150216121829.GA23673@biggie>
 <54E1E45B.2040602@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54E1E45B.2040602@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 16, 2015 at 01:36:43PM +0100, Hans Verkuil wrote:
> On 02/16/2015 01:18 PM, Luis de Bethencourt wrote:
> > Hi all,
> > 
> > As can be seen in Han's build log:
> > http://hverkuil.home.xs4all.nl/logs/Saturday.log
> > 
> > The recent commit bc0c5aa35ac88342831933ca7758ead62d9bae2b introduces a
> > compiler error in some platforms.
> > 
> > /home/hans/work/build/media_build/v4l/ir-hix5hd2.c: In function 'hix5hd2_ir_config':
> > /home/hans/work/build/media_build/v4l/ir-hix5hd2.c:95:2: error: implicit declaration of function 'writel_relaxed' [-Werror=implicit-function-declaration]
> >   writel_relaxed(0x01, priv->base + IR_ENABLE);
> >   ^
> > 
> > Better than reverting, what would be a good solution for this problem?
> > I am happy to implment it once I know what is the right direction.
> > 
> > From what I see that commit mentions that the function is now available from
> > include/asm-generic/io.h, but this isn't included.
> 
> I've just fixed the media_build repository to handle this. Do a git pull and
> it should compile again (only tested against kernel 3.18).
> 
> Regards,
> 
> 	Hans
> 

Great! Nice to know this is already fixed.

Thanks,
Luis

> > Thanks,
> > Luis
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
