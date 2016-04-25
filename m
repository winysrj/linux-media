Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32944 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053AbcDYQcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 12:32:54 -0400
Received: by mail-wm0-f66.google.com with SMTP id r12so23332810wme.0
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 09:32:53 -0700 (PDT)
Subject: Re: [RFC PATCH 01/24] V4L fixes
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425132549.GE32125@valkosipuli.retiisi.org.uk>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <571E46B2.7060300@gmail.com>
Date: Mon, 25 Apr 2016 19:32:50 +0300
MIME-Version: 1.0
In-Reply-To: <20160425132549.GE32125@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 25.04.2016 16:25, Sakari Ailus wrote:
> Hi Ivaylo,
>
> Thanks for the set!
>
> On Mon, Apr 25, 2016 at 12:08:01AM +0300, Ivaylo Dimitrov wrote:
>> From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
>>
>> Squashed from the following upstream commits:
>>
>> V4L: Create control class for sensor mode
>> V4L: add ad5820 focus specific custom controls
>> V4L: add V4L2_CID_TEST_PATTERN
>> V4L: Add V4L2_CID_MODE_OPSYSCLOCK for reading output system clock
>>
>> Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> ---
>>   include/uapi/linux/v4l2-controls.h | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
>> index b6a357a..23011cc 100644
>> --- a/include/uapi/linux/v4l2-controls.h
>> +++ b/include/uapi/linux/v4l2-controls.h
>> @@ -62,6 +62,7 @@
>>   #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
>>   #define V4L2_CTRL_CLASS_RF_TUNER	0x00a20000	/* RF tuner controls */
>>   #define V4L2_CTRL_CLASS_DETECT		0x00a30000	/* Detection controls */
>> +#define V4L2_CTRL_CLASS_MODE		0x00a40000	/* Sensor mode information */
>>
>>   /* User-class control IDs */
>>
>> @@ -974,4 +975,20 @@ enum v4l2_detect_md_mode {
>>   #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>>   #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>>
>> +/* SMIA-type sensor information */
>> +#define V4L2_CID_MODE_CLASS_BASE		(V4L2_CTRL_CLASS_MODE | 0x900)
>> +#define V4L2_CID_MODE_CLASS			(V4L2_CTRL_CLASS_MODE | 1)
>> +#define V4L2_CID_MODE_FRAME_WIDTH		(V4L2_CID_MODE_CLASS_BASE+1)
>> +#define V4L2_CID_MODE_FRAME_HEIGHT		(V4L2_CID_MODE_CLASS_BASE+2)
>> +#define V4L2_CID_MODE_VISIBLE_WIDTH		(V4L2_CID_MODE_CLASS_BASE+3)
>> +#define V4L2_CID_MODE_VISIBLE_HEIGHT		(V4L2_CID_MODE_CLASS_BASE+4)
>
> The interface here pre-dates the selection API. The frame width and height
> is today conveyed to the bridge driver by the smiapp driver in the scaler
> (or binner in case of the lack of the scaler) sub-device's source pad
> format.
>
> (While that's the current interface, I'm not entirely happy with it; it
> requires more sub-devices to be created for the same I2C device). I think in
> this case you'd need one more to properly control the sensor.
>

By looking at the code, it seems those are read-only, so I don't think 
it make sense to add a binner sub-device with read-only controls.

>> +#define V4L2_CID_MODE_PIXELCLOCK		(V4L2_CID_MODE_CLASS_BASE+5)
>> +#define V4L2_CID_MODE_SENSITIVITY		(V4L2_CID_MODE_CLASS_BASE+6)
>> +#define V4L2_CID_MODE_OPSYSCLOCK		(V4L2_CID_MODE_CLASS_BASE+7)
>
> While I don't remember quite what the sensitivity value was about (it could
> be e.g. binning summing / averaging), the other two values are passed to
> (and also controlled by) the user space using controls. There are
> V4L2_CID_PIXEL_RATE and V4L2_CID_LINK_FREQ or such.
>

I've already made a change so V4L2_CID_PIXEL_RATE is used in et8ek8 
driver 
(https://github.com/freemangordon/linux-n900/commit/54433e50451b4ed6cc6e3b25d149c5cacd97e438), 
but V4L2_CID_MODE_PIXELCLOCK is used in smiapp driver, which seems to 
expose its own controls. Not sure those are needed though. And if, what 
for. I hope you know better than me.

I guess V4L2_CID_MODE_OPSYSCLOCK can be easily transformed to 
V4L2_CID_LINK_FREQ in the same way as V4L2_CID_MODE_PIXELCLOCK.

>> +
>> +/* Control IDs specific to the AD5820 driver as defined by V4L2 */
>> +#define V4L2_CID_FOCUS_AD5820_BASE 		(V4L2_CTRL_CLASS_CAMERA | 0x10af)
>> +#define V4L2_CID_FOCUS_AD5820_RAMP_TIME		(V4L2_CID_FOCUS_AD5820_BASE+0)
>> +#define V4L2_CID_FOCUS_AD5820_RAMP_MODE		(V4L2_CID_FOCUS_AD5820_BASE+1)
>
> The ad5820 driver isn't in upstream at the moment. It should be investigated
> whether there is a possibility to have standard V4L2 controls for lens
> devices, or whether device specific controls should be implemented instead.
> Device specific controls are a safe choice in this case, but they should be
> in a separate patch, possibly one that would also include the lens driver
> itself.
>

Yeah, I sent the whole patch for the sake of not losing the history too 
much.

Thanks,
Ivo
