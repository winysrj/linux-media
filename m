Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50391 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600Ab2IMLoq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 07:44:46 -0400
Message-ID: <5051C6E8.8030109@ti.com>
Date: Thu, 13 Sep 2012 17:13:36 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	<linux-kernel@vger.kernel.org>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	<linux-doc@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3] media: v4l2-ctrl: add a helper function to modify
 the menu
References: <1347373418-18927-1-git-send-email-prabhakar.lad@ti.com> <1481481.zLUeB0rsrG@avalon>
In-Reply-To: <1481481.zLUeB0rsrG@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Thursday 13 September 2012 06:45 AM, Laurent Pinchart wrote:
> Hi Prabhakar,
> 
> Thanks for the patch.
> 
> On Tuesday 11 September 2012 19:53:38 Prabhakar Lad wrote:
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
>> Changes for v3:
>> 1: Fixed style/grammer issues as pointed by Hans.
>>    Thanks Hans for providing the description.
>>
>> Changes for v2:
>> 1: Fixed review comments from Hans, to have return type as
>>    void, add WARN_ON() for fail conditions, allow this fucntion
>>    to modify the menu of custom controls.
>>
>>  Documentation/video4linux/v4l2-controls.txt |   29 ++++++++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c        |   17 +++++++++++++++
>>  include/media/v4l2-ctrls.h                  |   11 ++++++++++
>>  3 files changed, 57 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/video4linux/v4l2-controls.txt
>> b/Documentation/video4linux/v4l2-controls.txt index 43da22b..01d0a82 100644
>> --- a/Documentation/video4linux/v4l2-controls.txt
>> +++ b/Documentation/video4linux/v4l2-controls.txt
>> @@ -367,6 +367,35 @@ it to 0 means that all menu items are supported.
>>  You set this mask either through the v4l2_ctrl_config struct for a custom
>>  control, or by calling v4l2_ctrl_new_std_menu().
>>
>> +There are situations where menu items may be device specific. In such cases
>> the
>> +framework provides a helper function to change the menu:
>> +
>> +void v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl, const char * const
>> *qmenu,
>> +	s32 max, u32 menu_skip_mask, s32 def);
> 
> Sorry if this is a stupid question, but wouldn't it be better to add a 
> function to create a custom menu instead of modifying it afterwards ?
> 
Create a custom menu? eventually everything boils down to modifying the
menu itself.

Regards,
--Prabhakar Lad

>> +
>> +A good example is the test pattern control for capture/display/sensors
>> devices
>> +that have the capability to generate test patterns. These test patterns are
>> +hardware specific, so the contents of the menu will vary from device to
>> device.
>> +
>> +This helper function is used to modify the menu, max, mask and the default
>> +value of the control.
>> +
>> +Example:
>> +
>> +	static const char * const test_pattern[] = {
>> +		"Disabled",
>> +		"Vertical Bars",
>> +		"Solid Black",
>> +		"Solid White",
>> +		NULL,
>> +	};
>> +	struct v4l2_ctrl *test_pattern_ctrl =
>> +		v4l2_ctrl_new_std_menu(&foo->ctrl_handler, &foo_ctrl_ops,
>> +			V4L2_CID_TEST_PATTERN, V4L2_TEST_PATTERN_DISABLED, 0,
>> +			V4L2_TEST_PATTERN_DISABLED);
>> +
>> +	v4l2_ctrl_modify_menu(test_pattern_ctrl, test_pattern, 3, 0,
>> +		V4L2_TEST_PATTERN_DISABLED);
>>
>>  Custom Controls
>>  ===============
> 

