Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m238Dw98028063
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 03:13:58 -0500
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m238DQf5029231
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 03:13:27 -0500
Received: by gv-out-0910.google.com with SMTP id l14so2348058gvf.13
	for <video4linux-list@redhat.com>; Mon, 03 Mar 2008 00:13:24 -0800 (PST)
Date: Mon, 3 Mar 2008 00:13:05 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080303081305.GA18774@plankton.ifup.org>
References: <54fa1a0d9c5bcdfcb2ba.1204098881@localhost>
	<20679.1204128530@vena.lwn.net>
	<20080228025651.GA16322@plankton.ifup.org>
	<20080229063458.0f49ddb0@areia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20080229063458.0f49ddb0@areia>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] v4l: Deadlock in videobuf-core for DQBUF waiting on QBUF
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


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 06:34 Fri 29 Feb 2008, Mauro Carvalho Chehab wrote:
> On Wed, 27 Feb 2008 18:56:51 -0800
> Brandon Philips <brandon@ifup.org> wrote:
> 
> > On 09:08 Wed 27 Feb 2008, Jonathan Corbet wrote:
> > > Brandon Philips <brandon@ifup.org> wrote:
> > > 
> > > >  	buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
> > > > +	mutex_unlock(&q->vb_lock);
> > > >  	retval = videobuf_waiton(buf, nonblocking, 1);
> > > > +	mutex_lock(&q->vb_lock);
> > > 
> > > Are you sure that this doesn't create a race where two threads could end
> > > up waiting on the same buf?  
> > 
> > You are right... I thought I had thought through this but a race can be
> > created with two threads doing DQBUF.
> > 
> > > Actually, almost anything could happen to buf by the time you've
> > > gotten the mutex back - it might not even exist anymore - but there
> > > are no checks for that.  It seems like a better fix might be to set
> > > nonblocking unconditionally to 1 for the videobuf_waiton() call, then
> > > start over from the beginning on a -EAGAIN return (if the caller has
> > > not requested nonblocking behavior).
> > 
> > Hrm, that is one solution.  I will think about it for a bit and submit a
> > new patch.
> > 
> > Thanks for catching this, I was being stupid.
> > 
> > Mauro: Please don't push this patch out.  Thanks.
> 
> The patch were already applied at the staging tree. I'll keep it there until we
> have a definitive solution. After that, the better would be to fold the both
> patches and send to 2.6.25-rc.

Quick update:

Sorry for the delay I was mentoring my robotics team since Thursday.

I wrote a test program (attached, super hacky) and I have found that the
current vivi can easily hang a kernel on a spinlock even before my
patch...

[  501.674961] vivi: 51946: Underrun, losed 1 frames. Current frame is
2. Will sleep for 5 jiffies
[  542.170534] BUG: spinlock lockup on CPU#0, vivi/17280, cc7ce448
[  542.173473] Pid: 17280, comm: vivi Tainted: P
2.6.25-rc2-default #25
[  542.181500]  [<c02251e1>] _raw_spin_lock+0xa6/0xbf
[  542.189520]  [<cee1ee73>] vivi_vid_timeout+0x18/0x285 [vivi]
[  542.197487]  [<c0332c4f>] _spin_lock_irq+0x21/0x2c
[  542.205477]  [<cee1ee5b>] vivi_vid_timeout+0x0/0x285 [vivi]
[  542.213483]  [<c0121b6e>] run_timer_softirq+0x128/0x180
[  542.221471]  [<cee1ee5b>] vivi_vid_timeout+0x0/0x285 [vivi]
[  542.229539]  [<c011ed81>] __do_softirq+0x3e/0x87
[  542.237489]  [<c011edff>] do_softirq+0x35/0x43
[  542.245479]  [<c011f0b5>] irq_exit+0x25/0x53
[  542.253473]  [<c0110486>] smp_apic_timer_interrupt+0x59/0x61
[  542.261480]  [<c0106918>] apic_timer_interrupt+0x28/0x30
[  542.269535]  [<c02251aa>] _raw_spin_lock+0x6f/0xbf
[  542.277508]  [<cee1e5ff>] vivi_thread+0x1c7/0x712 [vivi]
[  542.285630]  [<c011778f>] default_wake_function+0x0/0x5
[  542.293504]  [<cee1e438>] vivi_thread+0x0/0x712 [vivi]
[  542.301488]  [<c012a175>] kthread+0x36/0x5d
[  542.309476]  [<c012a13f>] kthread+0x0/0x5d
[  542.317483]  [<c0106ac7>] kernel_thread_helper+0x7/0x10
[  542.325511]  =======================

