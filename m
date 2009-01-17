Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0H0KrC0027809
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 19:20:53 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0H0Kdpg004003
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 19:20:39 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1967137wfc.6
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 16:20:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c785bba30901121717p2a822291u39524a21b61b7b42@mail.gmail.com>
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<c785bba30812311444l65b3825aq844b79dd6f420c09@mail.gmail.com>
	<412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
	<c785bba30901020850y51c7b9d2i47fd418828cd150c@mail.gmail.com>
	<c785bba30901030922y17d67d0bm822304a650a0e812@mail.gmail.com>
	<c785bba30901051633g7808197fl6d377420d799120c@mail.gmail.com>
	<c785bba30901070927x9be4bdcr84ceb792ccac7afb@mail.gmail.com>
	<412bdbff0901071024p7a16343cha01c09ea6ae2b5a2@mail.gmail.com>
	<20090107235058.15bf6fa9@pedra.chehab.org>
	<c785bba30901121717p2a822291u39524a21b61b7b42@mail.gmail.com>
Date: Fri, 16 Jan 2009 17:20:39 -0700
Message-ID: <c785bba30901161620x28b6b22i53e6540fc362db5c@mail.gmail.com>
From: Paul Thomas <pthomas8589@gmail.com>
To: video4linux-list <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: em28xx issues
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

On Mon, Jan 12, 2009 at 6:17 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
> On Wed, Jan 7, 2009 at 6:50 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> On Wed, 7 Jan 2009 13:24:10 -0500
>> "Devin Heitmueller" <devin.heitmueller@gmail.com> wrote:
>>
>>> A quick look at the code does show something interesting:
>>>
>>> There are a number of cases where we dereference the result of the
>>> "INPUT" macro as follows without checking the number of inputs
>>> defined:
>>>
>>> route.input = INPUT(index)->vmux;
>>>
>>> and here is the macro definition:
>>>
>>> #define INPUT(nr) (&em28xx_boards[dev->model].input[nr])
>>>
>>> It may be the case that a NULL pointer deference would occur if there
>>> was only one input defined (as is the case for the PointNix camera).
>>>
>>> As a test, you might want to copy the other two inputs for the
>>> PointNix device profile from some other device, and see if you still
>>> hits an oops during input selection.
>>
>> I've reviewed the input stuff at em28xx driver, to avoid accessing input
>> entries that aren't defined (so, filled with zeros).
>>
>> Cheers,
>> Mauro
>>
>
> So, I'm finally able to get the source to compile again. I'm now using
> a gcc 4.3.2 cross-compiler instead of a gcc 3.4.5. The three things
> that make it work nicely are to use the "make release DIR=" command,
> add "ARCH=arm CROSS_COMPILE=arm-unknown-gnu-" to the v4l-dvb make
> command and finally run "make install" from the embedded side.
>
> Anyway, I still get the oops with the latest tree. Also did some more
> tests on my x86_64 box it looks like I have to run ucview before
> fswebcam will work.
>
> Is there any way this is being caused by improper ioctl calls from user-space?
>
> The other thing that is odd is that there seems to be a need for some
> physical memory. I have 512MB of swap space, but unless I have > 6MB
> of physical memory I get a "Cannot allocate memory" error.
>
> thanks,
> Paul
>

I think some of this could be seen from the backtrace I posted before,
but I can clarify a little. I've been putting printks in the kernel to
follow the error.

The calling user space function from fswebcam is ioctl(s->fd,
VIDIOC_QBUF, &s->buf)

In v4l2-ioctl.c in the VIDIOC_QBUF case it gets to the
"ops->vidioc_qbuf(file, fh, p)" call

In em28xx-video.c in function vidioc_qbuf the return line "return
(videobuf_qbuf(&fh->vb_vidq, b));" calls videobuf_qbuf

In videobuf-core.c in function videobuf_qbuf it gets to "retval =
q->ops->buf_prepare(q, buf, field);"

in em28xx-video.c in function buffer_prepare it gets to "rc =
em28xx_init_isoc(dev, EM28XX_NUM_PACKETS,
				      EM28XX_NUM_BUFS, dev->max_pkt_size,
				      em28xx_isoc_copy);"

in em28xx-core.c in function em28xx_init_isoc it gets to "rc =
usb_submit_urb(dev->isoc_ctl.urb[i], GFP_ATOMIC);"

The last to functions I didn't trace because they were called to much,
but the backtrace says they are usb_hcd_submit_urb and finally
dma_cache_maint.

I'll try and add some more debugging in to see if I can see anything
else. Also I got a usbvision board that does the exact same thing, but
I haven't followed the call chain on it. The virtual driver works fine
with fswebcam.

I've seen a lot of the OMAP patches running around, but has anyone
else have good success using arm?

thanks,
Paul

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
