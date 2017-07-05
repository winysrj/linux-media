Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42144 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752467AbdGEXOh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:14:37 -0400
Date: Thu, 6 Jul 2017 02:14:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hansverk@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] ov5645: Add control to export CSI2 link
 frequency
Message-ID: <20170705231429.lkwv4dt53jw32lbh@valkosipuli.retiisi.org.uk>
References: <1499244289-7791-1-git-send-email-todor.tomov@linaro.org>
 <1499244289-7791-3-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499244289-7791-3-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 05, 2017 at 11:44:49AM +0300, Todor Tomov wrote:
> @@ -1231,6 +1246,13 @@ static int ov5645_probe(struct i2c_client *client,
>  						&ov5645_ctrl_ops,
>  						V4L2_CID_PIXEL_RATE,
>  						1, INT_MAX, 1, 1);
> +	ov5645->link_freq = v4l2_ctrl_new_int_menu(&ov5645->ctrls,
> +						   &ov5645_ctrl_ops,
> +						   V4L2_CID_LINK_FREQ,
> +						   ARRAY_SIZE(link_freq) - 1,
> +						   0, link_freq);
> +	if(ov5645->link_freq)

Thanks!

Applied the set, with the above typo fixed (i.e. space added).

> +		ov5645->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>  
>  	ov5645->sd.ctrl_handler = &ov5645->ctrls;
>  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
