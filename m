Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4632 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933902Ab3DJGvT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 02:51:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Tzu-Jung Lee" <roylee17@gmail.com>
Subject: Re: [PATCH 1/2] v4l2-ctl: break down the streaming_set()
Date: Wed, 10 Apr 2013 08:51:00 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	k.debski@samsung.com, "Tzu-Jung Lee" <tjlee@ambarella.com>
References: <1365572135-2311-1-git-send-email-tjlee@ambarella.com>
In-Reply-To: <1365572135-2311-1-git-send-email-tjlee@ambarella.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304100851.00549.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed April 10 2013 07:35:34 Tzu-Jung Lee wrote:
> This patch breaks down the streaming_set() into smaller
> ones, which can be resued for supporting m2m devices.
> 
> Further cleanup or consolidation can be applied with
> separate patches, since this one tries not to modify
> logics.
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 888 ++++++++++++++++++----------------
>  1 file changed, 480 insertions(+), 408 deletions(-)

Can you also add a 'Signed-off-by' line for these patches? While this code
isn't kernel code I still think it would be nice to properly attribute these
changes to you.

Regards,

	Hans
