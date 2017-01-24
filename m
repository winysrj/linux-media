Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35201 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdAXCQA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 21:16:00 -0500
Subject: Re: [PATCH v3 20/24] media: imx: Add Camera Interface subdev driver
To: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-21-git-send-email-steve_longerbeam@mentor.com>
 <b7456d40-040d-41b7-45bc-ef6709ab7933@xs4all.nl>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <30a80568-6da0-2502-3346-a4b900c7f1ce@gmail.com>
Date: Mon, 23 Jan 2017 18:15:56 -0800
MIME-Version: 1.0
In-Reply-To: <b7456d40-040d-41b7-45bc-ef6709ab7933@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/20/2017 06:38 AM, Hans Verkuil wrote:
> On 01/07/2017 03:11 AM, Steve Longerbeam wrote:
>> +static int vidioc_querycap(struct file *file, void *fh,
>> +			   struct v4l2_capability *cap)
>> +{
>> +	strncpy(cap->driver, "imx-media-camif", sizeof(cap->driver) - 1);
>> +	strncpy(cap->card, "imx-media-camif", sizeof(cap->card) - 1);
>> +	cap->bus_info[0] = 0;
> Should be set to something like 'platform:imx-media-camif'. v4l2-compliance should
> complain about this.

Right, I've fixed this already as part of v4l2-compliance testing.

>
>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> Set device_caps in struct video_device, then drop these two lines since
> the core will set these up based on the device_caps field in struct video_device.

done.

>
>> +
>> +static int camif_enum_input(struct file *file, void *fh,
>> +			    struct v4l2_input *input)
>> +{
>> +	struct camif_priv *priv = video_drvdata(file);
>> +	struct imx_media_subdev *sensor;
>> +	int index = input->index;
>> +
>> +	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
>> +	if (IS_ERR(sensor)) {
>> +		v4l2_err(&priv->sd, "no sensor attached\n");
>> +		return PTR_ERR(sensor);
>> +	}
>> +
>> +	if (index >= sensor->input.num)
>> +		return -EINVAL;
>> +
>> +	input->type = V4L2_INPUT_TYPE_CAMERA;
>> +	strncpy(input->name, sensor->input.name[index], sizeof(input->name));
>> +
>> +	if (index == priv->current_input) {
>> +		v4l2_subdev_call(sensor->sd, video, g_input_status,
>> +				 &input->status);
>> +		v4l2_subdev_call(sensor->sd, video, querystd, &input->std);
> Wrong op, use g_tvnorms instead.

done.


Steve

