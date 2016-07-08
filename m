Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49220 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbcGHJYw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 05:24:52 -0400
Subject: Re: [PATCH v2.1 6/9] v4l: Add 14-bit raw bayer pixel format
 definitions
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1466439608-22890-7-git-send-email-sakari.ailus@linux.intel.com>
 <1467038724-27562-1-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <abcc2b6c-48ba-5c5d-01bc-01c2796141b5@xs4all.nl>
Date: Fri, 8 Jul 2016 11:24:32 +0200
MIME-Version: 1.0
In-Reply-To: <1467038724-27562-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/27/2016 04:45 PM, Sakari Ailus wrote:
> The formats added by this patch are:
> 
> 	V4L2_PIX_FMT_SBGGR14
> 	V4L2_PIX_FMT_SGBRG14
> 	V4L2_PIX_FMT_SGRBG14
> 	V4L2_PIX_FMT_SRGGB14
> 
> Signed-off-by: Jouni Ukkonen <jouni.ukkonen@intel.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

You also need to update v4l2-ioctl.c, v4l_fill_fmtdesc() with the new pixel formats.

I'm OK if that's done in a follow-up patch for all the new pixelformat you
have defined in these patches.

Regards,

	Hans
