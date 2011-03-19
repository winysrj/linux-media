Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64643 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab1CST2s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2011 15:28:48 -0400
Received: by wya21 with SMTP id 21so4758294wya.19
        for <linux-media@vger.kernel.org>; Sat, 19 Mar 2011 12:28:47 -0700 (PDT)
Message-ID: <4D8503EC.6040103@gmail.com>
Date: Sat, 19 Mar 2011 20:28:44 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Kim HeungJun <riverful@gmail.com>
CC: "Kim, Heungjun" <riverful.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add support for M-5MOLS 8 Mega Pixel camera
References: <1300282723-31536-1-git-send-email-riverful.kim@samsung.com> <4D84B183.7020709@gmail.com> <3985908C-2E67-4274-AA8F-E5F70745DED7@gmail.com>
In-Reply-To: <3985908C-2E67-4274-AA8F-E5F70745DED7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/19/2011 04:11 PM, Kim HeungJun wrote:
> Hi Sylwester,
> 
> Thanks for the reviews. :)
> 
> 2011. 3. 19., 오후 10:37, Sylwester Nawrocki 작성:
> 
>> Hi HeungJun,
>>
>> On 03/16/2011 02:38 PM, Kim, Heungjun wrote:
>>> Add I2C/V4L2 subdev driver for M-5MOLS camera sensor with integrated
>>> image signal processor.
>>>
>>> Signed-off-by: Heungjun Kim<riverful.kim@samsung.com>
>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>> ---
>>>
>>> Hi Hans and everyone,
>>>
>>> This is sixth version of M-5MOLS 8 Mega Pixel camera sensor. And, if you see
>>
>> Would be good to indicate the version in the subject too.
>>
>>> previous version, you can find at:
>>> http://www.spinics.net/lists/linux-media/msg29350.html
>>>
>>> This driver patch is fixed several times, and the important issues is almost
>>> corrected. And, I hope that this is the last version one merged for 2.6.39.
>>> I look forward to be reviewed one more time.
>>>
>>> The summary of this version's feature is belows:
>>>
>>> 1. Add focus control
>>> 	: I've suggest menu type focus control, but I agreed this version is
>>> 	not yet the level accepted. So, I did not use focus control which
>>> 	I suggest.
>>> 	The M-5MOLS focus routine takes some time to execute. But, the user
>>> 	application calling v4l2 control, should not hanged while streaming
>>> 	using q/dqbuf. So, I use workqueue. I want to discuss the focus
>>> 	subject on mailnglist next time.
>>>
>>> 2. Add irq routine
>>> 	: M-5MOLS can issues using GPIO pin, and I insert the basic routine
>>> 	of irq. This version handles only the Auto focus interrupt source.
>>> 	It shows only lens focusing status, don't any action now.
>>>
>>> 3. Speed-up whole I2C operation
>>> 	: I've tested several times for decreasing the stabilization time
>>> 	while I2C communication, and I have find proper time. Of course,
>>> 	it's more faster than previous version.
>>
>> That sounds good. Do you think the delays before I2C read/write could
>> be avoided in some (if not all) cases by using some status registers
>> polling?
> I don't understand literally. Could you explain more detailed with some examples?
> My understanding is that it might be an issues or problem when getting some
> status registers with polling it. is it right?

My concern is that we might not need an extra delay between consecutive 
read or write operations in every case. Possibly it would be enough
to read the status of some operations instead. But that just what I suspect.

> 
>>
>>>
>>> 4. Let streamon() be called once at the streamming
>>> 	: It might be an issue, videobuf2 framework calls streamon when
>>> 	qbuf() for enqueueing. It means, the driver's streamon() function
>>
>> No, that's not really the case. At last videobuf2 buf_queue op might be
>> called in response to VIDIOC_STREAMON. Certainly there must be some bug
>> in the host driver if subdev's s_stream is being called repeatedly.
>
> Ah, it's good news. I seemed to use some little old version of vb2.
> Then, I would try to merge new vb2 on our branch, and I need some help on that.
> I'll contact you. After that, I test new vb2 merged on our branch and chech if there
> is not any issues, I'll correct to use just enable variable not using is_streaming(),
> and also correct comments.

Sorry, I confused you. Instead of "at last" I should have used "at most".
I think it's the host driver, not vb2 issue. I'll take care of that.
It doesn't bother to do an additional checking though, but your comments
should be slightly changed.

