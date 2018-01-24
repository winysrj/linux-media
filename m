Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42042 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932700AbeAXKSr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 05:18:47 -0500
Date: Wed, 24 Jan 2018 12:18:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2] media: ov5640: add JPEG support
Message-ID: <20180124101844.a4oy3sc7g5xxlwqu@valkosipuli.retiisi.org.uk>
References: <1516713794-3636-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516713794-3636-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Tue, Jan 23, 2018 at 02:23:14PM +0100, Hugues Fruchet wrote:
> +static int ov5640_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
> +				 struct v4l2_mbus_frame_desc *fd)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +
> +	if (pad != 0 || !fd)
> +		return -EINVAL;
> +
> +	mutex_lock(&sensor->lock);
> +	fd->entry[0].length = sensor->jpeg_size;
> +	mutex_unlock(&sensor->lock);
> +	fd->entry[0].pixelcode = MEDIA_BUS_FMT_JPEG_1X8;
> +	fd->entry[0].flags = V4L2_MBUS_FRAME_DESC_FL_LEN_MAX;
> +	fd->num_entries = 1;

Missed this on the previous time --- the frame descriptor now describes the
JPEG frame _only_. This needs to work for non-JPEG formats, too.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
