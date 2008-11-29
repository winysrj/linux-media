Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATDNrXF009166
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 08:23:53 -0500
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATDNCYY024706
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 08:23:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Sat, 29 Nov 2008 14:23:10 +0100
References: <5d5443650811282312w508c0804qf962f6cf5e859e2@mail.gmail.com>
In-Reply-To: <5d5443650811282312w508c0804qf962f6cf5e859e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811291423.10483.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: FM transmitter support under v4l2?
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

On Saturday 29 November 2008 08:12:51 Trilok Soni wrote:
> Hi,
>
> Anybody working on FM transmitter related drivers support under v4l2?
> If no, what parts of v4l2 which could be tweaked in right order to
> support such devices? I see that SI471x series seem to have FM
> transmitters too.

Hi Trilok,

No one is working on this. The V4L2 spec has support for modulators 
(which is probably one part that you need), but a different question is 
how to get the audio. I think using ALSA for that is probably the way 
to go. It's a bit unsatisfying having to use two different subsystems 
for this (v4l for tuning/modulating and alsa for actually 
reading/writing audio), but no one has come up with a better 
alternative.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
