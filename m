Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42395 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbcA0I06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 03:26:58 -0500
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id B732D180D43
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2016 09:26:52 +0100 (CET)
Subject: Re: [PATCH 0/2] v4l2: add support to set the InfoFrame content type
To: linux-media@vger.kernel.org
References: <1453881421-15865-1-git-send-email-hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56A88034.7000505@xs4all.nl>
Date: Wed, 27 Jan 2016 09:30:44 +0100
MIME-Version: 1.0
In-Reply-To: <1453881421-15865-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/27/16 08:56, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The HDMI standard defines a Content Type field in the video InfoFrame that
> can tell the receiver what sort of video is being transferred. Based on
> that information the receiver can choose to optimize for that content type.
> 
> A practical example is that if the content type is set to 'Game' then the
> TV might configure itself to a low-latency mode.
> 
> But this requires that applications can set the content type, and that's
> what this patch series does: it adds a new content type control and
> implements it in the adv7511 HDMI transmitter.

I knew I'd forgotten something: 1) documentation and 2) I need an
RX_CONTENT_TYPE control as well to read this value from the receiver.

The main reason for posting these patches was to make them public
since they were hiding in an obscure branch of my git repo and the
chances were high that I'd accidentally delete that branch at some
point in the future. I'm currently trying to find another patch
that I suspect I deleted in just that fashion :-(

Anyway, expect a v2 for this series.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> Hans Verkuil (2):
>   v4l2-ctrls: add V4L2_CID_DV_TX_CONTENT_TYPE
>   adv7511: add content type control support
> 
>  drivers/media/i2c/adv7511.c          | 12 +++++++++++-
>  drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++
>  include/uapi/linux/v4l2-controls.h   |  8 ++++++++
>  3 files changed, 30 insertions(+), 1 deletion(-)
> 
