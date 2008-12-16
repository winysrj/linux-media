Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGFacbZ027827
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 10:37:14 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGF4L8j023606
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 10:04:22 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1455988fga.7
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 07:04:16 -0800 (PST)
Message-ID: <412bdbff0812160704m32adfbcejbfe735dbc237eeff@mail.gmail.com>
Date: Tue, 16 Dec 2008 10:04:16 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812161004.28556.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0812151315j768feb89j5deaf4db4650749e@mail.gmail.com>
	<200812161004.28556.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: v4l audio enumeration API
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

On Tue, Dec 16, 2008 at 4:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Monday 15 December 2008 22:15:40 Devin Heitmueller wrote:
>> Hello,
>>
>> A longstanding problem with some devices that provide uncompressed
>> video has to do with there being no way to associate an ALSA audio
>> device with the video.  For example, the HVR-950 provides it's analog
>> video stream and has a USB audio device for the audio, and there is
>> no way to know the two are associated.  This isn't an issue with
>> devices that have an MPEG encoder, since the card multiplexes the
>> audio into the MPEG stream automatically.
>>
>> This has lead to some pretty crazy solutions from users such as
>> running tvtime or xawtv and arecord/aplay or sox at the same time,
>> with obvious problems with synchronization.  Markus was nice enough
>> to hack a version of tvtime that works for certain cards, but really
>> this is something the device be telling the application.  Having a
>> situation where every application out there needs to have custom
>> logic for each device is less than ideal.
>>
>> Has anyone proposed an API for associating a video stream with an
>> audio device?  Does anyone see a downside in having a call that will
>> tell the calling application where to find the audio stream?
>>
>> If nobody has done this before, I will take a closer look at the API
>> and make a proposal.
>>
>> Devin
>
> Hi Devin,
>
> Yes, I've made a proposal for this (and more) in this RFC:
>
> http://www.archivum.info/video4linux-list%40redhat.com/2008-07/msg00371.html
>
> It's been on hold since there was no point in working on this unless I
> could get the lower level v4l2_device and v4l2_subdev structs in first.
> But I hope to start working on this early next year.
>
> In a nutshell, the idea is to create a media controller device that
> allows you to query meta information (such as which v4l2/alsa/dvb/fb
> devices there are) for a particular media card.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

Hello Hans,

Thank you for providing the proposal.  Admittedly, I've been focusing
on the linux-dvb side and not paying enough attention to what has been
going on in v4l.

If there is anything I can do to help make this happen, please let me know.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
