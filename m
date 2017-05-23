Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47242 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760916AbdEWRKE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 13:10:04 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 2/2] media: i2c: adv748x: add adv748x driver
References: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
 <42b47ca01dd35e510dece486ea931b8fd3642dcf.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2610503.i2TEihcINK@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>
Cc: sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <1182ebdf-9382-8dff-ccfa-ec05bd10ad72@ideasonboard.com>
Date: Tue, 23 May 2017 18:09:57 +0100
MIME-Version: 1.0
In-Reply-To: <2610503.i2TEihcINK@avalon>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/05/17 22:48, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.

Thanks for the review,

I've worked through these, and changes that were straightforward have already
been done locally.

Those that were more complicated or will take more thought are now on my todo
list and being worked through...

There are a sprinkling of questions below so I'll send this now :)


> 
> On Wednesday 17 May 2017 15:13:18 Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Provide basic support for the ADV7481 and ADV7482.
>>
>> The driver is modelled with 2 subdevices to allow simultaneous streaming
>> from the AFE (Analog front end) and HDMI inputs.
> 
> Isn't that now four subdevices ?

Of course :)

> 
>> Presently the HDMI is hardcoded to link to the TXA CSI bus, whilst the
>> AFE is linked to the TXB CSI bus.
>>
>> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
>> and an earlier rework by Niklas Söderlund.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> [snip]
> 
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> b/Documentation/devicetree/bindings/media/i2c/adv748x.txt new file mode
>> 100644
>> index 000000000000..98d4600b7d26
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>> @@ -0,0 +1,72 @@
>> +* Analog Devices ADV748X video decoder with HDMI receiver
>> +
>> +The ADV7481, and ADV7482 are multi format video decoders with an integrated
>> +HDMI receiver. It can output CSI-2 on two independent outputs TXA and TXB
> 
> s/It/They/ ?
> 

Ack

>> from +three input sources HDMI, analog and TTL.
>> +
>> +Required Properties:
>> +
>> +  - compatible: Must contain one of the following
>> +    - "adi,adv7481" for the ADV7481
>> +    - "adi,adv7482" for the ADV7482
>> +
>> +  - reg: I2C slave address
>> +
>> +  - interrupt-names: Should specify the interrupts as "intrq1" and/or
>> "intrq2"
>> +                     "intrq3" is only available on the adv7480 and adv7481
> 
> The bindings don't cover the ADV7480 yet, I wouldn't mention it here.
>

Ok, removed.

> Which interrupt(s) are mandatory and which are optional ? If they're all 
> mandatory (which I doubt) I would phrase it as 
> 
>   - interrupt-names: Should specify the "intrq1", "intrq2" and "intrq3" 
> interrupts. The "intrq3" interrupt is only available on the adv7481.
> 
> If they're all optional, I would move it to the Optional Properties section 
> and phrase it as
> 
>   - interrupt-names: Should specify the "intrq1", "intrq2" and/or "intrq3" 
> interrupts. All interrupts are optional. The "intrq3" interrupt is only 
> available on the adv7481.
> 

I believe they can be optional.
Added an optional section.


> If some of them only are mandatory,
> 
>   - interrupt-names: Should specify the "intrq1", "intrq2" and/or "intrq3" 
> interrupts. The ... interrupts are mandatory, while the ... interrupts are 
> optional. The "intrq3" interrupt is only available on the adv7481.
> 
>> +  - interrupts: Specify the interrupt lines for the ADV748x
>> +
>> +The device node must contain one 'port' child node per device input and
>> output +port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port
>> nodes +are numbered as follows.
>> +
>> +  Name                  Type            Port
>> +------------------------------------------------------------
>> +  HDMI                  sink            0
>> +  AIN1                  sink            1
>> +  AIN2                  sink            2
>> +  AIN3                  sink            3
>> +  AIN4                  sink            4
>> +  AIN5                  sink            5
>> +  AIN6                  sink            6
>> +  AIN7                  sink            7
>> +  AIN8                  sink            8
>> +  TTL                   sink            9
>> +  TXA                   source          10
>> +  TXB                   source          11
>> +
>> +The digital output port node must contain at least one source endpoint.
> 
> s/node/nodes/ ?
> s/source //
> 

Fixed

>> +Example:
>> +
>> +    video_receiver@70 {
>> +            compatible = "adi,adv7482";
>> +            reg = <0x70>;
>> +
>> +            #address-cells = <1>;
>> +            #size-cells = <0>;
>> +
>> +            interrupt-parent = <&gpio6>;
>> +            interrupt-names = "intrq1", "intrq2";
>> +            interrupts = <30 IRQ_TYPE_LEVEL_LOW>,
>> +                         <31 IRQ_TYPE_LEVEL_LOW>;
>> +
>> +            port@10 {
>> +                    reg = <10>;
>> +                    adv7482_txa: endpoint@1 {
> 
> There's no need to number endpoints when there's a single one. Otherwise you'd 
> need a reg property in the endpoint.
> 

Ok - that's Good IMO; Can multiple (more than 2) devices be connected to a
single CSI2 bus?

Even if they can -  I don't think we would support that yet so either way, only
one endpoint!

>> +                            clock-lanes = <0>;
>> +                            data-lanes = <1 2 3 4>;
>> +                            remote-endpoint = <&csi40_in>;
>> +                    };
>> +            };
>> +
>> +            port@11 {
>> +                    reg = <11>;
>> +                    adv7482_txb: endpoint@1 {
>> +                            clock-lanes = <0>;
>> +                            data-lanes = <1>;
>> +                            remote-endpoint = <&csi20_in>;
>> +                    };
>> +            };
> 
> The example only shows ports 10 and 11. Should all ports be present, even if 
> they have no endpoint, because they're present at the hardware level ? That's 
> debatable, but if the ports are optional when not connected, I would document 
> that explicitly above.

IMO, port descriptions should be optional - and if not described, then the
driver has no requirement to support that port.

How about:
-----
Ports are optional if they are not connected to anything at the hardware level,
but the driver may not provide any support for ports which are not described.
-----

This would then make supporting the ADV7480 straight forward as it doesn't have
any AFE/TXB.

I can imagine perhaps there are scenarios where someone might use the chip for
the AFE, and not require the HDMI, and thus not connect the HDMI input
connector, or only use the HDMI and not the AFE (of course it could also be said
that those designs would probably consider an alternative/simpler chip)

> 
>> +    };
> 
> This all should be indented with tabs.

Retabbed.


> 
> [snip]
> 
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 7c23b7a1fd05..5c6a14cdbad5 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -204,6 +204,16 @@ config VIDEO_ADV7183
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called adv7183.
>>
>> +config VIDEO_ADV748X
>> +	tristate "Analog Devices ADV748x decoder"
>> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> 
> You also need
> 
> 	depends on OF

added.

> 
>> +	---help---
>> +	  V4l2 subdevice driver for the Analog Devices
> 
> s/V4l2/V4L2/
> 

changed.

>> +	  ADV7481 and ADV7482 HDMI/Analog video decoder.
> 
> s/decoder/decoders/
> 

Corrected.

>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called adv748x.
> 
> One day I'll propose a module parameter for Kconfig
> 
> config VIDEO_ADV748X
> 	module adv748x
> 
> would generate the above sentence automatically.

Yes, Seconded! - There is a lot of duplicated text there!

> 
>>  config VIDEO_ADV7604
>>  	tristate "Analog Devices ADV7604 decoder"
>>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index 62323ec66be8..e17faab108d6 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -1,6 +1,7 @@
>>  msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
>>  obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
>>
>> +obj-$(CONFIG_VIDEO_ADV748X) += adv748x/
>>  obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
>>  obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8/
>>  obj-$(CONFIG_VIDEO_CX25840) += cx25840/
> 
> If only someone could send a patch to sort the Makefiles alphabetically, we 
> would merge it immediately. Oh, wait, 
> https://patchwork.kernel.org/patch/9667605/
> 

I consciously placed this up alphabetically sorted with other folders, rather
than sorted with single file drivers.

If that is wrong, and it should be alphabetical across the whole file I can move
it of course.

Looks like we need a script that can automate the sorting, so that a maintainer
can run it just before pushing to Linus or some other less painful point rather
than submitting a patch which will be out of date before it hits the ML.


The script could then also be run as a git hook to sort pre-committing or as
part of an extended checkpatch option too :)

</pipedreams?>


> [snip]
> 
>> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c
>> b/drivers/media/i2c/adv748x/adv748x-afe.c new file mode 100644
>> index 000000000000..bac7f6e13b90
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> 
> [snip]
> 
> 
>> +/*
>> ---------------------------------------------------------------------------
>> -- + * SDP
>> + */
>> +
>> +#define ADV748X_AFE_INPUT_CVBS_AIN1			0x00
>> +#define ADV748X_AFE_INPUT_CVBS_AIN2			0x01
>> +#define ADV748X_AFE_INPUT_CVBS_AIN3			0x02
>> +#define ADV748X_AFE_INPUT_CVBS_AIN4			0x03
>> +#define ADV748X_AFE_INPUT_CVBS_AIN5			0x04
>> +#define ADV748X_AFE_INPUT_CVBS_AIN6			0x05
>> +#define ADV748X_AFE_INPUT_CVBS_AIN7			0x06
>> +#define ADV748X_AFE_INPUT_CVBS_AIN8			0x07
> 
> You don't use these macros, you can remove them.

