Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZJZOAu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 10:00:50 -0400
Message-ID: <4AE5ACF1.3080606@redhat.com>
Date: Mon, 26 Oct 2009 15:06:41 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Alexey Fisher <bug-track@fisher-privat.net>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Linux-uvc-devel] again "Logitech QuickCam Pro for Notebooks
 046d:0991"
References: <1255514751.15164.17.camel@zwerg>	 <59cf47a80910140837m664e7a37pdebad2e8ceacfef9@mail.gmail.com>	 <1255633259.8813.10.camel@mini>	 <200910220155.25481.laurent.pinchart@ideasonboard.com>	 <1256197227.3257.23.camel@zwerg>  <4AE441C7.9070209@redhat.com>	 <1256475770.3652.18.camel@mini>  <4AE450F5.90000@redhat.com> <1256557968.12179.5.camel@zwerg>
In-Reply-To: <1256557968.12179.5.camel@zwerg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/26/2009 12:52 PM, Alexey Fisher wrote:
> Am Sonntag, den 25.10.2009, 14:21 +0100 schrieb Hans de Goede:
>> Hi,
>>
>> On 10/25/2009 02:02 PM, Alexey Fisher wrote:
>>> Am Sonntag, den 25.10.2009, 13:17 +0100 schrieb Hans de Goede:
>>>> Hi,
>>>>
>>>> On 10/22/2009 09:40 AM, Alexey Fisher wrote:
>>>>> Hi Laurent,
>>>>> thank you for the answer, i thought - no body care. :)
>>>>>
>>>>> Am Donnerstag, den 22.10.2009, 01:55 +0200 schrieb Laurent Pinchart:
>>>>>> Hi Alexey,
>>>>>>
>>>>>> On Thursday 15 October 2009 21:00:59 Alexey Fisher wrote:
>>>>>>> I did some simple dirty hack, it prevent webcam from being killed by cheese.
>>>>>>> On other site it make cheese work too.
>>>>>>> Like Paulo said,  the camera is slow and it need more time to make thirst
>>>>>>> start, some time it need 8 seconds on second start it need about 2 seconds.
>>>>>>> If we call STREAMOFF before we get EOF, the camera will die.
>>>>>>
>>>>>> Which EOF are you talking about here ? The UVC bit in the video packets header
>>>>>> ? How have you tested that ?
>>>>>
>>>>> I used "uvcvideo trace=255" and cheese.
>>>>> I talking about "uvc_v4l2_ioctl(VIDIOC_STREAMON)", "Frame complete (EOF
>>>>> found)" and "uvc_v4l2_ioctl(VIDIOC_STREAMOFF)".
>>>>>
>>>>>>> IMHO, the driver should decide if camera ready or not. The easiest way
>>>>>>> is, to add SLOWSTART quirk. Correct way probobly will be to check if camera
>>>>>>> ready or not.
>>>>>>> Any ideas how to make it? Or any other ideas?
>>>>>>>
>>>>>>> I know, cheese use some bruteforce way to get settings, but the bug in
>>>>>>> cheese make the bug in uvcvideo easy to reproduce.
>>>>>>
>>>>>> It's not a bug in uvcvideo but a bug in the camera. Have you been to isolate
>>>>>> exactly which sequence of ioctls issued by Cheese make the camera crash ? I'd
>>>>>> like more information about that.
>>>>>
>>>>> I made dmesg of two situations, webcam work and don't work.
>>>>> cheese celling two times "uvc_v4l2_ioctl(VIDIOC_STREAMON)", thirst one
>>>>> to get the settings and second time to start the record. Between thirst
>>>>> and second pass the time out seems to be too short (even it is 10
>>>>> seconds).
>>>>>
>>>>
>>>> This is not an issue with the camera, nor with the driver, but an issue with
>>>> cheese. In order to not wait for ever when probing devices which for some
>>>> reason won't stream, cheese wait a maximum of 3 seconds before the stream to
>>>> start, so if the camera is this slow to start, then cheese will most likely
>>>> have given up before the cam has started.
>>>
>>> <sarcastic>   Really good and helpful response</sarcastic>
>>>
>>> so what, let say you have a network adapter driver for it and firefox...
>>> firefox asked for dns three time and these accidently erased eeprom of
>>> network adapter. So the developer of driver for this network adapter
>>> will claim the firefox is bad and not driver which enabled write access
>>> to eeprom.
>>> This example is a bit surrealistic (except e1000e), but this is exact
>>> point to your answer.
>>> I ready seid, this is not about cheese, empathy has same issue. So what?
>>> let us make in every application timeout for 20 seconds? How will you
>>> fix in on user space?
>>> If it will be like - cheese do not work but camera will work after it, i
>>> didn't had any problem, but in this case cheese kill the webcam and
>>> driver made it possible.
>>>
>>> This bug is more then one year old, and users who reported it are kicked
>>> all the time between developers with words: "my app is clean" or "this
>>> is not about the driver". If you can't communicate with each other, what
>>> is about us, users? Who can solve this problem?
>>>
>>
>> Sorry,
>>
>> I was trying to be helpful here, and your input as user is appreciated.
>>
>> fwiw I'm a v4l kernel developer, but I'm not involved in the UVC driver,
>> I'm however a contributor to cheese, I thought that my input that cheese
>> would give up even if the driver has a long enough timeout would be helpful.
>>
>> To try and see if this (the cheese timeout is the issue), you will need
>> to re-compile cheese from source, after unpacking cheese, edit
>> src/cheese-webcam.c and goto line 716 (in 2.28.0)
>>
>> And change the "10 * GST_SECOND" there in something bigger. I also see that
>> I'm mistaken and the timeout in cheese is not 3 but 10 seconds, it might
>> have changed recently, or my memory has been playing tricks on me.
>>
>> I still believe this might be the cause, the trace you have posted seems
>> consistent with cheese's behaviour. Also noticed that there never is a
>> successfull DQBUF the first time cheese opens the device. If cheese
>> (or rather gstreamer) does not manage to DQBUF the first time, then cheese
>> will not work with the device. There is a limitation in gstreamer
>> (or maybe in the way cheese uses it) where gstreamer needs to be streaming
>> before cheese can tell the properties of the cam. If the stream does not
>> start within the first 10 seconds, then cheese will fail to get the properties.
>>
>> If you go to cheese's edit ->  preferences menu, and your cam has no resolutions
>> listed there (the resolution drop down is grayed out). This is what is happening.
>>
>> As for empathy, I'm not familiar with that. But if we can get cheese to work
>> first I'm sure that that would be a good step in the right direction.
>>
>> Regards,
>
> Hallo Hans,
> thank you for your constructive response,
> I increased timeout to 15 seconds i now i can't reproduce camera freeze,
> i'll play with it more to be sure. There is still one issue with it - on
> cold start the image is zoomed in.
> I need to close cheese and open it again to get normal zoom. The
> resolution seems to be the same.
>

That definitely sounds like a camera bug, but maybe we can do something
on the driver side (like forcing a resolution change even if not necessary)
to work around this. Laurent ?

Note re-adding the mailing list and Laurent to the CC, they somehow got
dropped.

Regards,

Hans
