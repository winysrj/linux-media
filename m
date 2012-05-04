Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58790 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2EDIm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 04:42:29 -0400
Received: by obbtb18 with SMTP id tb18so3688611obb.19
        for <linux-media@vger.kernel.org>; Fri, 04 May 2012 01:42:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA37F14.6020500@redhat.com>
References: <20120424122156.GA16769@kipc2.localdomain> <20120502084318.GA21181@kipc2.localdomain>
 <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com>
 <20120502114430.GA4608@kipc2.localdomain> <CAPueXH7TjHo-Dx2wUCQEcDvn=5L_xobYVKrf+b6wnmLGwOSeRg@mail.gmail.com>
 <20120502133108.GA19522@kipc2.localdomain> <CAPueXH4nx=mtwF1WR+7NYG0Ze9Arne17j2Sfw439PrS9nPWFaQ@mail.gmail.com>
 <CAPueXH6Gw_YHEF47vCvkU9XJDt2BO2EjfStTBQEaswhm0RdZ-Q@mail.gmail.com>
 <20120503110156.GA11872@kipc2.localdomain> <CAPueXH4vR0ocZwnAftS-wGemjJ45WGYOOd+bi2gOxweXwZ7G3Q@mail.gmail.com>
 <4FA37F14.6020500@redhat.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Fri, 4 May 2012 09:42:08 +0100
Message-ID: <CAPueXH7XjOf1Y+o7MMAtM-vg6JtOKaETfBK2Yq06DUk7=dForg@mail.gmail.com>
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
To: Hans de Goede <hdegoede@redhat.com>
Cc: Karl Kiniger <karl.kiniger@med.ge.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-uvc-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I've add you has a developer to the project, so you should be able to
commit these patches yourself,
I would suggest that you pushed a new branch with your changes and
after testing we merge them into the master.
I'm doing the same for some fixes I have planned and also for the code
for version 0.3 that Martin kindly send me (it has a lot of new apps,
including a qt interface, and video capture support).

This is the project page:
https://sourceforge.net/p/libwebcam/code

currently master is not building against the new uvcvideo.h, I'll try
to fix that today, also the check for this header during configuration
is unnecessary since it's now in linux headers (just need to include
it with linux/uvcvideo.h)

Regards,
Paulo

2012/5/4 Hans de Goede <hdegoede@redhat.com>:
> Hi Paulo,
>
> I've also done some work on libwebcam a while ago, but have not yet had
> the time to send this to Martin Rubli. Attached are git format-patch
> patches against the 0.2.1 branch of svn. Note these are against what
> was in that branch when I did this work some months ago, so not sure
> if it will still apply cleanly.
>
> I would really like to work together with you on getting an updated version
> of libwebcam out there for use in distros (I maintain libwebcam in Fedora,
> and AFAIK you maintain it in Debian, right?)
>
> My sourceforge.net account is jwrdegoede, I hope you're willing to give
> me commit access to the git repo there.
>
> I guess if there is going to be more then 1 of us working on the git repo
> we should have some review procedure. If others don't object we could post
> patches to linux-media, prefixing the subject with a [PATCH libwebcam] and
> then do reviews on linux-media and push only after an ack?
>
> I guess we could start with that right away with my proposed patches,
> if you can make an initial git repo available I can rebase on top
> of that and then send the patches with git send-email (so 1 patch / mail)
> for review?
>
> Either way thanks for working on this!
>
> Regards,
>
> Hans
>
>
>
>
>
>
>
> On 05/03/2012 04:17 PM, Paulo Assis wrote:
>>
>> Karl Hi,
>> I'm setting up a libwebcam git repo in sourceforge, Martin Rubli from
>> logitech (the libwebcam developer), was kind enough to post me all
>> it's code and the old svn repo backup.
>> He had already done some fixes regarding the new ioctls for version
>> 0.3, so I just need to go through that and add add them to 0.2.
>> I still need to check with him how he wants to handle the 0.3 version,
>> since it has a lot of new code ( and some extra apps ).
>>
>> Regards,
>> Paulo
>>
>> 2012/5/3 Karl Kiniger<karl.kiniger@med.ge.com>:
>>>
>>> Hi Paulo,
>>>
>>> On Wed 120502, Paulo Assis wrote:
>>>>
>>>> OK, so UVCIOC_CTRL_ADD is no longer available, now we have:
>>>>
>>>> UVCIOC_CTRL_MAP and UVCIOC_CTRL_QUERY, so I guess some changes are
>>>> needed, I'll try to fix this ASAP.
>>>
>>>
>>> compiled libwebcam-0.2.1 from Ubuntu (had to fight against
>>> CMake - I am almost CMake agnostic so far...) and I got the
>>> manual focus control in guvcview so things are definitely
>>> looking better now.
>>>
>>> So far I have got a focus slider and a LED1 frequency slider,
>>> but not a LED mode... forgot what exactly was available in
>>> the past.
>>>
>>> -------
>>> LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/uvcdynctrl -i
>>> /usr/share/uvcdynctrl/data/046d/logitech.xml
>>> [libwebcam] Unsupported V4L2_CID_EXPOSURE_AUTO control with a
>>> non-contiguous range of choice IDs found
>>> [libwebcam] Invalid or unsupported V4L2 control encountered: ctrl_id =
>>> 0x009A0901, name = 'Exposure, Auto'
>>> Importing dynamic controls from file
>>> /usr/share/uvcdynctrl/data/046d/logitech.xml.
>>>  /usr/share/uvcdynctrl/data/046d/logitech.xml: error: video0: unable to
>>>    map 'Pan (relative)' control. ioctl(UVCIOC_CTRL_MAP) failed with
>>> return value -1 (error 2: No such file or directory)
>>> /usr/share/uvcdynctrl/data/046d/logitech.xml: error: video0: unable to
>>> map 'Tilt (relative)'
>>>    control. ioctl(UVCIOC_CTRL_MAP) failed with return value -1 (error 2:
>>> No such file or directory)
>>> /usr/share/uvcdynctrl/data/046d/logitech.xml:354: error: Invalid V4L2
>>> control type specified: 'V4L2_CTRL_TYPE_BUTTON'
>>> /usr/share/uvcdynctrl/data/046d/logitech.xml:368: error: Invalid V4L2
>>> control type specified: 'V4L2_CTRL_TYPE_BUTTON'
>>> /usr/share/uvcdynctrl/data/046d/logitech.xml:396: error: Invalid V4L2
>>> control type specified: 'V4L2_CTRL_TYPE_MENU'
>>>
>>> Thanks again,
>>> Karl
>>>
>>>>
>>>> Regards,
>>>> Paulo
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
