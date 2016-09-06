Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp001.me.com ([17.143.181.10]:41190 "EHLO
        pv33p04im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964886AbcIFR1g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 13:27:36 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp001.me.com by
 pv33p04im-asmtp001.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0OD300D00F2PB600@pv33p04im-asmtp001.me.com> for
 linux-media@vger.kernel.org; Tue, 06 Sep 2016 17:27:06 +0000 (GMT)
Content-type: multipart/mixed;
 boundary="Apple-Mail=_D3B7BAF3-82F6-4AF3-BAAB-4BC3CB73B724"
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
From: Oliver Collyer <ovcollyer@mac.com>
In-reply-to: <20160906122823.toxscjyxomrh2col@zver>
Date: Tue, 06 Sep 2016 20:26:58 +0300
Cc: linux-media@vger.kernel.org, Support INOGENI <support@inogeni.com>,
        james.liu@magewell.net
Message-id: <8058B4B1-CCE4-4A68-B777-05CE37A1BB2D@mac.com>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
 <20160905201935.wpgtrtt7e4bjjylo@zver>
 <FE81AFD0-C5F1-4FE7-A282-3294E668066C@mac.com>
 <20160906122823.toxscjyxomrh2col@zver>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail=_D3B7BAF3-82F6-4AF3-BAAB-4BC3CB73B724
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

[Resent without HTML content]

> On 6 Sep 2016, at 15:28, Andrey Utkin <andrey_utkin@fastmail.com> =
wrote:
>=20
> On Tue, Sep 06, 2016 at 01:51:51PM +0300, Oliver Collyer wrote:
>> So today I installed Ubuntu 16.04 on another PC (this one a high spec =
machine with a Rampage V Extreme motherboard) and I reproduced exactly =
the same errors and trace.
>>=20
>> Rebooting the same PC back into Windows 10 and using the same USB 3.0 =
port, I had no problems capturing using FFmpeg via DirectShow. I could =
start and stop the capture repeatedly without any warnings or errors =
appearing in FFmpeg (built from the same source).
>>=20
>> If the hardware is misbehaving, on both these capture devices, then =
DS must be handling it better than V4L2. Or there is simply an obscure =
bug in V4L2 which only manifests itself with certain devices.
>>=20
>> Would providing ssh access to the machine be of interest to anyone =
who wants to debug this?
>=20
> I am curious to tinker with this, just not sure about free time for =
it.
> Please go through the following instruction, and then we'll see if ssh
> is going to help to debug this.
>=20
> Also I think it is worth to CC actual manufacturers. There are =
addresses
> for technical support of both devices in public on maker websites.
> Please CC them when replying with new logs, to let them catch up.
>=20
> So, I am still not certain what confuses the device, i.e. where the
> faulty usage pattern comes from: ffmpeg or driver. So I'd like you to
> check the difference with various userspace applications which involve
> streaming from device.
>=20
> For each of your two devices, alone (not two at same time), do this:
>=20
> For each command from this list:
> "v4l2-compliance -s -d /dev/video0",
> "ffmpeg -f v4l2 -i /dev/video0 -vcodec rawvideo -f null -y /dev/null",
> "<what you referred to as 'capture API example'>"
> (feel free to add more, maybe mplayer invocation or such)
>=20
> dmesg -C
> plug in the device
> modprobe uvcvideo module
> run the command twice or more in row
> save uncut commands output (with command lines) to separate file
> rmmod uvcvideo
> unplug the device
> save "dmesg" output to separate file
>=20
>=20
> Done.
>=20
> I guess this test makes sense, or am I missing something you've =
already
> told us?
>=20
> If you go making a script for this, make sure to notice if rmmod fails
> for any reason, etc.

Hi Andrey

Thanks for your response and suggestions for tests.

Attached is an archive containing the log files you requested.

I did modify the test regime slightly as follows:

dmesg -C
plug in the device
modprobe -v uvcvideo
run the command once (1)
modprobe -v -r uvcvideo
modprobe -v uvcvideo
run the command again (2)
run the command again (3)
save uncut commands output (with command lines) to separate file
modprobe -v -r uvcvideo
unplug the device
save =E2=80=9Cdmesg=E2=80=9D output to separate file

The reason for the additional unload/load of the uvcvideo module after =
running command (1) is because I was finding that this command was =
producing the error straightaway with the Magewell device and it took =
another unload/reload sequence to produce the next error free command =
(2). The next command (3) then brings back the error. However, this did =
vary with the inogeni device - in this case, the (1) and (2) didn=E2=80=99=
t produce the error, but (3) did. Except in the case of the ffmpeg test =
which followed the same pattern as the Magewell device.

The other difference between the Magewell and Inogeni tests was in the =
case of the Inogeni it seems that even when the error didn=E2=80=99t =
occur, ffmpeg was still producing other warnings and errors relating to =
the capture that the Magewell didn=E2=80=99t produce, which appear to =
relate to timestamps.

The example capture comes from this page on the V4L2 wiki:

https://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html

=E2=80=A6with the addition of these lines from line 125:

		if (buf.flags & V4L2_BUF_FLAG_ERROR ) {
                	fprintf(stderr, "corrupt buffer\n");
		}

The capture example doesn=E2=80=99t do anything with the output so even =
if it was corrupt it wouldn=E2=80=99t make any difference, thus I=E2=80=99=
ve added some trace to flag the error.

For reference/your own testing I=E2=80=99ve attached it to this mail =
too.

In summary:

- both devices produce the Error -71 error leading to the =
V4L2_BUF_FLAG_ERROR error under similar circumstances, but =
unloading/reloading the uvcvideo module gets rid of it for one time =
only.
- the error state occurs in both the capture example and FFmpeg.
- the compliance outputs produces some warnings and errors for both =
devices, but I don=E2=80=99t know their significance.

Regards

Oliver

PS I=E2=80=99ve copied in support from Magewell and Inogeni - please =
refer to the linux-media archives for the full history of this =
discussion concerning capture issues in FFmpeg with your devices, when =
using V4L2.

http://www.spinics.net/lists/linux-media/msg105073.html


--Apple-Mail=_D3B7BAF3-82F6-4AF3-BAAB-4BC3CB73B724
Content-Disposition: attachment;
	filename=v4l2_capture_logs.zip
Content-Type: application/zip;
	name="v4l2_capture_logs.zip"
Content-Transfer-Encoding: base64

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
oajHWBa8P1XePlJigWD7SuTfRqxZXtLHTmpaVW32SF+zuu34v+PdosM8UB4cLIMODmTFuOPbEfa5
PgucFesbVjl5r9xxR2MZ/9urFr5lsTq9pU7rTOc8kCd1fC0e0p/SHdLfeD0HRTgS4VtdSp46yAVn
4oP285A9x6fa8an2gp5qB3wvha4deeE8DL7n95JPi+N76Qd/L3lu8Lz30swOome9l0LfDf6399Kx
gxw7yAvqIE/82J+lPntBP/YjH387+WHof8fNa5YG5Ni8fvTm5bvPbV7xU80rvNe84sBz/7PmZfwN
UEsHCI9+hiJxBAAAqxYAAFBLAQIVAxQACAAIAECgJknfZBZ0WgMAAHYJAAAdAAwAAAAAAAAAAEDA
gQAAAABpbm9nZW5pX2FwaV9leGFtcGxlX2RtZXNnLnR4dFVYCACI9s5XiPbOV1BLAQIVAxQACAAI
ADOgJknEGx7w6AAAAGkEAAAeAAwAAAAAAAAAAEDAgbUDAABpbm9nZW5pX2FwaV9leGFtcGxlX291
dHB1dC50eHRVWAgAcfbOV3H2zldQSwECFQMUAAgACABmnyZJf0svu1ADAAC8CAAAHAAMAAAAAAAA
AABAwIH5BAAAaW5vZ2VuaV9jb21wbGlhbmNlX2RtZXNnLnR4dFVYCADg9c5X4PXOV1BLAQIVAxQA
CAAIABqfJkl4tQ2VLwQAAHQXAAAYAAwAAAAAAAAAAEDAgaMIAABpbm9nZW5pX2ZmbXBlZ19kbWVz
Zy50eHRVWAgAVPXOV1T1zldQSwECFQMUAAgACABFnyZJT3/PKoYFAAADKAAAHQAMAAAAAAAAAABA
wIEoDQAAaW5vZ2VuaV9jb21wbGlhbmNlX291dHB1dC50eHRVWAgAovXOV6L1zldQSwECFQMUAAgA
CAAJnyZJy4KLfwgFAACaGQAAGQAMAAAAAAAAAABAwIEJEwAAaW5vZ2VuaV9mZm1wZWdfb3V0cHV0
LnR4dFVYCAAy9c5XMvXOV1BLAQIVAxQACAAIAJWeJklC193JEgMAANAJAAAeAAwAAAAAAAAAAEDA
gWgYAABtYWdld2VsbF9hcGlfZXhhbXBsZV9kbWVzZy50eHRVWAgAWvTOV1r0zldQSwECFQMUAAgA
CAAyniZJJqIip+sAAACiBAAAHwAMAAAAAAAAAABAwIHWGwAAbWFnZXdlbGxfYXBpX2V4YW1wbGVf
b3V0cHV0LnR4dFVYCACf885Xn/POV1BLAQIVAxQACAAIAMCcJkko1LUaEgMAAP0HAAAdAAwAAAAA
AAAAAEDAgR4dAABtYWdld2VsbF9jb21wbGlhbmNlX2RtZXNnLnR4dFVYCADo8M5X6PDOV1BLAQIV
AxQACAAIAPecJkkjjfXNhAUAAOInAAAeAAwAAAAAAAAAAEDAgYsgAABtYWdld2VsbF9jb21wbGlh
bmNlX291dHB1dC50eHRVWAgAUvHOV1LxzldQSwECFQMUAAgACAAwnCZJ4D4717kDAACIFgAAGQAM
AAAAAAAAAABAwIFrJgAAbWFnZXdlbGxfZmZtcGVnX2RtZXNnLnR4dFVYCADb785X2+/OV1BLAQIV
AxQACAAIAOCcJkmPfoYicQQAAKsWAAAaAAwAAAAAAAAAAEDAgXsqAABtYWdld2VsbF9mZm1wZWdf
b3V0cHV0LnR4dFVYCAAk8c5XJPHOV1BLBQYAAAAADAAMAAgEAABELwAAAAA=
--Apple-Mail=_D3B7BAF3-82F6-4AF3-BAAB-4BC3CB73B724
Content-Disposition: attachment;
	filename=capture_example.c
Content-Type: application/octet-stream;
	name="capture_example.c"
Content-Transfer-Encoding: 7bit

/*
 *  V4L2 video capture example
 *
 *  This program can be used and distributed without restrictions.
 *
 *      This program is provided with the V4L2 API
 * see https://linuxtv.org/docs.php for more information
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <getopt.h>             /* getopt_long() */

#include <fcntl.h>              /* low-level i/o */
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

#include <linux/videodev2.h>

#define CLEAR(x) memset(&(x), 0, sizeof(x))

enum io_method {
        IO_METHOD_READ,
        IO_METHOD_MMAP,
        IO_METHOD_USERPTR,
};

struct buffer {
        void   *start;
        size_t  length;
};

static char            *dev_name;
static enum io_method   io = IO_METHOD_MMAP;
static int              fd = -1;
struct buffer          *buffers;
static unsigned int     n_buffers;
static int              out_buf;
static int              force_format;
static int              frame_count = 70;

static void errno_exit(const char *s)
{
        fprintf(stderr, "%s error %d, %s\n", s, errno, strerror(errno));
        exit(EXIT_FAILURE);
}

static int xioctl(int fh, int request, void *arg)
{
        int r;

        do {
                r = ioctl(fh, request, arg);
        } while (-1 == r && EINTR == errno);

        return r;
}

static void process_image(const void *p, int size)
{
        if (out_buf)
                fwrite(p, size, 1, stdout);

        fflush(stderr);
        fprintf(stderr, ".");
        fflush(stdout);
}

static int read_frame(void)
{
        struct v4l2_buffer buf;
        unsigned int i;

        switch (io) {
        case IO_METHOD_READ:
                if (-1 == read(fd, buffers[0].start, buffers[0].length)) {
                        switch (errno) {
                        case EAGAIN:
                                return 0;

                        case EIO:
                                /* Could ignore EIO, see spec. */

                                /* fall through */

                        default:
                                errno_exit("read");
                        }
                }

                process_image(buffers[0].start, buffers[0].length);
                break;

        case IO_METHOD_MMAP:
                CLEAR(buf);

                buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                buf.memory = V4L2_MEMORY_MMAP;

                if (-1 == xioctl(fd, VIDIOC_DQBUF, &buf)) {
                        switch (errno) {
                        case EAGAIN:
                                return 0;

                        case EIO:
                                /* Could ignore EIO, see spec. */

                                /* fall through */

                        default:
                                errno_exit("VIDIOC_DQBUF");
                        }
                }

                assert(buf.index < n_buffers);

		if (buf.flags & V4L2_BUF_FLAG_ERROR ) {
                	fprintf(stderr, "corrupt buffer\n");
		}

                process_image(buffers[buf.index].start, buf.bytesused);

                if (-1 == xioctl(fd, VIDIOC_QBUF, &buf))
                        errno_exit("VIDIOC_QBUF");
                break;

        case IO_METHOD_USERPTR:
                CLEAR(buf);

                buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                buf.memory = V4L2_MEMORY_USERPTR;

                if (-1 == xioctl(fd, VIDIOC_DQBUF, &buf)) {
                        switch (errno) {
                        case EAGAIN:
                                return 0;

                        case EIO:
                                /* Could ignore EIO, see spec. */

                                /* fall through */

                        default:
                                errno_exit("VIDIOC_DQBUF");
                        }
                }

                for (i = 0; i < n_buffers; ++i)
                        if (buf.m.userptr == (unsigned long)buffers[i].start
                            && buf.length == buffers[i].length)
                                break;

                assert(i < n_buffers);

                process_image((void *)buf.m.userptr, buf.bytesused);

                if (-1 == xioctl(fd, VIDIOC_QBUF, &buf))
                        errno_exit("VIDIOC_QBUF");
                break;
        }

        return 1;
}

static void mainloop(void)
{
        unsigned int count;

        count = frame_count;

        while (count-- > 0) {
                for (;;) {
                        fd_set fds;
                        struct timeval tv;
                        int r;

                        FD_ZERO(&fds);
                        FD_SET(fd, &fds);

                        /* Timeout. */
                        tv.tv_sec = 2;
                        tv.tv_usec = 0;

                        r = select(fd + 1, &fds, NULL, NULL, &tv);

                        if (-1 == r) {
                                if (EINTR == errno)
                                        continue;
                                errno_exit("select");
                        }

                        if (0 == r) {
                                fprintf(stderr, "select timeout\n");
                                exit(EXIT_FAILURE);
                        }

                        if (read_frame())
                                break;
                        /* EAGAIN - continue select loop. */
                }
        }
}

static void stop_capturing(void)
{
        enum v4l2_buf_type type;

        switch (io) {
        case IO_METHOD_READ:
                /* Nothing to do. */
                break;

        case IO_METHOD_MMAP:
        case IO_METHOD_USERPTR:
                type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                if (-1 == xioctl(fd, VIDIOC_STREAMOFF, &type))
                        errno_exit("VIDIOC_STREAMOFF");
                break;
        }
}

static void start_capturing(void)
{
        unsigned int i;
        enum v4l2_buf_type type;

        switch (io) {
        case IO_METHOD_READ:
                /* Nothing to do. */
                break;

        case IO_METHOD_MMAP:
                for (i = 0; i < n_buffers; ++i) {
                        struct v4l2_buffer buf;

                        CLEAR(buf);
                        buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                        buf.memory = V4L2_MEMORY_MMAP;
                        buf.index = i;

                        if (-1 == xioctl(fd, VIDIOC_QBUF, &buf))
                                errno_exit("VIDIOC_QBUF");
                }
                type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                if (-1 == xioctl(fd, VIDIOC_STREAMON, &type))
                        errno_exit("VIDIOC_STREAMON");
                break;

        case IO_METHOD_USERPTR:
                for (i = 0; i < n_buffers; ++i) {
                        struct v4l2_buffer buf;

                        CLEAR(buf);
                        buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                        buf.memory = V4L2_MEMORY_USERPTR;
                        buf.index = i;
                        buf.m.userptr = (unsigned long)buffers[i].start;
                        buf.length = buffers[i].length;

                        if (-1 == xioctl(fd, VIDIOC_QBUF, &buf))
                                errno_exit("VIDIOC_QBUF");
                }
                type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                if (-1 == xioctl(fd, VIDIOC_STREAMON, &type))
                        errno_exit("VIDIOC_STREAMON");
                break;
        }
}

static void uninit_device(void)
{
        unsigned int i;

        switch (io) {
        case IO_METHOD_READ:
                free(buffers[0].start);
                break;

        case IO_METHOD_MMAP:
                for (i = 0; i < n_buffers; ++i)
                        if (-1 == munmap(buffers[i].start, buffers[i].length))
                                errno_exit("munmap");
                break;

        case IO_METHOD_USERPTR:
                for (i = 0; i < n_buffers; ++i)
                        free(buffers[i].start);
                break;
        }

        free(buffers);
}

static void init_read(unsigned int buffer_size)
{
        buffers = calloc(1, sizeof(*buffers));

        if (!buffers) {
                fprintf(stderr, "Out of memory\n");
                exit(EXIT_FAILURE);
        }

        buffers[0].length = buffer_size;
        buffers[0].start = malloc(buffer_size);

        if (!buffers[0].start) {
                fprintf(stderr, "Out of memory\n");
                exit(EXIT_FAILURE);
        }
}

static void init_mmap(void)
{
        struct v4l2_requestbuffers req;

        CLEAR(req);

        req.count = 4;
        req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        req.memory = V4L2_MEMORY_MMAP;

        if (-1 == xioctl(fd, VIDIOC_REQBUFS, &req)) {
                if (EINVAL == errno) {
                        fprintf(stderr, "%s does not support "
                                 "memory mapping\n", dev_name);
                        exit(EXIT_FAILURE);
                } else {
                        errno_exit("VIDIOC_REQBUFS");
                }
        }

        if (req.count < 2) {
                fprintf(stderr, "Insufficient buffer memory on %s\n",
                         dev_name);
                exit(EXIT_FAILURE);
        }

        buffers = calloc(req.count, sizeof(*buffers));

        if (!buffers) {
                fprintf(stderr, "Out of memory\n");
                exit(EXIT_FAILURE);
        }

        for (n_buffers = 0; n_buffers < req.count; ++n_buffers) {
                struct v4l2_buffer buf;

                CLEAR(buf);

                buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                buf.memory      = V4L2_MEMORY_MMAP;
                buf.index       = n_buffers;

                if (-1 == xioctl(fd, VIDIOC_QUERYBUF, &buf))
                        errno_exit("VIDIOC_QUERYBUF");

                buffers[n_buffers].length = buf.length;
                buffers[n_buffers].start =
                        mmap(NULL /* start anywhere */,
                              buf.length,
                              PROT_READ | PROT_WRITE /* required */,
                              MAP_SHARED /* recommended */,
                              fd, buf.m.offset);

                if (MAP_FAILED == buffers[n_buffers].start)
                        errno_exit("mmap");
        }
}

static void init_userp(unsigned int buffer_size)
{
        struct v4l2_requestbuffers req;

        CLEAR(req);

        req.count  = 4;
        req.type   = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        req.memory = V4L2_MEMORY_USERPTR;

        if (-1 == xioctl(fd, VIDIOC_REQBUFS, &req)) {
                if (EINVAL == errno) {
                        fprintf(stderr, "%s does not support "
                                 "user pointer i/o\n", dev_name);
                        exit(EXIT_FAILURE);
                } else {
                        errno_exit("VIDIOC_REQBUFS");
                }
        }

        buffers = calloc(4, sizeof(*buffers));

        if (!buffers) {
                fprintf(stderr, "Out of memory\n");
                exit(EXIT_FAILURE);
        }

        for (n_buffers = 0; n_buffers < 4; ++n_buffers) {
                buffers[n_buffers].length = buffer_size;
                buffers[n_buffers].start = malloc(buffer_size);

                if (!buffers[n_buffers].start) {
                        fprintf(stderr, "Out of memory\n");
                        exit(EXIT_FAILURE);
                }
        }
}

static void init_device(void)
{
        struct v4l2_capability cap;
        struct v4l2_cropcap cropcap;
        struct v4l2_crop crop;
        struct v4l2_format fmt;
        unsigned int min;

        if (-1 == xioctl(fd, VIDIOC_QUERYCAP, &cap)) {
                if (EINVAL == errno) {
                        fprintf(stderr, "%s is no V4L2 device\n",
                                 dev_name);
                        exit(EXIT_FAILURE);
                } else {
                        errno_exit("VIDIOC_QUERYCAP");
                }
        }

        if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE)) {
                fprintf(stderr, "%s is no video capture device\n",
                         dev_name);
                exit(EXIT_FAILURE);
        }

        switch (io) {
        case IO_METHOD_READ:
                if (!(cap.capabilities & V4L2_CAP_READWRITE)) {
                        fprintf(stderr, "%s does not support read i/o\n",
                                 dev_name);
                        exit(EXIT_FAILURE);
                }
                break;

        case IO_METHOD_MMAP:
        case IO_METHOD_USERPTR:
                if (!(cap.capabilities & V4L2_CAP_STREAMING)) {
                        fprintf(stderr, "%s does not support streaming i/o\n",
                                 dev_name);
                        exit(EXIT_FAILURE);
                }
                break;
        }


        /* Select video input, video standard and tune here. */


        CLEAR(cropcap);

        cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

        if (0 == xioctl(fd, VIDIOC_CROPCAP, &cropcap)) {
                crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                crop.c = cropcap.defrect; /* reset to default */

                if (-1 == xioctl(fd, VIDIOC_S_CROP, &crop)) {
                        switch (errno) {
                        case EINVAL:
                                /* Cropping not supported. */
                                break;
                        default:
                                /* Errors ignored. */
                                break;
                        }
                }
        } else {
                /* Errors ignored. */
        }


        CLEAR(fmt);

        fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        if (force_format) {
                fmt.fmt.pix.width       = 640;
                fmt.fmt.pix.height      = 480;
                fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
                fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;

                if (-1 == xioctl(fd, VIDIOC_S_FMT, &fmt))
                        errno_exit("VIDIOC_S_FMT");

                /* Note VIDIOC_S_FMT may change width and height. */
        } else {
                /* Preserve original settings as set by v4l2-ctl for example */
                if (-1 == xioctl(fd, VIDIOC_G_FMT, &fmt))
                        errno_exit("VIDIOC_G_FMT");
        }

        /* Buggy driver paranoia. */
        min = fmt.fmt.pix.width * 2;
        if (fmt.fmt.pix.bytesperline < min)
                fmt.fmt.pix.bytesperline = min;
        min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
        if (fmt.fmt.pix.sizeimage < min)
                fmt.fmt.pix.sizeimage = min;

        switch (io) {
        case IO_METHOD_READ:
                init_read(fmt.fmt.pix.sizeimage);
                break;

        case IO_METHOD_MMAP:
                init_mmap();
                break;

        case IO_METHOD_USERPTR:
                init_userp(fmt.fmt.pix.sizeimage);
                break;
        }
}

