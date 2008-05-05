Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45FHEaB006668
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 11:17:14 -0400
Received: from hoboi3bl4.telenet-ops.be (hoboi3bl4.telenet-ops.be
	[195.130.137.79])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m45FH1pm024959
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 11:17:01 -0400
Received: from hoboe1bl6.telenet-ops.be (hoboe1bl6.telenet-ops.be
	[195.130.136.41])
	by hoboi3bl4.telenet-ops.be (Postfix) with ESMTP id 1C29013C00E
	for <video4linux-list@redhat.com>;
	Mon,  5 May 2008 17:17:01 +0200 (CEST)
Received: from nocme1bl6.telenet-ops.be (localhost.localdomain [127.0.0.1])
	by hoboe1bl6.telenet-ops.be (Postfix) with ESMTP id 10C153E610D
	for <video4linux-list@redhat.com.>;
	Mon,  5 May 2008 17:17:01 +0200 (CEST)
From: 604hcl@telenet.be
To: video4linux-list@redhat.com
Message-ID: <W4018854147541210000621@nocme1bl6.telenet-ops.be>
Date: Mon, 05 May 2008 15:17:01 +0000
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="--=_vm_0011_W4018854_14754_1210000621"
Subject: phycore_im27 platform + mt9v022 camera
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

----=_vm_0011_W4018854_14754_1210000621
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi

I've been trying to capture an image from my mt9v022 camera with the vide=
o4linux example code. The code stops working in the start_capturing metho=
d. Right after the VIDIOC_STREAMON ioctl, the system freezes completely. =


Maybe some of you have an idea of the reason for this? I have attached mo=
dified code of the example

Regards

Hannes Claerhout

----=_vm_0011_W4018854_14754_1210000621
Content-Type: application/octet-stream;
        name="testcapt.c"
Content-Disposition: attachment;
        filename="testcapt.c"
Content-Transfer-Encoding: 7bit

/*
 *  V4L2 video capture example
 *
 *  This program can be used and distributed without restrictions.
 *
 *	This program were got from V4L2 API, Draft 0.20
 *		available at: http://v4l2spec.bytesex.org/
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
#define V4L2_PIX_FMT_SBGGR16  v4l2_fourcc('B','Y','R','2') /*  16  BGBG.. GRGR.. */
#define CLEAR(x) memset (&(x), 0, sizeof (x))

typedef enum {
	IO_METHOD_READ,
	IO_METHOD_MMAP,
	IO_METHOD_USERPTR,
} io_method;

struct buffer {
	void *                  start;
	size_t                  length;
};

static char *           dev_name        = NULL;
static io_method        io              = IO_METHOD_MMAP;
static int              fd              = -1;
struct buffer *         buffers         = NULL;
static unsigned int     n_buffers       = 4;

static void
errno_exit                      (const char *           s)
{
	fprintf (stderr, "%s error %d, %s\n",
		 s, errno, strerror (errno));

	exit (EXIT_FAILURE);
}

static int
xioctl                          (int                    fd,
				 int                    request,
				 void *                 arg)
{
	int r;

	do r = ioctl (fd, request, arg);
	while (-1 == r && EINTR == errno);

	return r;
}

static void
process_image                   (const void *           p)
{

    static int no_image = 0;
    char filename[50];
    FILE *fd;
    //ssize_t written = 0;

    snprintf(filename, sizeof(filename), "%swebcam-%5.5d.%s", "/tmp/",
	   no_image++, "pgm");

    fd = fopen(filename, "wb");
    if(fd)
    {
        fprintf(fd,"P5\n%u %u 255\n", 640, 480);
        fwrite(p, 1, 640*480, fd);
    }
    if(fd)
        fclose(fd);

    fputc('.', stdout);
    fflush(stdout);
}