Done.

> 
> [snip]
> 
>> +static int adv748x_afe_read_ro_map(struct adv748x_state *state, u8 reg)
>> +{
>> +	int ret;
>> +
>> +	/* Select SDP Read-Only Main Map */
>> +	ret = sdp_write(state, 0x0e, 0x01);
> 
> Can we get nice readable macros instead of magic values ? :-)

Now I have more documentation yes, I think I can convert some more of these values.


> Any risk this could race with the write to the same register in the set 
> control handler ?

Yes, it is a small possibility.

This locking is a bit of a pain, and I am torn between fine-grained locking, vs
global lock of the whole ADV748x.

The controls already take the global lock - but not all of the pad-format ops or
video-ops.

I'll add more locking.


>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return sdp_read(state, reg);
>> +}
>> +
>> +static int adv748x_afe_status(struct adv748x_afe *afe, u32 *signal,
>> +			      v4l2_std_id *std)
>> +{
>> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +	int info;
>> +
>> +	/* Read status from reg 0x10 of SDP RO Map */
>> +	info = adv748x_afe_read_ro_map(state, 0x10);
>> +	if (info < 0)
>> +		return info;
>> +
>> +	if (signal)
>> +		*signal = info & BIT(0) ? 0 : V4L2_IN_ST_NO_SIGNAL;
>> +
>> +	if (!std)
>> +		return 0;
>> +
>> +	*std = V4L2_STD_UNKNOWN;
>> +
>> +	/* Standard not valid if there is no signal */
> 
> How about
> 
> 	/* Standard not valid if there is no signal */
> 	if (!(info & BIT(0))) {
> 		*std = V4L2_STD_UNKNOWN;
> 		return 0;
> 	}
> 
> so you can lower the indentation of the switch statement ? It also avoids pre-
> assigning *std needlessly when there is a signal.

Sounds good to me.

Done.

> 
>> +	if (info & BIT(0)) {
>> +		switch (info & 0x70) {
>> +		case 0x00:
>> +			*std = V4L2_STD_NTSC;
>> +			break;
>> +		case 0x10:
>> +			*std = V4L2_STD_NTSC_443;
>> +			break;
>> +		case 0x20:
>> +			*std = V4L2_STD_PAL_M;
>> +			break;
>> +		case 0x30:
>> +			*std = V4L2_STD_PAL_60;
>> +			break;
>> +		case 0x40:
>> +			*std = V4L2_STD_PAL;
>> +			break;
>> +		case 0x50:
>> +			*std = V4L2_STD_SECAM;
>> +			break;
>> +		case 0x60:
>> +			*std = V4L2_STD_PAL_Nc | V4L2_STD_PAL_N;
>> +			break;
>> +		case 0x70:
>> +			*std = V4L2_STD_SECAM;
>> +			break;
>> +		default:
>> +			*std = V4L2_STD_UNKNOWN;
>> +			break;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +static int adv748x_afe_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +	int ret, signal = V4L2_IN_ST_NO_SIGNAL;
>> +
>> +	mutex_lock(&state->mutex);
>> +
>> +	ret = adv748x_txb_power(state, enable);
>> +	if (ret)
>> +		goto error;
>> +
>> +	afe->streaming = enable;
>> +
>> +	adv748x_afe_status(afe, &signal, NULL);
>> +	if (signal != V4L2_IN_ST_NO_SIGNAL)
>> +		adv_dbg(state, "Detected SDP signal\n");
>> +	else
>> +		adv_info(state, "Couldn't detect SDP video signal\n");
> 
> I'd make this a debug message too, to avoid giving userspace a way to flood 
> the kernel log.

Done

> 
>> +
>> +error:
>> +	mutex_unlock(&state->mutex);
>> +
>> +	return ret;
>> +}
> 
> [snip]
> 
>> +static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
>> +				      struct v4l2_subdev_pad_config *cfg,
>> +				      struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +	if (code->index != 0)
>> +		return -EINVAL;
>> +
>> +	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
>> +
>> +	return 0;
>> +}
>> +
>> +
> 
> Extra blank line.

Done

> 
>> +static int adv748x_afe_get_pad_format(struct v4l2_subdev *sd,
>> +				      struct v4l2_subdev_pad_config *cfg,
>> +				      struct v4l2_subdev_format *format)
>> +{
>> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>> +
>> +	adv748x_afe_fill_format(afe, &format->format);
> 
> This will return an height that depends on the active standard, while try 
> formats must not depend on the current device configuration. You can't 
> implement this properly as we have no pad operation related to TV standards, 
> and we certainly don't want to create such pad operations by blindly copying 
> the corresponding video ops. As a temporary work around I believe it should be 
> fine to set the height based on the active standard in the set format handler, 
> which should then copy the whole format into the try format. This function 
> should then return the try format when which is set to V4L2_SUBDEV_FORMAT_TRY 
> and call adv748x_afe_fill_format() otherwise.
> 
> Note that the get and set format handlers should in most cases take the pad 
> into account. For a subdev that can't change the format, a set format call on 
> the source pad should just return the format set on the sink pad without 
> changing anything.
> 
> There's also a problem here related to the sink pad: the input signal being 
> analog, the concept of a media bus format makes no sense. There's no UYVY8 in 
> analog TV signals, nor is there an image width expressed as a number of 
> pixels.
> 
> There's no point in trying to avoid hacks here as the API clearly lacks 
> support for analog TV, so your goal should be to try and minimize the hacks.


On my todo list to come back to...



>> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +		struct v4l2_mbus_framefmt *fmt;
>> +
>> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>> +		format->format.code = fmt->code;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv748x_afe_set_pad_format(struct v4l2_subdev *sd,
>> +				      struct v4l2_subdev_pad_config *cfg,
>> +				      struct v4l2_subdev_format *format)
>> +{
>> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>> +
>> +	adv748x_afe_fill_format(afe, &format->format);
>> +
>> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +		struct v4l2_mbus_framefmt *fmt;
>> +
>> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>> +		fmt->code = format->format.code;
> 
> What's the point in storing the code in fmt->code when 
> adv748x_afe_fill_format() has hardcoded it to MEDIA_BUS_FMT_UYVY8_2X8, only to 
> retrieve it in adv748x_afe_get_pad_format() ?

I'll go through AFE/HDMI get/set in detail after this.

> 
>> +	}
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +/* Contrast */
>> +#define ADV748X_AFE_REG_CON		0x08	/*Unsigned */
> 
> Missing space after /*. Same comment for the code below.

All done.

> 
>> +#define ADV748X_AFE_CON_MIN		0
>> +#define ADV748X_AFE_CON_DEF		128
>> +#define ADV748X_AFE_CON_MAX		255
>> +/* Brightness*/
>> +#define ADV748X_AFE_REG_BRI		0x0a	/*Signed */
>> +#define ADV748X_AFE_BRI_MIN		-128
>> +#define ADV748X_AFE_BRI_DEF		0
>> +#define ADV748X_AFE_BRI_MAX		127
>> +/* Hue */
>> +#define ADV748X_AFE_REG_HUE		0x0b	/*Signed, inverted */
>> +#define ADV748X_AFE_HUE_MIN		-127
>> +#define ADV748X_AFE_HUE_DEF		0
>> +#define ADV748X_AFE_HUE_MAX		128
>> +
>> +/* Saturation */
>> +#define ADV748X_AFE_REG_SD_SAT_CB	0xe3
>> +#define ADV748X_AFE_REG_SD_SAT_CR	0xe4
>> +#define ADV748X_AFE_SAT_MIN		0
>> +#define ADV748X_AFE_SAT_DEF		128
>> +#define ADV748X_AFE_SAT_MAX		255
>> +
>> +static int adv748x_afe_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct adv748x_afe *afe = adv748x_ctrl_to_afe(ctrl);
>> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +	int ret;
>> +
>> +	ret = sdp_write(state, 0x0e, 0x00);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_BRIGHTNESS:
>> +		if (ctrl->val < ADV748X_AFE_BRI_MIN ||
>> +		    ctrl->val > ADV748X_AFE_BRI_MAX)
>> +			return -ERANGE;
> 
> The control framework will catch this error internally, you can remove the 
> manual check.

Excellent - I love removing code :)

> 
>> +		ret = sdp_write(state, ADV748X_AFE_REG_BRI, ctrl->val);
>> +		break;
>> +	case V4L2_CID_HUE:
>> +		if (ctrl->val < ADV748X_AFE_HUE_MIN ||
>> +		    ctrl->val > ADV748X_AFE_HUE_MAX)
>> +			return -ERANGE;
>> +
>> +		/* Hue is inverted according to HSL chart */
>> +		ret = sdp_write(state, ADV748X_AFE_REG_HUE, -ctrl->val);
>> +		break;
>> +	case V4L2_CID_CONTRAST:
>> +		if (ctrl->val < ADV748X_AFE_CON_MIN ||
>> +		    ctrl->val > ADV748X_AFE_CON_MAX)
>> +			return -ERANGE;
>> +
>> +		ret = sdp_write(state, ADV748X_AFE_REG_CON, ctrl->val);
>> +		break;
>> +	case V4L2_CID_SATURATION:
>> +		if (ctrl->val < ADV748X_AFE_SAT_MIN ||
>> +		    ctrl->val > ADV748X_AFE_SAT_MAX)
>> +			return -ERANGE;
>> +		/*
>> +		 * This could be V4L2_CID_BLUE_BALANCE/V4L2_CID_RED_BALANCE
>> +		 * Let's not confuse the user, everybody understands 
> saturation
>> +		 */
> 
> This isn't about confusing the user. The saturation is a gain applied to the 
> chroma, while the balance is an offset. If the two hardware controls are 
> gains, the code is fine, and the comment isn't. If the two hardware controls 
> are offsets, we should expose them as balance controls instead.
> 

Thanks - you've cleared that up for me. Comment removed.

I'm sure these are Saturation, there are separate registers for U/V balance as
well, but I don't think they map to V4L2_CID_BLUE_BALANCE/V4L2_CID_RED_BALANCE
either :)


