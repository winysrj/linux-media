Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44706 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753812AbeAIH3A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 02:29:00 -0500
Subject: Re: [PATCH v2] media: i2c: adv748x: fix HDMI field heights
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1515435242-22956-1-git-send-email-kieran.bingham@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9c95a0d3-52de-9078-46f3-b0ba470b687f@xs4all.nl>
Date: Tue, 9 Jan 2018 08:28:54 +0100
MIME-Version: 1.0
In-Reply-To: <1515435242-22956-1-git-send-email-kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2018 07:14 PM, Kieran Bingham wrote:
> The ADV748x handles interlaced media using V4L2_FIELD_ALTERNATE field
> types.  The correct specification for the height on the mbus is the
> image height, in this instance, the field height.
> 
> The AFE component already correctly adjusts the height on the mbus, but
> the HDMI component got left behind.
> 
> Adjust the mbus height to correctly describe the image height of the
> fields when processing interlaced video for HDMI pipelines.
> 
> Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
> v2:
>  - switch conditional to check the fmt->field, removing the need for
>    the comment.
> 
>  drivers/media/i2c/adv748x/adv748x-hdmi.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> index 4da4253553fc..10d229a4f088 100644
> --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> @@ -105,6 +105,9 @@ static void adv748x_hdmi_fill_format(struct adv748x_hdmi *hdmi,
>  
>  	fmt->width = hdmi->timings.bt.width;
>  	fmt->height = hdmi->timings.bt.height;
> +
> +	if (fmt->field == V4L2_FIELD_ALTERNATE)
> +		fmt->height /= 2;
>  }
>  
>  static void adv748x_fill_optional_dv_timings(struct v4l2_dv_timings *timings)
> 