> 
> Actually, that has happened low frame rate issues on M-5MOLS, I had have headache
> cause of this some weeks, and it's the suspects. :D
> It's my fault not to use newer version.
> So, letting me know this new version is very happy for me.
> 
>>
>>> 	might be callled continuously if there is no proper handling in the
>>> 	subdev driver, and low the framerate by adding unneeded I2C operation.
>>> 	The M-5MOLS sensor needs command one time for streaming. If commands
>>> 	once, this sensor streams continuously, and this version handles it.
>>>
>>> 5. Update FW
>>> 	: It's a little tricky. Originally, the v4l2 frame provide load_fw(),
>>> 	but, there is the occasion which should do in openning the videonode,
>>> 	and it's the same occasion with us. So, if it's not wrong or it makes
>>> 	any problem, we hope to insert m5mols_update_fw() with weak attribute.
>>> 	And, I'm sorry that the fw updating code is confidential. unserstand
>>> 	by favor, plz.
>>>
>>> And, as always, this driver is tested on s5pc210 board using s5p-fimc driver.
>>>
>>> I'll wait for reviewing.
>>>
>>> Thanks and Regards,
>>> 	Heungjun Kim
>>> 	Samsung Electronics DMC R&D Center
>>>
>>>   drivers/media/video/Kconfig                  |    2 +
>>>   drivers/media/video/Makefile                 |    1 +
>>>   drivers/media/video/m5mols/Kconfig           |    5 +
>>>   drivers/media/video/m5mols/Makefile          |    3 +
>>>   drivers/media/video/m5mols/m5mols.h          |  251 ++++++
>>>   drivers/media/video/m5mols/m5mols_controls.c |  213 +++++
>>>   drivers/media/video/m5mols/m5mols_core.c     | 1062 ++++++++++++++++++++++++++
>>>   drivers/media/video/m5mols/m5mols_reg.h      |  218 ++++++
>>>   include/media/m5mols.h                       |   35 +
>>>   9 files changed, 1790 insertions(+), 0 deletions(-)
>>>   create mode 100644 drivers/media/video/m5mols/Kconfig
>>>   create mode 100644 drivers/media/video/m5mols/Makefile
>>>   create mode 100644 drivers/media/video/m5mols/m5mols.h
>>>   create mode 100644 drivers/media/video/m5mols/m5mols_controls.c
>>>   create mode 100644 drivers/media/video/m5mols/m5mols_core.c
>>>   create mode 100644 drivers/media/video/m5mols/m5mols_reg.h
>>>   create mode 100644 include/media/m5mols.h
>>>
>> ...
>>
>>> +/*
>>> + * m5mols_sensor_armboot() - booting M-5MOLS internal ARM core-controller.
>>> + *
>>> + * It makes to ready M-5MOLS for I2C&   MIPI interface. After it's powered up,
>>> + * it activates if it gets armboot command for I2C interface. After getting
>>> + * cmd, it must wait about least 520ms referenced by M-5MOLS datasheet.
>>> + */
>>> +static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
>>> +{
>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>> +	u32 reg;
>>> +	int ret;
>>> +
>>> +	/* ARM(M-5MOLS core) booting */
>>> +	ret = i2c_w8_flash(sd, CATF_CAM_START, true);
>>> +	if (ret<   0)
>>> +		return ret;
>>> +
>>> +	msleep(520);
>>
>> Don't you consider using a waitqueue and a relevant interrupt
>> generated by the ISP when it has completed booting?
>> This would allow to decrease the delay to an optimal minimum.
> I didn't yet consider it. But, it looks good option. I would try this at the next version. :)

Thanks.

> 
> And, but it seems relevant or not, how to think about changing to probe all sensors
> when video node (exactly fimc) being opened by user application?

Currently only the first sensor from the list, passed as platform data,
is initialized when the video device is opened, to make sure the capture
device is usable.

> I means, as you know, the most sensors has booting delay time, including even
> noonxxxxxxx&  srxxxxxx sensor series. But, we can choose the calling to probe sensor
> be made of workqueue() in the fimc. If doing as this, it can be possible not to wait
> probing previous sensor. So, What about your opinion?

Yeah, sounds like a good idea. Possibly that could save us some 100...200ms
in cases when the applications do not want to use the first sensor.
I'll consider that when converting FIMC to the media device.

--
Regards,
Sylwester


