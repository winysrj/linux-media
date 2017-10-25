Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60744 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750974AbdJYQIF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 12:08:05 -0400
Date: Wed, 25 Oct 2017 19:08:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH] media: ov9650: remove unnecessary terminated entry in
 menu items array
Message-ID: <20171025160802.wdywuhp3vnbaxig5@valkosipuli.retiisi.org.uk>
References: <1508779826-12499-1-git-send-email-akinobu.mita@gmail.com>
 <20171025102307.qjvqtorri4lw3weo@valkosipuli.retiisi.org.uk>
 <CAC5umyhsaWru-Z-LO7jZDt0z6H8LNh+VgC8PCO4y9GGEVA8YRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5umyhsaWru-Z-LO7jZDt0z6H8LNh+VgC8PCO4y9GGEVA8YRQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 26, 2017 at 12:22:14AM +0900, Akinobu Mita wrote:
> Hi Sakari,
> 
> 2017-10-25 19:23 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
> > On Tue, Oct 24, 2017 at 02:30:26AM +0900, Akinobu Mita wrote:
> >> The test_pattern_menu[] array has two valid items and a null terminated
> >> item.  So the control's maximum value which is passed to
> >> v4l2_ctrl_new_std_menu_items() should be one.  However,
> >> 'ARRAY_SIZE(test_pattern_menu) - 1' is actually passed and it's not
> >> correct.
> >>
> >> Fix it by removing unnecessary terminated entry and let the correct
> >> control's maximum value be passed to v4l2_ctrl_new_std_menu_items().
> >>
> >> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> >> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> ---
> >>  drivers/media/i2c/ov9650.c | 1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> >> index 6ffb460..69433e1 100644
> >> --- a/drivers/media/i2c/ov9650.c
> >> +++ b/drivers/media/i2c/ov9650.c
> >> @@ -985,7 +985,6 @@ static const struct v4l2_ctrl_ops ov965x_ctrl_ops = {
> >>  static const char * const test_pattern_menu[] = {
> >>       "Disabled",
> >>       "Color bars",
> >> -     NULL
> >
> > The number of items in the menu changes; I fixed that while applying the
> > patch:
> >
> > diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> > index 69433e1e2533..4f59da1f967b 100644
> > --- a/drivers/media/i2c/ov9650.c
> > +++ b/drivers/media/i2c/ov9650.c
> > @@ -1039,7 +1039,7 @@ static int ov965x_initialize_controls(struct ov965x *ov965x)
> >                                        V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
> >
> >         v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
> > -                                    ARRAY_SIZE(test_pattern_menu) - 1, 0, 0,
> > +                                    ARRAY_SIZE(test_pattern_menu), 0, 0,
> >                                      test_pattern_menu);
> >         if (hdl->error) {
> >                 ret = hdl->error;
> >
> >
> > Let me know if you see issues with this.
> 
> This change actually causes an issue.
> 
> This problem was found when I got the list of available controls for
> ov9650 subdev.
> 
> $ yavta -l /dev/v4l-subdev0
> <...>
> --- Image Processing Controls (class 0x009f0001) ---
> control 0x009f0903 `Test Pattern' min 0 max 2 step 1 default 0 current 0.
>   0: Disabled (*)
>   1: Color bars
> 
> Strangely, the max control value is '2'.  So I tried to set the control to '2'
> for the fun and got a null pointer dereference.
> 
> $ yavta -w '0x009f0903 2' --no-query /dev/v4l-subdev0
> Device /dev/v4l-subdev0 opened.
> Segmentation fault
> 
> Then, I found that the root cause is unnecessary terminated entry.
> So 'ARRAY_SIZE(test_pattern_menu) - 1' (=1) should be passed to
> v4l2_ctrl_new_std_menu_items().

Oops. Indeed, I'll drop that change above.

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
