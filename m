Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:37426 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbcFFQsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 12:48:11 -0400
Subject: Re: i.mx6 camera interface (CSI) and mainline kernel
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Tim Harvey <tharvey@gateworks.com>
References: <20160223114943.GA10944@frolo.macqel>
 <20160223141258.GA5097@frolo.macqel> <4956050.OLrYA1VK2G@avalon>
 <56D79B49.50009@mentor.com> <56D7E59B.6050605@xs4all.nl>
 <20160303083643.GA4303@frolo.macqel> <56D87824.8000707@mentor.com>
 <CAJ+vNU2kPgESnjTZokU3qNR6QAbU3G8HGwc7ahg4jDpeS_xjHg@mail.gmail.com>
 <56DF852A.30702@mentor.com>
 <CAJ+vNU0cWUZNcP=suP0rnhG-EqVov5ODk0fKpd4rqf9Setw7Gw@mail.gmail.com>
 <56E0BBE5.4060104@mentor.com>
 <CAJ+vNU2U3TRXzDJsau22qghUmwx2WQkOp8NVzZ=PxrhxV0yozg@mail.gmail.com>
 <57503AEE.1040907@xs4all.nl> <575063DA.9040001@mentor.com>
CC: Philippe De Muyter <phdm@macq.eu>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <5755A945.5080302@mentor.com>
Date: Mon, 6 Jun 2016 09:48:05 -0700
MIME-Version: 1.0
In-Reply-To: <575063DA.9040001@mentor.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/02/2016 09:50 AM, Steve Longerbeam wrote:
> On 06/02/2016 06:55 AM, Hans Verkuil wrote:
>> On 06/02/2016 03:29 PM, Tim Harvey wrote:
>>> On Wed, Mar 9, 2016 at 4:12 PM, Steve Longerbeam
>>> <steve_longerbeam@mentor.com> wrote:
>>>> On 03/09/2016 02:44 PM, Tim Harvey wrote:
>>>>> On Tue, Mar 8, 2016 at 6:06 PM, Steve Longerbeam
>>>>> <steve_longerbeam@mentor.com> wrote:
>>>>>> On 03/07/2016 08:19 AM, Tim Harvey wrote:
>>>>> <snip>
>>>>>> Hi Tim, good to hear it works for you on the Ventana boards.
>>>>>>
>>>>>> I've just pushed some more commits to the mx6-media-staging branch that
>>>>>> get the drivers/media/i2c/adv7180.c subdev working with the imx6 capture
>>>>>> backend. Images look perfect when switching to UYVY8_2X8 mbus code instead
>>>>>> of YUYV8_2X8. But I'm holding off on that change because this subdev is used
>>>>>> by Renesas targets and would likely corrupt captured images for those
>>>>>> targets. But I believe UYVY is the correct transmit order according to the
>>>>>> BT.656 standard.
>>>>>>
>>>>>> Another thing that should also be changed in drivers/media/i2c/adv7180.c
>>>>>> is the field type. It should be V4L2_FIELD_SEQ_TB for NTSC and V4L2_FIELD_SEQ_BT
>>>>>> for PAL.
>>>>>>
>>>>>> Steve
>>>>>>
>>>>>>
>>>>> Steve,
>>>>>
>>>>> with your latest patches, I'm crashing with an null-pointer-deref in
>>>>> adv7180_set_pad_format. What is your kernel config for
>>>>> CONFIG_MEDIA_CONTROLLER and CONFIG_VIDEO_V4L2_SUBDEV_API?
>>>> Right, I thought I fixed that, I was passing a NULL pad_cfg for
>>>> TRY_FORMAT, but that was fixed. Maybe you fetched a version
>>>> of mx6-media-staging while I was in the middle of debugging?
>>>> Try fetching again.
>>>>
>>>> I tried with both CONFIG_MEDIA_CONTROLLER and
>>>> CONFIG_VIDEO_V4L2_SUBDEV_API enabled and both disabled, and
>>>> I don't get the null deref in adv7180_set_pad_format.
>>>>
>>>>
>>>>> Your tree contains about 16 or so patches on top of linux-media for
>>>>> imx6 capture. Are you close to the point where you will be posting a
>>>>> patch series? If so, please CC me for testing with the adv7180 sensor.
>>>> I guess I can try posting a series again, but there will likely be push-back from
>>>> Pengutronix. They have their own video capture driver for imx6. Last I heard (a while ago!)
>>>> their version did not implement scaling, colorspace conversion, or image rotation via
>>>> the IC. Instead their driver sends raw camera frames directly to memory, and image
>>>> conversion is carried out by separate mem2mem device. Our capture driver does
>>>> image conversion (scaling, CSC, and rotation) natively using the IC pre-processing channel.
>>>> We also have a mem2mem device that does conversion using IC post-processing,
>>>> which I have included in mx6-media-staging.
>>>>
>>>> Also IIRC they did some pretty slick stuff with a video bus multiplexer subdev, which
>>>> can multiplex video from different sensors either using the internal mux in the SoC,
>>>> or can control an external mux via gpio. Our driver only supports the internal mux,
>>>> and does it with a platform data function.
>>>>
>>>> But like I said, I don't what the latest status is of the Pengutronix video capture support.
>>>>
>>>> Btw, I just pushed an update of mx6-media-staging that implements vidioc_[gs]_selection.
>>>>
>>>> Steve
>>>>
>>>>
>>> Steve,
>>>
>>> Some time has passed without any IMX6 CSI drivers or response from
>>> Pengutronix and Hans has agreed to add either/both drivers to staging.
>>> Do you have time to rebase and re-post your driver(s)? Maybe that will
>>> get the ball rolling on this final huge missing feature for the IMX6
>>> in mainline.
>> Right. All that is needed is for someone to take the latest version, make it compile
>> in the media_tree in drivers/media/staging and post the patch (just take care to keep
>> the correct copyrights, Signed-off-by's etc.) and I'll be happy to take it. This is
>> exactly what staging is for. I think it will greatly increases the chances of this
>> code being improved for mainline. And I'm happy to take both drivers as well, again,
>> that's what staging is for.
>>
>> I've been thinking of doing this myself, but I just don't have the time.
>>
>> Ideally this is done by the authors, but if they don't have time either then someone
>> else can do this.
>>
> Hi Hans and Tim,
>
> No problem, I will repost the patch-set this week. I've been meaning to,
> just busy lately with other tasks.

Hi all, I need a few more days. I would like to bring in the video-switch
subdev from Pengutronix, which will replace the platform data set_video_mux
method. Also re-org the device-tree to better define all the possible 
hardware
connections, and split out mx6-encode.c into mx6-smfc and mx6-ic subdevs.
Once this is done we should have a better base for adding media control
later. I should have this done by end of this week.

Steve


