Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab1IAORf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 10:17:35 -0400
Date: Thu, 1 Sep 2011 16:17:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pawel Osciak <pawel@osciak.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 5/7 v5] V4L: vb2: add support for buffers of different
 sizes on a single queue
In-Reply-To: <Pine.LNX.4.64.1108290918180.31184@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109011611410.6316@axis700.grange>
References: <1314211292-10414-1-git-send-email-g.liakhovetski@gmx.de>
 <1314211292-10414-6-git-send-email-g.liakhovetski@gmx.de>
 <CAMm-=zDzCEM6euT9TNJCEE9uhWM7GMbSF68sxyFOHn1kGeJ5VA@mail.gmail.com>
 <Pine.LNX.4.64.1108290918180.31184@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel

On Mon, 29 Aug 2011, Guennadi Liakhovetski wrote:

> On Sun, 28 Aug 2011, Pawel Osciak wrote:

[snip]

> > Could you share the userspace code that you used for testing this? I
> > just wanted to get a feel of how those new ioctls fall into place
> > together.
> 
> Theoretically - yes, just will have to clean up the code a bit;-) Will try 
> to find some time for this in the next couple of days.

Below is a patch to the current capture-example.c. It is not extremely 
intelligent, many things are hard-coded, but you should get the idea.

> > Also, did you try multiple CREATE_BUFS calls?
> 
> Yes, it currently does two CREATE_BUFS, I might try to mix REQBUFS with 
> CREATE_BUFS too though.

With this patch you can use the "-q" flag to choose, whether you want your 
first buffers to be allocated per REQBUFS or CREATE_BUFS. Both options 
work.

Locally I have an even much dirtier, but more useful version of this 
patch, that draws one buffer size on the framebuffer, and stores the other 
one in .pgm files, all works well.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/


diff --git a/contrib/test/capture-example.c b/contrib/test/capture-example.c
index 417615a..ab0d8fb 100644
--- a/contrib/test/capture-example.c
+++ b/contrib/test/capture-example.c
@@ -38,14 +38,23 @@ struct buffer {
 	size_t  length;
 };
 
+enum {
+	false	= 0,
+	true	= 1
+};
+
 static char            *dev_name;
 static enum io_method   io = IO_METHOD_MMAP;
 static int              fd = -1;
 struct buffer          *buffers;
-static unsigned int     n_buffers;
+static unsigned int     n_buffers, n_buffers_alt;
 static int		out_buf;
 static int              force_format;
 static int              frame_count = 70;
+static unsigned int	width, height, fourcc, colorspace;
+static unsigned int	width_alt = 320, height_alt = 240,
+	fourcc_alt = V4L2_PIX_FMT_NV12, colorspace_alt = V4L2_COLORSPACE_JPEG;
+static _Bool		use_request;
 
 static void errno_exit(const char *s)
 {
@@ -64,6 +73,61 @@ static int xioctl(int fh, unsigned long int request, void *arg)
 	return r;
 }
 
+static int create_buffers(unsigned int *width, unsigned int *height,
+			  unsigned int fcc, unsigned int clrspc, int n)
+{
+	int i, ret;
+	struct v4l2_create_buffers create = {
+		.memory = V4L2_MEMORY_MMAP,
+		.count = n,
+		.format = {
+			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			.fmt.pix = {
+				.width = *width,
+				.height = *height,
+				.pixelformat = fcc,
+				.field = V4L2_FIELD_ANY,
+				.colorspace = clrspc,
+			},
+		},
+	};
+	struct v4l2_buffer buf = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.memory = V4L2_MEMORY_MMAP,
+		.field = V4L2_FIELD_ANY,
+	};
+	struct v4l2_pix_format *pix = &create.format.fmt.pix;
+
+	ret = xioctl(fd, VIDIOC_TRY_FMT, &create.format);
+	if (ret < 0) {
+		fprintf(stderr, "TRY_FMT should never fail!: %d\n", ret);
+		errno_exit("VIDIOC_TRY_FMT");
+	}
+	fprintf(stderr, "TRY_FMT(%ux%u:%x) -> %u\n", pix->width, pix->height,
+		 pix->pixelformat, pix->sizeimage);
+
+	*width = pix->width;
+	*height = pix->height;
+
+	ret = xioctl(fd, VIDIOC_CREATE_BUFS, &create);
+	if (ret < 0)
+		errno_exit("VIDIOC_CREATE_BUFS");
+
+	fprintf(stderr, "CREATE_BUFS(%d@%d)\n", create.count, create.index);
+
+	for (i = create.index; i < create.index + create.count; i++) {
+		buf.index = i;
+		ret = xioctl(fd, VIDIOC_PREPARE_BUF, &buf);
+		if (ret < 0)
+			errno_exit("VIDIOC_PREPARE_BUF");
+	}
+
+	if (i > create.index)
+		return i - create.index;
+
+	return ret;
+}
+
 static void process_image(const void *p, int size)
 {
 	if (out_buf)
@@ -74,7 +138,7 @@ static void process_image(const void *p, int size)
 	fflush(stdout);
 }
 
