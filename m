Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40557 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2FZJdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 05:33:31 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6700AMBX8TKX30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 10:34:05 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M6700M6ZX7RZR50@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 10:33:28 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: ch.naveen@samsung.com, linux-media@vger.kernel.org
Cc: 'Marek Szyprowski' <m.szyprowski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jeongtae Park' <jtp.park@samsung.com>
References: <23828524.675831340322390207.JavaMail.weblogic@epml09>
In-reply-to: <23828524.675831340322390207.JavaMail.weblogic@epml09>
Subject: RE: [PATCH] s5p-mfc: Fix setting controls
Date: Tue, 26 Jun 2012 11:33:26 +0200
Message-id: <000001cd537e$bd927850$38b768f0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Naveen,

Today I have posted a patch that should resolve your problems with setting
controls
([PATCH] s5p-mfc: Fixed setup of custom controls in decoder and encoder).
Please check if it works now.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: NAVEEN KRISHNA CHATRADHI [mailto:ch.naveen@samsung.com]
> Sent: 22 June 2012 01:47
> To: Kamil Debski; linux-media@vger.kernel.org
> Cc: Marek Szyprowski; Kyungmin Park; Jeongtae Park
> Subject: Re: [PATCH] s5p-mfc: Fix setting controls
> 
> Hello Kamil,
> 
> Sorry for the delayed reply. I'm afraid this doesnt fix the whole issue.
> Still there is some problem with S_CTRL when used with custom controls.
> 
> when my application call s_ctrl with
> V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY
> the call finally lands on
> V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER in driver (The set value
> is also lost).
> 
> I think this is because of corruption of the master or cluster in v4l2-
> ioctl.c/ctrl.c and pointing to the standard controls master.
> instead of the custom control master.
> 
> Kindly, let me know your opinion or any clues on this.
> 
> Thanks & Regards
> Naveen Krishna
> 
> 
> 
> ------- Original Message -------
> Sender : Kamil Debski<k.debski@samsung.com>  Software Engineer/Poland R&D
> Center-Linux Platform (SSD)/Samsung Electronics
> Date   : Jun 15, 2012 13:51 (GMT+05:00)
> Title  : [PATCH] s5p-mfc: Fix setting controls
> 
> Fixed s_ctrl function when setting the following controls:
> - V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER
> - V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> index e1ebc76..eaab13e 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> @@ -639,13 +639,13 @@ static int s5p_mfc_dec_s_ctrl(struct v4l2_ctrl
> *ctrl)
> 
>  	switch (ctrl->id) {
>  	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY:
> -		ctx->loop_filter_mpeg4 = ctrl->val;
> +		ctx->display_delay = ctrl->val;
>  		break;
>  	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE:
>  		ctx->display_delay_enable = ctrl->val;
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
> -		ctx->display_delay = ctrl->val;
> +		ctx->loop_filter_mpeg4 = ctrl->val;
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:
>  		ctx->slice_interface = ctrl->val;
> --
> 1.7.0.4
> 
> <p>&nbsp;</p><p>&nbsp;</p>Thanks & Best Regards,
> Naveen Krishna Ch
> SE @ Samsung-B.LAB

