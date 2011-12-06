Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52125 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab1LFIlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 03:41:16 -0500
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LVR00GXYXGFS9G0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 17:41:15 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LVR003QPXGNBG50@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Tue, 06 Dec 2011 17:41:15 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Peter Korsgaard' <jacmet@sunsite.dk>, mchehab@infradead.org,
	linux-media@vger.kernel.org
References: <1323079935-5351-1-git-send-email-jacmet@sunsite.dk>
In-reply-to: <1323079935-5351-1-git-send-email-jacmet@sunsite.dk>
Subject: RE: [PATCH] s5p_mfc_enc: fix s/H264/H263/ typo
Date: Tue, 06 Dec 2011 09:40:31 +0100
Message-id: <00c801ccb3f2$b9333460$2b999d20$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Thank you for your patch!
I'll include it with the patches we'll be sending to Mauro.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Peter Korsgaard [mailto:jacmet@gmail.com] On Behalf Of Peter Korsgaard
> Sent: 05 December 2011 11:12
> To: k.debski@samsung.com; mchehab@infradead.org; linux-media@vger.kernel.org
> Cc: Peter Korsgaard
> Subject: [PATCH] s5p_mfc_enc: fix s/H264/H263/ typo
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
> ---
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> index 1e8cdb7..dff9dc7 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> @@ -61,7 +61,7 @@ static struct s5p_mfc_fmt formats[] = {
>  		.num_planes = 1,
>  	},
>  	{
> -		.name = "H264 Encoded Stream",
> +		.name = "H263 Encoded Stream",
>  		.fourcc = V4L2_PIX_FMT_H263,
>  		.codec_mode = S5P_FIMV_CODEC_H263_ENC,
>  		.type = MFC_FMT_ENC,
> --
> 1.7.7.1

