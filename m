Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57652 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755590AbdERVso (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 17:48:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 2/2] media: i2c: adv748x: add adv748x driver
Date: Fri, 19 May 2017 00:48:54 +0300
Message-ID: <2610503.i2TEihcINK@avalon>
In-Reply-To: <42b47ca01dd35e510dece486ea931b8fd3642dcf.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com> <42b47ca01dd35e510dece486ea931b8fd3642dcf.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Wednesday 17 May 2017 15:13:18 Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>=20
> Provide basic support for the ADV7481 and ADV7482.
>=20
> The driver is modelled with 2 subdevices to allow simultaneous stream=
ing
> from the AFE (Analog front end) and HDMI inputs.

Isn't that now four subdevices ?

> Presently the HDMI is hardcoded to link to the TXA CSI bus, whilst th=
e
> AFE is linked to the TXB CSI bus.
>=20
> The driver is based on a prototype by Koji Matsuoka in the Renesas BS=
P,
> and an earlier rework by Niklas S=F6derlund.
>=20
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.co=
m>

[snip]

> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> b/Documentation/devicetree/bindings/media/i2c/adv748x.txt new file mo=
de
> 100644
> index 000000000000..98d4600b7d26
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> @@ -0,0 +1,72 @@
> +* Analog Devices ADV748X video decoder with HDMI receiver
> +
> +The ADV7481, and ADV7482 are multi format video decoders with an int=
egrated
> +HDMI receiver. It can output CSI-2 on two independent outputs TXA an=
d TXB

s/It/They/ ?

> from +three input sources HDMI, analog and TTL.
> +
> +Required Properties:
> +
> +  - compatible: Must contain one of the following
> +    - "adi,adv7481" for the ADV7481
> +    - "adi,adv7482" for the ADV7482
> +
> +  - reg: I2C slave address
> +
> +  - interrupt-names: Should specify the interrupts as "intrq1" and/o=
r
> "intrq2"
> +                     "intrq3" is only available on the adv7480 and a=
dv7481

The bindings don't cover the ADV7480 yet, I wouldn't mention it here.

Which interrupt(s) are mandatory and which are optional ? If they're al=
l=20
mandatory (which I doubt) I would phrase it as=20

  - interrupt-names: Should specify the "intrq1", "intrq2" and "intrq3"=
=20
interrupts. The "intrq3" interrupt is only available on the adv7481.

If they're all optional, I would move it to the Optional Properties sec=
tion=20
and phrase it as

  - interrupt-names: Should specify the "intrq1", "intrq2" and/or "intr=
q3"=20
interrupts. All interrupts are optional. The "intrq3" interrupt is only=
=20
available on the adv7481.

If some of them only are mandatory,

  - interrupt-names: Should specify the "intrq1", "intrq2" and/or "intr=
q3"=20
interrupts. The ... interrupts are mandatory, while the ... interrupts =
are=20
optional. The "intrq3" interrupt is only available on the adv7481.

> +  - interrupts: Specify the interrupt lines for the ADV748x
> +
> +The device node must contain one 'port' child node per device input =
and
> output +port, in accordance with the video interface bindings defined=
 in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. The po=
rt
> nodes +are numbered as follows.
> +
> +  Name                  Type            Port
> +------------------------------------------------------------
> +  HDMI                  sink            0
> +  AIN1                  sink            1
> +  AIN2                  sink            2
> +  AIN3                  sink            3
> +  AIN4                  sink            4
> +  AIN5                  sink            5
> +  AIN6                  sink            6
> +  AIN7                  sink            7
> +  AIN8                  sink            8
> +  TTL                   sink            9
> +  TXA                   source          10
> +  TXB                   source          11
> +
> +The digital output port node must contain at least one source endpoi=
nt.

s/node/nodes/ ?
s/source //

> +Example:
> +
> +    video_receiver@70 {
> +            compatible =3D "adi,adv7482";
> +            reg =3D <0x70>;
> +
> +            #address-cells =3D <1>;
> +            #size-cells =3D <0>;
> +
> +            interrupt-parent =3D <&gpio6>;
> +            interrupt-names =3D "intrq1", "intrq2";
> +            interrupts =3D <30 IRQ_TYPE_LEVEL_LOW>,
> +                         <31 IRQ_TYPE_LEVEL_LOW>;
> +
> +            port@10 {
> +                    reg =3D <10>;
> +                    adv7482_txa: endpoint@1 {

There's no need to number endpoints when there's a single one. Otherwis=
e you'd=20
need a reg property in the endpoint.

> +                            clock-lanes =3D <0>;
> +                            data-lanes =3D <1 2 3 4>;
> +                            remote-endpoint =3D <&csi40_in>;
> +                    };
> +            };
> +
> +            port@11 {
> +                    reg =3D <11>;
> +                    adv7482_txb: endpoint@1 {
> +                            clock-lanes =3D <0>;
> +                            data-lanes =3D <1>;
> +                            remote-endpoint =3D <&csi20_in>;
> +                    };
> +            };

The example only shows ports 10 and 11. Should all ports be present, ev=
en if=20
they have no endpoint, because they're present at the hardware level ? =
That's=20
debatable, but if the ports are optional when not connected, I would do=
cument=20
that explicitly above.

> +    };

This all should be indented with tabs.

[snip]

> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 7c23b7a1fd05..5c6a14cdbad5 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -204,6 +204,16 @@ config VIDEO_ADV7183
>  =09  To compile this driver as a module, choose M here: the
>  =09  module will be called adv7183.
>=20
> +config VIDEO_ADV748X
> +=09tristate "Analog Devices ADV748x decoder"
> +=09depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API

You also need

=09depends on OF

> +=09---help---
> +=09  V4l2 subdevice driver for the Analog Devices

s/V4l2/V4L2/

> +=09  ADV7481 and ADV7482 HDMI/Analog video decoder.

s/decoder/decoders/

> +=09  To compile this driver as a module, choose M here: the
> +=09  module will be called adv748x.

One day I'll propose a module parameter for Kconfig

config VIDEO_ADV748X
=09module adv748x

would generate the above sentence automatically.

>  config VIDEO_ADV7604
>  =09tristate "Analog Devices ADV7604 decoder"
>  =09depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 62323ec66be8..e17faab108d6 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -1,6 +1,7 @@
>  msp3400-objs=09:=3D=09msp3400-driver.o msp3400-kthreads.o
>  obj-$(CONFIG_VIDEO_MSP3400) +=3D msp3400.o
>=20
> +obj-$(CONFIG_VIDEO_ADV748X) +=3D adv748x/
>  obj-$(CONFIG_VIDEO_SMIAPP)=09+=3D smiapp/
>  obj-$(CONFIG_VIDEO_ET8EK8)=09+=3D et8ek8/
>  obj-$(CONFIG_VIDEO_CX25840) +=3D cx25840/

If only someone could send a patch to sort the Makefiles alphabetically=
, we=20
would merge it immediately. Oh, wait,=20
https://patchwork.kernel.org/patch/9667605/

[snip]

> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c
> b/drivers/media/i2c/adv748x/adv748x-afe.c new file mode 100644
> index 000000000000..bac7f6e13b90
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c

[snip]


> +/*
> ---------------------------------------------------------------------=
------
> -- + * SDP
> + */
> +
> +#define ADV748X_AFE_INPUT_CVBS_AIN1=09=09=090x00
> +#define ADV748X_AFE_INPUT_CVBS_AIN2=09=09=090x01
> +#define ADV748X_AFE_INPUT_CVBS_AIN3=09=09=090x02
> +#define ADV748X_AFE_INPUT_CVBS_AIN4=09=09=090x03
> +#define ADV748X_AFE_INPUT_CVBS_AIN5=09=09=090x04
> +#define ADV748X_AFE_INPUT_CVBS_AIN6=09=09=090x05
> +#define ADV748X_AFE_INPUT_CVBS_AIN7=09=09=090x06
> +#define ADV748X_AFE_INPUT_CVBS_AIN8=09=09=090x07

You don't use these macros, you can remove them.

[snip]

> +static int adv748x_afe_read_ro_map(struct adv748x_state *state, u8 r=
eg)
> +{
> +=09int ret;
> +
> +=09/* Select SDP Read-Only Main Map */
> +=09ret =3D sdp_write(state, 0x0e, 0x01);

Can we get nice readable macros instead of magic values ? :-)

Any risk this could race with the write to the same register in the set=
=20
control handler ?

