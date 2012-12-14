Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45362 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab2LNPow (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 10:44:52 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1820462bkw.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 07:44:50 -0800 (PST)
Message-ID: <50CB497F.6070803@googlemail.com>
Date: Fri, 14 Dec 2012 16:45:03 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/9] em28xx: refactor the frame data processing code
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com> <CAGoCfiw1wN+KgvNLqDSmbz5AwswPT9K48XOM4RnfKvHkmmR59g@mail.gmail.com> <50CA16EB.7060201@googlemail.com> <CAGoCfixtaQ4Jj2dW7XaAzcqEBTDj3xRnO_iCP=kOnhaxYwO2rw@mail.gmail.com> <50CB4494.2060501@googlemail.com> <CAGoCfixTeu6m0dcmpy7p=_BM8oZknCwyJ=jFPPM7bgJKC=-=jg@mail.gmail.com>
In-Reply-To: <CAGoCfixTeu6m0dcmpy7p=_BM8oZknCwyJ=jFPPM7bgJKC=-=jg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.12.2012 16:29, schrieb Devin Heitmueller:
>>>> Yes, there will likely be heavy merge conflicts...
>>>> In which tree are the videobuf2 patches ?
>>> It's in a private tree right now, and it doesn't support VBI
>>> currently.  Once I've setup a public tree with yours and Hans changes,
>>> I'll start merging in my changes.
>> I suggest to do the conversion on top of my patches, as they should make
>> things much easier for you.
>> I unified the handling of the VBI and video buffers, leaving just a few
>> common functions dealing with the videobuf stuff.
> Yup, that's exactly what I had planned.
>
>> In any case, we should develop against a common tree with a minimum
>> number of pending patches.
>> And we should coordinate development.
>> I don't work on further changes of the frame processing stuff at the moment.
>> Some I2C fixes/changes will be next. After that, I will try to fix
>> support for remote controls with external IR IC (connected via i2c).
>>
>>> Obviously it would be great for you to test with your webcam and make
>>> sure I didn't break anything along the way.
>> Sure, I will be glad to test your changes.
>>
>>> I've also got changes to support V4L2_FIELD_SEQ_TB, which is needed in
>>> order to take the output and feed to certain hardware deinterlacers.
>>> In reality this is pretty much just a matter of treating the video
>>> data as progressive but changing the field type indicator.
>> Ok, so I assume most of the changes will happen in em28xx_copy_video().
> The changes really are all over the tree because it's not just vb2
> support but also support for v4l2_fh, which means every ioctl() has a
> change to its arguments, and there is no longer an open/close call
> implemented.  Also significant impact on the locking model.

Ok. Sounds like a lot of fun... ;)

If the changes are all over the tree, we will likely get more collisions.
So we should both make our changes public as soon as possible.

>
>> Maybe we can then use a common copy function for video and VBI. Placing
>> the field data sequentially in the videobuf is what we already do with
>> the VBI data in em28xx_copy_vbi()
> Let's get something that works, at which point we can tune/optimize as needed.

I agree.

Frank

>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

