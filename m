Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38673 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753570AbeBVMfu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:35:50 -0500
Subject: Re: [PATCH 0/5] Move finding the best match for size to V4L2 common
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: yong.zhi@intel.com, Hyungwoo <hyungwoo.yang@intel.com>,
        Chiranjeevi <chiranjeevi.rapolu@intel.com>, andy.yeh@intel.com
References: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <453d0bef-7d0e-c598-b3e8-0413c7d15dd7@xs4all.nl>
Date: Thu, 22 Feb 2018 13:35:44 +0100
MIME-Version: 1.0
In-Reply-To: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/08/18 13:44, Sakari Ailus wrote:
> Hi folks,
> 
> This set should make it a bit easier to support finding the right size in
> sensor drivers. Two sensor drivers and vivid are converted as an example.
> 
> I've tested the vivid change only but the patches are effectively the same
> and trivial.

For this series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Sakari Ailus (5):
>   v4l: common: Add a function to obtain best size from a list
>   vivid: Use v4l2_find_nearest_size
>   v4l: common: Remove v4l2_find_nearest_format
>   ov13858: Use v4l2_find_nearest_size
>   ov5670: Use v4l2_find_nearest_size
> 
>  drivers/media/i2c/ov13858.c                  | 37 +++-------------------------
>  drivers/media/i2c/ov5670.c                   | 34 +++----------------------
>  drivers/media/platform/vivid/vivid-vid-cap.c |  6 ++---
>  drivers/media/v4l2-core/v4l2-common.c        | 34 ++++++++++++++-----------
>  include/media/v4l2-common.h                  | 34 ++++++++++++++++++-------
>  5 files changed, 53 insertions(+), 92 deletions(-)
> 