> +=09if (ret < 0)
> +=09=09return ret;
> +
> +=09return sdp_read(state, reg);
> +}
> +
> +static int adv748x_afe_status(struct adv748x_afe *afe, u32 *signal,
> +=09=09=09      v4l2_std_id *std)
> +{
> +=09struct adv748x_state *state =3D adv748x_afe_to_state(afe);
> +=09int info;
> +
> +=09/* Read status from reg 0x10 of SDP RO Map */
> +=09info =3D adv748x_afe_read_ro_map(state, 0x10);
> +=09if (info < 0)
> +=09=09return info;
> +
> +=09if (signal)
> +=09=09*signal =3D info & BIT(0) ? 0 : V4L2_IN_ST_NO_SIGNAL;
> +
> +=09if (!std)
> +=09=09return 0;
> +
> +=09*std =3D V4L2_STD_UNKNOWN;
> +
> +=09/* Standard not valid if there is no signal */

How about

=09/* Standard not valid if there is no signal */
=09if (!(info & BIT(0))) {
=09=09*std =3D V4L2_STD_UNKNOWN;
=09=09return 0;
=09}

so you can lower the indentation of the switch statement ? It also avoi=
ds pre-
assigning *std needlessly when there is a signal.

> +=09if (info & BIT(0)) {
> +=09=09switch (info & 0x70) {
> +=09=09case 0x00:
> +=09=09=09*std =3D V4L2_STD_NTSC;
> +=09=09=09break;
> +=09=09case 0x10:
> +=09=09=09*std =3D V4L2_STD_NTSC_443;
> +=09=09=09break;
> +=09=09case 0x20:
> +=09=09=09*std =3D V4L2_STD_PAL_M;
> +=09=09=09break;
> +=09=09case 0x30:
> +=09=09=09*std =3D V4L2_STD_PAL_60;
> +=09=09=09break;
> +=09=09case 0x40:
> +=09=09=09*std =3D V4L2_STD_PAL;
> +=09=09=09break;
> +=09=09case 0x50:
> +=09=09=09*std =3D V4L2_STD_SECAM;
> +=09=09=09break;
> +=09=09case 0x60:
> +=09=09=09*std =3D V4L2_STD_PAL_Nc | V4L2_STD_PAL_N;
> +=09=09=09break;
> +=09=09case 0x70:
> +=09=09=09*std =3D V4L2_STD_SECAM;
> +=09=09=09break;
> +=09=09default:
> +=09=09=09*std =3D V4L2_STD_UNKNOWN;
> +=09=09=09break;
> +=09=09}
> +=09}
> +
> +=09return 0;
> +}

[snip]

> +static int adv748x_afe_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +=09struct adv748x_afe *afe =3D adv748x_sd_to_afe(sd);
> +=09struct adv748x_state *state =3D adv748x_afe_to_state(afe);
> +=09int ret, signal =3D V4L2_IN_ST_NO_SIGNAL;
> +
> +=09mutex_lock(&state->mutex);
> +
> +=09ret =3D adv748x_txb_power(state, enable);
> +=09if (ret)
> +=09=09goto error;
> +
> +=09afe->streaming =3D enable;
> +
> +=09adv748x_afe_status(afe, &signal, NULL);
> +=09if (signal !=3D V4L2_IN_ST_NO_SIGNAL)
> +=09=09adv_dbg(state, "Detected SDP signal\n");
> +=09else
> +=09=09adv_info(state, "Couldn't detect SDP video signal\n");

I'd make this a debug message too, to avoid giving userspace a way to f=
lood=20
the kernel log.

> +
> +error:
> +=09mutex_unlock(&state->mutex);
> +
> +=09return ret;
> +}

[snip]

> +static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
> +=09=09=09=09      struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09      struct v4l2_subdev_mbus_code_enum *code)
> +{
> +=09if (code->index !=3D 0)
> +=09=09return -EINVAL;
> +
> +=09code->code =3D MEDIA_BUS_FMT_UYVY8_2X8;
> +
> +=09return 0;
> +}
> +
> +

Extra blank line.

> +static int adv748x_afe_get_pad_format(struct v4l2_subdev *sd,
> +=09=09=09=09      struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09      struct v4l2_subdev_format *format)
> +{
> +=09struct adv748x_afe *afe =3D adv748x_sd_to_afe(sd);
> +
> +=09adv748x_afe_fill_format(afe, &format->format);

This will return an height that depends on the active standard, while t=
ry=20
formats must not depend on the current device configuration. You can't=20=

implement this properly as we have no pad operation related to TV stand=
ards,=20
and we certainly don't want to create such pad operations by blindly co=
pying=20
the corresponding video ops. As a temporary work around I believe it sh=
ould be=20
fine to set the height based on the active standard in the set format h=
andler,=20
which should then copy the whole format into the try format. This funct=
ion=20
should then return the try format when which is set to V4L2_SUBDEV_FORM=
AT_TRY=20
and call adv748x_afe_fill_format() otherwise.

Note that the get and set format handlers should in most cases take the=
 pad=20
into account. For a subdev that can't change the format, a set format c=
all on=20
the source pad should just return the format set on the sink pad withou=
t=20
changing anything.

There's also a problem here related to the sink pad: the input signal b=
eing=20
analog, the concept of a media bus format makes no sense. There's no UY=
VY8 in=20
analog TV signals, nor is there an image width expressed as a number of=
=20
pixels.

There's no point in trying to avoid hacks here as the API clearly lacks=
=20
support for analog TV, so your goal should be to try and minimize the h=
acks.

> +=09if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> +=09=09struct v4l2_mbus_framefmt *fmt;
> +
> +=09=09fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +=09=09format->format.code =3D fmt->code;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static int adv748x_afe_set_pad_format(struct v4l2_subdev *sd,
> +=09=09=09=09      struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09      struct v4l2_subdev_format *format)
> +{
> +=09struct adv748x_afe *afe =3D adv748x_sd_to_afe(sd);
> +
> +=09adv748x_afe_fill_format(afe, &format->format);
> +
> +=09if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> +=09=09struct v4l2_mbus_framefmt *fmt;
> +
> +=09=09fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +=09=09fmt->code =3D format->format.code;

What's the point in storing the code in fmt->code when=20
adv748x_afe_fill_format() has hardcoded it to MEDIA_BUS_FMT_UYVY8_2X8, =
only to=20
retrieve it in adv748x_afe_get_pad_format() ?

> +=09}
> +
> +=09return 0;
> +}

[snip]

> +/* Contrast */
> +#define ADV748X_AFE_REG_CON=09=090x08=09/*Unsigned */

Missing space after /*. Same comment for the code below.

> +#define ADV748X_AFE_CON_MIN=09=090
> +#define ADV748X_AFE_CON_DEF=09=09128
> +#define ADV748X_AFE_CON_MAX=09=09255
> +/* Brightness*/
> +#define ADV748X_AFE_REG_BRI=09=090x0a=09/*Signed */
> +#define ADV748X_AFE_BRI_MIN=09=09-128
> +#define ADV748X_AFE_BRI_DEF=09=090
> +#define ADV748X_AFE_BRI_MAX=09=09127
> +/* Hue */
> +#define ADV748X_AFE_REG_HUE=09=090x0b=09/*Signed, inverted */
> +#define ADV748X_AFE_HUE_MIN=09=09-127
> +#define ADV748X_AFE_HUE_DEF=09=090
> +#define ADV748X_AFE_HUE_MAX=09=09128
> +
> +/* Saturation */
> +#define ADV748X_AFE_REG_SD_SAT_CB=090xe3
> +#define ADV748X_AFE_REG_SD_SAT_CR=090xe4
> +#define ADV748X_AFE_SAT_MIN=09=090
> +#define ADV748X_AFE_SAT_DEF=09=09128
> +#define ADV748X_AFE_SAT_MAX=09=09255
> +
> +static int adv748x_afe_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +=09struct adv748x_afe *afe =3D adv748x_ctrl_to_afe(ctrl);
> +=09struct adv748x_state *state =3D adv748x_afe_to_state(afe);
> +=09int ret;
> +
> +=09ret =3D sdp_write(state, 0x0e, 0x00);
> +=09if (ret < 0)
> +=09=09return ret;
> +
> +=09switch (ctrl->id) {
> +=09case V4L2_CID_BRIGHTNESS:
> +=09=09if (ctrl->val < ADV748X_AFE_BRI_MIN ||
> +=09=09    ctrl->val > ADV748X_AFE_BRI_MAX)
> +=09=09=09return -ERANGE;

The control framework will catch this error internally, you can remove =
the=20
manual check.

> +=09=09ret =3D sdp_write(state, ADV748X_AFE_REG_BRI, ctrl->val);
> +=09=09break;
> +=09case V4L2_CID_HUE:
> +=09=09if (ctrl->val < ADV748X_AFE_HUE_MIN ||
> +=09=09    ctrl->val > ADV748X_AFE_HUE_MAX)
> +=09=09=09return -ERANGE;
> +
> +=09=09/* Hue is inverted according to HSL chart */
> +=09=09ret =3D sdp_write(state, ADV748X_AFE_REG_HUE, -ctrl->val);
> +=09=09break;
> +=09case V4L2_CID_CONTRAST:
> +=09=09if (ctrl->val < ADV748X_AFE_CON_MIN ||
> +=09=09    ctrl->val > ADV748X_AFE_CON_MAX)
> +=09=09=09return -ERANGE;
> +
> +=09=09ret =3D sdp_write(state, ADV748X_AFE_REG_CON, ctrl->val);
> +=09=09break;
> +=09case V4L2_CID_SATURATION:
> +=09=09if (ctrl->val < ADV748X_AFE_SAT_MIN ||
> +=09=09    ctrl->val > ADV748X_AFE_SAT_MAX)
> +=09=09=09return -ERANGE;
> +=09=09/*
> +=09=09 * This could be V4L2_CID_BLUE_BALANCE/V4L2_CID_RED_BALANCE
> +=09=09 * Let's not confuse the user, everybody understands=20
saturation
> +=09=09 */

This isn't about confusing the user. The saturation is a gain applied t=
o the=20
chroma, while the balance is an offset. If the two hardware controls ar=
e=20
gains, the code is fine, and the comment isn't. If the two hardware con=
trols=20
are offsets, we should expose them as balance controls instead.

> +=09=09ret =3D sdp_write(state, ADV748X_AFE_REG_SD_SAT_CB, ctrl->val)=
;
> +=09=09if (ret)
> +=09=09=09break;
> +=09=09ret =3D sdp_write(state, ADV748X_AFE_REG_SD_SAT_CR, ctrl->val)=
;
> +=09=09break;
> +=09default:
> +=09=09return -EINVAL;
> +=09}
> +
> +=09return ret;
> +}
> +
> +static int adv748x_afe_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +=09struct adv748x_afe *afe =3D adv748x_ctrl_to_afe(ctrl);
> +=09unsigned int width, height, fps;
> +=09v4l2_std_id std;
> +
> +=09switch (ctrl->id) {
> +=09case V4L2_CID_PIXEL_RATE:
> +=09=09width =3D 720;
> +=09=09if (afe->curr_norm =3D=3D V4L2_STD_ALL)
> +=09=09=09adv748x_afe_status(afe, NULL,  &std);
> +=09=09else
> +=09=09=09std =3D afe->curr_norm;
> +
> +=09=09height =3D std & V4L2_STD_525_60 ? 480 : 576;
> +=09=09fps =3D std & V4L2_STD_525_60 ? 30 : 25;
> +
> +=09=09*ctrl->p_new.p_s64 =3D width * height * fps;

Will the hardware really change the image height autonomously if the in=
put=20
standard is changed ? Or does it need a software action ? In the latter=
 case,=20
the software action should be triggered by the set format operation, an=
d the=20
pixel rate should reflect that. You could then avoid making the control=
=20
volatile, and change its value in the set format handler (with a call t=
o=20
__v4l2_ctrl_s_ctrl_int64). I believe you would also need to return 0 in=
 the=20
set control handler for the V4L2_CID_PIXEL_RATE control, as it would ge=
t=20
called from __v4l2_ctrl_s_ctrl_int64().

> +=09=09break;
> +=09default:
> +=09=09return -EINVAL;
> +=09}
> +
> +=09return 0;
> +}

