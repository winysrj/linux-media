Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG95eTW002246
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:05:40 -0500
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBG94TeC016937
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 04:04:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 16 Dec 2008 10:04:28 +0100
References: <412bdbff0812151315j768feb89j5deaf4db4650749e@mail.gmail.com>
In-Reply-To: <412bdbff0812151315j768feb89j5deaf4db4650749e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161004.28556.hverkuil@xs4all.nl>
Cc: 
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

On Monday 15 December 2008 22:15:40 Devin Heitmueller wrote:
> Hello,
>
> A longstanding problem with some devices that provide uncompressed
> video has to do with there being no way to associate an ALSA audio
> device with the video.  For example, the HVR-950 provides it's analog
> video stream and has a USB audio device for the audio, and there is
> no way to know the two are associated.  This isn't an issue with
> devices that have an MPEG encoder, since the card multiplexes the
> audio into the MPEG stream automatically.
>
> This has lead to some pretty crazy solutions from users such as
> running tvtime or xawtv and arecord/aplay or sox at the same time,
> with obvious problems with synchronization.  Markus was nice enough
> to hack a version of tvtime that works for certain cards, but really
> this is something the device be telling the application.  Having a
> situation where every application out there needs to have custom
> logic for each device is less than ideal.
>
> Has anyone proposed an API for associating a video stream with an
> audio device?  Does anyone see a downside in having a call that will
> tell the calling application where to find the audio stream?
>
> If nobody has done this before, I will take a closer look at the API
> and make a proposal.
>
> Devin

Hi Devin,

Yes, I've made a proposal for this (and more) in this RFC:

http://www.archivum.info/video4linux-list%40redhat.com/2008-07/msg00371.html

It's been on hold since there was no point in working on this unless I 
could get the lower level v4l2_device and v4l2_subdev structs in first. 
But I hope to start working on this early next year.

In a nutshell, the idea is to create a media controller device that 
allows you to query meta information (such as which v4l2/alsa/dvb/fb 
devices there are) for a particular media card.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
