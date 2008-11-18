Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAIBcvMv009624
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 06:38:58 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAIBc6Ls027303
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 06:38:07 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2991112wfc.6
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 03:38:06 -0800 (PST)
Message-ID: <62e5edd40811180338q2527233aw37b91734465f6b49@mail.gmail.com>
Date: Tue, 18 Nov 2008 12:38:06 +0100
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Hans de Goede" <j.w.r.degoede@hhs.nl>
In-Reply-To: <4922A0FD.2040108@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <200811172253.33396.linux@baker-net.org.uk>
	<4922924B.8050302@hhs.nl>
	<62e5edd40811180200q614d0a32l68c0e47f043d225d@mail.gmail.com>
	<4922A0FD.2040108@hhs.nl>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, sqcam-devel@lists.sourceforge.net
Subject: Re: Advice wanted on producing an in kernel sq905 driver
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

2008/11/18 Hans de Goede <j.w.r.degoede@hhs.nl>:
> Erik Andrén wrote:
>
> <snip>
>
>>> Correct, there is nothing special you need to do for that, just pass
>>> frames
>>> with the raw bayer data to userspace and set the pixelformat to one of:
>>> V4L2_PIX_FMT_SBGGR8 /* v4l2_fourcc('B', 'A', '8', '1'), 8 bit BGBG..
>>> GRGR..
>>> */
>>> V4L2_PIX_FMT_SGBRG8 /* v4l2_fourcc('G', 'B', 'R', 'G'), 8 bit GBGB..
>>> RGRG..
>>> */
>>> V4L2_PIX_FMT_SGRBG8 /* v4l2_fourcc('G','R','B','G'), 8 bit GRGR.. BGBG..
>>> */
>>> V4L2_PIX_FMT_SRGGB8 /* v4l2_fourcc('R','G','G','B'), 8 bit RGRG.. GBGB..
>>> */
>>>
>>> Note the last 2 currently are only defined internally in libv4l and not
>>> in
>>> linux/videodev2.h as no drivers use them yet, but if you need one of them
>>> adding it to linux/videodev2.h is fine.
>>
>> I'm currently developing a driver where I need the two lower ones in
>> order to get a correct bayer decoding.
>> Would it possible to add them into the linux/videodev2.h?
>>
>> I can send a patch tonight if required.
>>
>
> It is usual for such patches to be submitted together with the driver using
> the new defines. Just be sure you define
> V4L2_PIX_FMT_SGRBG8 as v4l2_fourcc('G','R','B','G')
> and
> V4L2_PIX_FMT_SRGGB8 as v4l2_fourcc('R','G','G','B')
>
> You can try sending a patch to Mauro as preperation for your driver, but I'm
> not sure he will take such a patch, he did not accept it from me in the past
> as no drivers were using them, maybe with a driver on the horizon he will
> accept such a patch.
>

I'm currently in the process of porting the old quickcam driver [1] to
the gspca framework sofar I have working video using the vv6410
sensor. Next step is to get the hdcs and pb0100 sensors up to speed.
The driver will be tracked in
http://linuxtv.org/hg/~eandren/gspca-stv06xx/ (nothing pushed yet)

[1] http://qce-ga.sourceforge.net/

I'll let Jean-Francoise and Mauro know when it's ready for mainline submission.

Regards,
Erik


> Regards,
>
> Hans
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
