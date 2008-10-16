Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G2LWtB005116
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 22:21:33 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G2LMw8016797
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 22:21:22 -0400
Received: by wf-out-1314.google.com with SMTP id 25so2957818wfc.6
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 19:21:21 -0700 (PDT)
Message-ID: <aec7e5c30810151921v53ab947aq8e1dd6c6ee834eaa@mail.gmail.com>
Date: Thu, 16 Oct 2008 11:21:21 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0810160041250.8535@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0810160041250.8535@axis700.grange>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Guennadi,

On Thu, Oct 16, 2008 at 8:41 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi, and thanks for the patch! A couple of notes:
>
> (Magnus, see a note for you at the bottom:-))
>
> first, you didn't add an ID for your sensor to
> include/media/v4l2-chip-ident.h, it is not reqlly required for your driver
> functionality, but you can use it to provide as a reply to the
> .vidioc_g_chip_ident request (.get_chip_id in struct soc_camera_ops).
>
> On Wed, 15 Oct 2008, Kuninori Morimoto wrote:
>
>> This patch adds ov772x driver that use soc_camera framework.
>> It was tested on SH Migo-r board.
>>
>> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

[snip]

>> +static struct regval_list ov772x_default_regs[] =
>> +{
>> +     { COM3,  ZERO },
>> +     { COM4,  PLL_4x | 0x01 },
>> +     { 0x16,  0x00 },  /* Mystery */
>> +     { COM11, B4 },    /* Mystery */
>> +     { 0x28,  0x00 },  /* Mystery */
>> +     { HREF,  0x00 },
>> +     { COM13, 0xe2 },  /* Mystery */
>
> Those "Mystery" register - are they not documented, or has the driver been
> reverse-engineered?

The data sheet does not cover them, but I think they come from the
magic init sequence in the Migo-R board code.

>> +     /*
>> +      * color bar mode
>> +      */
>> +     if (priv->info->color_bar) {
>> +             ret = ov772x_mask_set(priv->client,
>> +                             DSP_CTRL3, CBAR_MASK  , CBAR_ON);
>> +             if (ret < 0)
>> +                     goto start_end;
>> +     }
>
> What is this "color bar mode" and why do you think you need it to be
> specified by the platform data (also see below)?

The color bar mode is a camera test mode where color bars similar to
the vivi driver are output instead of the camera image. It's very
useful for testing and getting byte order issues resolved. Ideally I'd
like to have it as a second output, but I have to extend the SoC
camera framework first to get that in place.

I'm not sure if platform data is the best place to enable this, but I
guess it's good enough.

>> +static int ov772x_set_bus_param(struct soc_camera_device *icd,
>> +                             unsigned long             flags)
>> +{
>> +     int ret = 0;
>> +
>> +     /*
>> +      * check bus width
>> +      */
>> +     switch (flags & SOCAM_DATAWIDTH_MASK) {
>> +     case SOCAM_DATAWIDTH_10:
>> +     case SOCAM_DATAWIDTH_8:
>
> How does it work in both 8- and 10-bit modes without any reconfiguration?
> Are then just the upper 8 bits connected to the interface? Is it
> hard-wired, or software-switchable at runtime?

The device has 10 data pins but we use 8 on Migo-R. I think some extra
pixel formats are available with 10-bit interface but I'm not sure.
The data sheet is not very clear.

>> +
>> +struct ov772x_camera_info {
>> +     int             iface;
>> +     unsigned long   buswidth;
>> +     int             color_bar;
>> +     void (*power)(int);
>> +};
>
> Now, this one. Please, use struct soc_camera_link. It also provides bus_id
> (your iface), power, ok, I admit, the inclusion of the "gpio" member in it
> was a mistake of mine, it is too specific, we might remove it at some
> point. I am not sure you really need color_bar and bus_width. I think,
> cameras are more or less exchangeable parts, and if they need some
> parameters, that cannot be autoprobed and do not belong to the camera
> itself, it might be better to make them module parameters, like the
> sensor_type parameter in mt9v022. Even if in your case the sensor chip is
> soldered on the board, in another configuration it might not be.

Using soc_camera_link sounds like a good idea. I don't agree with you
regarding the module parameters - doing that removes the
per-camera-instance configuration that the platform data gives us.

> Magnus, I think, we should switch soc_camera_platform to use
> soc_camera_link too.

Sure.

> In both ov772x and soc_camera_platform cases, if you do need extra
> platform information, just embed soc_camera_link in your struct.

That seems the best way forward.

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