-static int read_frame(void)
+static int read_frame(_Bool do_queue)
 {
 	struct v4l2_buffer buf;
 	unsigned int i;
@@ -120,11 +184,11 @@ static int read_frame(void)
 			}
 		}
 
-		assert(buf.index < n_buffers);
+		assert(buf.index < n_buffers + n_buffers_alt);
 
 		process_image(buffers[buf.index].start, buf.bytesused);
 
-		if (-1 == xioctl(fd, VIDIOC_QBUF, &buf))
+		if (do_queue && -1 == xioctl(fd, VIDIOC_QBUF, &buf))
 			errno_exit("VIDIOC_QBUF");
 		break;
 
@@ -154,11 +218,11 @@ static int read_frame(void)
 			    && buf.length == buffers[i].length)
 				break;
 
-		assert(i < n_buffers);
+		assert(i < n_buffers + n_buffers_alt);
 
 		process_image((void *)buf.m.userptr, buf.bytesused);
 
-		if (-1 == xioctl(fd, VIDIOC_QBUF, &buf))
+		if (do_queue && -1 == xioctl(fd, VIDIOC_QBUF, &buf))
 			errno_exit("VIDIOC_QBUF");
 		break;
 	}
@@ -166,12 +230,8 @@ static int read_frame(void)
 	return 1;
 }
 
-static void mainloop(void)
+static void mainloop(unsigned int count, _Bool do_queue)
 {
-	unsigned int count;
-
-	count = frame_count;
-
 	while (count-- > 0) {
 		for (;;) {
 			fd_set fds;
@@ -198,7 +258,7 @@ static void mainloop(void)
 				exit(EXIT_FAILURE);
 			}
 
-			if (read_frame())
+			if (read_frame(do_queue))
 				break;
 			/* EAGAIN - continue select loop. */
 		}
@@ -223,7 +283,7 @@ static void stop_capturing(void)
 	}
 }
 
