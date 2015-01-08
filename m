Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53158 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbbAHMvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 07:51:04 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NHU005Q6ZVUUH80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Jan 2015 12:55:06 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org
Cc: 'Arun Kumar K' <arun.kk@samsung.com>
References: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
 <1418677859-31440-4-git-send-email-nicolas.dufresne@collabora.com>
In-reply-to: <1418677859-31440-4-git-send-email-nicolas.dufresne@collabora.com>
Subject: RE: [PATCH 3/3] media-doc: Fix MFC display delay control doc
Date: Thu, 08 Jan 2015 13:51:01 +0100
Message-id: <009a01d02b41$c1e281a0$45a784e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
> Sent: Monday, December 15, 2014 10:11 PM
> To: linux-media@vger.kernel.org
> Cc: Kamil Debski; Arun Kumar K; Nicolas Dufresne
> Subject: [PATCH 3/3] media-doc: Fix MFC display delay control doc
> 
> The V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE control
> is a boolean but was documented as a integer. The documentation was
> also slightly miss-leading.
> 
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  Documentation/DocBook/media/v4l/controls.xml | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml
> index e013e4b..4e9462f 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2692,12 +2692,11 @@ in the S5P family of SoCs by Samsung.
>  	      <row><entry></entry></row>
>  	      <row>
>  		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_
> DELAY_ENABLE</constant>&nbsp;</entry>
> -		<entry>integer</entry>
> -	      </row><row><entry spanname="descr">If the display delay is
> enabled then the decoder has to return a
> -CAPTURE buffer after processing a certain number of OUTPUT buffers. If
> this number is low, then it may result in -buffers not being dequeued
> in display order. In addition hardware may still use those buffers as
> reference, thus -application should not write to those buffers. This
> feature can be used for example for generating thumbnails of videos.
> -Applicable to the H264 decoder.
> +		<entry>boolean</entry>
> +	      </row><row><entry spanname="descr">If the display delay is
> +enabled then the decoder is forced to return a CAPTURE buffer (decoded
> +frame) after processing a certain number of OUTPUT buffers. The delay
> +can be set through
> <constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY</constan
> t>. This feature can be used for example for generating thumbnails of
> videos. Applicable to the H264 decoder.
>  	      </entry>
>  	      </row>
>  	      <row><entry></entry></row>
> --
> 2.1.0