>> +		ret = sdp_write(state, ADV748X_AFE_REG_SD_SAT_CB, ctrl->val);
>> +		if (ret)
>> +			break;
>> +		ret = sdp_write(state, ADV748X_AFE_REG_SD_SAT_CR, ctrl->val);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int adv748x_afe_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct adv748x_afe *afe = adv748x_ctrl_to_afe(ctrl);
>> +	unsigned int width, height, fps;
>> +	v4l2_std_id std;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_PIXEL_RATE:
>> +		width = 720;
>> +		if (afe->curr_norm == V4L2_STD_ALL)
>> +			adv748x_afe_status(afe, NULL,  &std);
>> +		else
>> +			std = afe->curr_norm;
>> +
>> +		height = std & V4L2_STD_525_60 ? 480 : 576;
>> +		fps = std & V4L2_STD_525_60 ? 30 : 25;
>> +
>> +		*ctrl->p_new.p_s64 = width * height * fps;
> 
> Will the hardware really change the image height autonomously if the input 
> standard is changed ? Or does it need a software action ? In the latter case, 
> the software action should be triggered by the set format operation, and the 
> pixel rate should reflect that. You could then avoid making the control 
> volatile, and change its value in the set format handler (with a call to 
> __v4l2_ctrl_s_ctrl_int64). I believe you would also need to return 0 in the 
> set control handler for the V4L2_CID_PIXEL_RATE control, as it would get 
> called from __v4l2_ctrl_s_ctrl_int64().
> 

Certainly at the moment we no hardware detect interrupt handling.

Using internal calls to the TX will be the right way I think,

I will have to make sure that the TX pixel rate is defined correctly at link
time, and any time it is updated.

Added to todo... :

>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +int adv748x_afe_probe(struct adv748x_afe *afe)
>> +{
>> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +	int ret;
>> +	unsigned int i;
>> +
>> +	afe->streaming = false;
>> +	afe->curr_norm = V4L2_STD_ALL;
>> +
>> +	adv748x_subdev_init(&afe->sd, state, &adv748x_afe_ops, "afe");
>> +
>> +	for (i = ADV748X_AFE_SINK_AIN0; i <= ADV748X_AFE_SINK_AIN7; i++)
>> +		afe->pads[i].flags = MEDIA_PAD_FL_SINK;
>> +
>> +	afe->pads[ADV748X_AFE_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
>> +
>> +	ret = media_entity_pads_init(&afe->sd.entity, ADV748X_AFE_NR_PADS,
>> +			afe->pads);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = adv748x_afe_init_controls(afe);
>> +	if (ret)
>> +		goto err_free_media;
>> +
>> +	return 0;
>> +
>> +err_free_media:
> 
> err_cleanup_media ? Or just error, as there's a single label ?

just error will be fine :)

> 
>> +	media_entity_cleanup(&afe->sd.entity);
>> +
>> +	return ret;
>> +}
> 
> [snip]
> 
>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
>> b/drivers/media/i2c/adv748x/adv748x-core.c new file mode 100644
>> index 000000000000..54937ce05f3a
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> 
> [snip]
> 
>> +static int adv748x_write_regs(struct adv748x_state *state,
>> +			      const struct adv748x_reg_value *regs)
>> +{
>> +	struct i2c_msg msg;
>> +	u8 data_buf[2];
>> +	int ret = -EINVAL;
> 
> So if the regs array is empty, you'll return an error ?
> 
>> +
>> +	if (!state->client->adapter) {
>> +		adv_err(state, "No adapter for regs write\n");
>> +		return -ENODEV;
>> +	}
> 
> When can you have a client without an adapter ?
> 
>> +	msg.flags = 0;
>> +	msg.len = 2;
>> +	msg.buf = &data_buf[0];
>> +
>> +	while (regs->addr != ADV748X_I2C_EOR) {
>> +
> 
> Extra blank line.
> 
>> +		if (regs->addr == ADV748X_I2C_WAIT)
>> +			msleep(regs->value);
> 
> You need curly braces around this statement.
> 
>> +		else {
>> +			msg.addr = regs->addr;
>> +			data_buf[0] = regs->reg;
>> +			data_buf[1] = regs->value;
>> +
>> +			ret = i2c_transfer(state->client->adapter, &msg, 1);
> 
> This makes me feel slightly uncomfortable. Please check with Wolfram whether 
> writing to different addresses from a single client is considered as a hack or 
> not.
> 
>> +			if (ret < 0) {
>> +				adv_err(state,
>> +					"Error regs addr: 0x%02x reg: 
> 0x%02x\n",
>> +					regs->addr, regs->reg);
>> +				break;
> 
> You can just return ret here.
> 
>> +			}
>> +		}
>> +		regs++;
>> +	}
>> +
>> +	return (ret < 0) ? ret : 0;
> 
> And return 0 unconditionally here.
> 
>> +}
>> +
>> +int adv748x_write(struct adv748x_state *state, u8 addr, u8 reg, u8 value)
>> +{
>> +	struct adv748x_reg_value regs[2];
>> +	int ret;
>> +
>> +	regs[0].addr = addr;
>> +	regs[0].reg = reg;
>> +	regs[0].value = value;
>> +	regs[1].addr = ADV748X_I2C_EOR;
>> +	regs[1].reg = 0xFF;
>> +	regs[1].value = 0xFF;
>> +
>> +	ret = adv748x_write_regs(state, regs);
> 
> This is overcomplicated, you don't need the whole machinery to write to a 
> single register. i2c_smbus_write_byte() will do.
> 
>> +	return ret;
> 
> No need for the ret variable.
> 
>> +}
> 
> Note that these comments will be moot if you use regmap as I proposed below. 
> In that case, you will need to create secondary devices with 
> i2c_new_secondary_device() to be used with regmap.

Regmap is on my wish list for this driver already ... I'll try to get that
converted.

> [snip]
> 
>> +int adv748x_txa_power(struct adv748x_state *state, bool on)
>> +{
>> +	int val, ret;
>> +
>> +	val = txa_read(state, 0x1e);
>> +	if (val < 0)
>> +		return val;
>> +
>> +	if (on && ((val & 0x40) == 0))
>> +		ret = adv748x_write_regs(state, adv748x_power_up_txa_4lane);
>> +	else
>> +		ret = adv748x_write_regs(state, adv748x_power_down_txa_4lane);
> 
> I don't know what this magic value represents (hint...), but do you really 
> want to power off when the on argument is true and bit 0x40 is set ?

Well, I'm missing something. I can't find the bit 0x40 in the documentation here.

CSI-TXA/CSI-TXB maps both have register 0x1e as csi_tx_top_reg_1e with only one
bit documented : "interpret_fs_as_ls" at BIT(7).

I'll try to figure out where this came from or if I'm reading the wrong register
map.

Perhaps it's a magical undocumented bit :)

I also intend to move this TX specific code into the adv748x_csi2 module as well.


>> +
>> +	return ret;
> 
> No need for the ret variable, just return directly from the calls.
> 
>> +}
>> +
>> +int adv748x_txb_power(struct adv748x_state *state, bool on)
>> +{
>> +	int val, ret;
>> +
>> +	val = txb_read(state, 0x1e);
>> +	if (val < 0)
>> +		return val;
>> +
>> +	if (on && ((val & 0x40) == 0))
>> +		ret = adv748x_write_regs(state, adv748x_power_up_txb_1lane);
>> +	else
>> +		ret = adv748x_write_regs(state, adv748x_power_down_txb_1lane);
> 
> Ditto.

As above, and hopefully, I can simplify this to be a single function for the
CSI2 entity instead.

> 
>> +
>> +	return ret;
>> +}
> 
> [snip]
> 
>> +/* TODO:KPB: Need to work out how to provide AFE port select! More
>> entities? */
> 
> KPB ?



Talking to myself, - The problem is I never listen. :-)


Do you have any suggestions here?

The AFE can have up to 8 inputs, but only one will be selected.
If the DT describes a single physical connection, (such as on Salvator-X) it is
straightforward that we support only that .. but of course there will be
use-cases with multiple inputs and 'someone' will want to be able to select.

