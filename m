Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34018 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752844AbdKXOGY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 09:06:24 -0500
Date: Fri, 24 Nov 2017 16:06:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v1 3/4] media: ov5640: add support of DVP parallel
 interface
Message-ID: <20171124140619.btdgn22rvoqswvgy@valkosipuli.retiisi.org.uk>
References: <1510839702-2454-1-git-send-email-hugues.fruchet@st.com>
 <1510839702-2454-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510839702-2454-4-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Nov 16, 2017 at 02:41:41PM +0100, Hugues Fruchet wrote:
> @@ -2185,7 +2262,11 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
>  				goto out;
>  		}
>  
> -		ret = ov5640_set_stream(sensor, enable);
> +		if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
> +			ret = ov5640_set_stream_mipi(sensor, enable);
> +		else
> +			ret = ov5640_set_stream_dvp(sensor);

Hmm. Do you want to configure it even when you're disabling streaming?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
