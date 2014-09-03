Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:14604 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbaICLqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 07:46:30 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBB00K7AQ1HKE10@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 07:46:29 -0400 (EDT)
Date: Wed, 03 Sep 2014 08:46:24 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, stoth@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 17/20] cx23885: fix weird sizes.
Message-id: <20140903084624.2cc523b8.m.chehab@samsung.com>
In-reply-to: <1408010045-24016-18-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
 <1408010045-24016-18-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Aug 2014 11:54:02 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> These values make no sense. All SDTV standards have the same width.
> This seems to be copied from the cx88 driver. Just drop these weird
> values.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/cx23885/cx23885.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 99a5fe0..f542ced 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -610,15 +610,15 @@ extern int cx23885_risc_databuffer(struct pci_dev *pci,
>  
>  static inline unsigned int norm_maxw(v4l2_std_id norm)
>  {
> -	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 720 : 768;
> +	return 720;

Not sure if you checked cx23885 datasheet. I didn't, but I don't doubt
that it uses about the same A/D logic as cx88.

In the case of cx88, the sampling rate for a few standards is different,
as recommended at the datasheet. This is done to provide the highest
image quality, as there are some customized filters for some standards,
but they require some specific sampling rates. That's why PAL-Nc and
NTSC/PAL-M are handled on a different way.

>  }
>  
>  static inline unsigned int norm_maxh(v4l2_std_id norm)
>  {
> -	return (norm & V4L2_STD_625_50) ? 576 : 480;
> +	return (norm & V4L2_STD_525_60) ? 480 : 576;

This is obviously wrong.

>  }
>  
>  static inline unsigned int norm_swidth(v4l2_std_id norm)
>  {
> -	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 754 : 922;
> +	return 754;
>  }

Same as above commented.

Regards,
Mauro