[snip]

> +int adv748x_afe_probe(struct adv748x_afe *afe)
> +{
> +=09struct adv748x_state *state =3D adv748x_afe_to_state(afe);
> +=09int ret;
> +=09unsigned int i;
> +
> +=09afe->streaming =3D false;
> +=09afe->curr_norm =3D V4L2_STD_ALL;
> +
> +=09adv748x_subdev_init(&afe->sd, state, &adv748x_afe_ops, "afe");
> +
> +=09for (i =3D ADV748X_AFE_SINK_AIN0; i <=3D ADV748X_AFE_SINK_AIN7; i=
++)
> +=09=09afe->pads[i].flags =3D MEDIA_PAD_FL_SINK;
> +
> +=09afe->pads[ADV748X_AFE_SOURCE].flags =3D MEDIA_PAD_FL_SOURCE;
> +
> +=09ret =3D media_entity_pads_init(&afe->sd.entity, ADV748X_AFE_NR_PA=
DS,
> +=09=09=09afe->pads);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09ret =3D adv748x_afe_init_controls(afe);
> +=09if (ret)
> +=09=09goto err_free_media;
> +
> +=09return 0;
> +
> +err_free_media:

err_cleanup_media ? Or just error, as there's a single label ?

> +=09media_entity_cleanup(&afe->sd.entity);
> +
> +=09return ret;
> +}

[snip]

> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c new file mode 100644
> index 000000000000..54937ce05f3a
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c

[snip]

> +static int adv748x_write_regs(struct adv748x_state *state,
> +=09=09=09      const struct adv748x_reg_value *regs)
> +{
> +=09struct i2c_msg msg;
> +=09u8 data_buf[2];
> +=09int ret =3D -EINVAL;

So if the regs array is empty, you'll return an error ?

> +
> +=09if (!state->client->adapter) {
> +=09=09adv_err(state, "No adapter for regs write\n");
> +=09=09return -ENODEV;
> +=09}

When can you have a client without an adapter ?

> +=09msg.flags =3D 0;
> +=09msg.len =3D 2;
> +=09msg.buf =3D &data_buf[0];
> +
> +=09while (regs->addr !=3D ADV748X_I2C_EOR) {
> +

Extra blank line.

> +=09=09if (regs->addr =3D=3D ADV748X_I2C_WAIT)
> +=09=09=09msleep(regs->value);

You need curly braces around this statement.

> +=09=09else {
> +=09=09=09msg.addr =3D regs->addr;
> +=09=09=09data_buf[0] =3D regs->reg;
> +=09=09=09data_buf[1] =3D regs->value;
> +
> +=09=09=09ret =3D i2c_transfer(state->client->adapter, &msg, 1);

This makes me feel slightly uncomfortable. Please check with Wolfram wh=
ether=20
writing to different addresses from a single client is considered as a =
hack or=20
not.

> +=09=09=09if (ret < 0) {
> +=09=09=09=09adv_err(state,
> +=09=09=09=09=09"Error regs addr: 0x%02x reg:=20
0x%02x\n",
> +=09=09=09=09=09regs->addr, regs->reg);
> +=09=09=09=09break;

You can just return ret here.

> +=09=09=09}
> +=09=09}
> +=09=09regs++;
> +=09}
> +
> +=09return (ret < 0) ? ret : 0;

And return 0 unconditionally here.

> +}
> +
> +int adv748x_write(struct adv748x_state *state, u8 addr, u8 reg, u8 v=
alue)
> +{
> +=09struct adv748x_reg_value regs[2];
> +=09int ret;
> +
> +=09regs[0].addr =3D addr;
> +=09regs[0].reg =3D reg;
> +=09regs[0].value =3D value;
> +=09regs[1].addr =3D ADV748X_I2C_EOR;
> +=09regs[1].reg =3D 0xFF;
> +=09regs[1].value =3D 0xFF;
> +
> +=09ret =3D adv748x_write_regs(state, regs);

This is overcomplicated, you don't need the whole machinery to write to=
 a=20
single register. i2c_smbus_write_byte() will do.

> +=09return ret;

No need for the ret variable.

> +}

Note that these comments will be moot if you use regmap as I proposed b=
elow.=20
In that case, you will need to create secondary devices with=20
i2c_new_secondary_device() to be used with regmap.

[snip]

> +int adv748x_txa_power(struct adv748x_state *state, bool on)
> +{
> +=09int val, ret;
> +
> +=09val =3D txa_read(state, 0x1e);
> +=09if (val < 0)
> +=09=09return val;
> +
> +=09if (on && ((val & 0x40) =3D=3D 0))
> +=09=09ret =3D adv748x_write_regs(state, adv748x_power_up_txa_4lane);=

> +=09else
> +=09=09ret =3D adv748x_write_regs(state, adv748x_power_down_txa_4lane=
);

I don't know what this magic value represents (hint...), but do you rea=
lly=20
want to power off when the on argument is true and bit 0x40 is set ?
> +
> +=09return ret;

No need for the ret variable, just return directly from the calls.

> +}
> +
> +int adv748x_txb_power(struct adv748x_state *state, bool on)
> +{
> +=09int val, ret;
> +
> +=09val =3D txb_read(state, 0x1e);
> +=09if (val < 0)
> +=09=09return val;
> +
> +=09if (on && ((val & 0x40) =3D=3D 0))
> +=09=09ret =3D adv748x_write_regs(state, adv748x_power_up_txb_1lane);=

> +=09else
> +=09=09ret =3D adv748x_write_regs(state, adv748x_power_down_txb_1lane=
);

Ditto.

> +
> +=09return ret;
> +}

[snip]

> +/* TODO:KPB: Need to work out how to provide AFE port select! More
> entities? */

KPB ?

> +#define ADV748X_SDP_INPUT_CVBS_AIN8 0x07
> +
> +/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
> +/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
> +static const struct adv748x_reg_value adv748x_init_txb_1lane[] =3D {=

> +
> +=09{ADV748X_I2C_IO, 0x00, 0x30},  /* Disable chip powerdown powerdow=
n Rx=20
*/
> +=09{ADV748X_I2C_IO, 0xF2, 0x01},  /* Enable I2C Read Auto-Increment =
*/
> +
> +=09{ADV748X_I2C_IO, 0x0E, 0xFF},  /* LLC/PIX/AUD/SPI PINS TRISTATED =
*/
> +
> +=09{ADV748X_I2C_SDP, 0x0f, 0x00}, /* Exit Power Down Mode */

Let's not mix uppercase and lowercase hex constants, you can use lowerc=
ase=20
throughout the whole driver.

> +=09{ADV748X_I2C_SDP, 0x52, 0xCD},/* ADI Required Write */
> +=09/* TODO: do not use hard codeded INSEL */

How about addressing that ? :-)

