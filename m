Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51028 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbbK0Lbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 06:31:50 -0500
Date: Fri, 27 Nov 2015 12:31:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?B?QXloYW4gS8Ocw4fDnEtNQU7EsFNB?=
	<ayhan.kucukmanisa@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Mt9v024 gettting image problem
In-Reply-To: <CAF-Najv7RjQf_QfQ1-6BfrEj9qz_cA8zqOq5ORc5JCV=EFqv5Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1511271225340.31689@axis700.grange>
References: <CAF-Najv7RjQf_QfQ1-6BfrEj9qz_cA8zqOq5ORc5JCV=EFqv5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The reason for a lower framerate must not necessarily be in the program, 
it can be the hardware - either the clock frequency, your camera is driven 
by, or the slow CPU, or the camera host driver, or your frame processing.

Thanks
Guennadi

On Thu, 26 Nov 2015, Ayhan K�~\�~G�~\KMANİSA wrote:

> Hi,
> 
> 
> I'm trying to get image from aptina mt9v024 sensor using v4l2 library. In
> sensor datasheet that is defined that sensor has 60 fps capability at
> default. But with my code which is below i could get images at 20 fps. How
> can i reach 60 fps? Could you give me an advice that where is my fault?
> 
> Thanks.
> 
> 
> //// CODE ////
> 
> 
> char *dev_name = "/dev/video0";
> int fd = v4l2_open(dev_name, O_RDWR | O_NONBLOCK, 0);
>         if (fd < 0) {
>                 perror("Cannot open device");
>                 exit(EXIT_FAILURE);
>         }
> cout << "camera init" << endl;
> CLEAR(fmt);
>         fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>         fmt.fmt.pix.width       = 752;
>         fmt.fmt.pix.height      = 480;
>         fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR16;
>         fmt.fmt.pix.field       = V4L2_FIELD_ANY;
>         xioctl(fd, VIDIOC_S_FMT, &fmt);
> 
> 
>         CLEAR(req);
>         req.count = 2;
>         req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>         req.memory = V4L2_MEMORY_MMAP;
>         xioctl(fd, VIDIOC_REQBUFS, &req);
> 
>         buffers = (buffer *)calloc(req.count, sizeof(*buffers));
>         for (n_buffers = 0; n_buffers < req.count; ++n_buffers) {
>                 CLEAR(buf);
> 
>                 buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>                 buf.memory      = V4L2_MEMORY_MMAP;
>                 buf.index       = n_buffers;
> 
>                 xioctl(fd, VIDIOC_QUERYBUF, &buf);
> 
>                 buffers[n_buffers].length = buf.length;
>                 buffers[n_buffers].start = v4l2_mmap(NULL, buf.length,
>                               PROT_READ | PROT_WRITE, MAP_SHARED,
>                               fd, buf.m.offset);
> 
>                 if (MAP_FAILED == buffers[n_buffers].start) {
>                         perror("mmap");
>                         exit(EXIT_FAILURE);
>                 }
>         }
> 
>         for (i = 0; i < n_buffers; ++i) {
>                 CLEAR(buf);
>                 buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>                 buf.memory = V4L2_MEMORY_MMAP;
>                 buf.index = i;
>                 xioctl(fd, VIDIOC_QBUF, &buf);
>         }
> type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> xioctl(fd, VIDIOC_STREAMON, &type);
> while(1)
> {
> do {
>                         FD_ZERO(&fds);
>                         FD_SET(fd, &fds);
> 
>                         /* Timeout. */
>                         tv.tv_sec = 2;
>                         tv.tv_usec = 0;
> 
>                         r = select(fd + 1, &fds, NULL, NULL, &tv);
>                 } while ((r == -1 && (errno = EINTR)));
>                 if (r == -1) {
>                         perror("select");
>                         return errno;
>                 }
> 
>                 CLEAR(buf);
>                 buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>                 buf.memory = V4L2_MEMORY_MMAP;
>                 xioctl(fd, VIDIOC_DQBUF, &buf);
> /* Getting Image */
> Mat bayer16Bit = Mat(fmt.fmt.pix.height, fmt.fmt.pix.width, CV_8UC1, (void
> *)buffers[buf.index].start);
> }
> 
> 
> 
> 
> ---------------------------------------------------------------------------------------------------
> Arş. Gör. Ayhan KÜÇÜKMANİSA
> Kocaeli Üniversitesi, Gömülü Sistemler ve Görüntüleme Sistemleri
> Laboratuvarı
> 
> Res. Asst. Ayhan KÜÇÜKMANİSA
> Kocaeli University, Laboratory of Embedded and Vision Systems
> 
