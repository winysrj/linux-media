Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:8968 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaFEPbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 11:31:38 -0400
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6P002WPCGPX040@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jun 2014 11:31:37 -0400 (EDT)
From: Thiago Santos <ts.santos@sisa.samsung.com>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Thiago Santos <ts.santos@sisa.samsung.com>
Subject: [PATCH/RFC 1/2] v4l2grab: Add threaded producer/consumer option
Date: Thu, 05 Jun 2014 12:31:23 -0300
Message-id: <1401982284-1983-2-git-send-email-ts.santos@sisa.samsung.com>
In-reply-to: <1401982284-1983-1-git-send-email-ts.santos@sisa.samsung.com>
References: <1401982284-1983-1-git-send-email-ts.santos@sisa.samsung.com>
MIME-version: 1.0
Content-type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds options to allow the buffer dqbuf to happen on one thread while
the qbuf happens on another. This is useful to test concurrency access to
the v4l2 features. To enable this, 3 new options were added:

t: enable threaded mode (off by default and will use the loop)
b: enable blocking io mode (off by default
s: how much the consumer thread will sleep after reading a buffer, this is to
   simulate the time that it takes to process a buffer in a real application
   (in ms)

For example, you can simulate an application that takes 1s to process a buffer
with:

v4l2grab -t 1 -b 1 -s 1000

Signed-off-by: Thiago Santos <ts.santos@sisa.samsung.com>
---
 contrib/test/Makefile.am |   2 +-
 contrib/test/v4l2grab.c  | 265 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 223 insertions(+), 44 deletions(-)

diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 80c7665..c2e3860 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -25,7 +25,7 @@ pixfmt_test_CFLAGS = $(X11_CFLAGS)
 pixfmt_test_LDFLAGS = $(X11_LIBS)
 
 v4l2grab_SOURCES = v4l2grab.c
-v4l2grab_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
+v4l2grab_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lpthread
 
 v4l2gl_SOURCES = v4l2gl.c
 v4l2gl_LDFLAGS = $(X11_LIBS) $(GL_LIBS) $(GLU_LIBS)
diff --git a/contrib/test/v4l2grab.c b/contrib/test/v4l2grab.c
index 674cbe7..2fa5bb8 100644
--- a/contrib/test/v4l2grab.c
+++ b/contrib/test/v4l2grab.c
@@ -24,8 +24,10 @@
 #include <linux/videodev2.h>
 #include "../../lib/include/libv4l2.h"
 #include <argp.h>
+#include <pthread.h>
 
-#define CLEAR(x) memset(&(x), 0, sizeof(x))
+#define CLEAR_P(x,s) memset((x), 0, s)
+#define CLEAR(x) CLEAR_P(&(x), sizeof(x))
 
 struct buffer {
 	void   *start;
@@ -46,22 +48,206 @@ static void xioctl(int fh, unsigned long int request, void *arg)
 	}
 }
 