> +=09{ADV748X_I2C_SDP, 0x00, ADV748X_SDP_INPUT_CVBS_AIN8},
> +=09{ADV748X_I2C_SDP, 0x0E, 0x80},=09/* ADI Required Write */
> +=09{ADV748X_I2C_SDP, 0x9C, 0x00},=09/* ADI Required Write */
> +=09{ADV748X_I2C_SDP, 0x9C, 0xFF},=09/* ADI Required Write */
> +=09{ADV748X_I2C_SDP, 0x0E, 0x00},=09/* ADI Required Write */
> +
> +=09/* ADI recommended writes for improved video quality */
> +=09{ADV748X_I2C_SDP, 0x80, 0x51},=09/* ADI Required Write */
> +=09{ADV748X_I2C_SDP, 0x81, 0x51},=09/* ADI Required Write */
> +=09{ADV748X_I2C_SDP, 0x82, 0x68},=09/* ADI Required Write */
> +
> +=09{ADV748X_I2C_SDP, 0x03, 0x42},  /* Tri-S Output , PwrDwn 656 pads=
 */
> +=09{ADV748X_I2C_SDP, 0x04, 0xB5},=09/* ITU-R BT.656-4 compatible */
> +=09{ADV748X_I2C_SDP, 0x13, 0x00},=09/* ADI Required Write */
> +
> +=09{ADV748X_I2C_SDP, 0x17, 0x41},=09/* Select SH1 */
> +=09{ADV748X_I2C_SDP, 0x31, 0x12},=09/* ADI Required Write */
> +=09{ADV748X_I2C_SDP, 0xE6, 0x4F},  /* V bit end pos manually in NTSC=
 */
> +
> +=09/* TODO: Convert this to a control option */
> +#ifdef REL_DGB_FORCE_TO_SEND_COLORBAR
> +=09{ADV748X_I2C_SDP, 0x0C, 0x01},=09/* ColorBar */
> +=09{ADV748X_I2C_SDP, 0x14, 0x01},=09/* ColorBar */
> +#endif

I think you can remove this. Or convert it to a control, as proposed by=
 the=20
comment.

> +=09/* Enable 1-Lane MIPI Tx, */
> +=09/* enable pixel output and route SD through Pixel port */
> +=09{ADV748X_I2C_IO, 0x10, 0x70},
> +
> +=09{ADV748X_I2C_TXB, 0x00, 0x81},=09/* Enable 1-lane MIPI */
> +=09{ADV748X_I2C_TXB, 0x00, 0xA1},=09/* Set Auto DPHY Timing */
> +=09{ADV748X_I2C_TXB, 0xD2, 0x40},=09/* ADI Required Write */
> +=09{ADV748X_I2C_TXB, 0xC4, 0x0A},=09/* ADI Required Write */
> +=09{ADV748X_I2C_TXB, 0x71, 0x33},=09/* ADI Required Write */
> +=09{ADV748X_I2C_TXB, 0x72, 0x11},=09/* ADI Required Write */
> +=09{ADV748X_I2C_TXB, 0xF0, 0x00},=09/* i2c_dphy_pwdn - 1'b0 */
> +=09{ADV748X_I2C_TXB, 0x31, 0x82},=09/* ADI Required Write */
> +=09{ADV748X_I2C_TXB, 0x1E, 0x40},=09/* ADI Required Write */
> +=09{ADV748X_I2C_TXB, 0xDA, 0x01},=09/* i2c_mipi_pll_en - 1'b1 */
> +
> +=09{ADV748X_I2C_WAIT, 0x00, 0x02},=09/* delay 2 */
> +=09{ADV748X_I2C_TXB, 0x00, 0x21 },=09/* Power-up CSI-TX */
> +=09{ADV748X_I2C_WAIT, 0x00, 0x01},=09/* delay 1 */
> +=09{ADV748X_I2C_TXB, 0xC1, 0x2B},=09/* ADI Required Write */
> +=09{ADV748X_I2C_WAIT, 0x00, 0x01},=09/* delay 1 */
> +=09{ADV748X_I2C_TXB, 0x31, 0x80},=09/* ADI Required Write */
> +
> +=09{ADV748X_I2C_EOR, 0xFF, 0xFF}=09/* End of register table */
> +};
> +
> +static int adv748x_reset(struct adv748x_state *state)
> +{
> +=09int ret;
> +
> +=09ret =3D adv748x_write_regs(state, adv748x_sw_reset);
> +=09if (ret < 0)
> +=09=09return ret;
> +
> +=09ret =3D adv748x_write_regs(state, adv748x_set_slave_address);
> +=09if (ret < 0)
> +=09=09return ret;
> +
> +=09/* Init and power down TXA */
> +=09ret =3D adv748x_write_regs(state, adv748x_init_txa_4lane);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09adv748x_txa_power(state, 0);

Can't you modify the TXA init table to initialized it powered off ?

> +=09/* Set VC 0 */
> +=09txa_clrset(state, 0x0d, 0xc0, 0x00);

Can't this be included in the table too ?

> +=09/* Init and power down TXB */
> +=09ret =3D adv748x_write_regs(state, adv748x_init_txb_1lane);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09adv748x_txb_power(state, 0);
> +
> +=09/* Set VC 0 */
> +=09txb_clrset(state, 0x0d, 0xc0, 0x00);

Same comments as for TXA.

> +=09/* Disable chip powerdown & Enable HDMI Rx block */
> +=09io_write(state, 0x00, 0x40);
> +
> +=09/* Enable 4-lane CSI Tx & Pixel Port */
> +=09io_write(state, 0x10, 0xe0);
> +
> +=09/* Use vid_std and v_freq as freerun resolution for CP */
> +=09cp_clrset(state, 0xc9, 0x01, 0x01);
> +
> +=09return 0;
> +}
> +
> +static int adv748x_print_info(struct adv748x_state *state)
> +{
> +=09int msb, lsb;
> +
> +=09lsb =3D io_read(state, 0xdf);
> +=09msb =3D io_read(state, 0xe0);
> +
> +=09if (lsb < 0 || msb < 0) {
> +=09=09adv_err(state, "Failed to read chip revision\n");
> +=09=09return -EIO;
> +=09}
> +
> +=09adv_info(state, "chip found @ 0x%02x revision %02x%02x\n",
> +=09=09 state->client->addr << 1, lsb, msb);

Should you return an error if the ID isn't known to the driver ?

> +=09return 0;
> +}

[snip]

> +void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_stat=
e
> *state,
> +=09=09const struct v4l2_subdev_ops *ops, const char *ident)
> +{
> +=09v4l2_subdev_init(sd, ops);
> +=09sd->flags |=3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +=09/* the owner is the same as the i2c_client's driver owner */
> +=09sd->owner =3D state->dev->driver->owner;
> +=09sd->dev =3D state->dev;
> +
> +=09v4l2_set_subdevdata(sd, state);
> +
> +=09/* initialize name */
> +=09snprintf(sd->name, sizeof(sd->name), "%s %d-%04x %s",
> +=09=09state->dev->driver->name,
> +=09=09i2c_adapter_id(state->client->adapter),
> +=09=09state->client->addr, ident);
> +
> +=09sd->entity.function =3D MEDIA_ENT_F_ATV_DECODER;

I don't think this applies to all subdevs. If there are more appropriat=
e=20
functions in the existing ones please pick them, otherwise don't bother=
 adding=20
new ones as the API is messed up and needs to be reworked anyway.

> +=09sd->entity.ops =3D &adv748x_media_ops;
> +}
> +
> +static int adv748x_parse_dt(struct adv748x_state *state)
> +{
> +=09struct device_node *ep_np =3D NULL;
> +=09struct of_endpoint ep;
> +=09unsigned int found =3D 0;

=09bool found =3D false;

> +
> +=09for_each_endpoint_of_node(state->dev->of_node, ep_np) {
> +=09=09of_graph_parse_endpoint(ep_np, &ep);
> +=09=09adv_info(state, "Endpoint %s on port %d",
> +=09=09=09=09of_node_full_name(ep.local_node),
> +=09=09=09=09ep.port);
> +
> +=09=09if (ep.port > ADV748X_PORT_MAX) {

This should be >=3D

> +=09=09=09adv_err(state, "Invalid endpoint %s on port %d",
> +=09=09=09=09of_node_full_name(ep.local_node),
> +=09=09=09=09ep.port);
> +
> +=09=09=09continue;
> +=09=09}
> +
> +=09=09state->endpoints[ep.port] =3D ep_np;

What happens if you have multiple endpoints per port ? It looks like yo=
u'll=20
keep the last one only. Shouldn't that be treated as an error ?

You need to get a reference to ep_np, and release it at remove time.

> +=09=09found++;

=09=09found =3D true;

> +=09}
> +
> +=09return found ? 0 : -ENODEV;
> +}
> +
> +static int adv748x_setup_links(struct adv748x_state *state)
> +{
> +=09int ret;
> +=09int enabled =3D MEDIA_LNK_FL_ENABLED;
> +
> +/*
> + * HACK/Workaround:
> + *
> + * Currently non-immutable link resets go through the RVin
> + * driver, and cause the links to fail, due to not being part of RVI=
N.
> + * As a temporary workaround until the RVIN driver knows better than=
 to
> parse
> + * links that do not belong to it, use static immutable links for ou=
r
> internal
> + * media paths.
> + */

Do we have an ETA for the VIN fix ?

> +#define ADV748x_DEV_STATIC_LINKS
> +#ifdef ADV748x_DEV_STATIC_LINKS
> +=09enabled |=3D MEDIA_LNK_FL_IMMUTABLE;
> +#endif
> +
> +=09/* TXA - Default link is with HDMI */
> +=09ret =3D media_create_pad_link(&state->hdmi.sd.entity, 1,
> +=09=09=09=09    &state->txa.sd.entity, 0, enabled);
> +=09if (ret) {
> +=09=09adv_err(state, "Failed to create HDMI-TXA pad links");

s/links/link/

> +=09=09return ret;
> +=09}
> +
> +#ifndef ADV748x_DEV_STATIC_LINKS
> +=09ret =3D media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_=
SOURCE,
> +=09=09=09=09    &state->txa.sd.entity, 0, 0);
> +=09if (ret) {
> +=09=09adv_err(state, "Failed to create AFE-TXA pad links");

s/links/link/

> +=09=09return ret;
> +=09}
> +#endif
> +
> +=09/* TXB - Can only output from the AFE */
> +=09ret =3D media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_=
SOURCE,
> +=09=09=09=09    &state->txb.sd.entity, 0, enabled);
> +=09if (ret) {
> +=09=09adv_err(state, "Failed to create AFE-TXB pad links");
> +=09=09return ret;
> +=09}
> +
> +=09return 0;
> +}

