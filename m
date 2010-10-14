Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3862 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0JNGdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 02:33:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v12 1/3] V4L2: Add seek spacing and RDS CAP bits.
Date: Thu, 14 Oct 2010 08:32:35 +0200
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	eduardo.valentin@nokia.com
References: <1286457373-1742-1-git-send-email-matti.j.aaltonen@nokia.com> <1286457373-1742-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1286457373-1742-2-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010140832.35329.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

On Thursday, October 07, 2010 15:16:11 Matti J. Aaltonen wrote:
> Add spacing field to v4l2_hw_freq_seek.
> 
> Add V4L2_TUNER_CAP_RDS_BLOCK_IO, which indicates that the tuner/
> transmitter if capable of transmitting/receiving RDS blocks.
> 
> Add V4L2_TUNER_CAP_RDS_CONTROLS capability, which indicates that the
> RDS data is handled as values of predefined controls like radio text,
> program ID and so on.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  include/linux/videodev2.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 61490c6..eadcda3 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1363,6 +1363,8 @@ struct v4l2_modulator {
>  #define V4L2_TUNER_CAP_SAP		0x0020
>  #define V4L2_TUNER_CAP_LANG1		0x0040
>  #define V4L2_TUNER_CAP_RDS		0x0080
> +#define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
> +#define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
>  
>  /*  Flags for the 'rxsubchans' field */
>  #define V4L2_TUNER_SUB_MONO		0x0001
> @@ -1392,7 +1394,8 @@ struct v4l2_hw_freq_seek {
>  	enum v4l2_tuner_type  type;
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
> -	__u32		      reserved[8];
> +	__u32		      spacing;
> +	__u32		      reserved[7];
>  };
>  
>  /*
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
