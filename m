Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41098 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1KOHGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 02:06:44 -0500
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LUO0039ZX21E3M0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 Nov 2011 16:06:39 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LUO00JVPX320P40@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Tue, 15 Nov 2011 16:06:38 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Sylwester Nawrocki' <snjw23@gmail.com>
Cc: 'linux-media' <linux-media@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
 <1319182554-10645-4-git-send-email-riverful.kim@samsung.com>
 <4EC197A6.3090101@gmail.com>
In-reply-to: <4EC197A6.3090101@gmail.com>
Subject: RE: [PATCH 4/5] m5mols: Add boot flag for not showing the msg of I2C
 error
Date: Tue, 15 Nov 2011 16:05:01 +0900
Message-id: <002501cca364$e476cdb0$ad646910$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
> Sent: Tuesday, November 15, 2011 7:35 AM
> To: Heungjun Kim
> Cc: linux-media; Kyungmin Park
> Subject: Re: [PATCH 4/5] m5mols: Add boot flag for not showing the msg of
> I2C error
> 
> Hi HeungJun,
> 
> Sorry for late review. Please see my comments below..
Nevermind. It's fine.

> 
> On 10/21/2011 09:35 AM, HeungJun, Kim wrote:
> > In M-5MOLS sensor, the I2C error can be occured before sensor booting
> done,
> > becase I2C interface is not stabilized although the sensor have done
> already
> > for booting, so the right value is deliver through I2C interface. In case,
> > it needs to make the I2C error msg not to be printed.
> >
> > Signed-off-by: HeungJun, Kim<riverful.kim@samsung.com>
> > Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> > ---
> >   drivers/media/video/m5mols/m5mols.h      |    2 ++
> >   drivers/media/video/m5mols/m5mols_core.c |   17 +++++++++++++----
> >   2 files changed, 15 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/video/m5mols/m5mols.h
> b/drivers/media/video/m5mols/m5mols.h
> > index 75f7984..0d7e202 100644
> > --- a/drivers/media/video/m5mols/m5mols.h
> > +++ b/drivers/media/video/m5mols/m5mols.h
> > @@ -175,6 +175,7 @@ struct m5mols_version {
> >    * @ver: information of the version
> >    * @cap: the capture mode attributes
> >    * @power: current sensor's power status
> > + * @boot: "true" means the M-5MOLS sensor done ARM Booting
> 
> How about making this "booting" instead (the opposite meaning) ? Also there
> is
> no need for quotation marks.
Ok. It sounds close to the meaning.

> 
> >    * @ctrl_sync: true means all controls of the sensor are initialized
> >    * @int_capture: true means the capture interrupt is issued once
> >    * @lock_ae: true means the Auto Exposure is locked
> > @@ -210,6 +211,7 @@ struct m5mols_info {
> >   	struct m5mols_version ver;
> >   	struct m5mols_capture cap;
> >   	bool power;
> > +	bool boot;
> >   	bool issue;
> >   	bool ctrl_sync;
> >   	bool lock_ae;
> > diff --git a/drivers/media/video/m5mols/m5mols_core.c
> b/drivers/media/video/m5mols/m5mols_core.c
> > index 24e66ad..0aae868 100644
> > --- a/drivers/media/video/m5mols/m5mols_core.c
> > +++ b/drivers/media/video/m5mols/m5mols_core.c
> > @@ -138,6 +138,7 @@ static u32 m5mols_swap_byte(u8 *data, u8 length)
> >   static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32
> *val)
> >   {
> >   	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	struct m5mols_info *info = to_m5mols(sd);
> >   	u8 rbuf[M5MOLS_I2C_MAX_SIZE + 1];
> >   	u8 category = I2C_CATEGORY(reg);
> >   	u8 cmd = I2C_COMMAND(reg);
> > @@ -168,8 +169,10 @@ static int m5mols_read(struct v4l2_subdev *sd, u32
> size, u32 reg, u32 *val)
> >
> >   	ret = i2c_transfer(client->adapter, msg, 2);
> >   	if (ret<  0) {
> > -		v4l2_err(sd, "read failed: size:%d cat:%02x cmd:%02x. %d\n",
> > -			 size, category, cmd, ret);
> > +		if (info->boot)
> > +			v4l2_err(sd,
> > +				"read failed: cat:%02x cmd:%02x ret:%d\n",
> > +				category, cmd, ret);
> >   		return ret;
> 
> To avoid dodgy indentation, this could be for instance rewritten as:
> 
>    	ret = i2c_transfer(client->adapter, msg, 2);
>    	if (ret == 2)
> 		return 0;
> 
> 	if (!info->booting)
> 		v4l2_err(sd, "read failed: size:%d cat:%02x cmd:%02x. %d\n",
> 			 size, category, cmd, ret);
> 
>   	return ret < 0 ? ret : -EIO;
>
Ok. If the reason is dodgy indentation, it would be better to change the message
string to the more shorter others. I'll consider at the next version patch. 

> >   	}
> >
> > @@ -232,6 +235,7 @@ int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg,
> u32 *val)
> >   int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
> >   {
> >   	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	struct m5mols_info *info = to_m5mols(sd);
> >   	u8 wbuf[M5MOLS_I2C_MAX_SIZE + 4];
> >   	u8 category = I2C_CATEGORY(reg);
> >   	u8 cmd = I2C_COMMAND(reg);
> > @@ -263,8 +267,10 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg,
> u32 val)
> >
> >   	ret = i2c_transfer(client->adapter, msg, 1);
> >   	if (ret<  0) {
> > -		v4l2_err(sd, "write failed: size:%d cat:%02x cmd:%02x. %d\n",
> > -			size, category, cmd, ret);
> > +		if (info->boot)
> > +			v4l2_err(sd,
> > +				"write failed: cat:%02x cmd:%02x ret:%d\n",
> > +				category, cmd, ret);
> 
> Ditto.
> 
> >   		return ret;
> >   	}
> >
> > @@ -778,6 +784,7 @@ int __attribute__ ((weak)) m5mols_update_fw(struct
> v4l2_subdev *sd,
> >    */
> >   static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
> >   {
> > +	struct m5mols_info *info = to_m5mols(sd);
> >   	int ret;
> >
> >   	/* Execute ARM boot sequence */
> > @@ -786,6 +793,8 @@ static int m5mols_sensor_armboot(struct v4l2_subdev
> *sd)
> >   		ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
> >   	if (!ret)
> >   		ret = m5mols_timeout_interrupt(sd, REG_INT_MODE, 2000);
> > +	if (!ret)
> > +		info->boot = true;
> 
> If you move this line after the check below, there is no need for "if
> (!ret)".
It looks better. I'll adapt it.

> 
> >   	if (ret<  0)
> >   		return ret;
> >
> 
> --
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

