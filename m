Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:59663 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758224Ab2I1Sgl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 14:36:41 -0400
From: Albert Wang <twang13@marvell.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Fri, 28 Sep 2012 11:37:41 -0700
Subject: RE: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support
 on marvell-ccic mcam-core
Message-ID: <477F20668A386D41ADCC57781B1F7043083B590CA2@SC-VEXCH1.marvell.com>
References: <1348840040-21390-1-git-send-email-twang13@marvell.com>
 <201209281615.49420.hverkuil@xs4all.nl>
In-Reply-To: <201209281615.49420.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Hans

Thank you for reviewing the patches!

>>On Fri September 28 2012 15:47:20 Albert Wang wrote:
>> 
>> This patch adds the support of Soc Camera on marvell-ccic mcam-core.
>> The Soc Camera mode does not compatible with current mode.
>> Only one mode can be used at one time.
>> 
>> To use Soc Camera, CONFIG_VIDEO_MMP_SOC_CAMERA should be defined.
>> What's more, the platform driver should support Soc camera at the same time.
>> 
>> Also add MIPI interface and dual CCICs support in Soc Camera mode.
>> 
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c | 1034 
>> ++++++++++++++++++++++----  
>> drivers/media/platform/marvell-ccic/mcam-core.h |  126 +++-
>>  2 files changed, 997 insertions(+), 163 deletions(-)
>> 
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c 
>> b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index ce2b7b4..4adb1ca 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c

...

>> +static int mcam_camera_querycap(struct soc_camera_host *ici,
>> +			struct v4l2_capability *cap)
>> +{
>> +	struct v4l2_dbg_chip_ident id;
>> +	struct mcam_camera *mcam = ici->priv;
>> +	struct soc_camera_device *icd = mcam->icd;
>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +	int ret = 0;
>> +
>> +	cap->version = KERNEL_VERSION(0, 0, 5);

>Don't fill in version. It's set to the kernel version automatically.

OK, will remove it.

>> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;

>Please also set cap->device_caps. See the spec.

OK, will update.

>> +	ret = v4l2_subdev_call(sd, core, g_chip_ident, &id);

>Yuck. Don't abuse this. g_chip_ident is for debugging purposes only.

Yes, can remove it.

>> +	if (ret < 0) {
>> +		cam_err(mcam, "%s %d\n", __func__, __LINE__);
>> +		return ret;
>> +	}
>> +
>> +	strcpy(cap->card, mcam->card_name);
>> +	strncpy(cap->driver, (const char *)&(id.ident), 4);

>No, the name of the driver is the name of this module: marvell_ccic.
>It's *not* the name of the sensor driver.

Yes, maybe you are right, we misunderstood this usage.

But I'm confused with how can we put the sensor module name to upper level?
I mean upper level user want to know which sensor module is connecting to the controller.
Currently, our user get the sensor module name by call this ioctl VIDIOC_QUERYCAP.

Anyway, maybe we need change the usage model.

>> +
>> +	return 0;
>> +}

>Regards
>
>	Hans

Thanks
Albert Wang