-static void start_capturing(void)
+static void start_capturing(unsigned int index, unsigned int count)
 {
 	unsigned int i;
 	enum v4l2_buf_type type;
@@ -234,7 +294,7 @@ static void start_capturing(void)
 		break;
 
 	case IO_METHOD_MMAP:
-		for (i = 0; i < n_buffers; ++i) {
+		for (i = index; i < index + count; ++i) {
 			struct v4l2_buffer buf;
 
 			CLEAR(buf);
@@ -251,7 +311,7 @@ static void start_capturing(void)
 		break;
 
 	case IO_METHOD_USERPTR:
-		for (i = 0; i < n_buffers; ++i) {
+		for (i = index; i < index + count; ++i) {
 			struct v4l2_buffer buf;
 
 			CLEAR(buf);
@@ -281,7 +341,7 @@ static void uninit_device(void)
 		break;
 
 	case IO_METHOD_MMAP:
-		for (i = 0; i < n_buffers; ++i)
+		for (i = 0; i < n_buffers + n_buffers_alt; ++i)
 			if (-1 == munmap(buffers[i].start, buffers[i].length))
 				errno_exit("munmap");
 		break;
@@ -313,15 +373,13 @@ static void init_read(unsigned int buffer_size)
 	}
 }
 
-static void init_mmap(void)
+static int request_buffers(unsigned int count)
 {
-	struct v4l2_requestbuffers req;
-
-	CLEAR(req);
-
-	req.count = 4;
-	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	req.memory = V4L2_MEMORY_MMAP;
+	struct v4l2_requestbuffers req = {
+		.count = count,
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.memory = V4L2_MEMORY_MMAP,
+	};
 
 	if (-1 == xioctl(fd, VIDIOC_REQBUFS, &req)) {
 		if (EINVAL == errno) {
@@ -333,40 +391,56 @@ static void init_mmap(void)
 		}
 	}
 
-	if (req.count < 2) {
-		fprintf(stderr, "Insufficient buffer memory on %s\n",
-			 dev_name);
-		exit(EXIT_FAILURE);
-	}
+	return req.count;
+}
+
+static void init_mmap(void)
+{
+	int ret;
+	int nbuf, i;
+
+	if (use_request)
+		ret = request_buffers(4);
+	else
+		ret = create_buffers(&width, &height, fourcc, colorspace, 4);
+
+	if (ret < 0)
+		errno_exit("{create,request}_buffers(main)");
 
-	buffers = calloc(req.count, sizeof(*buffers));
+	n_buffers = ret;
 
+	ret = create_buffers(&width_alt, &height_alt, fourcc_alt, colorspace_alt, 4);
+	if (ret < 0)
+		errno_exit("create_buffers(alternate)");
+
+	n_buffers_alt = ret;
+	nbuf = n_buffers_alt + n_buffers;
+
+	buffers = calloc(nbuf, sizeof(*buffers));
 	if (!buffers) {
 		fprintf(stderr, "Out of memory\n");
 		exit(EXIT_FAILURE);
 	}
 
-	for (n_buffers = 0; n_buffers < req.count; ++n_buffers) {
-		struct v4l2_buffer buf;
-
-		CLEAR(buf);
-
-		buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		buf.memory      = V4L2_MEMORY_MMAP;
-		buf.index       = n_buffers;
+	for (i = 0; i < nbuf; ++i) {
+		struct v4l2_buffer buf = {
+			.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			.memory      = V4L2_MEMORY_MMAP,
+			.index       = i,
+		};
 
 		if (-1 == xioctl(fd, VIDIOC_QUERYBUF, &buf))
 			errno_exit("VIDIOC_QUERYBUF");
 
-		buffers[n_buffers].length = buf.length;
-		buffers[n_buffers].start =
+		buffers[i].length = buf.length;
+		buffers[i].start =
 			mmap(NULL /* start anywhere */,
 			      buf.length,
 			      PROT_READ | PROT_WRITE /* required */,
 			      MAP_SHARED /* recommended */,
 			      fd, buf.m.offset);
 
-		if (MAP_FAILED == buffers[n_buffers].start)
+		if (MAP_FAILED == buffers[i].start)
 			errno_exit("mmap");
 	}
 }
@@ -409,13 +483,29 @@ static void init_userp(unsigned int buffer_size)
 	}
 }
 
+static int s_fmt(unsigned int width, unsigned int height, unsigned int fcc, unsigned int clrspc)
+{
+	struct v4l2_format fmt = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.fmt.pix = {
+			.width = width,
+			.height = height,
+			.pixelformat = fcc,
+			.field = V4L2_FIELD_ANY,
+			.colorspace = clrspc,
+		},
+	};
+	fprintf(stderr, "S_FMT(%ux%u:%x)\n", width, height, fcc);
+
+	return xioctl(fd, VIDIOC_S_FMT, &fmt);
+}
+
 static void init_device(void)
 {
 	struct v4l2_capability cap;
 	struct v4l2_cropcap cropcap;
 	struct v4l2_crop crop;
 	struct v4l2_format fmt;
-	unsigned int min;
 
 	if (-1 == xioctl(fd, VIDIOC_QUERYCAP, &cap)) {
 		if (EINVAL == errno) {
@@ -485,8 +575,8 @@ static void init_device(void)
 	if (force_format) {
 		fmt.fmt.pix.width       = 640;
 		fmt.fmt.pix.height      = 480;
-		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
-		fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;
+		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_NV16;
+		fmt.fmt.pix.field       = V4L2_FIELD_ANY;
 
 		if (-1 == xioctl(fd, VIDIOC_S_FMT, &fmt))
 			errno_exit("VIDIOC_S_FMT");
@@ -498,6 +588,11 @@ static void init_device(void)
 			errno_exit("VIDIOC_G_FMT");
 	}
 
+	width		= fmt.fmt.pix.width;
+	height		= fmt.fmt.pix.height;
+	colorspace	= fmt.fmt.pix.colorspace;
+	fourcc		= fmt.fmt.pix.pixelformat;
+
 	switch (io) {
 	case IO_METHOD_READ:
 		init_read(fmt.fmt.pix.sizeimage);
@@ -559,11 +654,12 @@ static void usage(FILE *fp, int argc, char **argv)
 		 "-o | --output        Outputs stream to stdout\n"
 		 "-f | --format        Force format to 640x480 YUYV\n"
 		 "-c | --count         Number of frames to grab [%i]\n"
+		 "-q | --request       Use REQBUFS for the first buffer set\n"
 		 "",
 		 argv[0], dev_name, frame_count);
 }
 
-static const char short_options[] = "d:hmruofc:";
+static const char short_options[] = "d:hmruofc:q";
 
 static const struct option
 long_options[] = {
@@ -575,6 +671,7 @@ long_options[] = {
 	{ "output", no_argument,       NULL, 'o' },
 	{ "format", no_argument,       NULL, 'f' },
 	{ "count",  required_argument, NULL, 'c' },
+	{ "request",no_argument,       NULL, 'q' },
 	{ 0, 0, 0, 0 }
 };
 
@@ -624,6 +721,10 @@ int main(int argc, char **argv)
 			force_format++;
 			break;
 
+		case 'q':
+			use_request = true;
+			break;
+
 		case 'c':
 			errno = 0;
 			frame_count = strtol(optarg, NULL, 0);
@@ -639,9 +740,26 @@ int main(int argc, char **argv)
 
 	open_device();
 	init_device();
-	start_capturing();
-	mainloop();
+	start_capturing(0, n_buffers);
+	mainloop(200, true);
 	stop_capturing();
+
+	if (io == IO_METHOD_MMAP) {
+		if (-1 == s_fmt(width_alt, height_alt, fourcc_alt, colorspace_alt))
+			errno_exit("S_FMT(alternate)");
+
+		start_capturing(n_buffers, n_buffers_alt);
+		mainloop(n_buffers_alt, false);
+		stop_capturing();
+
+		if (-1 == s_fmt(width, height, fourcc, colorspace))
+			errno_exit("S_FMT(main)");
+
+		start_capturing(0, n_buffers);
+		mainloop(200, true);
+		stop_capturing();
+	}
+
 	uninit_device();
 	close_device();
 	fprintf(stderr, "\n");
