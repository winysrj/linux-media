Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56056 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbLCNTU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2015 08:19:20 -0500
Date: Thu, 3 Dec 2015 11:19:12 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, Benoit Parrot <bparrot@ti.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.5] New ti-cal driver
Message-ID: <20151203111912.6fdfc076@recife.lan>
In-Reply-To: <56585B0E.8090907@xs4all.nl>
References: <56585B0E.8090907@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 27 Nov 2015 14:30:54 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The following changes since commit 10897dacea26943dd80bd6629117f4620fc320ef:
> 
>   Merge tag 'v4.4-rc2' into patchwork (2015-11-23 14:16:58 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git cal
> 
> for you to fetch changes up to 5df9a7909b737e9725c1005b3b39383e9c2490ca:
> 
>   media: v4l: ti-vpe: Document DRA72 CAL h/w module (2015-11-27 14:25:07 +0100)
> 
> ----------------------------------------------------------------
> Benoit Parrot (2):
>       media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
>       media: v4l: ti-vpe: Document DRA72 CAL h/w module

Please put the DT documentation patch before the patch itself. Documenting
first makes easier to review, and removes a checkpatch warning:

WARNING: DT compatible string "ti,dra72-cal" appears un-documented -- check ./Documentation/devicetree/bindings/
#2210: FILE: drivers/media/platform/ti-vpe/cal.c:2128:
+	{ .compatible = "ti,dra72-cal", },


Also, with regards to:

>       media: v4l: ti-vpe: Add CAL v4l2 camera capture driver

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#78: 
new file mode 100644

Please add an entry to MAINTAINERS for platform/ti-vpe.

Thanks,
Mauro





