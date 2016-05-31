Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43463 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbcEaU4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 16:56:23 -0400
Subject: Re: multi-sensor media controller
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <21de7cb7-69b1-94bd-584a-e5494bfb7dc8@codeaurora.org>
 <Pine.LNX.4.64.1605291626360.24272@axis700.grange>
Cc: linux-media@vger.kernel.org
From: Jeremy Gebben <jgebben@codeaurora.org>
Message-ID: <02af9738-54b6-e615-c707-1dd2ddcb0f5c@codeaurora.org>
Date: Tue, 31 May 2016 14:56:25 -0600
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1605291626360.24272@axis700.grange>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,


On 5/29/16 8:43 AM, Guennadi Liakhovetski wrote:
> Hi Jeremy,
>
> On Fri, 27 May 2016, Jeremy Gebben wrote:
>
>> Hi,
>>
>> Can someone give me a quick sanity check on a media controller set up?
>>
>> We have have devices (well, phones) that can have 2 or more sensors and 2 or
>> more 'front end' ISPs.  The ISPs take CSI input from a sensor, and can produce
>> Bayer and YUV output to memory. There is a bridge between the sensors and ISPs
>> which allow any ISP to receive input from any sensor. We would (eventually)
>> like to use the request API to ensure that sensor and ISP settings match for
>> every frame.
>>
>> We use this hardware in several different ways, some of the interesting ones
>> are described below:
>>
>> 1. 2 sensors running independently, and possibly at different frame rates. For
>> example in video chat you might want a "Picture in Picture" setup where you
>> send output from both a front and back sensor.
>> (note: 'B' is the bridge)
>>
>> SENSOR_A --> B --> ISP_X --> BUFFERS
>>              B
>> SENSOR_B --> B --> ISP_Y --> BUFFERS
>>
>> 2. Single sensor, dual ISP. High resolution use of a single sensor may
>> require both ISPs to work on different regions of the image. For example,
>> ISP_X might process the left half of the image while ISP_Y processes the
>> right.
>>
>> SENSOR_A --> B --> ISP_X ----> BUFFERS
>>              B --> ISP_Y --/
>>              B
>>
>> 3. 2 different types of sensors working together to produce a single set of
>> images. Processing must be synchronized, and eventually the buffers from
>> SENSOR_A and SENSOR_C will be combined by other processing not shown here.
>>
>> SENSOR_A --> B --> ISP_X --> BUFFERS
>> SENSOR_C --> B --> ISP_Y --> BUFFERS
>>              B
>>
>> It seems to me that the way to do handle all these cases would be to put all
>> of the hardware in a single media_device:
>>
>>  +----------------------+
>>  |  SENSOR_A  B  ISP_X  |
>>  |  SENSOR_C  B         |
>>  |  SENSOR_B  B  ISP_Y  |
>>  +----------------------+
>>
>> This makes cases #2 and #3 above easy to configure.
>
> Yes, agree.
>
>> But the topology can get
>> rather large if the number of sensors and ISPs goes up.
>
> We've seen some rather large topology graphs already :)
>
>> Also, case #1 could be
>> a little strange because there would be 2 independent sets of requests coming
>> to the same media_device at the same time.
>
> Do you mean, because request API calls are made to the /dev/media0 device?
> I don't remember the details, is this how the API is supposed to be used?
> Isn't there a way to direct the calls to specific /dev/video* devices or
> to subdevices?

See: https://meet.quicinc.com/hosseins/34WMDH75

You allocate a request id using MEDIA_REQ_CMD_ALLOC on a /dev/media* 
device. Then you call /dev/video* ioctls to change settings, passing the 
request id as an argument. Then you call MEDIA_REQ_CMD_QUEUE which 
applies all the settings.

My concern is that having 2 independent camera pipelines using request 
ids from the same /dev/media could cause problems somehow. But I cannot 
quantify "somehow" so I guess I'll look into the patches further to work 
it out.


>> Am I on the right track here?
>>
>> I did find Guennadi's presentation about multi-stream:
>> https://linuxtv.org/downloads/presentations/media_summit_2016_san_diego/v4l2-multistream.pdf
>>
>> ...but I'm not sure I follow all of it from the slides alone, and
>> we don't have the mux/demux hardware that was the focus of his presentation.
>
> Doesn't your bridge also perform the mux-demux role in some
> configurations?

Hmm, yeah, maybe I oversimplified. I probably need to dig in to the 
hardware docs further.


> But that isn't the main point anyway. As a part of a
> solution for the multi-stream set up, the use of stream routing has been
> proposed. So, using that, you might be able to represent your bridge as a
> stream router. Details of a routing API are still to be clarified.

I'll watch for further traffic on the routing API.

Thank you for the feedback.

Jeremy



>
> Thanks
> Guennadi
>
>> Thanks,
>>
>> Jeremy
>>
>> --
>>  The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>>  a Linux Foundation Collaborative Project
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


-- 
  The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
  a Linux Foundation Collaborative Project