[snip]

> +static int adv748x_probe(struct i2c_client *client,
> +=09=09=09 const struct i2c_device_id *id)
> +{
> +=09struct adv748x_state *state;
> +=09int ret;
> +
> +=09/* Check if the adapter supports the needed features */
> +=09if (!i2c_check_functionality(client->adapter,=20
I2C_FUNC_SMBUS_BYTE_DATA))
> +=09=09return -EIO;
> +
> +=09state =3D devm_kzalloc(&client->dev, sizeof(struct adv748x_state)=
,
> +=09=09=09     GFP_KERNEL);

Please use kzalloc(). The state structure needs to outlive the remove()=
 time=20
if userspace keeps a subdev node open. The V4L2 and MC code don't suppo=
rt this=20
yet so you can't fix the issue completely, but devm_kzalloc() is clearl=
y part=20
of the problem.

> +=09if (!state)
> +=09=09return -ENOMEM;
> +
> +=09mutex_init(&state->mutex);
> +
> +=09state->dev =3D &client->dev;
> +=09state->client =3D client;
> +=09i2c_set_clientdata(client, state);
> +
> +=09/* SW reset ADV748X to its default values */
> +=09ret =3D adv748x_reset(state);
> +=09if (ret) {
> +=09=09adv_err(state, "Failed to reset hardware");
> +=09=09goto err_free_mutex;
> +=09}
> +
> +=09ret =3D adv748x_print_info(state);
> +=09if (ret)
> +=09=09goto err_free_mutex;

Shouldn't you try to identify the chip before resetting it ?

> +=09/* Discover and process ports declared by the Device tree endpoin=
ts */
> +=09ret =3D adv748x_parse_dt(state);
> +=09if (ret)
> +=09=09goto err_free_mutex;

I'd parse DT before trying to access the chip.

> +=09/* Initialise HDMI */
> +=09ret =3D adv748x_hdmi_probe(&state->hdmi);
> +=09if (ret) {
> +=09=09adv_err(state, "Failed to probe HDMI");
> +=09=09goto err_free_mutex;
> +=09}
> +
> +=09/* Initialise AFE */
> +=09ret =3D adv748x_afe_probe(&state->afe);
> +=09if (ret) {
> +=09=09adv_err(state, "Failed to probe AFE");
> +=09=09goto err_free_hdmi;
> +=09}
> +
> +=09/* Initialise TXA */
> +=09ret =3D adv748x_csi2_probe(state, &state->txa);
> +=09if (ret) {
> +=09=09adv_err(state, "Failed to probe TXA");
> +=09=09goto err_free_afe;
> +=09}
> +
> +=09/* Initialise TXB  (Not 7480) */
> +=09ret =3D adv748x_csi2_probe(state, &state->txb);
> +=09if (ret) {
> +=09=09adv_err(state, "Failed to probe TXB");
> +=09=09goto err_free_txa;
> +=09}

As documented in the comments you're performing initialization here, sh=
ould=20
the functions be named *_init() ?

> +=09return 0;
> +
> +err_free_txa:
> +=09adv748x_csi2_remove(&state->txa);

And the remove functions called *_cleanup() ? I'd then rename the error=
 labels=20
to err_cleanup_*.

> +err_free_afe:
> +=09adv748x_afe_remove(&state->afe);
> +err_free_hdmi:
> +=09adv748x_hdmi_remove(&state->hdmi);
> +err_free_mutex:
> +=09mutex_destroy(&state->mutex);
> +
> +=09return ret;
> +}
> +
> +static int adv748x_remove(struct i2c_client *client)
> +{
> +=09struct adv748x_state *state =3D i2c_get_clientdata(client);
> +
> +=09adv748x_afe_remove(&state->afe);
> +=09adv748x_hdmi_remove(&state->hdmi);
> +
> +=09adv748x_csi2_remove(&state->txa);
> +=09adv748x_csi2_remove(&state->txb);
> +
> +=09mutex_destroy(&state->mutex);
> +
> +=09return 0;
> +}

[snip]

> +static struct i2c_driver adv748x_driver =3D {
> +=09.driver =3D {
> +=09=09.name =3D "adv748x",
> +=09=09.of_match_table =3D of_match_ptr(adv748x_of_table),

No need for the of_match_ptr() macro as the driver depends on OF.

> +=09},
> +=09.probe =3D adv748x_probe,
> +=09.remove =3D adv748x_remove,
> +=09.id_table =3D adv748x_id,
> +};
> +
> +module_i2c_driver(adv748x_driver);
> +
> +MODULE_AUTHOR("Kieran Bingham <kieran.bingham@ideasonboard.com>");
> +MODULE_DESCRIPTION("ADV748X video decoder");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c
> b/drivers/media/i2c/adv748x/adv748x-csi2.c new file mode 100644
> index 000000000000..a745246e34b5
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c

[snip]

> @@ -0,0 +1,283 @@
> +/*
> + * Driver for Analog Devices ADV748X CSI-2 Transmitter
> + *
> + * Copyright (C) 2017 Renesas Electronics Corp.
> + *
> + * This program is free software; you can redistribute  it and/or mo=
dify it
> + * under  the terms of  the GNU General  Public License as published=
 by
> the + * Free Software Foundation;  either version 2 of the  License, =
or (at
> your + * option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "adv748x.h"
> +
> +static bool is_txa(struct adv748x_csi2 *tx)
> +{
> +=09return tx =3D=3D &tx->state->txa;
> +}
> +
> +static struct v4l2_subdev *adv748x_csi2_get_remote_sd(struct media_p=
ad
> *local)
> +{
> +=09struct media_pad *pad;
> +
> +=09pad =3D media_entity_remote_pad(local);

You need to guard against pad being NULL. Additionally, as the function=
 is=20
only called on tx->pads[ADV748X_CSI2_SINK], the remote entity is guaran=
teed to=20
be a subdev, but otherwise you would need to add

=09if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
=09=09return NULL;

here. How about specializing the function slightly to avoid that ?

static struct v4l2_subdev *adv748x_csi2_get_source_sd(struct adv748x_cs=
i2 *tx)
{
=09struct media_pad *pad =3D &tx->pads[ADV748X_CSI2_SINK];

=09pad =3D media_entity_remote_pad(pad);
=09if (!pad)
=09=09return NULL;

=09return media_entity_to_v4l2_subdev(pad->entity);
}

> +=09return media_entity_to_v4l2_subdev(pad->entity);
> +}

[snip]

> +static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> +{
> +=09struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> +=09struct adv748x_state *state =3D tx->state;
> +
> +=09adv_info(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
> +=09=09=09sd->name);

I'd make this a debug message.

> +
> +=09/*
> +=09 * We can not register our sub devices until both CSI/TX entities=

> +=09 * are registered.
> +=09 */
> +=09if (is_txa(tx))
> +=09=09return 0;

Do you have a guarantee that TXA will be registered first ? What if onl=
y TXA=20
is connected and TXB unused ?

> +=09return adv748x_register_subdevs(state, sd->v4l2_dev);
> +}
> +
> +static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_o=
ps =3D {
> +=09.registered =3D adv748x_csi2_registered,
> +};

[snip]


> +static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, int enable)=

> +{
> +=09struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> +=09struct v4l2_subdev *src;
> +
> +=09src =3D adv748x_csi2_get_remote_sd(&tx->pads[ADV748X_CSI2_SINK]);=

> +=09if (!src)
> +=09=09return -ENODEV;

Maybe -EPIPE ?

> +=09return v4l2_subdev_call(src, video, s_stream, enable);
> +}

