Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:41881 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775AbcDARld (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Apr 2016 13:41:33 -0400
Subject: Re: [PATCH v2] [media] tpg: Export the tpg code from vivid as a
 module
To: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com
References: <1459531093-7071-1-git-send-email-helen.koike@collabora.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56FEB2C4.6060308@xs4all.nl>
Date: Fri, 1 Apr 2016 10:41:24 -0700
MIME-Version: 1.0
In-Reply-To: <1459531093-7071-1-git-send-email-helen.koike@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

On 04/01/2016 10:18 AM, Helen Mae Koike Fornazier wrote:
> The test pattern generator will be used by other drivers as the virtual
> media controller (vimc)
>
> Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
> ---
>
> The patch is based on 'media/master' branch and available at
>          https://github.com/helen-fornazier/opw-staging tpg/review/vivid
>
> Changes since last version:
> 	* module name: tpg -> video-tpg
> 	* header ifdef/define:
> 		_TPG_H_ -> _MEDIA_TPG_H_
> 		_TPG_COLORS_H_ -> _MEDIA_TPG_COLORS_H_
>
>   drivers/media/platform/Kconfig                  |    2 +
>   drivers/media/platform/Makefile                 |    2 +
>   drivers/media/platform/tpg/Kconfig              |    5 +
>   drivers/media/platform/tpg/Makefile             |    3 +
>   drivers/media/platform/tpg/tpg-colors.c         | 1415 ++++++++++++++
>   drivers/media/platform/tpg/tpg-core.c           | 2334 +++++++++++++++++++++++
>   drivers/media/platform/vivid/Kconfig            |    1 +
>   drivers/media/platform/vivid/Makefile           |    2 +-
>   drivers/media/platform/vivid/vivid-core.h       |    2 +-
>   drivers/media/platform/vivid/vivid-tpg-colors.c | 1416 --------------
>   drivers/media/platform/vivid/vivid-tpg-colors.h |   68 -
>   drivers/media/platform/vivid/vivid-tpg.c        | 2314 ----------------------
>   drivers/media/platform/vivid/vivid-tpg.h        |  598 ------
>   include/media/tpg-colors.h                      |   68 +
>   include/media/tpg.h                             |  597 ++++++
>   15 files changed, 4429 insertions(+), 4398 deletions(-)
>   create mode 100644 drivers/media/platform/tpg/Kconfig
>   create mode 100644 drivers/media/platform/tpg/Makefile
>   create mode 100644 drivers/media/platform/tpg/tpg-colors.c
>   create mode 100644 drivers/media/platform/tpg/tpg-core.c
>   delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.c
>   delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.h
>   delete mode 100644 drivers/media/platform/vivid/vivid-tpg.c
>   delete mode 100644 drivers/media/platform/vivid/vivid-tpg.h
>   create mode 100644 include/media/tpg-colors.h
>   create mode 100644 include/media/tpg.h

I think this is a good idea, but I would move the module to drivers/media/common and rename it v4l2-tpg.

It is currently closely tied to V4L2, so v4l2-tpg seems a better choice than just plain tpg.

Regards,

	Hans
