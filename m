Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63019 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2IKIFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 04:05:34 -0400
MIME-Version: 1.0
In-Reply-To: <201209110955.26208.hverkuil@xs4all.nl>
References: <1347349142-2230-1-git-send-email-prabhakar.lad@ti.com> <201209110955.26208.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Sep 2012 13:35:12 +0530
Message-ID: <CA+V-a8vR3T0N5AEzZZ4qrr2Yp9g9hqgZ79CYiQNjUzoPEDhBRg@mail.gmail.com>
Subject: Re: [PATCH v2] media: v4l2-ctrl: add a helper function to modify the menu
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Tue, Sep 11, 2012 at 1:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Pradhakar,
>
> Looks good, but I have a number of style/grammar issues which I've corrected
> below.
>
> On Tue 11 September 2012 09:39:02 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> Add a helper function to modify the menu, max and default value
>> to set.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Rob Landley <rob@landley.net>
>> ---
>> Changes for v2:
>> 1: Fixed review comments from Hans, to have return type as
>>    void, add WARN_ON() for fail conditions, allow this fucntion
>>    to modify the menu of custom controls.
>>
>>  Documentation/video4linux/v4l2-controls.txt |   30 +++++++++++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c        |   17 +++++++++++++++
>>  include/media/v4l2-ctrls.h                  |   11 +++++++++
>>  3 files changed, 58 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
>> index 43da22b..160368a 100644
>> --- a/Documentation/video4linux/v4l2-controls.txt
>> +++ b/Documentation/video4linux/v4l2-controls.txt
>> @@ -367,6 +367,36 @@ it to 0 means that all menu items are supported.
>>  You set this mask either through the v4l2_ctrl_config struct for a custom
>>  control, or by calling v4l2_ctrl_new_std_menu().
>>
>> +Changing the menu:
>> +There are situations when menu items may be device specific, in such cases the
>> +framework provides the helper function to change the menu.
>> +
>> +void v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl, const char * const *qmenu,
>> +     s32 max, u32 menu_skip_mask, s32 def);
>> +
>> +A good example is the test pattern generation, the capture/display/sensors have
>> +the capability to generate test patterns. This test patterns are hardware
>> +specific, In such case the menu will vary from device to device.
>> +
>> +This helper, function is used to modify the menu, max, mask and the default
>> +value to set.
>> +
>> +Example for usage:
>> +     static const char * const test_pattern[] = {
>> +             "Disabled",
>> +             "Vertical Bars",
>> +             "Vertical Bars",
>> +             "Solid Black",
>> +             "Solid White",
>> +             NULL
>> +     };
>> +     struct v4l2_ctrl *test_pattern_ctrl =
>> +             v4l2_ctrl_new_std_menu(&foo->ctrl_handler, &foo_ctrl_ops,
>> +                     V4L2_CID_TEST_PATTERN, V4L2_TEST_PATTERN_DISABLED, 0,
>> +                     V4L2_TEST_PATTERN_DISABLED);
>> +
>> +     v4l2_ctrl_modify_menu(test_pattern_ctrl, test_pattern, 5, 0x3, 1);
>> +
>
> There are a number of style/grammar issues with the text above. I've
> corrected them in the revised version below. That replaces your version
> completely. So just to make it clear: I've dropped the first line ('Changing
> the menu:') because I don't think that line is necessary.
>
Thanks for the text :) I'll fix it for v3.

> New text:
>
> There are situations where menu items may be device specific. In such cases the
> framework provides a helper function to change the menu:
>
> void v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl, const char * const *qmenu,
>         s32 max, u32 menu_skip_mask, s32 def);
>
> A good example is the test pattern control for capture/display/sensors devices
> that have the capability to generate test patterns. These test patterns are
> hardware specific, so the contents of the menu will vary from device to device.
>
> This helper function is used to modify the menu, max, mask and the default
> value of the control.
>
> Example:
>
>         static const char * const test_pattern[] = {
>                 "Disabled",
>                 "Vertical Bars",
>                 "Solid Black",
>                 "Solid White",
>                 NULL
>         };
>         struct v4l2_ctrl *test_pattern_ctrl =
>                 v4l2_ctrl_new_std_menu(&foo->ctrl_handler, &foo_ctrl_ops,
>                         V4L2_CID_TEST_PATTERN, V4L2_TEST_PATTERN_DISABLED, 0,
>                         V4L2_TEST_PATTERN_DISABLED);
>
>         v4l2_ctrl_modify_menu(test_pattern_ctrl, test_pattern, 3, 0,
>                         V4L2_TEST_PATTERN_DISABLED);
>
>>
>>  Custom Controls
>>  ===============
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index d731422..d89b460 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -2666,3 +2666,20 @@ unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait)
>>       return 0;
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_poll);
>> +
>> +/* Helper function for modifying the menu */
>> +void v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl, const char * const *qmenu,
>> +                        s32 max, u32 menu_skip_mask, s32 def)
>> +{
>> +     if (WARN_ON(ctrl->type != V4L2_CTRL_TYPE_MENU || qmenu == NULL))
>> +             return;
>> +
>> +     if (WARN_ON(def < 0 || def > max))
>> +             return;
>> +
>> +     ctrl->qmenu = qmenu;
>> +     ctrl->maximum = max;
>> +     ctrl->menu_skip_mask = menu_skip_mask;
>> +     ctrl->cur.val = ctrl->val = ctrl->default_value = def;
>> +}
>> +EXPORT_SYMBOL(v4l2_ctrl_modify_menu);
>> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
>> index 776605f..0c91b4e 100644
>> --- a/include/media/v4l2-ctrls.h
>> +++ b/include/media/v4l2-ctrls.h
>> @@ -488,6 +488,17 @@ static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
>>       mutex_unlock(ctrl->handler->lock);
>>  }
>>
>> +/**
>> + * v4l2_ctrl_modify_menu() - This function is used to modify the menu.
>> + * @ctrl:            The control of which menu should be changed.
>
> "The control whose menu should be modified."
>
Ok.

>> + * @qmenu:           The new menu to which control will point to.
>
> "The new menu."
>
Ok.

Regards,
--Prabhakar Lad

>> + * @max:             Maximum value of the control.
>> + * @menu_skip_mask:  The control's skip mask for menu controls.
>> + * @def:             The default value for control to be set.
>> + */
>> +void v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl, const char * const *qmenu,
>> +                        s32 max, u32 menu_skip_mask, s32 def);
>> +
>>  /** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
>>    * @ctrl:   The control.
>>    *
>>
>
> Regards,
>
>         Hans
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