[snip]

> +/* -----------------------------------------------------------------=
-------
> + * v4l2_subdev_pad_ops
> + *
> + * The CSI2 bus pads, are ignorant to the data sizes or formats.

s/,//

> + * But we must support setting the pad formats for format propagatio=
n.
> + */
> +
> +static struct v4l2_mbus_framefmt *
> +adv748x_csi2_get_pad_format(struct v4l2_subdev *sd,
> +=09=09=09    struct v4l2_subdev_pad_config *cfg,
> +=09=09=09    unsigned int pad, u32 which)
> +{
> +=09struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> +
> +=09if (which =3D=3D V4L2_SUBDEV_FORMAT_TRY)
> +=09=09return v4l2_subdev_get_try_format(sd, cfg, pad);
> +=09else
> +=09=09return &tx->format;
> +}
> +
> +static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
> +=09=09=09=09   struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09   struct v4l2_subdev_format *sdformat)
> +{
> +=09struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> +=09struct adv748x_state *state =3D tx->state;
> +=09struct v4l2_mbus_framefmt *mbusformat;
> +
> +=09mbusformat =3D adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad=
,
> +=09=09=09=09=09=09 sdformat->which);
> +=09if (!mbusformat)
> +=09=09return -EINVAL;
> +
> +=09mutex_lock(&state->mutex);
> +
> +=09sdformat->format =3D *mbusformat;
> +
> +=09mutex_unlock(&state->mutex);
> +
> +=09return 0;
> +}
> +
> +static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
> +=09=09=09=09   struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09   struct v4l2_subdev_format *sdformat)
> +{
> +=09struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> +=09struct adv748x_state *state =3D tx->state;
> +=09struct media_pad *pad =3D &tx->pads[sdformat->pad];
> +=09struct v4l2_mbus_framefmt *mbusformat;
> +
> +=09mbusformat =3D adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad=
,
> +=09=09=09=09=09=09 sdformat->which);
> +=09if (!mbusformat)
> +=09=09return -EINVAL;
> +
> +=09mutex_lock(&state->mutex);
> +
> +=09if (pad->flags & MEDIA_PAD_FL_SOURCE)
> +=09=09sdformat->format =3D tx->format;

This isn't correct. tx->format is the active format, and should not be =
used at=20
all when setting TRY formats. There are multiple constructs you can use=
 to=20
implement this, one of them being

=09if (sdformat->pad =3D=3D ADV748X_CSI2_SOURCE) {
=09=09const struct v4l2_mbus_framefmt *sink_fmt;

=09=09sink_fmt =3D adv748x_csi2_get_pad_format(sd, cfg,
=09=09=09=09=09=09       ADV748X_CSI2_SINK,
=09=09=09=09=09=09       sdformat->which);
=09=09if (!sink_fmt)
=09=09=09return -EINVAL;

=09=09sdformat->format =3D *sink_fmt;
=09}

=09*mbusformat =3D sdformat->format;

=09mutex_unlock(&state->mutex);

> +=09if (!mbusformat)
> +=09=09return -EINVAL;
> +
> +=09mutex_lock(&state->mutex);
> +
> +=09if (pad->flags & MEDIA_PAD_FL_SOURCE)
> +=09=09sdformat->format =3D tx->format;
> +
> +=09*mbusformat =3D sdformat->format;
> +
> +=09mutex_unlock(&state->mutex);
> +
> +=09return 0;
> +}

[snip]

