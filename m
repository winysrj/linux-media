Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab3DYMpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 08:45:31 -0400
Date: Thu, 25 Apr 2013 09:45:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL] m2m: Time stamp related fixes
Message-ID: <20130425094523.52ce633e@redhat.com>
In-Reply-To: <000b01ce41ad$f5f6c160$e1e44420$%debski@samsung.com>
References: <000b01ce41ad$f5f6c160$e1e44420$%debski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 25 Apr 2013 14:11:04 +0200
Kamil Debski <k.debski@samsung.com> escreveu:

> Hi Mauro,
> 
> Sorry for posting this so late. The patches in this pull request add
> timestamp_type 
> handling to mem2mem drivers.
> 
> Best wishes,
>--

Kamil,

Not sure what your emailer is doing, but both patchwork and my emailer
thinks that your message ends with "--". That causes pwclient to not
get anything below it, forcing me to manually cut and paste the remaining
parts of it.

Could you please fix it?

Thanks!
Mauro

> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center		
> 
> The following changes since commit 5f3f254f7c138a22a544b80ce2c14a3fc4ed711e:
> 
>   [media] media/rc/imon.c: kill urb when send_packet() is interrupted
> (2013-04-23 17:50:34 -0300)
> 
> are available in the git repository at:
> 
>   git://git.linuxtv.org/kdebski/media.git media_tree
> 
> for you to fetch changes up to 3a9e65ae54131b8d4568a9e1b0695c37fffb37a2:
> 
>   mem2mem_testdev: set timestamp_type and add debug param (2013-04-25
> 13:51:13 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (1):
>       mem2mem_testdev: set timestamp_type and add debug param
> 
> Kamil Debski (7):
>       s5p-g2d: Add copy time stamp handling
>       s5p-jpeg: Add copy time stamp handling
>       s5p-mfc: Optimize copy time stamp handling
>       coda: Add copy time stamp handling
>       exynos-gsc: Add copy time stamp handling
>       m2m-deinterlace: Add copy time stamp handling
>       mx2-emmaprp: Add copy time stamp handling
> 
>  drivers/media/platform/coda.c               |    5 +++++
>  drivers/media/platform/exynos-gsc/gsc-m2m.c |    5 +++++
>  drivers/media/platform/m2m-deinterlace.c    |    5 +++++
>  drivers/media/platform/mem2mem_testdev.c    |   12 +++++++++++-
>  drivers/media/platform/mx2_emmaprp.c        |    5 +++++
>  drivers/media/platform/s5p-g2d/g2d.c        |    5 +++++
>  drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
>  drivers/media/platform/s5p-mfc/s5p_mfc.c    |   10 ++++------
>  8 files changed, 45 insertions(+), 7 deletions(-)
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro


-- 

Cheers,
Mauro