static int
read_frame                      (void)
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
				/* Could ignore EIO, see spec. */

				/* fall through */

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
			case EAGAIN:
				return 0;

			case EIO:
				/* Could ignore EIO, see spec. */

				/* fall through */

			default:
				errno_exit ("VIDIOC_DQBUF");
			}
		}

		assert (buf.index < n_buffers);

		process_image (buffers[buf.index].start);

		if (-1 == xioctl (fd, VIDIOC_QBUF, &buf))
			errno_exit ("VIDIOC_QBUF");

		break;

	case IO_METHOD_USERPTR:
		CLEAR (buf);

		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = V4L2_MEMORY_USERPTR;

		if (-1 == xioctl (fd, VIDIOC_DQBUF, &buf)) {
			switch (errno) {
			case EAGAIN:
				return 0;

			case EIO:
				/* Could ignore EIO, see spec. */

				/* fall through */

			default:
				errno_exit ("VIDIOC_DQBUF");
			}
		}

		for (i = 0; i < n_buffers; ++i)
			if (buf.m.userptr == (unsigned long) buffers[i].start
			    && buf.length == buffers[i].length)
				break;

		assert (i < n_buffers);

		process_image ((void *) buf.m.userptr);

		if (-1 == xioctl (fd, VIDIOC_QBUF, &buf))
			errno_exit ("VIDIOC_QBUF");

		break;
	}

	return 1;
}

static void
mainloop                        (void)
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

static void
stop_capturing                  (void)
{
	enum v4l2_buf_type type;

	switch (io) {
	case IO_METHOD_READ:
		/* Nothing to do. */
		break;

	case IO_METHOD_MMAP:
	case IO_METHOD_USERPTR:
		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

		if (-1 == xioctl (fd, VIDIOC_STREAMOFF, &type))
			errno_exit ("VIDIOC_STREAMOFF");

		break;
	}
}

static void
start_capturing                 (void)
{
	unsigned int i;
	enum v4l2_buf_type type;

	switch (io) {
	case IO_METHOD_READ:
		/* Nothing to do. */
		break;

	case IO_METHOD_MMAP:
		printf("Entering case IO_MMAP\n");
		for (i = 0; i < n_buffers; ++i) {
			struct v4l2_buffer buf;

			CLEAR (buf);

			buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			buf.memory      = V4L2_MEMORY_MMAP;
			buf.index       = i;

		
			if (-1 == xioctl (fd, VIDIOC_QBUF, &buf))
				errno_exit ("VIDIOC_QBUF");
		}
		printf("Buffers initialised\n");
		
		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		
		printf("IOCTL StreamOn\n");
		if (-1 == xioctl (fd, VIDIOC_STREAMON, &type))
			errno_exit ("VIDIOC_STREAMON");

		printf("Method MMAP completed\n");
		break;

	case IO_METHOD_USERPTR:
		for (i = 0; i < n_buffers; ++i) {
			struct v4l2_buffer buf;

			CLEAR (buf);

			buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			buf.memory      = V4L2_MEMORY_USERPTR;
			buf.index       = i;
			buf.m.userptr   = (unsigned long) buffers[i].start;
			buf.length      = buffers[i].length;

			if (-1 == xioctl (fd, VIDIOC_QBUF, &buf))
				errno_exit ("VIDIOC_QBUF");
		}

		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

		if (-1 == xioctl (fd, VIDIOC_STREAMON, &type))
			errno_exit ("VIDIOC_STREAMON");

		break;
	}
}

static void
uninit_device                   (void)
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

	case IO_METHOD_USERPTR:
		for (i = 0; i < n_buffers; ++i)
			free (buffers[i].start);
		break;
	}

	free (buffers);
}

static void
init_read                       (unsigned int           buffer_size)
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

static void
init_mmap                       (void)
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

static void
init_userp                      (unsigned int           buffer_size)
{
	struct v4l2_requestbuffers req;

	CLEAR (req);

	req.count               = 4;
	req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	req.memory              = V4L2_MEMORY_USERPTR;

	if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) {
		if (EINVAL == errno) {
			fprintf (stderr, "%s does not support "
				 "user pointer i/o\n", dev_name);
			exit (EXIT_FAILURE);
		} else {
			errno_exit ("VIDIOC_REQBUFS");
		}
	}

	buffers = calloc (4, sizeof (*buffers));

	if (!buffers) {
		fprintf (stderr, "Out of memory\n");
		exit (EXIT_FAILURE);
	}

	for (n_buffers = 0; n_buffers < 4; ++n_buffers) {
		buffers[n_buffers].length = buffer_size;
		buffers[n_buffers].start = malloc (buffer_size);

		if (!buffers[n_buffers].start) {
			fprintf (stderr, "Out of memory\n");
			exit (EXIT_FAILURE);
		}
	}
}