static void close_device(void)
{
        if (-1 == close(fd))
                errno_exit("close");

        fd = -1;
}

static void open_device(void)
{
        struct stat st;

        if (-1 == stat(dev_name, &st)) {
                fprintf(stderr, "Cannot identify '%s': %d, %s\n",
                         dev_name, errno, strerror(errno));
                exit(EXIT_FAILURE);
        }

        if (!S_ISCHR(st.st_mode)) {
                fprintf(stderr, "%s is no device\n", dev_name);
                exit(EXIT_FAILURE);
        }

        fd = open(dev_name, O_RDWR /* required */ | O_NONBLOCK, 0);

        if (-1 == fd) {
                fprintf(stderr, "Cannot open '%s': %d, %s\n",
                         dev_name, errno, strerror(errno));
                exit(EXIT_FAILURE);
        }
}

static void usage(FILE *fp, int argc, char **argv)
{
        fprintf(fp,
                 "Usage: %s [options]\n\n"
                 "Version 1.3\n"
                 "Options:\n"
                 "-d | --device name   Video device name [%s]\n"
                 "-h | --help          Print this message\n"
                 "-m | --mmap          Use memory mapped buffers [default]\n"
                 "-r | --read          Use read() calls\n"
                 "-u | --userp         Use application allocated buffers\n"
                 "-o | --output        Outputs stream to stdout\n"
                 "-f | --format        Force format to 640x480 YUYV\n"
                 "-c | --count         Number of frames to grab [%i]\n"
                 "",
                 argv[0], dev_name, frame_count);
}

