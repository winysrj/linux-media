Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59401 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281AbZKRUKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 15:10:32 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 18 Nov 2009 14:10:36 -0600
Subject: RE: [PATCH v2] V4L - Adding Digital Video Timings APIs
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C61B2@dlee06.ent.ti.com>
References: <1258563824-1310-1-git-send-email-m-karicheri2@ti.com>
 <200911181908.51793.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE401559C6120@dlee06.ent.ti.com>
 <200911182023.34005.hverkuil@xs4all.nl>
In-Reply-To: <200911182023.34005.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Thanks for doing the 64-bit test. I will incorporate
the below comments along with the other comments and will
post v3 of the patch with you included in the sign off.

Regards,

Murali
>
>I did some quick 64-bit tests and discovered that we need to add the packed
>attribute to struct v4l2_bt_timings and struct v4l2_dv_timings in order to
>prevent nasty 32-bit to 64-bit conversions in v4l2-compat-ioctl32.c.
>
>See below:
>
>> >> +/*
>> >> + *  D V     B T     T I M I N G S
>> >> + */
>> >> +
>> >> +/* BT.656/BT.1120 timing data */
>> >> +struct v4l2_bt_timings {
>> >> +    __u32   width;          /* width in pixels */
>> >> +    __u32   height;         /* height in lines */
>> >> +    __u32   interlaced;     /* Interlaced or progressive */
>> >> +    __u32   polarities;     /* Positive or negative polarity */
>> >> +    __u64   pixelclock;     /* Pixel clock in HZ. Ex. 74.25MHz-
>>74250000 */
>> >> +    __u32   hfrontporch;    /* Horizpontal front porch in pixels */
>> >> +    __u32   hsync;          /* Horizontal Sync length in pixels */
>> >> +    __u32   hbackporch;     /* Horizontal back porch in pixels */
>> >> +    __u32   vfrontporch;    /* Vertical front porch in pixels */
>> >> +    __u32   vsync;          /* Vertical Sync length in lines */
>> >> +    __u32   vbackporch;     /* Vertical back porch in lines */
>> >> +    __u32   il_vfrontporch; /* Vertical front porch for bottom field
>of
>> >> +                             * interlaced field formats
>> >> +                             */
>> >> +    __u32   il_vsync;       /* Vertical sync length for bottom field
>of
>> >> +                             * interlaced field formats
>> >> +                             */
>> >> +    __u32   il_vbackporch;  /* Vertical back porch for bottom field
>of
>> >> +                             * interlaced field formats
>> >> +                             */
>> >> +    __u32   reserved[16];
>> >> +};
>
>End with:
>
>} __attribute__ ((packed));
>
>> >> +
>> >> +/* Interlaced or progressive format */
>> >> +#define     V4L2_DV_PROGRESSIVE     0
>> >> +#define     V4L2_DV_INTERLACED      1
>> >> +
>> >> +/* Polarities. If bit is not set, it is assumed to be negative
>polarity
>> >*/
>> >> +#define V4L2_DV_VSYNC_POS_POL       0x00000001
>> >> +#define V4L2_DV_HSYNC_POS_POL       0x00000002
>> >> +
>> >> +/* BT.656/1120 timing type */
>> >> +enum v4l2_dv_timings_type {
>> >> +    V4L2_DV_BT_656_1120,
>> >> +};
>> >
>> >I forgot something: we shouldn't use enums as that can give problems on
>> >some
>> >architectures (ARM being one of them, I believe). So this should become
>a
>> >define and the type field below a __u32.
>> >
>> >> +
>> >> +/* DV timings */
>> >> +struct v4l2_dv_timings {
>> >> +    enum v4l2_dv_timings_type type;
>> >> +    union {
>> >> +            struct v4l2_bt_timings  bt;
>> >> +            __u32   reserved[32];
>> >> +    };
>> >> +};
>
>Ditto.
>
>I also attached a small diff for the v4l2-apps/test/ioctl-test.c source
>which
>I used to test this.
>
>The patch is Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>
>You can include this when you post the v4l2-apps patches.
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
