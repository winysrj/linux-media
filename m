Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46329 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2FYRAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 13:00:00 -0400
Received: by bkcji2 with SMTP id ji2so3372564bkc.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 09:59:59 -0700 (PDT)
Message-ID: <4FE8990B.7060402@gmail.com>
Date: Mon, 25 Jun 2012 18:59:55 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: sakari.ailus@iki.fi
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Schedule the selections API compatibility definitions
 for removal
References: <4FDB80C8.4060505@iki.fi> <1340643118-32340-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1340643118-32340-1-git-send-email-sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/25/2012 06:51 PM, Sylwester Nawrocki wrote:
> Signed-off-by: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
> ---

Hi Sakari,

Let me add an explanation that was supposed to be originally included
in that patch..

Here is the patch for Documentation/feature-removal-schedule.txt that
is mentioned in the description of the first patch in this series.

This change set looks good to me, except there seem to be missing
compatibility definitions for the selections flags. I presume we
are going to need those since the original subdev selections API
will exist in v3.5 kernels, and this change set is going to be
applied only to v3.6.

So something like that might be needed:

#define V4L2_SUBDEV_SEL_FLAG_SIZE_GE      V4L2_SEL_FLAG_SIZE_GE
#define V4L2_SUBDEV_SEL_FLAG_SIZE_LE      V4L2_SEL_FLAG_SIZE_LE
#define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG  V4L2_SEL_FLAG_KEEP_CONFIG

After adding that this series seems good for merging to me.

Thanks and regards,
Sylwester

>   Documentation/feature-removal-schedule.txt |   15 +++++++++++++++
>   1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 09701af..ef9f942 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -558,3 +558,18 @@ Why:	The V4L2_CID_VCENTER, V4L2_CID_HCENTER controls have been deprecated
>   	There are newer controls (V4L2_CID_PAN*, V4L2_CID_TILT*) that provide
>   	similar	functionality.
>   Who:	Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
> +
> +----------------------------
> +
> +What:	Remove the backward compatibility V4L2 selections target and selections
> +	flags definitions
> +When:	3.8
> +Why:	The regular V4L2 selections and the subdev selection API originally
> +	defined distinct names for the target rectangles and flags - V4L2_SEL_*
> +	and V4L2_SUBDEV_SEL_*. Although, it turned out that the meaning of these
> +	target rectangles is virtually identical and the APIs were consolidated
> +	to use single set of names - V4L2_SEL_*. This consolidation didn't
> +	change the ABI in any way. Alias definitions were created for the
> +	original ones to avoid any instabilities in the user space interface.
> +	After few cycles these comptibility definitions will be removed.
> +Who:	Sylwester Nawrocki<sylvester.nawrocki@gmail.com>