AFAICT there is no way to expose an input selection on a subdev - Is this going
to be a custom control ? :S

In an ideal world - the inputs could be enumerated through the video node inputs
- but of course  - that is a separate driver with no interface between the
subdevs for determining input selection ?

Otherwise - it will have to be an entity for each of the 8 inputs with media
controller setting the routes - but that feels very heavyweight for userspace if
it wants to switch camera inputs :-S




> 
>> +#define ADV748X_SDP_INPUT_CVBS_AIN8 0x07
>> +
>> +/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
>> +/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
>> +static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
>> +
>> +	{ADV748X_I2C_IO, 0x00, 0x30},  /* Disable chip powerdown powerdown Rx 
> */
>> +	{ADV748X_I2C_IO, 0xF2, 0x01},  /* Enable I2C Read Auto-Increment */
>> +
>> +	{ADV748X_I2C_IO, 0x0E, 0xFF},  /* LLC/PIX/AUD/SPI PINS TRISTATED */
>> +
>> +	{ADV748X_I2C_SDP, 0x0f, 0x00}, /* Exit Power Down Mode */
> 
> Let's not mix uppercase and lowercase hex constants, you can use lowercase 
> throughout the whole driver.
> 

Ack. - That's a painful one to fix. I wonder if that's sed'able.

I'll fix as I go along.

>> +	{ADV748X_I2C_SDP, 0x52, 0xCD},/* ADI Required Write */
>> +	/* TODO: do not use hard codeded INSEL */
> 
> How about addressing that ? :-)

I'd love to hear your comments on the options here :
 Custom ctrl, input enumeration, media controller


> 
>> +	{ADV748X_I2C_SDP, 0x00, ADV748X_SDP_INPUT_CVBS_AIN8},
>> +	{ADV748X_I2C_SDP, 0x0E, 0x80},	/* ADI Required Write */
>> +	{ADV748X_I2C_SDP, 0x9C, 0x00},	/* ADI Required Write */
>> +	{ADV748X_I2C_SDP, 0x9C, 0xFF},	/* ADI Required Write */
>> +	{ADV748X_I2C_SDP, 0x0E, 0x00},	/* ADI Required Write */
>> +
>> +	/* ADI recommended writes for improved video quality */
>> +	{ADV748X_I2C_SDP, 0x80, 0x51},	/* ADI Required Write */
>> +	{ADV748X_I2C_SDP, 0x81, 0x51},	/* ADI Required Write */
>> +	{ADV748X_I2C_SDP, 0x82, 0x68},	/* ADI Required Write */
>> +
>> +	{ADV748X_I2C_SDP, 0x03, 0x42},  /* Tri-S Output , PwrDwn 656 pads */
>> +	{ADV748X_I2C_SDP, 0x04, 0xB5},	/* ITU-R BT.656-4 compatible */
>> +	{ADV748X_I2C_SDP, 0x13, 0x00},	/* ADI Required Write */
>> +
>> +	{ADV748X_I2C_SDP, 0x17, 0x41},	/* Select SH1 */
>> +	{ADV748X_I2C_SDP, 0x31, 0x12},	/* ADI Required Write */
>> +	{ADV748X_I2C_SDP, 0xE6, 0x4F},  /* V bit end pos manually in NTSC */
>> +
>> +	/* TODO: Convert this to a control option */
>> +#ifdef REL_DGB_FORCE_TO_SEND_COLORBAR
>> +	{ADV748X_I2C_SDP, 0x0C, 0x01},	/* ColorBar */
>> +	{ADV748X_I2C_SDP, 0x14, 0x01},	/* ColorBar */
>> +#endif
> 
> I think you can remove this. Or convert it to a control, as proposed by the 
> comment.

I think it's valuable to keep for people who are bringing up a platform.
Actually - it could even be a good automatable test for the

I presume V4L2_CID_TEST_PATTERN should be a reasonable choice ...