> +static int adv748x_csi2_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +=09struct adv748x_csi2 *tx =3D container_of(ctrl->handler,
> +=09=09=09=09=09struct adv748x_csi2, ctrl_hdl);
> +
> +=09switch (ctrl->id) {
> +=09case V4L2_CID_PIXEL_RATE:
> +=09{
> +=09=09struct v4l2_ctrl *rate;
> +=09=09struct v4l2_subdev *src;
> +
> +=09=09src =3D adv748x_csi2_get_remote_sd(&tx-
>pads[ADV748X_CSI2_SINK]);
> +=09=09if (!src)
> +=09=09=09return -ENODEV;
> +
> +=09=09rate =3D v4l2_ctrl_find(src->ctrl_handler, V4L2_CID_PIXEL_RATE=
);

Instead of going through the control framework, can't you just call an=20=

internal function directly ? You wouldn't have to expose the PIXEL_RATE=
=20
control in the AFE and HDMI subdevs at all, it would simplify the=20
implementation. My above comments about removing the volatile flag from=
 the=20
control will then probably not apply anymore though, but the part about=
=20
whether the AFE changes the size on the flight when the standard change=
s is=20
still valid.

> +=09=09if (!rate)
> +=09=09=09return -EPIPE;
> +
> +=09=09*ctrl->p_new.p_s64 =3D v4l2_ctrl_g_ctrl_int64(rate);
> +
> +=09=09break;
> +=09}
> +=09default:
> +=09=09return -EINVAL;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops adv748x_csi2_ctrl_ops =3D {
> +=09.g_volatile_ctrl =3D adv748x_csi2_g_volatile_ctrl,
> +};
> +
> +static int adv748x_csi2_init_controls(struct adv748x_csi2 *tx)
> +{
> +=09struct v4l2_ctrl *ctrl;
> +
> +=09v4l2_ctrl_handler_init(&tx->ctrl_hdl, 1);
> +
> +=09// Can lock all controls with the global state mutex.
> +=09// tx->ctrl_hdl.lock =3D &tx->state->mutex;

Do you need to keep this ?

> +=09ctrl =3D v4l2_ctrl_new_std(&tx->ctrl_hdl, &adv748x_csi2_ctrl_ops,=

> +=09=09=09=09 V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
> +=09if (ctrl)
> +=09=09ctrl->flags |=3D V4L2_CTRL_FLAG_VOLATILE;
> +
> +=09tx->sd.ctrl_handler =3D &tx->ctrl_hdl;
> +=09if (tx->ctrl_hdl.error) {
> +=09=09v4l2_ctrl_handler_free(&tx->ctrl_hdl);
> +=09=09return tx->ctrl_hdl.error;
> +=09}
> +
> +=09return v4l2_ctrl_handler_setup(&tx->ctrl_hdl);
> +}
> +
> +int adv748x_csi2_probe(struct adv748x_state *state, struct adv748x_c=
si2
> *tx)
> +{
> +=09struct device_node *ep;
> +=09int ret;
> +
> +=09/* We can not use container_of to get back to the state with two =
TXs=20
*/
> +=09tx->state =3D state;
> +
> +=09ep =3D state->endpoints[is_txa(tx) ? ADV748X_PORT_TXA :=20
ADV748X_PORT_TXB];
> +=09if (!ep) {
> +=09=09adv_err(state, "No endpoint found for %s\n",
> +=09=09=09=09is_txa(tx) ? "txa" : "txb");
> +=09=09return -ENODEV;
> +=09}
> +
> +=09adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
> +=09=09=09is_txa(tx) ? "txa" : "txb");
> +
> +=09/* Ensure that matching is based upon the endpoint fwnodes */
> +=09tx->sd.fwnode =3D of_fwnode_handle(ep);
> +
> +=09/* Register internal ops for incremental subdev registration */
> +=09tx->sd.internal_ops =3D &adv748x_csi2_internal_ops;
> +
> +=09tx->pads[ADV748X_CSI2_SINK].flags =3D MEDIA_PAD_FL_SINK;
> +=09tx->pads[ADV748X_CSI2_SOURCE].flags =3D MEDIA_PAD_FL_SOURCE;
> +
> +=09ret =3D media_entity_pads_init(&tx->sd.entity, ADV748X_CSI2_NR_PA=
DS,
> +=09=09=09=09     tx->pads);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09ret =3D adv748x_csi2_init_controls(tx);
> +=09if (ret)
> +=09=09goto err_free_media;
> +
> +=09ret =3D v4l2_async_register_subdev(&tx->sd);
> +=09if (ret)
> +=09=09goto err_free_ctrl;
> +
> +=09return 0;
> +
> +err_free_ctrl:
> +=09v4l2_ctrl_handler_free(&tx->ctrl_hdl);
> +err_free_media:
> +=09media_entity_cleanup(&tx->sd.entity);
> +
> +=09return ret;
> +}

[snip]

> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> b/drivers/media/i2c/adv748x/adv748x-hdmi.c new file mode 100644
> index 000000000000..b9e61e6a43fa
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c

[snip]

> +static const struct v4l2_dv_timings_cap adv748x_hdmi_timings_cap =3D=
 {
> +=09.type =3D V4L2_DV_BT_656_1120,
> +=09/* keep this initialization for compatibility with GCC < 4.4.6 */=

> +=09.reserved =3D { 0 },

Does gcc < 4.4.6 really not initialize non-specified fields to 0 ?

> +=09/* Min pixelclock value is unknown */
> +=09V4L2_INIT_BT_TIMINGS(ADV748X_HDMI_MIN_WIDTH, ADV748X_HDMI_MAX_WID=
TH,
> +=09=09=09     ADV748X_HDMI_MIN_HEIGHT, ADV748X_HDMI_MAX_HEIGHT,
> +=09=09=09     ADV748X_HDMI_MIN_PIXELCLOCK,
> +=09=09=09     ADV748X_HDMI_MAX_PIXELCLOCK,
> +=09=09=09     V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
> +=09=09=09     V4L2_DV_BT_CAP_INTERLACED |
> +=09=09=09     V4L2_DV_BT_CAP_PROGRESSIVE)
> +};

[snip]

> +static bool adv748x_hdmi_have_signal(struct adv748x_state *state)

s/have/has/ ?

> +{
> +=09int val;
> +
> +=09/* Check that VERT_FILTER and DG_REGEN is locked */
> +=09val =3D hdmi_read(state, 0x07);
> +=09return (val & BIT(7)) && (val & BIT(5));
> +}
> +
> +static unsigned int adv748x_hdmi_read_pixelclock(struct adv748x_stat=
e
> *state)=20
> +{
> +=09int a, b;
> +
> +=09a =3D hdmi_read(state, 0x51);
> +=09b =3D hdmi_read(state, 0x52);
> +=09if (a < 0 || b < 0)
> +=09=09return -ENODATA;

Returning a negative error code from a function that returns an unsigne=
d int ?

> +
> +=09return ((a << 1) | (b >> 7)) * 1000000 + (b & 0x7f) * 1000000 / 1=
28;
> +}
> +
> +static int adv748x_hdmi_set_video_timings(struct adv748x_state *stat=
e,
> +=09=09=09=09=09  const struct v4l2_dv_timings=20
*timings)
> +{
> +=09const struct adv748x_hdmi_video_standards *stds =3D
> +=09=09adv748x_hdmi_video_standards;
> +=09int i;

i only takes positive values, you can make it an unsigned int.

> +=09for (i =3D 0; stds[i].timings.bt.width; i++) {

How about removing the sentinel at the end of the array and use i <=20
ARRAY_SIZE(adv748x_hdmi_video_standards) as the condition ?

> +=09=09if (!v4l2_match_dv_timings(timings, &stds[i].timings, 250000,
> +=09=09=09=09=09   false))
> +=09=09=09continue;

If you invert the condition and break and add a check after the loop to=
 return=20
an error if the loop went through without finding a match, you can lowe=
r the=20
indentation of the code below.

> +=09=09/*
> +=09=09 * The resolution of 720p, 1080i and 1080p is Hsync width of
> +=09=09 * 40 pixelclock cycles. These resolutions must be shifted
> +=09=09 * horizontally to the left in active video mode.
> +=09=09 */

I'm not sure to understand this.

> +=09=09switch (stds[i].vid_std) {
> +=09=09case 0x53: /* 720p */
> +=09=09=09cp_write(state, 0x8B, 0x43);
> +=09=09=09cp_write(state, 0x8C, 0xD8);
> +=09=09=09cp_write(state, 0x8B, 0x4F);
> +=09=09=09cp_write(state, 0x8D, 0xD8);
> +=09=09=09break;
> +=09=09case 0x54: /* 1080i */
> +=09=09case 0x5e: /* 1080p */
> +=09=09=09cp_write(state, 0x8B, 0x43);
> +=09=09=09cp_write(state, 0x8C, 0xD4);
> +=09=09=09cp_write(state, 0x8B, 0x4F);
> +=09=09=09cp_write(state, 0x8D, 0xD4);
> +=09=09=09break;
> +=09=09default:
> +=09=09=09cp_write(state, 0x8B, 0x40);
> +=09=09=09cp_write(state, 0x8C, 0x00);
> +=09=09=09cp_write(state, 0x8B, 0x40);
> +=09=09=09cp_write(state, 0x8D, 0x00);
> +=09=09=09break;
> +=09=09}
> +
> +=09=09io_write(state, 0x05, stds[i].vid_std);
> +=09=09io_clrset(state, 0x03, 0x70, stds[i].v_freq << 4);
> +
> +=09=09return 0;
> +=09}
> +
> +=09return -EINVAL;
> +}
> +
> +/* -----------------------------------------------------------------=
------
> + * v4l2_subdev_video_ops
> + */
> +
> +static int adv748x_hdmi_s_dv_timings(struct v4l2_subdev *sd,
> +=09=09=09=09     struct v4l2_dv_timings *timings)
> +{
> +=09struct adv748x_hdmi *hdmi =3D adv748x_sd_to_hdmi(sd);
> +=09struct adv748x_state *state =3D adv748x_hdmi_to_state(hdmi);
> +=09int ret;
> +
> +=09if (!timings)
> +=09=09return -EINVAL;

Can this happen ?

> +=09if (v4l2_match_dv_timings(&hdmi->timings, timings, 0, false))
> +=09=09return 0;
> +
> +=09if (!v4l2_valid_dv_timings(timings, &adv748x_hdmi_timings_cap,
> +=09=09=09=09   NULL, NULL))
> +=09=09return -ERANGE;
> +
> +=09adv748x_fill_optional_dv_timings(timings);
> +
> +=09ret =3D adv748x_hdmi_set_video_timings(state, timings);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09hdmi->timings =3D *timings;

The g/s operations are nicely locked for the CSI2 entities but they are=
 not=20
here.

> +=09cp_clrset(state, 0x91, 0x40, timings->bt.interlaced ? 0x40 : 0x00=
);
> +
> +=09return 0;
> +}

[snip]

> +static int adv748x_hdmi_query_dv_timings(struct v4l2_subdev *sd,
> +=09=09=09=09=09 struct v4l2_dv_timings *timings)
> +{
> +=09struct adv748x_hdmi *hdmi =3D adv748x_sd_to_hdmi(sd);
> +=09struct adv748x_state *state =3D adv748x_hdmi_to_state(hdmi);
> +=09struct v4l2_bt_timings *bt =3D &timings->bt;
> +=09int tmp;

Please don't name variables tmp, that's not descriptive at all.

> +=09if (!timings)
> +=09=09return -EINVAL;

Can this happen ?

> +=09memset(timings, 0, sizeof(struct v4l2_dv_timings));
> +
> +=09if (!adv748x_hdmi_have_signal(state))
> +=09=09return -ENOLINK;
> +
> +=09timings->type =3D V4L2_DV_BT_656_1120;
> +
> +=09bt->interlaced =3D hdmi_read(state, 0x0b) & BIT(5) ?
> +=09=09V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
> +
> +=09bt->width =3D hdmi_read16(state, 0x07, 0x1fff);
> +=09bt->height =3D hdmi_read16(state, 0x09, 0x1fff);
> +=09bt->hfrontporch =3D hdmi_read16(state, 0x20, 0x1fff);
> +=09bt->hsync =3D hdmi_read16(state, 0x22, 0x1fff);
> +=09bt->hbackporch =3D hdmi_read16(state, 0x24, 0x1fff);
> +=09bt->vfrontporch =3D hdmi_read16(state, 0x2a, 0x3fff) / 2;
> +=09bt->vsync =3D hdmi_read16(state, 0x2e, 0x3fff) / 2;
> +=09bt->vbackporch =3D hdmi_read16(state, 0x32, 0x3fff) / 2;
> +
> +=09bt->pixelclock =3D adv748x_hdmi_read_pixelclock(state);
> +=09if (bt->pixelclock < 0)

bt->pixelclock is unsigned.

> +=09=09return -ENODATA;
> +
> +=09tmp =3D hdmi_read(state, 0x05);
> +=09bt->polarities =3D (tmp & BIT(4) ? V4L2_DV_VSYNC_POS_POL : 0) |
> +=09=09(tmp & BIT(5) ? V4L2_DV_HSYNC_POS_POL : 0);
> +
> +=09if (bt->interlaced =3D=3D V4L2_DV_INTERLACED) {
> +=09=09bt->height +=3D hdmi_read16(state, 0x0b, 0x1fff);
> +=09=09bt->il_vfrontporch =3D hdmi_read16(state, 0x2c, 0x3fff) / 2;
> +=09=09bt->il_vsync =3D hdmi_read16(state, 0x30, 0x3fff) / 2;
> +=09=09bt->il_vbackporch =3D hdmi_read16(state, 0x34, 0x3fff) / 2;
> +=09}
> +
> +=09adv748x_fill_optional_dv_timings(timings);
> +
> +=09if (!adv748x_hdmi_have_signal(state)) {
> +=09=09adv_info(state, "HDMI signal lost during readout\n");
> +=09=09return -ENOLINK;
> +=09}

Can the readout trigger an HDMI signal loss, or is it a random check ?

> +=09/*
> +=09 * TODO: No interrupt handling is implemented yet.
> +=09 * There should be an IRQ when a cable is plugged and a the new
> +=09 * timings figured out and stored to state. This the next best th=
ing
> +=09 */
> +=09hdmi->timings =3D *timings;
> +
> +=09adv_dbg(state, "HDMI %dx%d%c clock: %llu Hz pol: %x "
> +=09=09"hfront: %d hsync: %d hback: %d "
> +=09=09"vfront: %d vsync: %d vback: %d "
> +=09=09"il_vfron: %d il_vsync: %d il_vback: %d\n",
> +=09=09bt->width, bt->height,
> +=09=09bt->interlaced =3D=3D V4L2_DV_INTERLACED ? 'i' : 'p',
> +=09=09bt->pixelclock, bt->polarities,
> +=09=09bt->hfrontporch, bt->hsync, bt->hbackporch,
> +=09=09bt->vfrontporch, bt->vsync, bt->vbackporch,
> +=09=09bt->il_vfrontporch, bt->il_vsync, bt->il_vbackporch);
> +
> +=09return 0;
> +}

[snip]

> +static int adv748x_hdmi_s_stream(struct v4l2_subdev *sd, int enable)=

> +{
> +=09struct adv748x_hdmi *hdmi =3D adv748x_sd_to_hdmi(sd);
> +=09struct adv748x_state *state =3D adv748x_hdmi_to_state(hdmi);
> +=09int ret;
> +
> +=09mutex_lock(&state->mutex);
> +
> +=09ret =3D adv748x_txa_power(state, enable);
> +=09if (ret)
> +=09=09goto error;
> +
> +=09if (adv748x_hdmi_have_signal(state))
> +=09=09adv_dbg(state, "Detected HDMI signal\n");
> +=09else
> +=09=09adv_info(state, "Couldn't detect HDMI video signal\n");

Same as with the AFE, I would make this a debug message.

> +
> +error:

This code is executed in the success case too, I'd name the label done =
or out.

> +=09mutex_unlock(&state->mutex);
> +=09return ret;
> +}

[snip]

> +static int adv748x_hdmi_get_pad_format(struct v4l2_subdev *sd,
> +=09=09=09=09  struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09  struct v4l2_subdev_format *format)
> +{
> +=09struct adv748x_hdmi *hdmi =3D adv748x_sd_to_hdmi(sd);
> +
> +=09adv748x_hdmi_fill_format(hdmi, &format->format);
> +
> +=09if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> +=09=09struct v4l2_mbus_framefmt *fmt;
> +
> +=09=09fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +=09=09format->format.code =3D fmt->code;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static int adv748x_hdmi_set_pad_format(struct v4l2_subdev *sd,
> +=09=09=09=09       struct v4l2_subdev_pad_config *cfg,
> +=09=09=09=09       struct v4l2_subdev_format *format)
> +{
> +=09struct adv748x_hdmi *hdmi =3D adv748x_sd_to_hdmi(sd);
> +
> +=09adv748x_hdmi_fill_format(hdmi, &format->format);
> +
> +=09if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> +=09=09struct v4l2_mbus_framefmt *fmt;
> +
> +=09=09fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +=09=09fmt->code =3D format->format.code;
> +=09}
> +
> +=09return 0;
> +}

The comments I made for the AFE apply here too.

> +static int adv748x_hdmi_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +=09struct adv748x_hdmi *hdmi =3D adv748x_ctrl_to_hdmi(ctrl);
> +=09struct adv748x_state *state =3D adv748x_hdmi_to_state(hdmi);
> +=09int ret;
> +
> +=09/* Enable video adjustment first */
> +=09ret =3D cp_read(state, ADV748X_HDMI_VID_ADJ_REG);
> +=09if (ret < 0)
> +=09=09return ret;
> +=09ret |=3D ADV748X_HDMI_VID_ADJ_ENABLE;
> +
> +=09ret =3D cp_write(state, ADV748X_HDMI_VID_ADJ_REG, ret);
> +=09if (ret < 0)
> +=09=09return ret;

Can't you use the cp_clrset macro ?

> +=09switch (ctrl->id) {
> +=09case V4L2_CID_BRIGHTNESS:
> +=09=09if (ctrl->val < ADV748X_HDMI_BRI_MIN ||
> +=09=09    ctrl->val > ADV748X_HDMI_BRI_MAX)
> +=09=09=09return -ERANGE;

Same as for the AFE, the control framework handlers this.

> +=09=09ret =3D cp_write(state, ADV748X_HDMI_BRI_REG, ctrl->val);
> +=09=09break;
> +=09case V4L2_CID_HUE:
> +=09=09if (ctrl->val < ADV748X_HDMI_HUE_MIN ||
> +=09=09    ctrl->val > ADV748X_HDMI_HUE_MAX)
> +=09=09=09return -ERANGE;
> +
> +=09=09ret =3D cp_write(state, ADV748X_HDMI_HUE_REG, ctrl->val);
> +=09=09break;
> +=09case V4L2_CID_CONTRAST:
> +=09=09if (ctrl->val < ADV748X_HDMI_CON_MIN ||
> +=09=09    ctrl->val > ADV748X_HDMI_CON_MAX)
> +=09=09=09return -ERANGE;
> +
> +=09=09ret =3D cp_write(state, ADV748X_HDMI_CON_REG, ctrl->val);
> +=09=09break;
> +=09case V4L2_CID_SATURATION:
> +=09=09if (ctrl->val < ADV748X_HDMI_SAT_MIN ||
> +=09=09    ctrl->val > ADV748X_HDMI_SAT_MAX)
> +=09=09=09return -ERANGE;
> +
> +=09=09ret =3D cp_write(state, ADV748X_HDMI_SAT_REG, ctrl->val);
> +=09=09break;
> +=09default:
> +=09=09return -EINVAL;
> +=09}
> +
> +=09return ret;
> +}

