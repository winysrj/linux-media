Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab0BAXML (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 18:12:11 -0500
Message-ID: <4B675FC3.2050505@redhat.com>
Date: Mon, 01 Feb 2010 21:12:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: m-karicheri2@ti.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/6] V4L - vpfe capture - header files for ISIF driver
References: <1265063238-29072-1-git-send-email-m-karicheri2@ti.com> <1265063238-29072-2-git-send-email-m-karicheri2@ti.com> <1265063238-29072-3-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1265063238-29072-3-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m-karicheri2@ti.com wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> 
> This is the header file for ISIF driver on DM365.  ISIF driver is equivalent
> to CCDC driver on DM355 and DM644x. This driver is tested for
> YUV capture from TVP514x driver. This patch contains the header files required for
> this driver. The name of the file is changed to reflect the name of IP.
> 
> Reviewed-by: Nori, Sekhar <nsekhar@ti.com>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to linux-next tree of v4l-dvb
>  - rebasing to latest for merge (v3) 
>  - Updated based on comments against v1 of the patch (v2)
>  drivers/media/video/davinci/isif_regs.h |  269 ++++++++++++++++
>  include/media/davinci/isif.h            |  531 +++++++++++++++++++++++++++++++
>  2 files changed, 800 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/isif_regs.h
>  create mode 100644 include/media/davinci/isif.h

Hi Murali,

As always, it is almost impossible for me to know if you're submitting yet another RFC version
or a final version to be applied.

So, I kindly ask you to send all those patches that are still under discussions with [RFC PATCH]
at the subject, and, on the final version, send it to me via a git pull request.

Unfortunately, I don't have enough time to go inside every RFC patch that are under discussion,
so I prefer to optimize my time focusing on the patch versions that are considered ready for
inclusion, and where there's no c/c to any members-only ML.

-- 

Cheers,
Mauro
