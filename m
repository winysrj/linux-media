Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbeHaTjI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 15:39:08 -0400
Date: Fri, 31 Aug 2018 12:31:02 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.20] Add Request API for the topic branch
Message-ID: <20180831123102.72bf427d@coco.lan>
In-Reply-To: <23a0f5a6-af4b-c239-7443-df85631c0075@xs4all.nl>
References: <23a0f5a6-af4b-c239-7443-df85631c0075@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Aug 2018 12:40:38 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> This is a pull request to add the Request API v18 as a topic branch.
> 
> Note that this does not yet include the follow-up patches:
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg134630.html
> 
> Those will come in a separate pull request on top of this one once this is
> agreed upon (hopefully soon!).
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 3799eca51c5be3cd76047a582ac52087373b54b3:
> 
>   media: camss: add missing includes (2018-08-29 14:02:06 -0400)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git reqv18
> 
> for you to fetch changes up to 1212ceb69544eee3864ec8461bc53ee6ddd87fb0:
> 
>   vivid: add request support (2018-08-30 12:01:28 +0200)

This pull request breaks compilation with 386:

drivers/media/platform/vivid/vivid-osd.c:./include/linux/slab.h:631:13: error: undefined identifier '__builtin_mul_overflow'
drivers/media/platform/vivid/vivid-osd.c:./include/linux/slab.h:631:13: warning: call with no type!

Thanks,
Mauro
