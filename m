Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab1CVA1x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 20:27:53 -0400
Message-ID: <4D87ED00.1050406@redhat.com>
Date: Mon, 21 Mar 2011 21:27:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: riverful.kim@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"???/Mobile S/W Platform Lab(DMC?)/E4(??)/????"
	<sw0312.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: [RFC PATCH RESEND v2 2/3] v4l2-ctrls: modify uvc driver to use
 new menu type of V4L2_CID_FOCUS_AUTO
References: <4D6EFA00.80009@samsung.com> <201103031110.44920.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103031110.44920.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

Em 03-03-2011 07:10, Laurent Pinchart escreveu:
> On Thursday 03 March 2011 03:16:32 Kim, HeungJun wrote:
>> As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu
>> type, this uvc is modified the usage of V4L2_CID_FOCUS_AUTO, maintaining
>> v4l2 menu index.
>>
>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'm assuming that you'll be applying those patches on your tree and sending
me a pull request, right?

Thanks!
Mauro

> 
>> ---
>>  drivers/media/video/uvc/uvc_ctrl.c |    9 ++++++++-
>>  1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>> b/drivers/media/video/uvc/uvc_ctrl.c index 59f8a9a..064827f 100644
>> --- a/drivers/media/video/uvc/uvc_ctrl.c
>> +++ b/drivers/media/video/uvc/uvc_ctrl.c
>> @@ -333,6 +333,11 @@ static struct uvc_menu_info exposure_auto_controls[] =
>> { { 8, "Aperture Priority Mode" },
>>  };
>>
>> +static struct uvc_menu_info focus_auto_controls[] = {
>> +	{ 0, "Manual Mode" },
>> +	{ 1, "Auto Mode" },
>> +};
>> +
>>  static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
>>  	__u8 query, const __u8 *data)
>>  {
>> @@ -560,8 +565,10 @@ static struct uvc_control_mapping uvc_ctrl_mappings[]
>> = { .selector	= UVC_CT_FOCUS_AUTO_CONTROL,
>>  		.size		= 1,
>>  		.offset		= 0,
>> -		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
>> +		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
>>  		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
>> +		.menu_info	= focus_auto_controls,
>> +		.menu_count	= ARRAY_SIZE(focus_auto_controls),
>>  	},
>>  	{
>>  		.id		= V4L2_CID_IRIS_ABSOLUTE,
> 