>> +	/* Enable 1-Lane MIPI Tx, */
>> +	/* enable pixel output and route SD through Pixel port */
>> +	{ADV748X_I2C_IO, 0x10, 0x70},
>> +
>> +	{ADV748X_I2C_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
>> +	{ADV748X_I2C_TXB, 0x00, 0xA1},	/* Set Auto DPHY Timing */
>> +	{ADV748X_I2C_TXB, 0xD2, 0x40},	/* ADI Required Write */
>> +	{ADV748X_I2C_TXB, 0xC4, 0x0A},	/* ADI Required Write */
>> +	{ADV748X_I2C_TXB, 0x71, 0x33},	/* ADI Required Write */
>> +	{ADV748X_I2C_TXB, 0x72, 0x11},	/* ADI Required Write */
>> +	{ADV748X_I2C_TXB, 0xF0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
>> +	{ADV748X_I2C_TXB, 0x31, 0x82},	/* ADI Required Write */
>> +	{ADV748X_I2C_TXB, 0x1E, 0x40},	/* ADI Required Write */
>> +	{ADV748X_I2C_TXB, 0xDA, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
>> +
>> +	{ADV748X_I2C_WAIT, 0x00, 0x02},	/* delay 2 */
>> +	{ADV748X_I2C_TXB, 0x00, 0x21 },	/* Power-up CSI-TX */
>> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
>> +	{ADV748X_I2C_TXB, 0xC1, 0x2B},	/* ADI Required Write */
>> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
>> +	{ADV748X_I2C_TXB, 0x31, 0x80},	/* ADI Required Write */
>> +
>> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
>> +};
>> +
>> +static int adv748x_reset(struct adv748x_state *state)
>> +{
>> +	int ret;
>> +
>> +	ret = adv748x_write_regs(state, adv748x_sw_reset);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = adv748x_write_regs(state, adv748x_set_slave_address);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* Init and power down TXA */
>> +	ret = adv748x_write_regs(state, adv748x_init_txa_4lane);
>> +	if (ret)
>> +		return ret;
>> +
>> +	adv748x_txa_power(state, 0);
> 
> Can't you modify the TXA init table to initialized it powered off ?
> 
>> +	/* Set VC 0 */
>> +	txa_clrset(state, 0x0d, 0xc0, 0x00);
> 
> Can't this be included in the table too ?
> 
>> +	/* Init and power down TXB */
>> +	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
>> +	if (ret)
>> +		return ret;
>> +
>> +	adv748x_txb_power(state, 0);
>> +
>> +	/* Set VC 0 */
>> +	txb_clrset(state, 0x0d, 0xc0, 0x00);
> 
> Same comments as for TXA.

Yes, moving those to the init tables seems a good choice.
I think I'll add a reset call to each of the entities as well to move this code
to their respective objects.

> 
>> +	/* Disable chip powerdown & Enable HDMI Rx block */
>> +	io_write(state, 0x00, 0x40);
>> +
>> +	/* Enable 4-lane CSI Tx & Pixel Port */
>> +	io_write(state, 0x10, 0xe0);
>> +
>> +	/* Use vid_std and v_freq as freerun resolution for CP */
>> +	cp_clrset(state, 0xc9, 0x01, 0x01);
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv748x_print_info(struct adv748x_state *state)
>> +{
>> +	int msb, lsb;
>> +
>> +	lsb = io_read(state, 0xdf);
>> +	msb = io_read(state, 0xe0);
>> +
>> +	if (lsb < 0 || msb < 0) {
>> +		adv_err(state, "Failed to read chip revision\n");
>> +		return -EIO;
>> +	}
>> +
>> +	adv_info(state, "chip found @ 0x%02x revision %02x%02x\n",
>> +		 state->client->addr << 1, lsb, msb);
> 
> Should you return an error if the ID isn't known to the driver ?

Yes, this could be a reasonable thing to do.
Probably wants a device info structure to check expected values here.

> 
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state
>> *state,
>> +		const struct v4l2_subdev_ops *ops, const char *ident)
>> +{
>> +	v4l2_subdev_init(sd, ops);
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +
>> +	/* the owner is the same as the i2c_client's driver owner */
>> +	sd->owner = state->dev->driver->owner;
>> +	sd->dev = state->dev;
>> +
>> +	v4l2_set_subdevdata(sd, state);
>> +
>> +	/* initialize name */
>> +	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x %s",
>> +		state->dev->driver->name,
>> +		i2c_adapter_id(state->client->adapter),
>> +		state->client->addr, ident);
>> +
>> +	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> 
> I don't think this applies to all subdevs. If there are more appropriate 
> functions in the existing ones please pick them, otherwise don't bother adding 
> new ones as the API is messed up and needs to be reworked anyway.

Ok

How about MEDIA_ENT_F_IO_V4L for the CSI2 entities.

The distinction between AFE, and HDMI is a bit more difficult:

I could set MEDIA_ENT_F_IO_DTV for HDMI and continue with
MEDIA_ENT_F_ATV_DECODER for analog? Or should this be a VBI variant...

Do these 'functions' have a discernable effect anywhere?


> 
>> +	sd->entity.ops = &adv748x_media_ops;
>> +}
>> +
>> +static int adv748x_parse_dt(struct adv748x_state *state)
>> +{
>> +	struct device_node *ep_np = NULL;
>> +	struct of_endpoint ep;
>> +	unsigned int found = 0;
> 
> 	bool found = false;
> 
>> +
>> +	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
>> +		of_graph_parse_endpoint(ep_np, &ep);
>> +		adv_info(state, "Endpoint %s on port %d",
>> +				of_node_full_name(ep.local_node),
>> +				ep.port);
>> +
>> +		if (ep.port > ADV748X_PORT_MAX) {
> 
> This should be >=

Fixed.

> 
>> +			adv_err(state, "Invalid endpoint %s on port %d",
>> +				of_node_full_name(ep.local_node),
>> +				ep.port);
>> +
>> +			continue;
>> +		}
>> +
>> +		state->endpoints[ep.port] = ep_np;
> 
> What happens if you have multiple endpoints per port ? It looks like you'll 
> keep the last one only. Shouldn't that be treated as an error ?

Perhaps - at least worth an error message, but I'm not convinced it should be a
fatal error? The actual connections established will be identifiable through the
media-controller at run time.

I can add an adv_err print and then if someone does try this they'll have a
better understanding of the issue.


> 
> You need to get a reference to ep_np, and release it at remove time.
> 

Added, along with a adv748x_dt_cleanup()

>> +		found++;
> 
> 		found = true;
> 
>> +	}
>> +
>> +	return found ? 0 : -ENODEV;
>> +}
>> +
>> +static int adv748x_setup_links(struct adv748x_state *state)
>> +{
>> +	int ret;
>> +	int enabled = MEDIA_LNK_FL_ENABLED;
>> +
>> +/*
>> + * HACK/Workaround:
>> + *
>> + * Currently non-immutable link resets go through the RVin
>> + * driver, and cause the links to fail, due to not being part of RVIN.
>> + * As a temporary workaround until the RVIN driver knows better than to
>> parse
>> + * links that do not belong to it, use static immutable links for our
>> internal
>> + * media paths.
>> + */
> 
> Do we have an ETA for the VIN fix ?


I don't know yet - I'll need to discuss this with Niklas further.

I can remove this 'workaround' and leave the code as static immutable links
until they can be supporte.

>> +#define ADV748x_DEV_STATIC_LINKS
>> +#ifdef ADV748x_DEV_STATIC_LINKS
>> +	enabled |= MEDIA_LNK_FL_IMMUTABLE;
>> +#endif
>> +
>> +	/* TXA - Default link is with HDMI */
>> +	ret = media_create_pad_link(&state->hdmi.sd.entity, 1,
>> +				    &state->txa.sd.entity, 0, enabled);
>> +	if (ret) {
>> +		adv_err(state, "Failed to create HDMI-TXA pad links");
> 
> s/links/link/

done

> 
>> +		return ret;
>> +	}
>> +
>> +#ifndef ADV748x_DEV_STATIC_LINKS
>> +	ret = media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_SOURCE,
>> +				    &state->txa.sd.entity, 0, 0);
>> +	if (ret) {
>> +		adv_err(state, "Failed to create AFE-TXA pad links");
> 
> s/links/link/

done

> 
>> +		return ret;
>> +	}
>> +#endif
>> +
>> +	/* TXB - Can only output from the AFE */
>> +	ret = media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_SOURCE,
>> +				    &state->txb.sd.entity, 0, enabled);
>> +	if (ret) {
>> +		adv_err(state, "Failed to create AFE-TXB pad links");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +static int adv748x_probe(struct i2c_client *client,
>> +			 const struct i2c_device_id *id)
>> +{
>> +	struct adv748x_state *state;
>> +	int ret;
>> +
>> +	/* Check if the adapter supports the needed features */
>> +	if (!i2c_check_functionality(client->adapter, 
> I2C_FUNC_SMBUS_BYTE_DATA))
>> +		return -EIO;
>> +
>> +	state = devm_kzalloc(&client->dev, sizeof(struct adv748x_state),
>> +			     GFP_KERNEL);
> 
> Please use kzalloc(). The state structure needs to outlive the remove() time 
> if userspace keeps a subdev node open. The V4L2 and MC code don't support this 
> yet so you can't fix the issue completely, but devm_kzalloc() is clearly part 
> of the problem.
> 


And free() in remove? Surely that's just the exact same scenario?

Shouldn't we be looking to take a reference to the dev on open, and release on
close instead? (Of course that's a much lower core level issue)

IMO (of course if you disagree, I'll change this) it would be more clear to keep
this as devm_ - and when a core solution is identified, it will be clear to
apply to all the devm's - or the devm's will become automatic?





>> +	if (!state)
>> +		return -ENOMEM;
>> +
>> +	mutex_init(&state->mutex);
>> +
>> +	state->dev = &client->dev;
>> +	state->client = client;
>> +	i2c_set_clientdata(client, state);
>> +
>> +	/* SW reset ADV748X to its default values */
>> +	ret = adv748x_reset(state);
>> +	if (ret) {
>> +		adv_err(state, "Failed to reset hardware");
>> +		goto err_free_mutex;
>> +	}
>> +
>> +	ret = adv748x_print_info(state);
>> +	if (ret)
>> +		goto err_free_mutex;
> 
> Shouldn't you try to identify the chip before resetting it ?

Maybe it's taking a punt :) (yes)

Also - renaming adv748x_print_info() -> adv748x_identify_chip() :)

> 
>> +	/* Discover and process ports declared by the Device tree endpoints */
>> +	ret = adv748x_parse_dt(state);
>> +	if (ret)
>> +		goto err_free_mutex;
> 
> I'd parse DT before trying to access the chip.

Ok

> 
>> +	/* Initialise HDMI */
>> +	ret = adv748x_hdmi_probe(&state->hdmi);
>> +	if (ret) {
>> +		adv_err(state, "Failed to probe HDMI");
>> +		goto err_free_mutex;
>> +	}
>> +
>> +	/* Initialise AFE */
>> +	ret = adv748x_afe_probe(&state->afe);
>> +	if (ret) {
>> +		adv_err(state, "Failed to probe AFE");
>> +		goto err_free_hdmi;
>> +	}
>> +
>> +	/* Initialise TXA */
>> +	ret = adv748x_csi2_probe(state, &state->txa);
>> +	if (ret) {
>> +		adv_err(state, "Failed to probe TXA");
>> +		goto err_free_afe;
>> +	}
>> +
>> +	/* Initialise TXB  (Not 7480) */
>> +	ret = adv748x_csi2_probe(state, &state->txb);
>> +	if (ret) {
>> +		adv_err(state, "Failed to probe TXB");
>> +		goto err_free_txa;
>> +	}
> 
> As documented in the comments you're performing initialization here, should 
> the functions be named *_init() ?

Sure - I guess I was following the driver model naming - but yes _init is more
appropriate I think.

> 
>> +	return 0;
>> +
>> +err_free_txa:
>> +	adv748x_csi2_remove(&state->txa);
> 
> And the remove functions called *_cleanup() ? I'd then rename the error labels 
> to err_cleanup_*.

I'm less convinced here - they are still doing remove actions - but I can change
them.


> 
>> +err_free_afe:
>> +	adv748x_afe_remove(&state->afe);
>> +err_free_hdmi:
>> +	adv748x_hdmi_remove(&state->hdmi);
>> +err_free_mutex:
>> +	mutex_destroy(&state->mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +static int adv748x_remove(struct i2c_client *client)
>> +{
>> +	struct adv748x_state *state = i2c_get_clientdata(client);
>> +
>> +	adv748x_afe_remove(&state->afe);
>> +	adv748x_hdmi_remove(&state->hdmi);
>> +
>> +	adv748x_csi2_remove(&state->txa);
>> +	adv748x_csi2_remove(&state->txb);
>> +
>> +	mutex_destroy(&state->mutex);
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +static struct i2c_driver adv748x_driver = {
>> +	.driver = {
>> +		.name = "adv748x",
>> +		.of_match_table = of_match_ptr(adv748x_of_table),
> 
> No need for the of_match_ptr() macro as the driver depends on OF.

Ok

> 
>> +	},
>> +	.probe = adv748x_probe,
>> +	.remove = adv748x_remove,
>> +	.id_table = adv748x_id,
>> +};
>> +
>> +module_i2c_driver(adv748x_driver);
>> +
>> +MODULE_AUTHOR("Kieran Bingham <kieran.bingham@ideasonboard.com>");
>> +MODULE_DESCRIPTION("ADV748X video decoder");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c
>> b/drivers/media/i2c/adv748x/adv748x-csi2.c new file mode 100644
>> index 000000000000..a745246e34b5
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> 
> [snip]
> 
>> @@ -0,0 +1,283 @@
>> +/*
>> + * Driver for Analog Devices ADV748X CSI-2 Transmitter
>> + *
>> + * Copyright (C) 2017 Renesas Electronics Corp.
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by
>> the + * Free Software Foundation;  either version 2 of the  License, or (at
>> your + * option) any later version.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +
>> +#include "adv748x.h"
>> +
>> +static bool is_txa(struct adv748x_csi2 *tx)
>> +{
>> +	return tx == &tx->state->txa;
>> +}
>> +
>> +static struct v4l2_subdev *adv748x_csi2_get_remote_sd(struct media_pad
>> *local)
>> +{
>> +	struct media_pad *pad;
>> +
>> +	pad = media_entity_remote_pad(local);
> 
> You need to guard against pad being NULL. Additionally, as the function is 
> only called on tx->pads[ADV748X_CSI2_SINK], the remote entity is guaranteed to 
> be a subdev, but otherwise you would need to add
> 
> 	if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> 		return NULL;
> 
> here. How about specializing the function slightly to avoid that ?
> 
> static struct v4l2_subdev *adv748x_csi2_get_source_sd(struct adv748x_csi2 *tx)
> {
> 	struct media_pad *pad = &tx->pads[ADV748X_CSI2_SINK];
> 
> 	pad = media_entity_remote_pad(pad);
> 	if (!pad)
> 		return NULL;
> 
> 	return media_entity_to_v4l2_subdev(pad->entity);
> }

I like that...


> 
>> +	return media_entity_to_v4l2_subdev(pad->entity);
>> +}
> 
> [snip]
> 
>> +static int adv748x_csi2_registered(struct v4l2_subdev *sd)
>> +{
>> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>> +	struct adv748x_state *state = tx->state;
>> +
>> +	adv_info(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
>> +			sd->name);
> 
> I'd make this a debug message.

Done.

> 
>> +
>> +	/*
>> +	 * We can not register our sub devices until both CSI/TX entities
>> +	 * are registered.
>> +	 */
>> +	if (is_txa(tx))
>> +		return 0;
> 
> Do you have a guarantee that TXA will be registered first ? What if only TXA 
> is connected and TXB unused ?

Hum... no - not guaranteed, and ouch ...

On the thinking todo list ...


> 
>> +	return adv748x_register_subdevs(state, sd->v4l2_dev);
>> +}
>> +
>> +static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
>> +	.registered = adv748x_csi2_registered,
>> +};
> 
> [snip]
> 
> 
>> +static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>> +	struct v4l2_subdev *src;
>> +
>> +	src = adv748x_csi2_get_remote_sd(&tx->pads[ADV748X_CSI2_SINK]);
>> +	if (!src)
>> +		return -ENODEV;
> 
> Maybe -EPIPE ?

Ack.

> 
>> +	return v4l2_subdev_call(src, video, s_stream, enable);
>> +}
> 
> [snip]
> 
>> +/* ------------------------------------------------------------------------
>> + * v4l2_subdev_pad_ops
>> + *
>> + * The CSI2 bus pads, are ignorant to the data sizes or formats.
> 
> s/,//

Fixed

> 
>> + * But we must support setting the pad formats for format propagation.
>> + */
>> +
>> +static struct v4l2_mbus_framefmt *
>> +adv748x_csi2_get_pad_format(struct v4l2_subdev *sd,
>> +			    struct v4l2_subdev_pad_config *cfg,
>> +			    unsigned int pad, u32 which)
>> +{
>> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>> +
>> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
>> +		return v4l2_subdev_get_try_format(sd, cfg, pad);
>> +	else
>> +		return &tx->format;
>> +}
>> +
>> +static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
>> +				   struct v4l2_subdev_pad_config *cfg,
>> +				   struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>> +	struct adv748x_state *state = tx->state;
>> +	struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
>> +						 sdformat->which);
>> +	if (!mbusformat)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&state->mutex);
>> +
>> +	sdformat->format = *mbusformat;
>> +
>> +	mutex_unlock(&state->mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
>> +				   struct v4l2_subdev_pad_config *cfg,
>> +				   struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>> +	struct adv748x_state *state = tx->state;
>> +	struct media_pad *pad = &tx->pads[sdformat->pad];
>> +	struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
>> +						 sdformat->which);
>> +	if (!mbusformat)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&state->mutex);
>> +
>> +	if (pad->flags & MEDIA_PAD_FL_SOURCE)
>> +		sdformat->format = tx->format;
> 
> This isn't correct. tx->format is the active format, and should not be used at 
> all when setting TRY formats. There are multiple constructs you can use to 
> implement this, one of them being
> 
> 	if (sdformat->pad == ADV748X_CSI2_SOURCE) {
> 		const struct v4l2_mbus_framefmt *sink_fmt;
> 
> 		sink_fmt = adv748x_csi2_get_pad_format(sd, cfg,
> 						       ADV748X_CSI2_SINK,
> 						       sdformat->which);
> 		if (!sink_fmt)
> 			return -EINVAL;
> 
> 		sdformat->format = *sink_fmt;
> 	}
> 
> 	*mbusformat = sdformat->format;
> 
> 	mutex_unlock(&state->mutex);

