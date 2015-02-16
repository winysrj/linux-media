Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34905 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbbBPMhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 07:37:03 -0500
Message-ID: <54E1E45B.2040602@xs4all.nl>
Date: Mon, 16 Feb 2015 13:36:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Luis de Bethencourt <luis@debethencourt.com>,
	linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent commit introduces compiler Error in some platforms
References: <20150216121829.GA23673@biggie>
In-Reply-To: <20150216121829.GA23673@biggie>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2015 01:18 PM, Luis de Bethencourt wrote:
> Hi all,
> 
> As can be seen in Han's build log:
> http://hverkuil.home.xs4all.nl/logs/Saturday.log
> 
> The recent commit bc0c5aa35ac88342831933ca7758ead62d9bae2b introduces a
> compiler error in some platforms.
> 
> /home/hans/work/build/media_build/v4l/ir-hix5hd2.c: In function 'hix5hd2_ir_config':
> /home/hans/work/build/media_build/v4l/ir-hix5hd2.c:95:2: error: implicit declaration of function 'writel_relaxed' [-Werror=implicit-function-declaration]
>   writel_relaxed(0x01, priv->base + IR_ENABLE);
>   ^
> 
> Better than reverting, what would be a good solution for this problem?
> I am happy to implment it once I know what is the right direction.
> 
> From what I see that commit mentions that the function is now available from
> include/asm-generic/io.h, but this isn't included.

I've just fixed the media_build repository to handle this. Do a git pull and
it should compile again (only tested against kernel 3.18).

Regards,

	Hans

> Thanks,
> Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

