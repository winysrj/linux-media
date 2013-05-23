Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:59705 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab3EWJi3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 05:38:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 0/7] media: davinci: vpif trivial cleanup
Date: Thu, 23 May 2013 11:38:12 +0200
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231138.12523.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 16 May 2013 14:58:15 Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patch series cleans the VPIF driver, uses devm_* api wherever
> required and uses module_platform_driver() to simplify the code.
> 
> This patch series applies on 3.10.rc1 and is tested on OMAP-L138.

Can you repost this taken into account Laurent's comments regarding the
unwanted header includes?

Thanks,

	Hans

> 
> Lad, Prabhakar (7):
>   media: davinci: vpif: remove unwanted header includes
>   media: davinci: vpif: Convert to devm_* api
>   media: davinci: vpif: remove unnecessary braces around defines
>   media: davinci: vpif_capture: remove unwanted header inclusion and
>     sort them alphabetically
>   media: davinci: vpif_capture: Convert to devm_* api
>   media: davinci: vpif_display: remove unwanted header inclusion and
>     sort them alphabetically
>   media: davinci: vpif_display: Convert to devm_* api
> 
>  drivers/media/platform/davinci/vpif.c         |   42 ++---------
>  drivers/media/platform/davinci/vpif_capture.c |   96 +++++--------------------
>  drivers/media/platform/davinci/vpif_capture.h |    6 +-
>  drivers/media/platform/davinci/vpif_display.c |   85 ++++------------------
>  drivers/media/platform/davinci/vpif_display.h |    6 +-
>  5 files changed, 46 insertions(+), 189 deletions(-)
> 
> 
