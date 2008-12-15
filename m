Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFA6dWV001806
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 05:06:39 -0500
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBFA6PaU023255
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 05:06:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Mon, 15 Dec 2008 11:06:24 +0100
References: <412bdbff0812141701j3ee744daq49f47da9150124f4@mail.gmail.com>
In-Reply-To: <412bdbff0812141701j3ee744daq49f47da9150124f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812151106.24382.hverkuil@xs4all.nl>
Cc: 
Subject: Re: Template for a new driver
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

On Monday 15 December 2008 02:01:14 Devin Heitmueller wrote:
> Hello,
>
> I am writing a new driver for a video decoder, and wanted to ask if
> there was any particular driver people would suggest as a model to
> look at for new drivers.  For example, I am not completely familiar
> with which interfaces are deprecated, and want to make sure I use a
> driver as a template that reflects the latest standards/conventions.
>
> Suggestions welcome.
>
> Thanks in advance,
>
> Devin

Hi Devin,

You definitely want to use the new v4l2_subdev framework for this. Read 
Documentation/video4linux/v4l2-framework.txt for more info.

A good example template is probably saa7115.c. Not as big and 
complicated as the audio-video decoder cx25840, but still a good 
non-trivial example.

I also recommend using struct v4l2_i2c_driver_data if you desire to be 
compatible with older kernels. The main reason for having this struct 
is to hide all the ugly kernel #ifdefs.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
