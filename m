Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAICl5J1004830
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 07:47:05 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAICko3P025537
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 07:46:51 -0500
Message-ID: <4922BA7D.7010303@hhs.nl>
Date: Tue, 18 Nov 2008 13:52:13 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
References: <200811172253.33396.linux@baker-net.org.uk>	
	<4922924B.8050302@hhs.nl>	
	<62e5edd40811180200q614d0a32l68c0e47f043d225d@mail.gmail.com>	
	<4922A0FD.2040108@hhs.nl>
	<62e5edd40811180338q2527233aw37b91734465f6b49@mail.gmail.com>
In-Reply-To: <62e5edd40811180338q2527233aw37b91734465f6b49@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Erik Andrén wrote:
> 2008/11/18 Hans de Goede <j.w.r.degoede@hhs.nl>:
>> Erik Andrén wrote:
>>
>> <snip>
>>
>>>> Correct, there is nothing special you need to do for that, just pass
>>>> frames
>>>> with the raw bayer data to userspace and set the pixelformat to one of:
>>>> V4L2_PIX_FMT_SBGGR8 /* v4l2_fourcc('B', 'A', '8', '1'), 8 bit BGBG..
>>>> GRGR..
>>>> */
>>>> V4L2_PIX_FMT_SGBRG8 /* v4l2_fourcc('G', 'B', 'R', 'G'), 8 bit GBGB..
>>>> RGRG..
>>>> */
>>>> V4L2_PIX_FMT_SGRBG8 /* v4l2_fourcc('G','R','B','G'), 8 bit GRGR.. BGBG..
>>>> */
>>>> V4L2_PIX_FMT_SRGGB8 /* v4l2_fourcc('R','G','G','B'), 8 bit RGRG.. GBGB..
>>>> */
>>>>
>>>> Note the last 2 currently are only defined internally in libv4l and not
>>>> in
>>>> linux/videodev2.h as no drivers use them yet, but if you need one of them
>>>> adding it to linux/videodev2.h is fine.
>>> I'm currently developing a driver where I need the two lower ones in
>>> order to get a correct bayer decoding.
>>> Would it possible to add them into the linux/videodev2.h?
>>>
>>> I can send a patch tonight if required.
>>>
>> It is usual for such patches to be submitted together with the driver using
>> the new defines. Just be sure you define
>> V4L2_PIX_FMT_SGRBG8 as v4l2_fourcc('G','R','B','G')
>> and
>> V4L2_PIX_FMT_SRGGB8 as v4l2_fourcc('R','G','G','B')
>>
>> You can try sending a patch to Mauro as preperation for your driver, but I'm
>> not sure he will take such a patch, he did not accept it from me in the past
>> as no drivers were using them, maybe with a driver on the horizon he will
>> accept such a patch.
>>
> 
> I'm currently in the process of porting the old quickcam driver [1] to
> the gspca framework sofar I have working video using the vv6410
> sensor. Next step is to get the hdcs and pb0100 sensors up to speed.
> The driver will be tracked in
> http://linuxtv.org/hg/~eandren/gspca-stv06xx/ (nothing pushed yet)
> 

Good! and <ugh> I've been working on the same, I'm nowhere near as far as you 
though, can you please put a tarbal or whatever somewhere, then I can see if 
there is anything in my version worth salvaging to improve your driver in some 
points.

I've access to an pb0100 using cam.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