[snip]

> diff --git a/drivers/media/i2c/adv748x/adv748x.h
> b/drivers/media/i2c/adv748x/adv748x.h new file mode 100644
> index 000000000000..af6c2a5278f6
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x.h

[snip]

> +/* CSI2 transmitters can have 3 internal connections, HDMI/AFE/TTL *=
/
> +#define ADV748X_CSI2_MAX_SUBDEVS 3

We don't support the TTL yet though.

[snip]

> +/**
> + * struct adv748x_state - State of ADV748X
> + * @dev:=09=09(OF) device
> + * @client:=09=09I2C client
> + * @mutex:=09=09protect global state
> + *
> + * @endpoints:=09=09parsed device node endpoints for each port
> + *
> + * @hdmi:=09=09state of HDMI receiver context
> + * @sdp:=09=09state of AFE receiver context

The field is named afe.

> + * @txa:=09=09state of TXA transmitter context
> + * @txb:=09=09state of TXB transmitter context
> + */
> +struct adv748x_state {
> +=09struct device *dev;
> +=09struct i2c_client *client;
> +=09struct mutex mutex;
> +
> +=09struct device_node *endpoints[ADV748X_PORT_MAX];
> +
> +=09struct adv748x_hdmi hdmi;
> +=09struct adv748x_afe afe;
> +
> +=09struct adv748x_csi2 txa;
> +=09struct adv748x_csi2 txb;
> +};

[snip]

> +/* Register handling */
> +int adv748x_read(struct adv748x_state *state, u8 addr, u8 reg);
> +int adv748x_write(struct adv748x_state *state, u8 addr, u8 reg, u8 v=
alue);
> +
> +#define io_read(s, r) adv748x_read(s, ADV748X_I2C_IO, r)
> +#define io_write(s, r, v) adv748x_write(s, ADV748X_I2C_IO, r, v)
> +#define io_clrset(s, r, m, v) io_write(s, r, (io_read(s, r) & ~m) | =
v)

How about using regmap to avoid the I2C read in clrset macros ?

> +#define hdmi_read(s, r) adv748x_read(s, ADV748X_I2C_HDMI, r)
> +#define hdmi_read16(s, r, m) (((hdmi_read(s, r) << 8) | hdmi_read(s,=
 r+1))
> & m)
> +#define hdmi_write(s, r, v) adv748x_write(s, ADV748X_I2C_HDMI, r, v)=

> +#define hdmi_clrset(s, r, m, v) hdmi_write(s, r, (hdmi_read(s, r) & =
~m) |
> v)
> +
> +#define sdp_read(s, r) adv748x_read(s, ADV748X_I2C_SDP, r)
> +#define sdp_write(s, r, v) adv748x_write(s, ADV748X_I2C_SDP, r, v)
> +#define sdp_clrset(s, r, m, v) sdp_write(s, r, (sdp_read(s, r) & ~m)=
 | v)
> +
> +#define cp_read(s, r) adv748x_read(s, ADV748X_I2C_CP, r)
> +#define cp_write(s, r, v) adv748x_write(s, ADV748X_I2C_CP, r, v)
> +#define cp_clrset(s, r, m, v) cp_write(s, r, (cp_read(s, r) & ~m) | =
v)
> +
> +#define txa_read(s, r) adv748x_read(s, ADV748X_I2C_TXA, r)
> +#define txa_write(s, r, v) adv748x_write(s, ADV748X_I2C_TXA, r, v)
> +#define txa_clrset(s, r, m, v) txa_write(s, r, (txa_read(s, r) & ~m)=
 | v)
> +
> +#define txb_read(s, r) adv748x_read(s, ADV748X_I2C_TXB, r)
> +#define txb_write(s, r, v) adv748x_write(s, ADV748X_I2C_TXB, r, v)
> +#define txb_clrset(s, r, m, v) txb_write(s, r, (txb_read(s, r) & ~m)=
 | v)

[snip]

--=20
Regards,

Laurent Pinchart