I will work on fixing this tomorrow before fixing the videobuf issue.  I
would like to be able to test my fix before submitting it this time.

Cheers,

	Brandon

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="v4l-thread.c"

/*
 * V4L2 video capture example with pthread qbuf
 * Based on example from v4l2 spec
 *
 * brandon@ifup.org
 *
 * Compile: gcc v4l-thread.c -lpthread -o v4l-thread
 *
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

#include <asm/types.h>          /* for videodev2.h */

#include <linux/videodev2.h>

#define CLEAR(x) memset (&(x), 0, sizeof (x))

typedef enum {
        IO_METHOD_READ,
        IO_METHOD_MMAP,
} io_method;

struct buffer {
        void *                  start;
        size_t                  length;
};

static char *           dev_name        = NULL;
static io_method        io              = IO_METHOD_MMAP;
static int              fd              = -1;
struct buffer *         buffers         = NULL;
static unsigned int     n_buffers       = 0;


static void errno_exit(const char *s)
{
        fprintf (stderr, "%s error %d, %s\n",
                 s, errno, strerror (errno));

        exit (EXIT_FAILURE);
}

static int xioctl (int fd, int request, void *arg)
{
        int r;

        do r = ioctl (fd, request, arg);
        while (-1 == r && EINTR == errno);

        return r;
}

static void process_image  (const void *p)
{
        fputc ('.', stdout);
        fflush (stdout);
}

void *qbuf_thread(void *arg) {
	int retval;
        struct v4l2_buffer buf;
	int i;
	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	buf.memory = V4L2_MEMORY_MMAP;

        while (1) {
		sleep(5);
		for (i = 0; i < n_buffers; i++) {
			buf.index = i;
			retval = xioctl(fd, VIDIOC_QBUF, &buf);
			if (retval < 0)
				printf("QBUF %i %i %s\n", i, errno, strerror (errno));
			else
				printf("QBUF %i\n", i);
		}
        }
}


static int read_frame (void)
{
        struct v4l2_buffer buf;
        unsigned int i;

        switch (io) {
        case IO_METHOD_READ:
                if (-1 == read (fd, buffers[0].start, buffers[0].length)) {
                        switch (errno) {
                        case EAGAIN:
                                return 0;

                        case EIO:
				return 0;

                        default:
                                errno_exit ("read");
                        }
                }

                process_image (buffers[0].start);

                break;

        case IO_METHOD_MMAP:
                CLEAR (buf);

                buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                buf.memory = V4L2_MEMORY_MMAP;

                if (-1 == xioctl (fd, VIDIOC_DQBUF, &buf)) {
                        switch (errno) {
			case 16:
                        case EAGAIN:
                        case EINVAL:
                                return 0;

                        case EIO:
                                /* Could ignore EIO, see spec. */

                                /* fall through */

                        default:
                                errno_exit ("VIDIOC_DQBUF");
                        }
                }

                assert (buf.index < n_buffers);
		printf("DQBUF %i\n", buf.index);
                process_image (buffers[buf.index].start);

                break;
        }

        return 1;
}

static void mainloop (void)
{
        unsigned int count;

        count = 100;

        while (count-- > 0) {
                for (;;) {
                        fd_set fds;
                        struct timeval tv;
                        int r;

                        FD_ZERO (&fds);
                        FD_SET (fd, &fds);

                        /* Timeout. */
                        tv.tv_sec = 2;
                        tv.tv_usec = 0;

                        r = select (fd + 1, &fds, NULL, NULL, &tv);

                        if (-1 == r) {
                                if (EINTR == errno)
                                        continue;

                                errno_exit ("select");
                        }

                        if (0 == r) {
                                fprintf (stderr, "select timeout\n");
                                exit (EXIT_FAILURE);
                        }

                        if (read_frame ())
                                break;

                        /* EAGAIN - continue select loop. */
                }
        }
}

static void stop_capturing (void)
{
        enum v4l2_buf_type type;

        switch (io) {
        case IO_METHOD_READ:
                /* Nothing to do. */
                break;

        case IO_METHOD_MMAP:
                type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

                if (-1 == xioctl (fd, VIDIOC_STREAMOFF, &type))
                        errno_exit ("VIDIOC_STREAMOFF");

                break;
        }
}

