Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38968 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab2CVClp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 22:41:45 -0400
Received: by lbbgm6 with SMTP id gm6so1398266lbb.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 19:41:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120317185747.GE5412@valkosipuli.localdomain>
References: <1331983334-18934-1-git-send-email-ajaykumar.rs@samsung.com>
	<1331983334-18934-2-git-send-email-ajaykumar.rs@samsung.com>
	<20120317185747.GE5412@valkosipuli.localdomain>
Date: Thu, 22 Mar 2012 08:11:43 +0530
Message-ID: <CAEC9eQP-4ggXJdoryvSCmhGMLbRYDqC88UWzTMm3WrCBgFq82w@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] media: video: s5p-g2d: Add support for FIMG2D v41
 H/W logic
From: Ajay kumar <ajaynumb@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ajay Kumar <ajaykumar.rs@samsung.com>, linux-media@vger.kernel.org,
	k.debski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, es10.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr.Sakari

On Sun, Mar 18, 2012 at 12:27 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Ajay,
>
> Thanks for the patch. I have a few comments below.
>
> On Sat, Mar 17, 2012 at 04:52:14PM +0530, Ajay Kumar wrote:
>> Modify the G2D driver(which initially supported only FIMG2D v3 style H/W)
>> to support FIMG2D v41 style hardware present on Exynos4x12 and Exynos52x0 SOC.
>>
>>       -- Set the SRC and DST type to 'memory' instead of using reset values.
>>       -- FIMG2D v41 H/W uses different logic for stretching(scaling).
>>       -- Use CACHECTL_REG only with FIMG2D v3.
>>
>> Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
>> ---
>>  drivers/media/video/s5p-g2d/g2d-hw.c   |   39 ++++++++++++++++++++++++++++---
>>  drivers/media/video/s5p-g2d/g2d-regs.h |    6 +++++
>>  drivers/media/video/s5p-g2d/g2d.c      |   23 +++++++++++++++++-
>>  drivers/media/video/s5p-g2d/g2d.h      |    9 ++++++-
>>  4 files changed, 70 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-g2d/g2d-hw.c b/drivers/media/video/s5p-g2d/g2d-hw.c
>> index 5b86cbe..f8225b8 100644
>> --- a/drivers/media/video/s5p-g2d/g2d-hw.c
>> +++ b/drivers/media/video/s5p-g2d/g2d-hw.c
>> @@ -28,6 +28,8 @@ void g2d_set_src_size(struct g2d_dev *d, struct g2d_frame *f)
>>  {
>>       u32 n;
>>
>> +     w(0, SRC_SELECT_REG);
>> +
>>       w(f->stride & 0xFFFF, SRC_STRIDE_REG);
>>
>>       n = f->o_height & 0xFFF;
>> @@ -52,6 +54,8 @@ void g2d_set_dst_size(struct g2d_dev *d, struct g2d_frame *f)
>>  {
>>       u32 n;
>>
>> +     w(0, DST_SELECT_REG);
>> +
>>       w(f->stride & 0xFFFF, DST_STRIDE_REG);
>>
>>       n = f->o_height & 0xFFF;
>> @@ -82,10 +86,36 @@ void g2d_set_flip(struct g2d_dev *d, u32 r)
>>       w(r, SRC_MSK_DIRECT_REG);
>>  }
>>
>> -u32 g2d_cmd_stretch(u32 e)
>> +/**
>> + * g2d_calc_scale_factor - convert scale factor to fixed pint 16
>
> Point, perhaps?
Ok. Typo.

>> + * @n: numerator
>> + * @d: denominator
>> + */
>> +static unsigned long g2d_calc_scale_factor(int n, int d)
>> +{
>> +     return (n << 16) / d;
>> +}
>> +
>> +void g2d_set_v41_stretch(struct g2d_dev *d, struct g2d_frame *src,
>> +                                     struct g2d_frame *dst)
>>  {
>> -     e &= 1;
>> -     return e << 4;
>> +     int src_w, src_h, dst_w, dst_h;
>
> Is int intentional --- width and height usually can't be negative.
I will use 'unsigned int'.

>> +     u32 wcfg, hcfg;
>> +
>> +     w(DEFAULT_SCALE_MODE, SRC_SCALE_CTRL_REG);
>> +
>> +     src_w = src->c_width;
>> +     src_h = src->c_height;
>> +
>> +     dst_w = dst->c_width;
>> +     dst_h = dst->c_height;
>> +
>> +     /* inversed scaling factor: src is numerator */
>> +     wcfg = g2d_calc_scale_factor(src_w, dst_w);
>> +     hcfg = g2d_calc_scale_factor(src_h, dst_h);
>
> I think this would be more simple without that many temporary variables and
> an extra function.
You are right. I will Change it.

>> +     w(wcfg, SRC_XSCALE_REG);
>> +     w(hcfg, SRC_YSCALE_REG);
>>  }
>>
>>  void g2d_set_cmd(struct g2d_dev *d, u32 c)
>> @@ -96,7 +126,8 @@ void g2d_set_cmd(struct g2d_dev *d, u32 c)
>>  void g2d_start(struct g2d_dev *d)
>>  {
>>       /* Clear cache */
>> -     w(0x7, CACHECTL_REG);
>> +     if (d->device_type == TYPE_G2D_3X)
>> +             w(0x7, CACHECTL_REG);
>>       /* Enable interrupt */
>>       w(1, INTEN_REG);
>>       /* Start G2D engine */
>
> Kind regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for your review and comments. I will resubmit the patch with changes.

Regards,
Ajay
