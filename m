Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA242YRO013123
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 00:02:34 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA242Koi026645
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 00:02:21 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1711770fga.7
	for <video4linux-list@redhat.com>; Sat, 01 Nov 2008 21:02:20 -0700 (PDT)
Message-ID: <d9def9db0811012102h7e573d0aoe1cec248d17bb7c@mail.gmail.com>
Date: Sun, 2 Nov 2008 05:02:19 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811010951i65532f11q42fb22a318f20278@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811011505.51716.hverkuil@xs4all.nl>
	<412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
	<200811011721.46016.hverkuil@xs4all.nl>
	<412bdbff0811010951i65532f11q42fb22a318f20278@mail.gmail.com>
Cc: v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	em28xx <em28xx@mcentral.de>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, Nov 1, 2008 at 5:51 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> Hello Hans,
>
> Thanks for getting back to me.  Responses inline:
>
> On Sat, Nov 1, 2008 at 12:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> As one of the half dozen people who are working on the linux-dvb
>>> version of em28xx, I am against the wholesale replacement of the
>>> current version with Markus's codebase.
>>
>> At this time I do not advocate replacing the current em28xx driver. But
>> when they are both in the kernel, then I expect and hope that the best
>> features of the em28xx driver are merged into the empia driver and that
>> the current em28xx driver can eventually be dropped.
>
> I'm certainly not against this approach, and having it in the mainline
> will make it easier for others to contribute and improve the codebase.
>  We would however have to deal with how to handle all the overlapping
> product support and the increased confusion that results from users
> reporting problems and figuring out which driver they are talking
> about (this is already an issue today though as most users don't
> understand that there are two drivers).
>
>>> # Doesn't leverage common infrastructure such as videobuf (resulting
>>> in duplicate functionality and more difficult for those who have to
>>> maintain multiple drivers)
>>
>> Definitely a candidate to merge into Markus' driver eventually. There
>> are more drivers that do not use videobuf (my own ivtv and cx18 drivers
>> spring to mind).
>
> Agreed.  If both drivers are used in parallel than this is less of an
> issue.  I was just against the wholesale replacement, which would
> result in moving backwards in these areas since the work was already
> done in the mainline driver.
>
>>> # Firmware blobs embedded in source - While it's easier for the user,
>>> many distributions do not allow firmware blobs in the kernel due to
>>> the belief that this is not GPL compatible. We would need to get
>>> permission from the vendor to redistribute the firmware as a file (in
>>> the V4L driver, we extract it from the Windows driver binary)
>>
>> From what I saw firmware blobs were only present in the xceive drivers,
>> and it is my opinion that it is not a good idea to merge these into the
>> kernel. Much better to fix the existing drivers. Having the empia
>> driver into the kernel will actually force those fixes to be made.
>
> Yes, I was referring to the Xceive drivers.   I agree with what you
> are saying, as long as we can agree that we should not have parallel
> tuner implementations in the kernel and the changes to use the
> mainline tuners should be made *before* it gets imported.
>
>>> # Ambigious licensing - some of the files have headers from companies
>>> other than Empiatech which are very clearly not GPL compatible (like
>>> the Micronas drx3973d driver). Also, it's not clear that even the
>>> firmware blobs mentioned above are authorized to be redistributed by
>>> their rightful owners (Xceive and Micronas). While Empiatech may be
>>> ok with making a GPL driver, these parties have not consented to
>>> having their intellectual property in the kernel (they may have
>>> consented but the header files say just the opposite).
>>
>> Licensing should obviously be addressed. But such drivers (except for
>> the xceive ones) are currently not used by the empia sources as
>> submitted by Markus.
>
> I do not believe they should be included into the codebase until the
> licensing issues are addressed.  Having the code in the kernel is a
> liability risk, even if it is not used by anything right now.
>
>>> # It has its own xc3028 and xc5000 tuner driver. I don't know whether
>>> his driver is better than the one in V4L. Presumably he has the
>>> datasheets for those parts, but on the other hand the V4L driver
>>> allows loading of the firmware externally. The V4L drivers are also
>>> used by devices beyond the em28xx and may have functionality required
>>> by other companies products.
>>
>> For the record: other devs have datasheets and sources as well for these
>> devices.
>
> Yes, I know.  Markus has suggested that his versions of the drivers
> are better because they are based on the reference code.  The xc5000
> driver aside (where the mainline driver is also based on the Xceive
> reference code with proper licensing and attribution), I do not
> believe he has ever offered any technical basis for his assertion.
>
>>> # What I'll call "Black magic" - lots of arbitrary code without any
>>> explanation as to what it is doing or why. Why does the DVB init
>>> routine write 0x77 to register 0x12? What does that do? A combination
>>> of poor use of constants and commented code combined with a lack of
>>> access to the datasheets leaves this a mystery. You just have to
>>> "trust that it's doing the right thing because it works"
>>
>> This is not an uncommon occurence when datasheets are not public.
>> Hopefully Markus can address such problems when the driver is in the
>> kernel. It's IMHO not a blocking issue.
>
> He has had the opportunity to do this in his own tree, and has thus
> far not done it because, as he put it in email to me "nobody cares
> about this".  I disagree with this assertion personally as someone who
> has had to fix bugs in the mainline driver and it would have been very
> helpful to at least have commented what some of the code is doing.  He
> has the datasheets, and has made a conscious decision to not describe
> what the code is doing.
>

