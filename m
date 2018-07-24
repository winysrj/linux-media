Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388479AbeGXXMw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 19:12:52 -0400
Date: Tue, 24 Jul 2018 19:04:13 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [GIT PULL FOR v4.19] Various fixes
Message-ID: <20180724190413.77025078@coco.lan>
In-Reply-To: <a9296b29-09ad-9379-0786-de282b71abf2@xs4all.nl>
References: <a9296b29-09ad-9379-0786-de282b71abf2@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 18 Jul 2018 12:38:58 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Various fixes. Please note that I re-added the 'Add support for STD ioctls on subdev nodes'
> patch. It really is needed.
> 
> Regards,
> 
> 	Hans
> 

> Jacopo Mondi (9):
>       sh: defconfig: migor: Update defconfig
>       sh: defconfig: migor: Enable CEU and sensor drivers
>       sh: defconfig: ecovec: Update defconfig
>       sh: defconfig: ecovec: Enable CEU and video drivers
>       sh: defconfig: se7724: Update defconfig
>       sh: defconfig: se7724: Enable CEU and sensor driver
>       sh: defconfig: ap325rxa: Update defconfig
>       sh: defconfig: ap325rxa: Enable CEU and sensor driver

I didn't apply the above ones. I understand you want to enable
the sensor drivers there, but It should either go via SUPERH
tree or we would need his ack to merge on our tree.

>       sh: migor: Remove stale soc_camera include

It caused me lots of doubts if we should either apply this one
via the media tree or not. I ended by applying, as we're maintaining
the soc_camera stuff, with are being removed. So, it makes more sense
to merge it via our tree.

Still, it would be nicer if we had the SUPERH maintainer's ack on
it.


Thanks,
Mauro