static void
init_device                     (void)
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
	case IO_METHOD_USERPTR:
		if (!(cap.capabilities & V4L2_CAP_STREAMING)) {
			fprintf (stderr, "%s does not support streaming i/o\n",
				 dev_name);
			exit (EXIT_FAILURE);
		}

		break;
	}


	/* Select video input, video standard and tune here. */


	CLEAR (cropcap);

	cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

	if (0 == xioctl (fd, VIDIOC_CROPCAP, &cropcap)) {
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
	} else {
		/* Errors ignored. */
	}


	CLEAR (fmt);

	fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;

	printf("%d FD val\n", fd);
	
	if(-1 == xioctl(fd, VIDIOC_G_FMT, &fmt))
	{
		errno_exit ("VIDIOC_G_FMT");
	}
	else
	{
		printf("fmt type: %d\n", fmt.type);
		printf("fmt p width: %d\n", fmt.fmt.pix.width);
		printf("fmt p height: %d\n",fmt.fmt.pix.height);
		printf("fmt pixelformat: %d\n",fmt.fmt.pix.pixelformat);
		printf("fmt colorspace: %d\n",fmt.fmt.pix.colorspace);
		printf("fmt field: %d\n",fmt.fmt.pix.field);
		printf("fmt sizeimage: %d\n", fmt.fmt.pix.sizeimage);
	}
	printf("%d FD val\n",fd);
	CLEAR (fmt);
	fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	fmt.fmt.pix.width       = 752;
	fmt.fmt.pix.height      = 480;
	fmt.fmt.pix.pixelformat = /*V4L2_PIX_FMT_YUYV;*/ V4L2_PIX_FMT_SBGGR8;
	fmt.fmt.pix.field       = /*V4L2_FIELD_INTERLACED*/ 1;
	fmt.fmt.pix.colorspace  = V4L2_COLORSPACE_SRGB;
	fmt.fmt.pix.sizeimage   = ((752 * 480)) ;
	
	
	
	if (-1 == xioctl (fd, VIDIOC_S_FMT, &fmt))
	{
		errno_exit ("VIDIOC_S_FMT");
	}
	
	printf("Succeeded S_FMT\n");
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

	case IO_METHOD_USERPTR:
		init_userp (fmt.fmt.pix.sizeimage);
		break;
	}
}

static void
close_device                    (void)
{
	if (-1 == close (fd))
		errno_exit ("close");

	fd = -1;
}

static void
open_device                     (void)
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
	printf("%s","open_device complete\n");
	printf("%d FD val\n", fd);
}

static void
usage                           (FILE *                 fp,
				 int                    argc,
				 char **                argv)
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
	{ "device",     required_argument,      NULL,           'd' },
	{ "help",       no_argument,            NULL,           'h' },
	{ "mmap",       no_argument,            NULL,           'm' },
	{ "read",       no_argument,            NULL,           'r' },
	{ "userp",      no_argument,            NULL,           'u' },
	{ 0, 0, 0, 0 }
};

int main(int argc, char **                argv)
{
	dev_name = "/dev/video0";

	for (;;) 
	{
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

		case 'u':
			io = IO_METHOD_USERPTR;
			break;

		default:
			usage (stderr, argc, argv);
			exit (EXIT_FAILURE);
		}
	}
	
	printf("The device name: %s\n", dev_name);
	open_device ();

	init_device ();

	start_capturing ();

//	mainloop ();

//	stop_capturing ();

//	uninit_device ();

//	close_device ();

	exit (EXIT_SUCCESS);

	return 0;
}


----=_vm_0011_W4018854_14754_1210000621
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
----=_vm_0011_W4018854_14754_1210000621--
