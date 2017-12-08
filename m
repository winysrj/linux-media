Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49688 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752479AbdLHQiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 11:38:07 -0500
Date: Fri, 8 Dec 2017 14:38:01 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [GIT PULL FOR v4.16] media: imx: Add better OF graph support
Message-ID: <20171208143801.14319617@vento.lan>
In-Reply-To: <4fa72331-0b80-1df6-ed58-d907e585bd50@xs4all.nl>
References: <4fa72331-0b80-1df6-ed58-d907e585bd50@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 8 Dec 2017 11:56:58 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Note: the new v4l2-async work makes it possible to simplify this. That
> will be done in follow-up patches. It's easier to do that if this is in
> first.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 781b045baefdabf7e0bc9f33672ca830d3db9f27:
> 
>   media: imx274: Fix error handling, add MAINTAINERS entry (2017-11-30 04:45:12 -0500)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git imx
> 
> for you to fetch changes up to 82737cbb02f269b8eb608c7bd906a79072f6adad:
> 
>   media: staging/imx: update TODO (2017-12-04 14:05:19 +0100)
> 
> ----------------------------------------------------------------
> Steve Longerbeam (9):
>       media: staging/imx: get CSI bus type from nearest upstream entity

There are some non-trivial conflicts on this patch.
Care to rebase it?

Thanks!
Mauro

Thanks,
Mauro
