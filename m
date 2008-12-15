Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFEafeP027869
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 09:36:41 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBFEZFhF003362
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 09:35:16 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1198861fga.7
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 06:35:15 -0800 (PST)
Message-ID: <412bdbff0812150635x7187a9feh9e8a42b3034c67df@mail.gmail.com>
Date: Mon, 15 Dec 2008 09:35:15 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812151106.24382.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0812141701j3ee744daq49f47da9150124f4@mail.gmail.com>
	<200812151106.24382.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
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

On Mon, Dec 15, 2008 at 5:06 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Monday 15 December 2008 02:01:14 Devin Heitmueller wrote:
>> Hello,
>>
>> I am writing a new driver for a video decoder, and wanted to ask if
>> there was any particular driver people would suggest as a model to
>> look at for new drivers.  For example, I am not completely familiar
>> with which interfaces are deprecated, and want to make sure I use a
>> driver as a template that reflects the latest standards/conventions.
>>
>> Suggestions welcome.
>>
>> Thanks in advance,
>>
>> Devin
>
> Hi Devin,
>
> You definitely want to use the new v4l2_subdev framework for this. Read
> Documentation/video4linux/v4l2-framework.txt for more info.
>
> A good example template is probably saa7115.c. Not as big and
> complicated as the audio-video decoder cx25840, but still a good
> non-trivial example.
>
> I also recommend using struct v4l2_i2c_driver_data if you desire to be
> compatible with older kernels. The main reason for having this struct
> is to hide all the ugly kernel #ifdefs.
>
> Regards,
>
>        Hans

Thanks for the feedback.  Because I didn't wait for more responses
last night, I ended up using the cx25840 driver as the base, which
seems to have been a good choice.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
