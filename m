Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:44634 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030733AbeEZAKV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 20:10:21 -0400
Received: by mail-qt0-f196.google.com with SMTP id d3-v6so8616740qtp.11
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 17:10:20 -0700 (PDT)
Message-ID: <a8fb7943417e74fc19f594ae880fea5f306c7be3.camel@ndufresne.ca>
Subject: Re: [PATCH 3/6] media: videodev2.h: Add macro
 V4L2_FIELD_IS_SEQUENTIAL
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 25 May 2018 20:10:18 -0400
In-Reply-To: <1527292416-26187-4-git-send-email-steve_longerbeam@mentor.com>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
         <1527292416-26187-4-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(in text this time, sorry)

Le vendredi 25 mai 2018 à 16:53 -0700, Steve Longerbeam a écrit :
> Add a macro that returns true if the given field type is
> 'sequential',
> that is, the data is transmitted, or exists in memory, as all top
> field
> lines followed by all bottom field lines, or vice-versa.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  include/uapi/linux/videodev2.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h
> b/include/uapi/linux/videodev2.h
> index 600877b..408ee96 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -126,6 +126,10 @@ enum v4l2_field {
>  	 (field) == V4L2_FIELD_INTERLACED_BT ||\
>  	 (field) == V4L2_FIELD_SEQ_TB ||\
>  	 (field) == V4L2_FIELD_SEQ_BT)
> +#define V4L2_FIELD_IS_SEQUENTIAL(field) \
> +	((field) == V4L2_FIELD_SEQ_TB ||\
> +	 (field) == V4L2_FIELD_SEQ_BT ||\
> +	 (field) == V4L2_FIELD_ALTERNATE)

No, alternate has no place here, in alternate mode each buffers have
only one field.

>  #define V4L2_FIELD_HAS_T_OR_B(field)	\
>  	((field) == V4L2_FIELD_BOTTOM (||\
>  	 (field) == V4L2_FIELD_TOP ||\