+/* Used by the multi thread capture version */
+struct buffer_queue {
+	struct v4l2_buffer *buffers;
+	int buffers_size;
+
+	int read_pos;
+	int write_pos;
+	int n_frames;
+
+	int fd;
+
+	pthread_mutex_t mutex;
+	pthread_cond_t buffer_cond;
+};
+
+/* Gets a buffer and puts it in the buffers list at write position, then
+ * notifies the consumer that a new buffer is ready to be used */
+static void *produce_buffer (void * p)
+{
+	struct buffer_queue 		*bq;
+	fd_set				fds;
+	struct timeval			tv;
+	int				i;
+	struct v4l2_buffer		*buf;
+	int				r;
+
+	bq = p;
+
+	for (i = 0; i < bq->n_frames; i++) {
+		printf ("Prod: %d\n", i);
+		buf = &bq->buffers[bq->write_pos % bq->buffers_size];
+		do {
+			FD_ZERO(&fds);
+			FD_SET(bq->fd, &fds);
+
+			/* Timeout. */
+			tv.tv_sec = 2;
+			tv.tv_usec = 0;
+
+			r = select(bq->fd + 1, &fds, NULL, NULL, &tv);
+		} while ((r == -1 && (errno == EINTR)));
+		if (r == -1) {
+			perror("select");
+			pthread_exit (NULL);
+			return NULL;
+		}
+
+		CLEAR_P(buf, sizeof(struct v4l2_buffer));
+		buf->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		buf->memory = V4L2_MEMORY_MMAP;
+		xioctl(bq->fd, VIDIOC_DQBUF, buf);
+
+		pthread_mutex_lock (&bq->mutex);
+		bq->write_pos++;
+		printf ("Prod: %d (done)\n", i);
+		pthread_cond_signal (&bq->buffer_cond);
+		pthread_mutex_unlock (&bq->mutex);
+
+	}
+
+	pthread_exit (NULL);
+}
+
+/* will create a separate thread that will produce the buffers and put
+ * into a circular array while this same thread will get the buffers from
+ * this array and 'render' them */
+static int capture_threads (int fd, struct buffer *buffers, int bufpool_size,
+			struct v4l2_format fmt, int n_frames,
+			char *out_dir, int sleep_ms)
+{
+	struct v4l2_buffer		buf;
+	unsigned int			i;
+	struct buffer_queue		buf_queue;
+	pthread_t			producer;
+	char				out_name[25 + strlen(out_dir)];
+	FILE				*fout;
+	struct timespec			sleeptime;
+
+	if (sleep_ms) {
+		sleeptime.tv_sec = sleep_ms / 1000;
+		sleeptime.tv_nsec = (sleep_ms % 1000) * 1000000;
+	}
+
+	buf_queue.buffers_size = bufpool_size * 2;
+	buf_queue.buffers = calloc(buf_queue.buffers_size,
+				   sizeof(struct v4l2_buffer));
+	buf_queue.fd = fd;
+	buf_queue.read_pos = 0;
+	buf_queue.write_pos = 0;
+	buf_queue.n_frames = n_frames;
+	pthread_mutex_init (&buf_queue.mutex, NULL);
+	pthread_cond_init (&buf_queue.buffer_cond, NULL);
+
+	pthread_create (&producer, NULL, produce_buffer, &buf_queue);
+
+	for (i = 0; i < n_frames; i++) {
+		printf ("Read: %d\n", i);
+
+		/* wait for a buffer to be available in the queue */
+		pthread_mutex_lock (&buf_queue.mutex);
+		while (buf_queue.read_pos == buf_queue.write_pos) {
+			pthread_cond_wait (&buf_queue.buffer_cond,
+					   &buf_queue.mutex);
+		}
+		pthread_mutex_unlock (&buf_queue.mutex);
+
+		if (sleep_ms)
+			nanosleep (&sleeptime, NULL);
+
+		sprintf(out_name, "%s/out%03d.ppm", out_dir, i);
+		fout = fopen(out_name, "w");
+		if (!fout) {
+			perror("Cannot open image");
+			exit(EXIT_FAILURE);
+		}
+		fprintf(fout, "P6\n%d %d 255\n",
+			fmt.fmt.pix.width, fmt.fmt.pix.height);
+		buf = buf_queue.buffers[buf_queue.read_pos %
+					buf_queue.buffers_size];
+		fwrite(buffers[buf.index].start, buf.bytesused, 1, fout);
+		fclose(fout);
+
+		xioctl(fd, VIDIOC_QBUF, &buf);
+
+		pthread_mutex_lock (&buf_queue.mutex);
+		buf_queue.read_pos++;
+		printf ("Read: %d (done)\n", i);
+		pthread_cond_signal (&buf_queue.buffer_cond);
+		pthread_mutex_unlock (&buf_queue.mutex);
+	}
+
+	pthread_mutex_destroy (&buf_queue.mutex);
+	pthread_cond_destroy (&buf_queue.buffer_cond);
+	free (buf_queue.buffers);
+	return 0;
+}
+
+static int capture_loop (int fd, struct buffer *buffers, struct v4l2_format fmt,
+			int n_frames, char *out_dir)
+{
+	struct v4l2_buffer		buf;
+	unsigned int			i;
+	struct timeval			tv;
+	int				r;
+	fd_set				fds;
+	FILE				*fout;
+	char				out_name[25 + strlen(out_dir)];
+
+	for (i = 0; i < n_frames; i++) {
+		do {
+			FD_ZERO(&fds);
+			FD_SET(fd, &fds);
+
+			/* Timeout. */
+			tv.tv_sec = 2;
+			tv.tv_usec = 0;
+
+			r = select(fd + 1, &fds, NULL, NULL, &tv);
+		} while ((r == -1 && (errno == EINTR)));
+		if (r == -1) {
+			perror("select");
+			return errno;
+		}
+
+		CLEAR(buf);
+		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		buf.memory = V4L2_MEMORY_MMAP;
+		xioctl(fd, VIDIOC_DQBUF, &buf);
+
+		sprintf(out_name, "%s/out%03d.ppm", out_dir, i);
+		fout = fopen(out_name, "w");
+		if (!fout) {
+			perror("Cannot open image");
+			exit(EXIT_FAILURE);
+		}
+		fprintf(fout, "P6\n%d %d 255\n",
+			fmt.fmt.pix.width, fmt.fmt.pix.height);
+		fwrite(buffers[buf.index].start, buf.bytesused, 1, fout);
+		fclose(fout);
+
+		xioctl(fd, VIDIOC_QBUF, &buf);
+	}
+	return 0;
+}
+
 static int capture(char *dev_name, int x_res, int y_res, int n_frames,
-		   char *out_dir)
+		   char *out_dir, int block, int threads, int sleep_ms)
 {
 	struct v4l2_format		fmt;
 	struct v4l2_buffer		buf;
 	struct v4l2_requestbuffers	req;
 	enum v4l2_buf_type		type;
-	fd_set				fds;
-	struct timeval			tv;
-	int				r, fd = -1;
+	int				fd = -1;
 	unsigned int			i, n_buffers;
-	char				out_name[25 + strlen(out_dir)];
-	FILE				*fout;
 	struct buffer			*buffers;
 
-	fd = v4l2_open(dev_name, O_RDWR | O_NONBLOCK, 0);
+	if (block)
+		fd = v4l2_open(dev_name, O_RDWR, 0);
+	else
+		fd = v4l2_open(dev_name, O_RDWR | O_NONBLOCK, 0);
 	if (fd < 0) {
 		perror("Cannot open device");
 		exit(EXIT_FAILURE);
@@ -119,40 +305,11 @@ static int capture(char *dev_name, int x_res, int y_res, int n_frames,
 	type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	xioctl(fd, VIDIOC_STREAMON, &type);
-	for (i = 0; i < n_frames; i++) {
-		do {
-			FD_ZERO(&fds);
-			FD_SET(fd, &fds);
-
-			/* Timeout. */
-			tv.tv_sec = 2;
-			tv.tv_usec = 0;
-
-			r = select(fd + 1, &fds, NULL, NULL, &tv);
-		} while ((r == -1 && (errno == EINTR)));
-		if (r == -1) {
-			perror("select");
-			return errno;
-		}
-
-		CLEAR(buf);
-		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		buf.memory = V4L2_MEMORY_MMAP;
-		xioctl(fd, VIDIOC_DQBUF, &buf);
-
-		sprintf(out_name, "%s/out%03d.ppm", out_dir, i);
-		fout = fopen(out_name, "w");
-		if (!fout) {
-			perror("Cannot open image");
-			exit(EXIT_FAILURE);
-		}
-		fprintf(fout, "P6\n%d %d 255\n",
-			fmt.fmt.pix.width, fmt.fmt.pix.height);
-		fwrite(buffers[buf.index].start, buf.bytesused, 1, fout);
-		fclose(fout);
-
-		xioctl(fd, VIDIOC_QBUF, &buf);
-	}
+	if (threads)
+		capture_threads(fd, buffers, 2, fmt, n_frames, out_dir,
+				sleep_ms);
+	else
+		capture_loop(fd, buffers, fmt, n_frames, out_dir);
 
 	type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	xioctl(fd, VIDIOC_STREAMOFF, &type);
@@ -179,6 +336,9 @@ static const struct argp_option options[] = {
 	{"xres",	'x',	"XRES",		0,	"horizontal resolution", 0},
 	{"yres",	'y',	"YRES",		0,	"vertical resolution", 0},
 	{"n-frames",	'n',	"NFRAMES",	0,	"number of frames to capture", 0},
+	{"threads",	't',	"THREADS",	0,	"if different threads should capture and save", 0},
+	{"block",	'b',	"BLOCKMODE",	0,	"if blocking mode should be used", 0},
+	{"sleep",	's',	"SLEEP",	0,	"how long should the consumer thread sleep to simulate the processing of a buffer (in ms)"},
 	{ 0, 0, 0, 0, 0, 0 }
 };
 
@@ -188,6 +348,9 @@ static char	*out_dir = ".";
 static int	x_res = 640;
 static int	y_res = 480;
 static int	n_frames = 20;
+static int	threads = 0;
+static int	block = 0;
+static int	sleep_ms = 0;
 
 static error_t parse_opt(int k, char *arg, struct argp_state *state)
 {
@@ -215,6 +378,21 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		if (val)
 			n_frames = val;
 		break;
+	case 't':
+		val = atoi(arg);
+		if (val)
+			threads = 1;
+		break;
+	case 'b':
+		val = atoi(arg);
+		if (val)
+			block = 1;
+		break;
+	case 's':
+		val = atoi(arg);
+		if (val)
+			sleep_ms = val;
+		break;
 	default:
 		return ARGP_ERR_UNKNOWN;
 	}
@@ -232,5 +410,6 @@ int main(int argc, char **argv)
 {
 	argp_parse(&argp, argc, argv, 0, 0, 0);
 
-	return capture(dev_name, x_res, y_res, n_frames, out_dir);
+	return capture(dev_name, x_res, y_res, n_frames, out_dir, block,
+		       threads, sleep_ms);
 }
-- 
2.0.0

