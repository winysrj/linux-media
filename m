Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33676 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933536AbcIWAXf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 20:23:35 -0400
Subject: Re: g_webcam Isoch high bandwidth transfer
To: Bin Liu <b-liu@ti.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org
References: <20160920170441.GA10705@uda0271908>
 <871t0d4r72.fsf@linux.intel.com> <20160921132702.GA18578@uda0271908>
 <87oa3go065.fsf@linux.intel.com> <87lgyknyp7.fsf@linux.intel.com>
 <87d1jw6yfd.fsf@linux.intel.com> <20160922133327.GA31827@uda0271908>
 <87a8ezn2av.fsf@linux.intel.com> <20160922201131.GD31827@uda0271908>
From: yfw <nh26223@gmail.com>
Message-ID: <05d5b2dd-0c1b-e7bd-afc5-313b5a5ab268@gmail.com>
Date: Fri, 23 Sep 2016 08:23:25 +0800
MIME-Version: 1.0
In-Reply-To: <20160922201131.GD31827@uda0271908>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bin,

On 2016/9/23 4:11, Bin Liu wrote:
> +Fengwei Yin per his request.
Thanks a lot for adding me to this thread.

>
> On Thu, Sep 22, 2016 at 10:48:40PM +0300, Felipe Balbi wrote:
>>
>> Hi,
>>
>> Bin Liu <b-liu@ti.com> writes:
>>
>> [...]
>>
>>>> Here's one that actually compiles, sorry about that.
>>>
>>> No worries, I was sleeping ;-)
>>>
>>> I will test it out early next week. Thanks.
>>
>> meanwhile, how about some instructions on how to test this out myself?
>> How are you using g_webcam and what are you running on host side? Got a
>> nice list of commands there I can use? I think I can get to bottom of
>> this much quicker if I can reproduce it locally ;-)
I am using similar use case with a different gadget function driver.
>
> On device side:
> - first patch g_webcam as in my first email in this thread to enable
>   640x480@30fps;
> - # modprobe g_webcam streaming_maxpacket=3072
> - then run uvc-gadget to feed the YUV frames;
> 	http://git.ideasonboard.org/uvc-gadget.git
- I am using uvc function driver  + configfs.
- maxpacket in configfs was set to 3072.
- uvc-gadget from the same source as Bin.
>
> On host side:
> - first check the device ep descriptor, which should be
> 	wMaxPacketSize     0x1400  3x 1024 bytes
> - then use luvcview or yavta to capture the video stream
- lsusb give me same wMaxPacketSize.
- I am using example (changed a little bit) from libuvc.

Regards
Yin, Fengwei

>
> Capture the bus trace to check if multiple IN transactions happens in
> each SOF.
>
> The data buffer size in the usb_request coming from the uvc driver is
> 5120 bytes, so there should be 3 IN transactions if the UDC works
> correctly.
>
> Regards,
> -Bin.
>