You are the first person I ever saw asking for that in a driver. A
short mail asking
what a specific register does is the usual way how register
information can be revealed.

eg.:
http://linuxtv.org/hg/v4l-dvb/file/55f8fcf70843/linux/drivers/media/video/sn9c102/sn9c102_ov7630.c
line 36 and ongoing.


>>> # He's the only one who has access to the datasheets, so there is
>>> limited opportunity for peer review. The community driver is based on
>>> reverse engineering, and we can pass around USB traces we collect to
>>> justify/explain design decisions. How do you question a design when
>>> the basis of answers is essentially "because the secret document that
>>> I can't show you says so"?
>>
>> There are lots of drivers that are based on NDAs (e.g. my cx18 driver).
>> The code is public, but the datasheets aren't. That's actually much
>> better than to rely on reverse engineering. Of course, you get the best
>> results if the datasheets are also public, but that's sadly not always
>> possible. Often active developers can all get NDAs, so that multiple
>> devs have access to datasheets (again, that's the case for the cx18
>> driver).
>>
>> I see this as an advantage, not a disadvantage.
>
> I understand the value of datasheets, as I am in this situation myself
> with several devices.  However, in many cases a well written driver
> will have good comments as to what it is doing (super secret
> algorithms aside).  In fact, now that I have access to some of the
> Empia datasheets, I have some patches for the mainline driver that
> better document some of these cases.
>

Take care that you get the official agreement to publish documentation about it.

>>> I'm sorry if the sharing of my views on this matter create more
>>> animosity within the community, as that is the exact opposite of what
>>> I want.
>>
>> This is I think the last chance to get Markus' driver into the kernel.
>> If this fails again, then there is no other choice but to fork it all.
>> But for the end-users it's so much better if Markus would maintain the
>> empia driver since he has the datasheets and hardware.
>>
>> Forget the history, and see this as a new driver. I think I presented a
>> reasonable roadmap for it to be merged.
>
> Sure, and if Markus is willing to compromise on things like the tuner
> drivers, then this would be good for everybody.  Past experience has
> suggested that he was unwilling to compromise on anything (based on my
> attempts in the past), so if things have changed then I would be
> thrilled to work with him.
>

In case of the tuners I'd like to keep them the way they are *for now*
- it might be
changed lateron. Those things are still in progress. It doesn't
interfere with other
tuners in the system.
The driver explicitly tells the tuner-core to not attach anything when
those 2 chips are
used for analog and digital TV. It's backward compatible without
adding any problems.
The xc5000 driver from Steven is based on reference drivers as far as
I know, there have
been a few updates to it and especially the xc5000 part of that device
is still not in a
frozen state (there are issues with the cx25843 - xc5000)
All the firmware parts are moved out of the driver, frequency tables
are kept inside.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
