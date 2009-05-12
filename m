Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:18814 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZELBHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 21:07:52 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2356021rvb.1
        for <linux-media@vger.kernel.org>; Mon, 11 May 2009 18:07:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090511203647.6c982275@pedra.chehab.org>
References: <5e9665e10904230315o46ef5f95o8c393a9148976880@mail.gmail.com>
	 <20090511203647.6c982275@pedra.chehab.org>
Date: Tue, 12 May 2009 10:07:53 +0900
Message-ID: <5e9665e10905111807n36215403yfa978db454cdc975@mail.gmail.com>
Subject: Re: About using VIDIOC_REQBUFS
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Thank you for your comment, first of all.
In earlier mail, my question was actually about how to capture a
different pixel format data from the one configured in the first
S_FMT. Like opening device configured with YUV422 pixel format and try
to capture a JPEG data which comes from the same device.

After sending that mail, I tried several different ways to capture
JPEG data. Actually, the way I asked in earlier mail didn't go well.
Here is the reason that I couldn't make it.(I tried s_fmt before every
reqbufs and querybuf and mmap after that)

- There was a driver modification necessary to use munmap : I'm using
OMAP3 camera interface driver of Sakari. I had to make driver to
re-issue videobuf_queue_core_init in S_FMT of omap3 camera interface
through videobuf_queue_sg_init. It seems to be weird to re-init
videobuf core in S_FMT. Isn't it? I don't know but I couldn't
guarantee that it is a safe way.

So, I decided to handle one pixel format per one file descriptor.
I mean, opening device and get a file descriptor for preview buffer
and open one more time with the same device and get a file descriptor
for JPEG capture buffer. It seems to be more decent to me. And even
each different pixel formats could be handled in a different thread.
Pretty handy.
With this way, I just need to keep the streaming section mutually
exclusive from each thread, which means when thread A starts streaming
with streamon, thread B can't streamon with the same device. (device
just returns EBUSY)

Besides that, I found that there is no way to know the maximum memory
size to be mmaped.
So I posted following RFC on linux-media list.
Please find this and any comment will be appreciated.
http://www.spinics.net/lists/linux-media/msg05013.html

Cheers,
Nate

On Tue, May 12, 2009 at 8:36 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em Thu, 23 Apr 2009 19:15:14 +0900
> "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com> escreveu:
>
>> Hello Hans,
>>
>> Is it an ordinary way to use twice reqbuf without closing and
>> re-opening between them?
>>
>> I mean like this,
>>
>> 1. Open device
>> 2. VIDIOC_REQBUFS
>>      <snip>
>> 3. VIDIOC_STREAMON
>>      <snip>
>> 4. VIDIOC_STREAMOFF
>> 5. VIDIOC_REQBUFS
>>      <snip>
>> 6. VIDIOC_STREAMON
>>
>> I suppose there should be a strict order for this. That order seems to
>> be wrong but necessary when we do capturing a JPEG data which size
>> (not resolution) is bigger than the preview data size. (Assuming that
>> user is using mmap)
>> Please let me know the right way for that kind of case. Just close and
>> re-open with big enough size for JPEG? or mmap with big enough size in
>> the first place?
>
> That's a very good question.
>
> You shouldn't be needing to close/open the device for this to work, but between
> (4) and (5), you'll need to call VIDIOC_S_FMT, to change the videobuf size,
> and, to be safe, unmap the videobuf memory.
>
> A code like the above may give different results depending on the way
> videobuffer handling is implemented.
>
> A good idea is to test it with vivi driver (that uses videobuf), with debugs
> enabled, and compare with other drivers.
>
> I did such test with vivi and it worked properly (although I didn't change the
> data size).
>
> If you want to test, I used the driver-test program, available at the
> development tree, with the patch bellow. I didn't actually tested to resize the
> stream, but from vivi logs, the mmapped buffers seem to be properly
> allocated/deallocated.
>
>
>
> Cheers,
> Mauro
>
> diff --git a/v4l2-apps/test/driver-test.c b/v4l2-apps/test/driver-test.c
> --- a/v4l2-apps/test/driver-test.c
> +++ b/v4l2-apps/test/driver-test.c
> @@ -30,7 +30,7 @@ int main(void)
>  {
>        struct v4l2_driver drv;
>        struct drv_list *cur;
> -       unsigned int count = 10, i;
> +       unsigned int count = 10, i, j;
>        double freq;
>
>        if (v4l2_open ("/dev/video0", 1,&drv)<0) {
> @@ -97,45 +97,47 @@ int main(void)
>        fflush (stdout);
>        sleep(1);
>
> -       v4l2_mmap_bufs(&drv, 2);
> +       for (j = 0; j < 5; j++) {
> +               v4l2_mmap_bufs(&drv, 2);
>
> -       v4l2_start_streaming(&drv);
> +               v4l2_start_streaming(&drv);
>
> -       printf("Waiting for frames...\n");
> +               printf("Waiting for frames...\n");
>
> -       for (i=0;i<count;i++) {
> -               fd_set fds;
> -               struct timeval tv;
> -               int r;
> +               for (i=0;i<count;i++) {
> +                       fd_set fds;
> +                       struct timeval tv;
> +                       int r;
>
> -               FD_ZERO (&fds);
> -               FD_SET (drv.fd, &fds);
> +                       FD_ZERO (&fds);
> +                       FD_SET (drv.fd, &fds);
>
> -               /* Timeout. */
> -               tv.tv_sec = 2;
> -               tv.tv_usec = 0;
> +                       /* Timeout. */
> +                       tv.tv_sec = 2;
> +                       tv.tv_usec = 0;
>
> -               r = select (drv.fd + 1, &fds, NULL, NULL, &tv);
> -               if (-1 == r) {
> -                       if (EINTR == errno)
> -                               continue;
> +                       r = select (drv.fd + 1, &fds, NULL, NULL, &tv);
> +                       if (-1 == r) {
> +                               if (EINTR == errno)
> +                                       continue;
> +
> +                               perror ("select");
> +                               return errno;
> +                       }
>
> -                       perror ("select");
> -                       return errno;
> +                       if (0 == r) {
> +                               fprintf (stderr, "select timeout\n");
> +                               return errno;
> +                       }
> +
> +                       if (v4l2_rcvbuf(&drv, recebe_buffer))
> +                               break;
>                }
>
> -               if (0 == r) {
> -                       fprintf (stderr, "select timeout\n");
> -                       return errno;
> -               }
> -
> -               if (v4l2_rcvbuf(&drv, recebe_buffer))
> -                       break;
> +               printf("stopping streaming\n");
> +               v4l2_stop_streaming(&drv);
>        }
>
> -       printf("stopping streaming\n");
> -       v4l2_stop_streaming(&drv);
> -
>        if (v4l2_close (&drv)<0) {
>                perror("close");
>                return -1;
>
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
