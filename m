Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:24216 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934896Ab3DKJ0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 05:26:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Tzu-Jung Lee" <roylee17@gmail.com>
Subject: Re: [PATCH 1/2] v4l2-ctl: break down the streaming_set()
Date: Thu, 11 Apr 2013 11:25:31 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	k.debski@samsung.com, "Tzu-Jung Lee" <tjlee@ambarella.com>
References: <1365570647-28401-1-git-send-email-tjlee@ambarella.com> <1365591426-23285-1-git-send-email-tjlee@ambarella.com>
In-Reply-To: <1365591426-23285-1-git-send-email-tjlee@ambarella.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111125.31920.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 10 April 2013 12:57:05 Tzu-Jung Lee wrote:
> This patch breaks down the streaming_set() into smaller
> ones, which can be resued for supporting m2m devices.
> 
> Further cleanup or consolidation can be applied with
> separate patches, since this one tries not to modify
> logics.
> 
> Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 921 +++++++++++++++++++---------------
>  1 file changed, 505 insertions(+), 416 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index c29565f..a180c6a 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp

Thanks! I've committed your patches to v4l-utils. I also added a bunch of
other fixes (among others I broke the non-poll streaming case with my eos
patch).

I do have some questions about the EOS semantics, but I'll ask those in a
separate mail.

Regards,

	Hans
