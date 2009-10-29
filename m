Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZJ2KwZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 06:52:25 -0400
Message-ID: <4AE97550.2020100@redhat.com>
Date: Thu, 29 Oct 2009 11:58:24 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Alexey Fisher <bug-track@fisher-privat.net>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Linux-uvc-devel] again "Logitech QuickCam Pro for Notebooks
 046d:0991"
References: <1255514751.15164.17.camel@zwerg>	 <200910281352.14940.laurent.pinchart@ideasonboard.com>	 <1256736993.2575.5.camel@mini>	 <200910281440.48791.laurent.pinchart@ideasonboard.com> <1256737867.2575.6.camel@mini>
In-Reply-To: <1256737867.2575.6.camel@mini>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/28/2009 02:51 PM, Alexey Fisher wrote:
> Am Mittwoch, den 28.10.2009, 14:40 +0100 schrieb Laurent Pinchart:
>> On Wednesday 28 October 2009 14:36:33 Alexey Fisher wrote:
>>> Hi Laurent,
>>>
>>> Am Mittwoch, den 28.10.2009, 13:52 +0100 schrieb Laurent Pinchart:
>>>> Hi Alexey,
>>>>
>>>> On Wednesday 28 October 2009 10:58:24 Alexey Fisher wrote:
>>>>> Am Mittwoch, den 28.10.2009, 00:27 +0100 schrieb Laurent Pinchart:
>>>>>> On Monday 26 October 2009 15:06:41 Hans de Goede wrote:
>>>>>>> On 10/26/2009 12:52 PM, Alexey Fisher wrote:
>>>>>>>> Am Sonntag, den 25.10.2009, 14:21 +0100 schrieb Hans de Goede:
>>>>>>
>>>>>> [snip]
>>>>>>
>>>>>>>>> fwiw I'm a v4l kernel developer, but I'm not involved in the
>>>>>>>>> UVC driver, I'm however a contributor to cheese, I thought that
>>>>>>>>> my input that cheese would give up even if the driver has a
>>>>>>>>> long enough timeout would be helpful.
>>>>>>>>>
>>>>>>>>> To try and see if this (the cheese timeout is the issue), you
>>>>>>>>> will need to re-compile cheese from source, after unpacking
>>>>>>>>> cheese, edit src/cheese-webcam.c and goto line 716 (in 2.28.0)
>>>>>>>>>
>>>>>>>>> And change the "10 * GST_SECOND" there in something bigger. I
>>>>>>>>> also see that I'm mistaken and the timeout in cheese is not 3
>>>>>>>>> but 10 seconds, it might have changed recently, or my memory
>>>>>>>>> has been playing tricks on me.
>>>>>>>>>
>>>>>>>>> I still believe this might be the cause, the trace you have
>>>>>>>>> posted seems consistent with cheese's behaviour. Also noticed
>>>>>>>>> that there never is a successfull DQBUF the first time cheese
>>>>>>>>> opens the device. If cheese (or rather gstreamer) does not
>>>>>>>>> manage to DQBUF the first time, then cheese will not work with
>>>>>>>>> the device. There is a limitation in gstreamer (or maybe in the
>>>>>>>>> way cheese uses it) where gstreamer needs to be streaming
>>>>>>>>> before cheese can tell the properties of the cam. If the stream
>>>>>>>>> does not start within the first 10 seconds, then cheese will
>>>>>>>>> fail to get the properties.
>>>>>>>>>
>>>>>>>>> If you go to cheese's edit ->   preferences menu, and your cam
>>>>>>>>> has no resolutions listed there (the resolution drop down is
>>>>>>>>> grayed out). This is what is happening.
>>>>>>>>>
>>>>>>>>> As for empathy, I'm not familiar with that. But if we can get
>>>>>>>>> cheese to work first I'm sure that that would be a good step in
>>>>>>>>> the right direction.
>>>>>>>>
>>>>>>>> Hallo Hans,
>>>>>>>> thank you for your constructive response,
>>>>>>>> I increased timeout to 15 seconds i now i can't reproduce camera
>>>>>>>> freeze, i'll play with it more to be sure. There is still one
>>>>>>>> issue with it - on cold start the image is zoomed in.
>>>>>>>> I need to close cheese and open it again to get normal zoom. The
>>>>>>>> resolution seems to be the same.
>>>>>>
>>>>>> Zoomed in ? Really ? As far as I know the QuickCam Pro for Notebooks
>>>>>> has no optical or digital zoom. Could you please send me lsusb's
>>>>>> output for your device ?
>>>>>
>>>>> Yes. I can use digital zoom under M$Win with Logitech software.
>>>>
>>>> That's probably implemented in software in the Windows driver.
>>>>
>>>> [snip]
>>>> The zoom control, if present, should have appeared here.
>>>>
>>>> As your camera doesn't expose any zoom control I really don't know where
>>>> the zoom comes from.
>>>
>>> i don't really care about zoom problem. This not making this webcam
>>> freeze so probably nobody will find this issue. You can sleep well :)
>>>
>>> if you have some ideas about camera freeze, please let me know.
>>
>> You have been able to work around the freeze by raising cheese's timeout to 15
>> seconds, right ?
>
> yes
>

Talking about this, can you please file a bug against upstream cheese to
change the timeout to be 15 seconds ?

Regards,

Hans
