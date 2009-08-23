Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7N2hQs0005944
	for <video4linux-list@redhat.com>; Sat, 22 Aug 2009 22:43:26 -0400
Received: from mail-ew0-f211.google.com (mail-ew0-f211.google.com
	[209.85.219.211])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7N2h8YB009173
	for <video4linux-list@redhat.com>; Sat, 22 Aug 2009 22:43:09 -0400
Received: by ewy7 with SMTP id 7so1569938ewy.7
	for <video4linux-list@redhat.com>; Sat, 22 Aug 2009 19:43:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL121-W59DBB36A6C20DA86B99BA8D8FB0@phx.gbl>
References: <COL121-W59DBB36A6C20DA86B99BA8D8FB0@phx.gbl>
Date: Sun, 23 Aug 2009 22:13:08 +1930
Message-ID: <b101ebb80908221943o690ad9a9t3a58b6139d4794b6@mail.gmail.com>
From: =?ISO-8859-1?Q?Jos=E9_Gregorio_D=EDaz_Unda?= <xt4mhz@gmail.com>
To: not disclosed <n0td1scl0s3d@hotmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: UVC / V4L2 webcam / grab
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

2009/8/23 not disclosed <n0td1scl0s3d@hotmail.com>:
>
>
>
> I need to grab single frames from a UVC / V4L2 webcam with low latency and I need the frame
> to be acquired ASAP _after_ another event has occurred.  The code I am using is ~ that below
> and the problem I have is that unless I grab one frame and discard it I find the frame I grab (the
> image) sometimes contains things that could only occur _prior_ to the capture code being called.
>
> In pseudo code my problem looks like this:
>
> set_condition(1);
> usleep(DELAY);
> ...
> set_condition(2);
> usleep(DELAY);
> grabframe(data);
>
> The problem is the data may contain output from condition (1) even if DELAY is long enough
> to guarantee the image should only contain and image from condition (2). If I do something like:
>
>
>
> set_condition(1);
>
> usleep(DELAY);
>
> ...
>
> set_condition(2);
>
> usleep(DELAY);
>
> grabframe(data);
>
> grabframe(data);
>
>
> the second grab returns the correct image regardless of what DELAY I use.
>
> This may be a stupid problem and I am not too familiar with how V4L2 works but here goes:
>
> What is the easiest way to use V4L2 to grab an individual frame from a UVC webcam and
> ensure that the data in the frame relates to an image that occurred _after_ the grab was
> requested? second part is, what is the fastest / simplest way to do this?
>
> I don't even know if it is possible to ensure this because I suppose hardware limitations
> may prevent a deterministic result.
>
> Sorry for cryptic explanation, the detailed one would take a huge space to explain.
> Simplest terms I am changing the lighting conditions then capturing the result, say this was
> from red->blue lighting, some of my grabbed images contain red when it would be impossible
> to do so unless the data I received was captured before I requested it.
>
> Cheers,
>
> SA
>
> // code snippet
>
>
>
> // set up...
> int type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> ret = ioctl (vd->fd, VIDIOC_STREAMON, &type);
>
>
>
> // code to run at capture
> memset (&vd->buf, 0, sizeof (struct v4l2_buffer));
> vd->buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> vd->buf.memory = V4L2_MEMORY_MMAP;
> ret = ioctl (vd->fd, VIDIOC_DQBUF, &vd->buf);
> memcpy (vd->framebuffer, vd->mem[vd->buf.index],(size_t) vd->framesizeIn);
> ret = ioctl (vd->fd, VIDIOC_QBUF, &vd->buf);
>
> _________________________________________________________________
> Share your memories online with anyone you want.
> http://www.microsoft.com/middleeast/windows/windowslive/products/photos-share.aspx?tab=1--
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subjectunsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

Hi SA.

Recently I had to do a "very basic" program to show in a Web a image
grabbed from the webcam.

I started using "uvccapture" like this:

uvccapture -v -d/dev/video0 -t0 -q100

But I got an error:

jgdu-laptop:~# uvccapture -v -d/dev/video0 -t0 -q100
Using videodevice: /dev/video0
Saving images to: snap.jpg
Image size: 320x240
Taking snapshot every 0 seconds
Taking images using mmap
Error opening device /dev/video0: unable to query device.
 Init v4L2 failed !! exit fatal

I suppose the webcam was not supported.

So I found "vgrabbj" and the core functional prototype is:

vgrabbj > imagen-`date +%d%m%Y-%k%M%S`.jpg

This command grabs the image and name it with DDMMYY-mmss format.

I hope this helps.

José Gregorio.

-- 
Lic. José Gregorio Díaz Unda.
Asesor de Tecnologías de Información y Comunicación.
Tel.: 0412.5518085
Alternativos: xt4mhz@*.com
Web: www.usb.ve - jgdu.blogspot.com
GNU/Linux Debian Lenny - Kernel 2.6.26-2-686

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
