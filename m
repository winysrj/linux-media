Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2672 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaAEMP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 07:15:57 -0500
Message-ID: <52C94CEA.5070502@xs4all.nl>
Date: Sun, 05 Jan 2014 13:15:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v6 12/12] v4l2-framework.txt: add SDR device type
References: <1388289844-2766-1-git-send-email-crope@iki.fi> <1388289844-2766-13-git-send-email-crope@iki.fi>
In-Reply-To: <1388289844-2766-13-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/29/2013 05:04 AM, Antti Palosaari wrote:
> Add SDR device type to v4l2-framework.txt document.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/video4linux/v4l2-framework.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 6c4866b..ae3a2cc 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -768,6 +768,7 @@ types exist:
>  VFL_TYPE_GRABBER: videoX for video input/output devices
>  VFL_TYPE_VBI: vbiX for vertical blank data (i.e. closed captions, teletext)
>  VFL_TYPE_RADIO: radioX for radio tuners
> +VFL_TYPE_SDR: swradioX for Software Defined Radio tuners
>  
>  The last argument gives you a certain amount of control over the device
>  device node number used (i.e. the X in videoX). Normally you will pass -1
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