Fixed.


> 
>> +	if (!mbusformat)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&state->mutex);
>> +
>> +	if (pad->flags & MEDIA_PAD_FL_SOURCE)
>> +		sdformat->format = tx->format;
>> +
>> +	*mbusformat = sdformat->format;
>> +
>> +	mutex_unlock(&state->mutex);
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +static int adv748x_csi2_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct adv748x_csi2 *tx = container_of(ctrl->handler,
>> +					struct adv748x_csi2, ctrl_hdl);
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_PIXEL_RATE:
>> +	{
>> +		struct v4l2_ctrl *rate;
>> +		struct v4l2_subdev *src;
>> +
>> +		src = adv748x_csi2_get_remote_sd(&tx-
>> pads[ADV748X_CSI2_SINK]);
>> +		if (!src)
>> +			return -ENODEV;
>> +
>> +		rate = v4l2_ctrl_find(src->ctrl_handler, V4L2_CID_PIXEL_RATE);
> 
> Instead of going through the control framework, can't you just call an 
> internal function directly ? You wouldn't have to expose the PIXEL_RATE 
> control in the AFE and HDMI subdevs at all, it would simplify the 
> implementation. My above comments about removing the volatile flag from the 
> control will then probably not apply anymore though, but the part about 
> whether the AFE changes the size on the flight when the standard changes is 
> still valid.

Ok - I'll look at this across all the entities.
If the HDMI/AFE call into the CSI2, they can set the control, and keep the
control events, and remove the volatile.

> 
>> +		if (!rate)
>> +			return -EPIPE;
>> +
>> +		*ctrl->p_new.p_s64 = v4l2_ctrl_g_ctrl_int64(rate);
>> +
>> +		break;
>> +	}
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops adv748x_csi2_ctrl_ops = {
>> +	.g_volatile_ctrl = adv748x_csi2_g_volatile_ctrl,
>> +};
>> +
>> +static int adv748x_csi2_init_controls(struct adv748x_csi2 *tx)
>> +{
>> +	struct v4l2_ctrl *ctrl;
>> +
>> +	v4l2_ctrl_handler_init(&tx->ctrl_hdl, 1);
>> +
>> +	// Can lock all controls with the global state mutex.
>> +	// tx->ctrl_hdl.lock = &tx->state->mutex;
> 
> Do you need to keep this ?

Well ... currently no - because the CSI2 cannot set the control handler mutex to
the global state mutex if it performs the pass through.

However, once I 'simplify' the V4L2_CID_PIXEL_RATE such that AFE and HDMI set
the value in the TX - then the CSI2 control handler can take the state lock.

> 
>> +	ctrl = v4l2_ctrl_new_std(&tx->ctrl_hdl, &adv748x_csi2_ctrl_ops,
>> +				 V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
>> +	if (ctrl)
>> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +
>> +	tx->sd.ctrl_handler = &tx->ctrl_hdl;
>> +	if (tx->ctrl_hdl.error) {
>> +		v4l2_ctrl_handler_free(&tx->ctrl_hdl);
>> +		return tx->ctrl_hdl.error;
>> +	}
>> +
>> +	return v4l2_ctrl_handler_setup(&tx->ctrl_hdl);
>> +}
>> +
>> +int adv748x_csi2_probe(struct adv748x_state *state, struct adv748x_csi2
>> *tx)
>> +{
>> +	struct device_node *ep;
>> +	int ret;
>> +
>> +	/* We can not use container_of to get back to the state with two TXs 
> */
>> +	tx->state = state;
>> +
>> +	ep = state->endpoints[is_txa(tx) ? ADV748X_PORT_TXA : 
> ADV748X_PORT_TXB];
>> +	if (!ep) {
>> +		adv_err(state, "No endpoint found for %s\n",
>> +				is_txa(tx) ? "txa" : "txb");
>> +		return -ENODEV;
>> +	}
>> +
>> +	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
>> +			is_txa(tx) ? "txa" : "txb");
>> +
>> +	/* Ensure that matching is based upon the endpoint fwnodes */
>> +	tx->sd.fwnode = of_fwnode_handle(ep);
>> +
>> +	/* Register internal ops for incremental subdev registration */
>> +	tx->sd.internal_ops = &adv748x_csi2_internal_ops;
>> +
>> +	tx->pads[ADV748X_CSI2_SINK].flags = MEDIA_PAD_FL_SINK;
>> +	tx->pads[ADV748X_CSI2_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
>> +
>> +	ret = media_entity_pads_init(&tx->sd.entity, ADV748X_CSI2_NR_PADS,
>> +				     tx->pads);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = adv748x_csi2_init_controls(tx);
>> +	if (ret)
>> +		goto err_free_media;
>> +
>> +	ret = v4l2_async_register_subdev(&tx->sd);
>> +	if (ret)
>> +		goto err_free_ctrl;
>> +
>> +	return 0;
>> +
>> +err_free_ctrl:
>> +	v4l2_ctrl_handler_free(&tx->ctrl_hdl);
>> +err_free_media:
>> +	media_entity_cleanup(&tx->sd.entity);
>> +
>> +	return ret;
>> +}
> 
> [snip]
> 
>> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c
>> b/drivers/media/i2c/adv748x/adv748x-hdmi.c new file mode 100644
>> index 000000000000..b9e61e6a43fa
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> 
> [snip]
> 
>> +static const struct v4l2_dv_timings_cap adv748x_hdmi_timings_cap = {
>> +	.type = V4L2_DV_BT_656_1120,
>> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
>> +	.reserved = { 0 },
> 
> Does gcc < 4.4.6 really not initialize non-specified fields to 0 ?

* Yes *

I've discussed this point with Sakari, and he tested it locally.

> 
>> +	/* Min pixelclock value is unknown */
>> +	V4L2_INIT_BT_TIMINGS(ADV748X_HDMI_MIN_WIDTH, ADV748X_HDMI_MAX_WIDTH,
>> +			     ADV748X_HDMI_MIN_HEIGHT, ADV748X_HDMI_MAX_HEIGHT,
>> +			     ADV748X_HDMI_MIN_PIXELCLOCK,
>> +			     ADV748X_HDMI_MAX_PIXELCLOCK,
>> +			     V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
>> +			     V4L2_DV_BT_CAP_INTERLACED |
>> +			     V4L2_DV_BT_CAP_PROGRESSIVE)
>> +};
> 
> [snip]
> 
>> +static bool adv748x_hdmi_have_signal(struct adv748x_state *state)
> 
> s/have/has/ ?

Fixed

> 
>> +{
>> +	int val;
>> +
>> +	/* Check that VERT_FILTER and DG_REGEN is locked */
>> +	val = hdmi_read(state, 0x07);
>> +	return (val & BIT(7)) && (val & BIT(5));
>> +}
>> +
>> +static unsigned int adv748x_hdmi_read_pixelclock(struct adv748x_state
>> *state) 
>> +{
>> +	int a, b;
>> +
>> +	a = hdmi_read(state, 0x51);
>> +	b = hdmi_read(state, 0x52);
>> +	if (a < 0 || b < 0)
>> +		return -ENODATA;
> 
> Returning a negative error code from a function that returns an unsigned int ?

Ah, yes.


> 
>> +
>> +	return ((a << 1) | (b >> 7)) * 1000000 + (b & 0x7f) * 1000000 / 128;
>> +}
>> +
>> +static int adv748x_hdmi_set_video_timings(struct adv748x_state *state,
>> +					  const struct v4l2_dv_timings 
> *timings)
>> +{
>> +	const struct adv748x_hdmi_video_standards *stds =
>> +		adv748x_hdmi_video_standards;
>> +	int i;
> 
> i only takes positive values, you can make it an unsigned int.

Fixed

> 
>> +	for (i = 0; stds[i].timings.bt.width; i++) {
> 
> How about removing the sentinel at the end of the array and use i < 
> ARRAY_SIZE(adv748x_hdmi_video_standards) as the condition ?
> 
>> +		if (!v4l2_match_dv_timings(timings, &stds[i].timings, 250000,
>> +					   false))
>> +			continue;
> 
> If you invert the condition and break and add a check after the loop to return 
> an error if the loop went through without finding a match, you can lower the 
> indentation of the code below.
> 
>> +		/*
>> +		 * The resolution of 720p, 1080i and 1080p is Hsync width of
>> +		 * 40 pixelclock cycles. These resolutions must be shifted
>> +		 * horizontally to the left in active video mode.
>> +		 */
> 
> I'm not sure to understand this.

I'll try to reword this based on what the datasheet is describing here.

There are some specific offsets that have to be applied depending upon the
resolution.

> 
>> +		switch (stds[i].vid_std) {
>> +		case 0x53: /* 720p */
>> +			cp_write(state, 0x8B, 0x43);
>> +			cp_write(state, 0x8C, 0xD8);
>> +			cp_write(state, 0x8B, 0x4F);
>> +			cp_write(state, 0x8D, 0xD8);
>> +			break;
>> +		case 0x54: /* 1080i */
>> +		case 0x5e: /* 1080p */
>> +			cp_write(state, 0x8B, 0x43);
>> +			cp_write(state, 0x8C, 0xD4);
>> +			cp_write(state, 0x8B, 0x4F);
>> +			cp_write(state, 0x8D, 0xD4);
>> +			break;
>> +		default:
>> +			cp_write(state, 0x8B, 0x40);
>> +			cp_write(state, 0x8C, 0x00);
>> +			cp_write(state, 0x8B, 0x40);
>> +			cp_write(state, 0x8D, 0x00);
>> +			break;
>> +		}
>> +
>> +		io_write(state, 0x05, stds[i].vid_std);
>> +		io_clrset(state, 0x03, 0x70, stds[i].v_freq << 4);
>> +
>> +		return 0;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +/* -----------------------------------------------------------------------
>> + * v4l2_subdev_video_ops
>> + */
>> +
>> +static int adv748x_hdmi_s_dv_timings(struct v4l2_subdev *sd,
>> +				     struct v4l2_dv_timings *timings)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +	int ret;
>> +
>> +	if (!timings)
>> +		return -EINVAL;
> 
> Can this happen ?

Looks like most other drivers don't bother to check - but I can't actually see
'proof' that it can't happen. It's just 'arg' as passed through the ioctl
handlers... Something must have pulled it across the User/Kernel boundary though ...

> 
>> +	if (v4l2_match_dv_timings(&hdmi->timings, timings, 0, false))
>> +		return 0;
>> +
>> +	if (!v4l2_valid_dv_timings(timings, &adv748x_hdmi_timings_cap,
>> +				   NULL, NULL))
>> +		return -ERANGE;
>> +
>> +	adv748x_fill_optional_dv_timings(timings);
>> +
>> +	ret = adv748x_hdmi_set_video_timings(state, timings);
>> +	if (ret)
>> +		return ret;
>> +
>> +	hdmi->timings = *timings;
> 
> The g/s operations are nicely locked for the CSI2 entities but they are not 
> here.
> 

Ack.

>> +	cp_clrset(state, 0x91, 0x40, timings->bt.interlaced ? 0x40 : 0x00);
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +static int adv748x_hdmi_query_dv_timings(struct v4l2_subdev *sd,
>> +					 struct v4l2_dv_timings *timings)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +	struct v4l2_bt_timings *bt = &timings->bt;
>> +	int tmp;
> 
> Please don't name variables tmp, that's not descriptive at all.

Indeed - this is a 'polarity' value.

> 
>> +	if (!timings)
>> +		return -EINVAL;
> 
> Can this happen ?
> 
>> +	memset(timings, 0, sizeof(struct v4l2_dv_timings));
>> +
>> +	if (!adv748x_hdmi_have_signal(state))
>> +		return -ENOLINK;
>> +
>> +	timings->type = V4L2_DV_BT_656_1120;
>> +
>> +	bt->interlaced = hdmi_read(state, 0x0b) & BIT(5) ?
>> +		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
>> +
>> +	bt->width = hdmi_read16(state, 0x07, 0x1fff);
>> +	bt->height = hdmi_read16(state, 0x09, 0x1fff);
>> +	bt->hfrontporch = hdmi_read16(state, 0x20, 0x1fff);
>> +	bt->hsync = hdmi_read16(state, 0x22, 0x1fff);
>> +	bt->hbackporch = hdmi_read16(state, 0x24, 0x1fff);
>> +	bt->vfrontporch = hdmi_read16(state, 0x2a, 0x3fff) / 2;
>> +	bt->vsync = hdmi_read16(state, 0x2e, 0x3fff) / 2;
>> +	bt->vbackporch = hdmi_read16(state, 0x32, 0x3fff) / 2;
>> +
>> +	bt->pixelclock = adv748x_hdmi_read_pixelclock(state);
>> +	if (bt->pixelclock < 0)
> 
> bt->pixelclock is unsigned.

Fixed.

> 
>> +		return -ENODATA;
>> +
>> +	tmp = hdmi_read(state, 0x05);
>> +	bt->polarities = (tmp & BIT(4) ? V4L2_DV_VSYNC_POS_POL : 0) |
>> +		(tmp & BIT(5) ? V4L2_DV_HSYNC_POS_POL : 0);
>> +
>> +	if (bt->interlaced == V4L2_DV_INTERLACED) {
>> +		bt->height += hdmi_read16(state, 0x0b, 0x1fff);
>> +		bt->il_vfrontporch = hdmi_read16(state, 0x2c, 0x3fff) / 2;
>> +		bt->il_vsync = hdmi_read16(state, 0x30, 0x3fff) / 2;
>> +		bt->il_vbackporch = hdmi_read16(state, 0x34, 0x3fff) / 2;
>> +	}
>> +
>> +	adv748x_fill_optional_dv_timings(timings);
>> +
>> +	if (!adv748x_hdmi_have_signal(state)) {
>> +		adv_info(state, "HDMI signal lost during readout\n");
>> +		return -ENOLINK;
>> +	}
> 
> Can the readout trigger an HDMI signal loss, or is it a random check ?

I assume this was put in as a check to ensure that the values read are accurate
in some effort to prevent a race against a partially valid state being read.

> 
>> +	/*
>> +	 * TODO: No interrupt handling is implemented yet.
>> +	 * There should be an IRQ when a cable is plugged and a the new
>> +	 * timings figured out and stored to state. This the next best thing
>> +	 */
>> +	hdmi->timings = *timings;
>> +
>> +	adv_dbg(state, "HDMI %dx%d%c clock: %llu Hz pol: %x "
>> +		"hfront: %d hsync: %d hback: %d "
>> +		"vfront: %d vsync: %d vback: %d "
>> +		"il_vfron: %d il_vsync: %d il_vback: %d\n",
>> +		bt->width, bt->height,
>> +		bt->interlaced == V4L2_DV_INTERLACED ? 'i' : 'p',
>> +		bt->pixelclock, bt->polarities,
>> +		bt->hfrontporch, bt->hsync, bt->hbackporch,
>> +		bt->vfrontporch, bt->vsync, bt->vbackporch,
>> +		bt->il_vfrontporch, bt->il_vsync, bt->il_vbackporch);
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +static int adv748x_hdmi_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +	int ret;
>> +
>> +	mutex_lock(&state->mutex);
>> +
>> +	ret = adv748x_txa_power(state, enable);
>> +	if (ret)
>> +		goto error;
>> +
>> +	if (adv748x_hdmi_have_signal(state))
>> +		adv_dbg(state, "Detected HDMI signal\n");
>> +	else
>> +		adv_info(state, "Couldn't detect HDMI video signal\n");
> 
> Same as with the AFE, I would make this a debug message.
> 
>> +
>> +error:
> 
> This code is executed in the success case too, I'd name the label done or out.

Done, Done,

> 
>> +	mutex_unlock(&state->mutex);
>> +	return ret;
>> +}
> 
> [snip]
> 
>> +static int adv748x_hdmi_get_pad_format(struct v4l2_subdev *sd,
>> +				  struct v4l2_subdev_pad_config *cfg,
>> +				  struct v4l2_subdev_format *format)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +
>> +	adv748x_hdmi_fill_format(hdmi, &format->format);
>> +
>> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +		struct v4l2_mbus_framefmt *fmt;
>> +
>> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>> +		format->format.code = fmt->code;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv748x_hdmi_set_pad_format(struct v4l2_subdev *sd,
>> +				       struct v4l2_subdev_pad_config *cfg,
>> +				       struct v4l2_subdev_format *format)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +
>> +	adv748x_hdmi_fill_format(hdmi, &format->format);
>> +
>> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +		struct v4l2_mbus_framefmt *fmt;
>> +
>> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>> +		fmt->code = format->format.code;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> The comments I made for the AFE apply here too.

Ack ...

> 
>> +static int adv748x_hdmi_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_ctrl_to_hdmi(ctrl);
>> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +	int ret;
>> +
>> +	/* Enable video adjustment first */
>> +	ret = cp_read(state, ADV748X_HDMI_VID_ADJ_REG);
>> +	if (ret < 0)
>> +		return ret;
>> +	ret |= ADV748X_HDMI_VID_ADJ_ENABLE;
>> +
>> +	ret = cp_write(state, ADV748X_HDMI_VID_ADJ_REG, ret);
>> +	if (ret < 0)
>> +		return ret;
> 
> Can't you use the cp_clrset macro ?

Yes, I think so - It's not exactly what is being done here - but I think the
goal is the same.

> 
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_BRIGHTNESS:
>> +		if (ctrl->val < ADV748X_HDMI_BRI_MIN ||
>> +		    ctrl->val > ADV748X_HDMI_BRI_MAX)
>> +			return -ERANGE;
> 
> Same as for the AFE, the control framework handlers this.

More deleted lines :D ---

> 
>> +		ret = cp_write(state, ADV748X_HDMI_BRI_REG, ctrl->val);
>> +		break;
>> +	case V4L2_CID_HUE:
>> +		if (ctrl->val < ADV748X_HDMI_HUE_MIN ||
>> +		    ctrl->val > ADV748X_HDMI_HUE_MAX)
>> +			return -ERANGE;
>> +
>> +		ret = cp_write(state, ADV748X_HDMI_HUE_REG, ctrl->val);
>> +		break;
>> +	case V4L2_CID_CONTRAST:
>> +		if (ctrl->val < ADV748X_HDMI_CON_MIN ||
>> +		    ctrl->val > ADV748X_HDMI_CON_MAX)
>> +			return -ERANGE;
>> +
>> +		ret = cp_write(state, ADV748X_HDMI_CON_REG, ctrl->val);
>> +		break;
>> +	case V4L2_CID_SATURATION:
>> +		if (ctrl->val < ADV748X_HDMI_SAT_MIN ||
>> +		    ctrl->val > ADV748X_HDMI_SAT_MAX)
>> +			return -ERANGE;
>> +
>> +		ret = cp_write(state, ADV748X_HDMI_SAT_REG, ctrl->val);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
> 
> [snip]
> 
>> diff --git a/drivers/media/i2c/adv748x/adv748x.h
>> b/drivers/media/i2c/adv748x/adv748x.h new file mode 100644
>> index 000000000000..af6c2a5278f6
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv748x/adv748x.h
> 
> [snip]
> 
>> +/* CSI2 transmitters can have 3 internal connections, HDMI/AFE/TTL */
>> +#define ADV748X_CSI2_MAX_SUBDEVS 3
> 
> We don't support the TTL yet though.

Reduced.

> 
> [snip]
> 
>> +/**
>> + * struct adv748x_state - State of ADV748X
>> + * @dev:		(OF) device
>> + * @client:		I2C client
>> + * @mutex:		protect global state
>> + *
>> + * @endpoints:		parsed device node endpoints for each port
>> + *
>> + * @hdmi:		state of HDMI receiver context
>> + * @sdp:		state of AFE receiver context
> 
> The field is named afe.

Good spot

> 
>> + * @txa:		state of TXA transmitter context
>> + * @txb:		state of TXB transmitter context
>> + */
>> +struct adv748x_state {
>> +	struct device *dev;
>> +	struct i2c_client *client;
>> +	struct mutex mutex;
>> +
>> +	struct device_node *endpoints[ADV748X_PORT_MAX];
>> +
>> +	struct adv748x_hdmi hdmi;
>> +	struct adv748x_afe afe;
>> +
>> +	struct adv748x_csi2 txa;
>> +	struct adv748x_csi2 txb;
>> +};
> 
> [snip]
> 
>> +/* Register handling */
>> +int adv748x_read(struct adv748x_state *state, u8 addr, u8 reg);
>> +int adv748x_write(struct adv748x_state *state, u8 addr, u8 reg, u8 value);
>> +
>> +#define io_read(s, r) adv748x_read(s, ADV748X_I2C_IO, r)
>> +#define io_write(s, r, v) adv748x_write(s, ADV748X_I2C_IO, r, v)
>> +#define io_clrset(s, r, m, v) io_write(s, r, (io_read(s, r) & ~m) | v)
> 
> How about using regmap to avoid the I2C read in clrset macros ?

Yes, I think regmap may be a useful conversion here.

I'll see if I can get a good go at converting.

> 
>> +#define hdmi_read(s, r) adv748x_read(s, ADV748X_I2C_HDMI, r)
>> +#define hdmi_read16(s, r, m) (((hdmi_read(s, r) << 8) | hdmi_read(s, r+1))
>> & m)
>> +#define hdmi_write(s, r, v) adv748x_write(s, ADV748X_I2C_HDMI, r, v)
>> +#define hdmi_clrset(s, r, m, v) hdmi_write(s, r, (hdmi_read(s, r) & ~m) |
>> v)
>> +
>> +#define sdp_read(s, r) adv748x_read(s, ADV748X_I2C_SDP, r)
>> +#define sdp_write(s, r, v) adv748x_write(s, ADV748X_I2C_SDP, r, v)
>> +#define sdp_clrset(s, r, m, v) sdp_write(s, r, (sdp_read(s, r) & ~m) | v)
>> +
>> +#define cp_read(s, r) adv748x_read(s, ADV748X_I2C_CP, r)
>> +#define cp_write(s, r, v) adv748x_write(s, ADV748X_I2C_CP, r, v)
>> +#define cp_clrset(s, r, m, v) cp_write(s, r, (cp_read(s, r) & ~m) | v)
>> +
>> +#define txa_read(s, r) adv748x_read(s, ADV748X_I2C_TXA, r)
>> +#define txa_write(s, r, v) adv748x_write(s, ADV748X_I2C_TXA, r, v)
>> +#define txa_clrset(s, r, m, v) txa_write(s, r, (txa_read(s, r) & ~m) | v)
>> +
>> +#define txb_read(s, r) adv748x_read(s, ADV748X_I2C_TXB, r)
>> +#define txb_write(s, r, v) adv748x_write(s, ADV748X_I2C_TXB, r, v)
>> +#define txb_clrset(s, r, m, v) txb_write(s, r, (txb_read(s, r) & ~m) | v)
> 
> [snip]
> 