static void start_capturing (void)
{
        unsigned int i;
        enum v4l2_buf_type type;
	int retval;

        switch (io) {
        case IO_METHOD_READ:
                /* Nothing to do. */
                break;

        case IO_METHOD_MMAP:
                for (i = 0; i < n_buffers; ++i) {
                        struct v4l2_buffer buf;

                        CLEAR (buf);

                        buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                        buf.memory      = V4L2_MEMORY_MMAP;
                        buf.index       = i;

                        if (-1 == xioctl (fd, VIDIOC_QBUF, &buf))
                                errno_exit ("VIDIOC_QBUF");
                }

                type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

                if (-1 == xioctl (fd, VIDIOC_STREAMON, &type))
                        errno_exit ("VIDIOC_STREAMON");

                break;
        }

	pthread_t q_thread;
	retval = pthread_create (
		&q_thread, NULL, qbuf_thread, NULL);
	if (retval != 0)
		errno_exit("Create interrupt thread");

}

static void uninit_device(void)
{
        unsigned int i;

        switch (io) {
        case IO_METHOD_READ:
                free (buffers[0].start);
                break;

        case IO_METHOD_MMAP:
                for (i = 0; i < n_buffers; ++i)
                        if (-1 == munmap (buffers[i].start, buffers[i].length))
                                errno_exit ("munmap");
                break;

        }

        free (buffers);
}

static void init_read(unsigned int buffer_size)
{
        buffers = calloc (1, sizeof (*buffers));

        if (!buffers) {
                fprintf (stderr, "Out of memory\n");
                exit (EXIT_FAILURE);
        }

        buffers[0].length = buffer_size;
        buffers[0].start = malloc (buffer_size);

        if (!buffers[0].start) {
                fprintf (stderr, "Out of memory\n");
                exit (EXIT_FAILURE);
        }
}

static void init_mmap(void)
{
        struct v4l2_requestbuffers req;

        CLEAR (req);

        req.count               = 4;
        req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        req.memory              = V4L2_MEMORY_MMAP;

        if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) {
                if (EINVAL == errno) {
                        fprintf (stderr, "%s does not support "
                                 "memory mapping\n", dev_name);
                        exit (EXIT_FAILURE);
                } else {
                        errno_exit ("VIDIOC_REQBUFS");
                }
        }

        if (req.count < 2) {
                fprintf (stderr, "Insufficient buffer memory on %s\n",
                         dev_name);
                exit (EXIT_FAILURE);
        }

        buffers = calloc (req.count, sizeof (*buffers));

        if (!buffers) {
                fprintf (stderr, "Out of memory\n");
                exit (EXIT_FAILURE);
        }

        for (n_buffers = 0; n_buffers < req.count; ++n_buffers) {
                struct v4l2_buffer buf;

                CLEAR (buf);

                buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                buf.memory      = V4L2_MEMORY_MMAP;
                buf.index       = n_buffers;

                if (-1 == xioctl (fd, VIDIOC_QUERYBUF, &buf))
                        errno_exit ("VIDIOC_QUERYBUF");

                buffers[n_buffers].length = buf.length;
                buffers[n_buffers].start =
                        mmap (NULL /* start anywhere */,
                              buf.length,
                              PROT_READ | PROT_WRITE /* required */,
                              MAP_SHARED /* recommended */,
                              fd, buf.m.offset);

                if (MAP_FAILED == buffers[n_buffers].start)
                        errno_exit ("mmap");
        }
}