static const char short_options[] = "d:hmruofc:";

static const struct option
long_options[] = {
        { "device", required_argument, NULL, 'd' },
        { "help",   no_argument,       NULL, 'h' },
        { "mmap",   no_argument,       NULL, 'm' },
        { "read",   no_argument,       NULL, 'r' },
        { "userp",  no_argument,       NULL, 'u' },
        { "output", no_argument,       NULL, 'o' },
        { "format", no_argument,       NULL, 'f' },
        { "count",  required_argument, NULL, 'c' },
        { 0, 0, 0, 0 }
};

int main(int argc, char **argv)
{
        dev_name = "/dev/video0";

        for (;;) {
                int idx;
                int c;

                c = getopt_long(argc, argv,
                                short_options, long_options, &idx);

                if (-1 == c)
                        break;

                switch (c) {
                case 0: /* getopt_long() flag */
                        break;

                case 'd':
                        dev_name = optarg;
                        break;

                case 'h':
                        usage(stdout, argc, argv);
                        exit(EXIT_SUCCESS);

                case 'm':
                        io = IO_METHOD_MMAP;
                        break;

                case 'r':
                        io = IO_METHOD_READ;
                        break;

                case 'u':
                        io = IO_METHOD_USERPTR;
                        break;

                case 'o':
                        out_buf++;
                        break;

                case 'f':
                        force_format++;
                        break;

                case 'c':
                        errno = 0;
                        frame_count = strtol(optarg, NULL, 0);
                        if (errno)
                                errno_exit(optarg);
                        break;

                default:
                        usage(stderr, argc, argv);
                        exit(EXIT_FAILURE);
                }
        }

        open_device();
        init_device();
        start_capturing();
        mainloop();
        stop_capturing();
        uninit_device();
        close_device();
       fprintf(stderr, "\n");
        return 0;
}

--Apple-Mail=_D3B7BAF3-82F6-4AF3-BAAB-4BC3CB73B724--
