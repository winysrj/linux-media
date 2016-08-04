Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:43452 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812AbcHDQFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 12:05:04 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2] V4L2: Add documentation for SDI timings and related flags
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <1470325151-14522-1-git-send-email-charles-antoine.couret@nexvision.fr>
Date: Thu, 4 Aug 2016 18:04:50 +0200
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <65FBAAA2-4460-4940-920A-575D01EE0923@darmarit.de>
References: <1470325151-14522-1-git-send-email-charles-antoine.couret@nexvision.fr>
To: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 04.08.2016 um 17:39 schrieb Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>:

> Signed-off-by: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
> ---
> Documentation/media/uapi/v4l/vidioc-enuminput.rst  | 31 +++++++++++++++++-----
> .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 16 +++++++++++
> 2 files changed, 40 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> index 5060f54..18331b9 100644
> --- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> @@ -260,17 +260,34 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
> 
>    -  .. row 11
> 
> -       -  :cspan:`2` Digital Video
> +       -  ``V4L2_IN_ST_NO_V_LOCK``
> +
> +       -  0x00000400
> +
> +       -  No vertical sync lock.
> 
>    -  .. row 12
> 
> +       -  ``V4L2_IN_ST_NO_STD_LOCK``
> +
> +       -  0x00000800
> +
> +       -  No standard format lock in case of auto-detection format
> +	  by the component.
> +
> +    -  .. row 13
> +
> +       -  :cspan:`2` Digital Video
> +
> +    -  .. row 14
> +
>       -  ``V4L2_IN_ST_NO_SYNC``
> 
>       -  0x00010000
> 
>       -  No synchronization lock.
> 
> -    -  .. row 13
> +    -  .. row 15

Hi Charles,

you don't need to continue the "row nn" comments. These row-numbering 
comes from the migration tool when we migrated from DocBook.

@Mauro: may it is the best, we drop all these "row nn" comments?

-- Markus --

