Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:25621 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144Ab2AFKT7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 05:19:59 -0500
Message-ID: <4F06CAC5.8010902@maxwell.research.nokia.com>
Date: Fri, 06 Jan 2012 12:19:49 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 03/17] vivi: Add an integer menu test control
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-3-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201051659.14528.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201051659.14528.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.

Thanks for the review!

> On Tuesday 20 December 2011 21:27:55 Sakari Ailus wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Add an integer menu test control for the vivi driver.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/vivi.c |   21 +++++++++++++++++++++
>>  1 files changed, 21 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
>> index 7d754fb..763ec23 100644
>> --- a/drivers/media/video/vivi.c
>> +++ b/drivers/media/video/vivi.c
>> @@ -177,6 +177,7 @@ struct vivi_dev {
>>  	struct v4l2_ctrl	   *menu;
>>  	struct v4l2_ctrl	   *string;
>>  	struct v4l2_ctrl	   *bitmask;
>> +	struct v4l2_ctrl	   *int_menu;
>>
>>  	spinlock_t                 slock;
>>  	struct mutex		   mutex;
>> @@ -503,6 +504,10 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct
>> vivi_buffer *buf) dev->boolean->cur.val,
>>  			dev->menu->qmenu[dev->menu->cur.val],
>>  			dev->string->cur.string);
>> +	snprintf(str, sizeof(str), " integer_menu %s, value %lld ",
>> +			dev->int_menu->qmenu[dev->int_menu->cur.val],
> 
> Shouldn't you print the content of qmenu_int as a 64-bit integer instead ?

Oh, yes; I should. Also the value would be wrong, as well as the menu
item array --- should be the int one.

>> +			dev->int64->cur.val64);
> 
> Shouldn't this be dev->int_menu->cur.val ?
> 
>> +	gen_text(dev, vbuf, line++ * 16, 16, str);
>>  	mutex_unlock(&dev->ctrl_handler.lock);
>>  	gen_text(dev, vbuf, line++ * 16, 16, str);
>>  	if (dev->button_pressed) {
>> @@ -1183,6 +1188,22 @@ static const struct v4l2_ctrl_config
>> vivi_ctrl_bitmask = { .step = 0,
>>  };
>>
>> +static const s64 * const vivi_ctrl_int_menu_values[] = {
>> +	1, 1, 2, 3, 5, 8, 13, 21, 42,
>> +};
>> +
>> +static const struct v4l2_ctrl_config vivi_ctrl_string = {
>> +	.ops = &vivi_ctrl_ops,
>> +	.id = VIDI_CID_CUSTOM_BASE + 7
>> +	.name = "Integer menu",
>> +	.type = V4L2_CTRL_TYPE_INTEGER_MENU,
>> +	.min = 1,
>> +	.max = 8,
> 
> There are 9 values in your vivi_ctrl_int_menu_values array. Is 8 on purpose 
> here ?

I put it there to limit the maximum to 8 instead of 9, but 9 would be
equally good. I'll change it.

>> +	.def = 4,
>> +	.menu_skip_mask = 0x02,
>> +	.qmenu_int = &vivi_ctrl_int_menu_values,
>> +};
>> +
>>  static const struct v4l2_file_operations vivi_fops = {
>>  	.owner		= THIS_MODULE,
>>  	.open           = v4l2_fh_open,
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