static void init_device(void)
{
        struct v4l2_capability cap;
        struct v4l2_cropcap cropcap;
        struct v4l2_crop crop;
        struct v4l2_format fmt;
        unsigned int min;

        if (-1 == xioctl (fd, VIDIOC_QUERYCAP, &cap)) {
                if (EINVAL == errno) {
                        fprintf (stderr, "%s is no V4L2 device\n",
                                 dev_name);
                        exit (EXIT_FAILURE);
                } else {
                        errno_exit ("VIDIOC_QUERYCAP");
                }
        }

        if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE)) {
                fprintf (stderr, "%s is no video capture device\n",
                         dev_name);
                exit (EXIT_FAILURE);
        }

        switch (io) {
        case IO_METHOD_READ:
                if (!(cap.capabilities & V4L2_CAP_READWRITE)) {
                        fprintf (stderr, "%s does not support read i/o\n",
                                 dev_name);
                        exit (EXIT_FAILURE);
                }

                break;

        case IO_METHOD_MMAP:
                if (!(cap.capabilities & V4L2_CAP_STREAMING)) {
                        fprintf (stderr, "%s does not support streaming i/o\n",
                                 dev_name);
                        exit (EXIT_FAILURE);
                }

                break;
        }

        /* Select video input, video standard and tune here. */

        cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

        if (-1 == xioctl (fd, VIDIOC_CROPCAP, &cropcap)) {
                /* Errors ignored. */
        }

        crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        crop.c = cropcap.defrect; /* reset to default */

        if (-1 == xioctl (fd, VIDIOC_S_CROP, &crop)) {
                switch (errno) {
                case EINVAL:
                        /* Cropping not supported. */
                        break;
                default:
                        /* Errors ignored. */
                        break;
                }
        }

        CLEAR (fmt);

        fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        fmt.fmt.pix.width       = 640;
        fmt.fmt.pix.height      = 480;
        fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
        fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;

        if (-1 == xioctl (fd, VIDIOC_S_FMT, &fmt))
                errno_exit ("VIDIOC_S_FMT");

        /* Note VIDIOC_S_FMT may change width and height. */

        /* Buggy driver paranoia. */
        min = fmt.fmt.pix.width * 2;
        if (fmt.fmt.pix.bytesperline < min)
                fmt.fmt.pix.bytesperline = min;
        min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
        if (fmt.fmt.pix.sizeimage < min)
                fmt.fmt.pix.sizeimage = min;

        switch (io) {
        case IO_METHOD_READ:
                init_read (fmt.fmt.pix.sizeimage);
                break;

        case IO_METHOD_MMAP:
                init_mmap ();
                break;

        }
}

static void close_device(void)
{
        if (-1 == close (fd))
                errno_exit ("close");

        fd = -1;
}

static void open_device(void)
{
        struct stat st;

        if (-1 == stat (dev_name, &st)) {
                fprintf (stderr, "Cannot identify '%s': %d, %s\n",
                         dev_name, errno, strerror (errno));
                exit (EXIT_FAILURE);
        }

        if (!S_ISCHR (st.st_mode)) {
                fprintf (stderr, "%s is no device\n", dev_name);
                exit (EXIT_FAILURE);
        }

        fd = open (dev_name, O_RDWR /* required */ | O_NONBLOCK, 0);

        if (-1 == fd) {
                fprintf (stderr, "Cannot open '%s': %d, %s\n",
                         dev_name, errno, strerror (errno));
                exit (EXIT_FAILURE);
        }
}

static void usage(FILE *fp, int argc, char **argv)
{
        fprintf (fp,
                 "Usage: %s [options]\n\n"
                 "Options:\n"
                 "-d | --device name   Video device name [/dev/video]\n"
                 "-h | --help          Print this message\n"
                 "-m | --mmap          Use memory mapped buffers\n"
                 "-r | --read          Use read() calls\n"
                 "-u | --userp         Use application allocated buffers\n"
                 "",
                 argv[0]);
}

static const char short_options [] = "d:hmru";

static const struct option
long_options [] = {
	{ "device",	required_argument,	NULL,	'd' },
	{ "help",	no_argument,		NULL,	'h' },
	{ "mmap",	no_argument,		NULL,	'm' }, 
	{ "read",	no_argument,		NULL,	'r' }, 
	{ "userp",	no_argument,		NULL,	'u' },
	{ 0, 0, 0, 0 }
};

int main (int argc, char **argv)
{
        dev_name = "/dev/video";

        for (;;) {
                int index;
                int c;

                c = getopt_long (argc, argv,
                                 short_options, long_options,
                                 &index);

                if (-1 == c)
                        break;

                switch (c) {
                case 0: /* getopt_long() flag */
                        break;

                case 'd':
                        dev_name = optarg;
                        break;

                case 'h':
                        usage (stdout, argc, argv);
                        exit (EXIT_SUCCESS);

                case 'm':
                        io = IO_METHOD_MMAP;
                        break;

                case 'r':
                        io = IO_METHOD_READ;
                        break;

                default:
                        usage (stderr, argc, argv);
                        exit (EXIT_FAILURE);
                }
        }

        open_device ();
        init_device ();
        start_capturing ();
        mainloop ();
        stop_capturing ();
        uninit_device ();
        close_device ();
        exit (EXIT_SUCCESS);

        return 0;
}


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--EeQfGwPcQSOJBaQU--
