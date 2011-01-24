Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p0OD1jhG012693
	for <video4linux-list@redhat.com>; Mon, 24 Jan 2011 08:01:45 -0500
Received: from mail-ww0-f46.google.com (mail-ww0-f46.google.com [74.125.82.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OD1a8v010872
	for <video4linux-list@redhat.com>; Mon, 24 Jan 2011 08:01:36 -0500
Received: by wwj40 with SMTP id 40so4778782wwj.27
	for <video4linux-list@redhat.com>; Mon, 24 Jan 2011 05:01:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110124132310.116472tnxlp48n5a@webmail.hebergement.com>
References: <AANLkTi=SMpfBj6bjKMzfHC--Rhpeb5MzF3g9KFUUSef7@mail.gmail.com>
	<20110124115107.20972qivh7d7l28r@webmail.hebergement.com>
	<AANLkTik4t_zZe8Uz=1LvcdHLnKx7jOirCm7+BhT0zU60@mail.gmail.com>
	<20110124124946.97531j0p9ou68nkq@webmail.hebergement.com>
	<AANLkTikuc9v6HTa3-691iW6XsNWCGtDT2ACYVH0pH4rz@mail.gmail.com>
	<20110124132310.116472tnxlp48n5a@webmail.hebergement.com>
From: chetan patil <chtpatil@gmail.com>
Date: Mon, 24 Jan 2011 18:31:12 +0530
Message-ID: <AANLkTikh65TobYLyY4Nkm3Tfep2uA362JNBOWM+HY8wP@mail.gmail.com>
Subject: Re: v4l2
To: fpantaleao@mobisensesystems.com, video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

And

For FBDev driver. The memory is allocated from??

Is it that the memory is taken from ram or rom and
buffered till the image is being displayed???

Like in my laptop is i press volume button then one
On Screen Display comes, is it due to FBDev driver??

Thanks.

On Mon, Jan 24, 2011 at 5:53 PM, <fpantaleao@mobisensesystems.com> wrote:

> Right.
>
>
> chetan patil <chtpatil@gmail.com> a =E9crit :
>
>  So suppose if i want to access v4l2, then at that time i
>> must have an application to do so??
>>
>> Like if i start my webcam aap in Linux.
>> Then
>>  First: Application starts
>>    Second: v4l2 is called
>>      Third: v4l2 interacts with capturing device from /dev/video0
>>        Fourth: Gives it back to application.
>>          Fifth: Image is displayed?
>>
>> In case of frame buffer.
>> The image to be displayed (graphics) will be done with
>> FBDev Driver ???
>>
>> So V4l2 becomes capture driver and FBDev becomes display driver??
>>
>> Right?
>>
>> Thanks.
>>
>>
>> On Mon, Jan 24, 2011 at 5:19 PM, <fpantaleao@mobisensesystems.com> wrote:
>>
>>  FBDev and V4l2 are not related but they share the same philosophy: HAL.
>>> FBDev is for graphics controller, V4L2 is for image/video/radio
>>> acquisition.
>>> You will find details about V4L2 at http://v4l2spec.bytesex.org/
>>> You can also download MBS270 V2 demo programs at:
>>> http://mobisense.free.fr/fics/xscale_BSPs/2009_08/app.tar.bz2
>>>
>>>
>>> FP
>>>
>>> chetan patil <chtpatil@gmail.com> a =E9crit :
>>>
>>>  Thanks.
>>>
>>>>
>>>> If possible can you share some docs related to
>>>> FBDev and V4l2.
>>>>
>>>> Are FBDev and V4l2 related.?/
>>>>
>>>>
>>>>
>>>> On Mon, Jan 24, 2011 at 4:21 PM, <fpantaleao@mobisensesystems.com>
>>>> wrote:
>>>>
>>>>  V4L2 is an API to uniformly access video devices on Linux machine. It
>>>>
>>>>> consists of several modules acting as a HAL( Hardware Abstraction
>>>>> Layer)
>>>>> between video devices and user land.
>>>>>
>>>>> FP
>>>>>
>>>>> chetan patil <chtpatil@gmail.com> a =E9crit :
>>>>>
>>>>>  Hi,
>>>>>
>>>>>
>>>>>> I was trying to understand v4l2.
>>>>>>
>>>>>> I'm not getting whether it is a driver or a module
>>>>>> which is dynamically inserted into the kernel
>>>>>> whenever we have to use it.
>>>>>>
>>>>>> Does all video capture device (webcam) only use
>>>>>> v4l2??
>>>>>>
>>>>>> Please give some overview if possible.
>>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>>
>>>>>> I did google but not getting proper answers.
>>>>>>
>>>>>> --
>>>>>> Regards,
>>>>>>
>>>>>> Chetan Arvind Patil,
>>>>>> +919970018364
>>>>>> <http://sites.google.com/site/chtpatil/>
>>>>>> --
>>>>>> video4linux-list mailing list
>>>>>> Unsubscribe mailto:video4linux-list-request@redhat.com
>>>>>> ?subject=3Dunsubscribe
>>>>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>> --
>>>> Regards,
>>>>
>>>> Chetan Arvind Patil,
>>>> +919970018364
>>>> <http://sites.google.com/site/chtpatil/>
>>>>
>>>>
>>>>
>>>
>>>
>>>
>>>
>>
>> --
>> Regards,
>>
>> Chetan Arvind Patil,
>> +919970018364
>> <http://sites.google.com/site/chtpatil/>
>>
>>
>
>
>
>


-- =

Regards,

Chetan Arvind Patil,
+919970018364
<http://sites.google.com/site/chtpatil/>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
