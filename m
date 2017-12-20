Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41265 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754989AbdLTLA0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 06:00:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH REBASED] media: v4l-utils: dvbv5: Streaming I/O for DVB
Date: Wed, 20 Dec 2017 09:00:13 -0200
Message-Id: <fd2e528ecf42700e73c5943665eb3a2e59b96c5b.1513767273.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Junghak Sung <jh1009.sung@samsung.com>

Add a new scenario to use streaming I/O for TS recording.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

This is the old patch adding dvbv5-zap support for the new DVB
mmap API. It is just rebased on the top of the current version
of v4l-utils.

For now, build-test only.

It should be noticed that, instead of adding mmap support into
the library, it just adds support for it directly at the
dvbv5-zap API, as it is meant just for testing the new API.

Once it works, the new mmap API logic should be moved to the
libdvbv5 core.

 include/linux/dvb/dmx.h |  64 +++++++++++++++++
 utils/dvb/dvbv5-zap.c   | 185 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 247 insertions(+), 2 deletions(-)

diff --git a/include/linux/dvb/dmx.h b/include/linux/dvb/dmx.h
index 7d27bf5c1d20..c8dd6d3234ab 100644
--- a/include/linux/dvb/dmx.h
+++ b/include/linux/dvb/dmx.h
@@ -209,6 +209,64 @@ struct dmx_stc {
 	__u64 stc;
 };
 
+/**
+ * struct dmx_buffer - dmx buffer info
+ *
+ * @index:	id number of the buffer
+ * @bytesused:	number of bytes occupied by data in the buffer (payload);
+ * @offset:	for buffers with memory == DMX_MEMORY_MMAP;
+ *		offset from the start of the device memory for this plane,
+ *		(or a "cookie" that should be passed to mmap() as offset)
+ * @length:	size in bytes of the buffer
+ *
+ * Contains data exchanged by application and driver using one of the streaming
+ * I/O methods.
+ */
+struct dmx_buffer {
+	__u32			index;
+	__u32			bytesused;
+	__u32			offset;
+	__u32			length;
+	__u32			reserved[4];
+};
+
+/**
+ * struct dmx_requestbuffers - request dmx buffer information
+ *
+ * @count:	number of requested buffers,
+ * @size:	size in bytes of the requested buffer
+ *
+ * Contains data used for requesting a dmx buffer.
+ * All reserved fields must be set to zero.
+ */
+struct dmx_requestbuffers {
+	__u32			count;
+	__u32			size;
+	__u32			reserved[2];
+};
+
+/**
+ * struct dmx_exportbuffer - export of dmx buffer as DMABUF file descriptor
+ *
+ * @index:	id number of the buffer
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
+ * @fd:		file descriptor associated with DMABUF (set by driver)
+ *
+ * Contains data used for exporting a dmx buffer as DMABUF file descriptor.
+ * The buffer is identified by a 'cookie' returned by DMX_QUERYBUF
+ * (identical to the cookie used to mmap() the buffer to userspace). All
+ * reserved fields must be set to zero. The field reserved0 is expected to
+ * become a structure 'type' allowing an alternative layout of the structure
+ * content. Therefore this field should not be used for any other extensions.
+ */
+struct dmx_exportbuffer {
+	__u32		index;
+	__u32		flags;
+	__s32		fd;
+	__u32		reserved[5];
+};
+
 #define DMX_START                _IO('o', 41)
 #define DMX_STOP                 _IO('o', 42)
 #define DMX_SET_FILTER           _IOW('o', 43, struct dmx_sct_filter_params)
@@ -227,4 +285,10 @@ typedef enum dmx_ts_pes dmx_pes_type_t;
 typedef struct dmx_filter dmx_filter_t;
 
 
+#define DMX_REQBUFS              _IOWR('o', 60, struct dmx_requestbuffers)
+#define DMX_QUERYBUF             _IOWR('o', 61, struct dmx_buffer)
+#define DMX_EXPBUF               _IOWR('o', 62, struct dmx_exportbuffer)
+#define DMX_QBUF                 _IOWR('o', 63, struct dmx_buffer)
+#define DMX_DQBUF                _IOWR('o', 64, struct dmx_buffer)
+
 #endif /* _DVBDMX_H_ */
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 5567736da3c7..de4c00e539c3 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -33,6 +33,7 @@
 #include <signal.h>
 #include <argp.h>
 #include <sys/time.h>
+#include <sys/mman.h>
 
 #include <config.h>
 
@@ -73,6 +74,7 @@ struct arguments {
 	enum dvb_file_formats input_format, output_format;
 	unsigned traffic_monitor, low_traffic, non_human, port;
 	char *search, *server;
+	unsigned streaming;
 	const char *cc;
 
 	/* Used by status print */
@@ -94,6 +96,7 @@ static const struct argp_option options[] = {
 	{"pat",		'p', NULL,			0, N_("add pat and pmt to TS recording (implies -r)"), 0},
 	{"all-pids",	'P', NULL,			0, N_("don't filter any pids. Instead, outputs all of them"), 0 },
 	{"record",	'r', NULL,			0, N_("set up /dev/dvb/adapterX/dvr0 for TS recording"), 0},
+	{"streaming",	'R', NULL,			0, N_("uses streaming I/O for TS recording"), 0},
 	{"silence",	's', NULL,			0, N_("increases silence (can be used more than once)"), 0},
 	{"sat_number",	'S', N_("satellite_number"),	0, N_("satellite number. If not specified, disable DISEqC"), 0},
 	{"timeout",	't', N_("seconds"),		0, N_("timeout for zapping and for recording"), 0},
@@ -493,6 +496,171 @@ static void get_show_stats(struct arguments *args,
 	} while (!timeout_flag && loop);
 }
 
+#define TEST_EXPBUF (1)
+
+#define STREAM_BUF_CNT (10)
+#define STREAM_BUF_SIZ (188*1024)
+
+#define memzero(x) memset(&(x), 0, sizeof(x))
+
+struct stream_ctx {
+	int in_fd;
+	int out_fd;
+	int buf_cnt;
+	int buf_size;
+	char *buf[STREAM_BUF_CNT];
+	int buf_flag[STREAM_BUF_CNT];
+	int exp_buf[STREAM_BUF_CNT];
+	int error;
+};
+
+static int stream_init(struct stream_ctx *sc, int in_fd, int out_fd)
+{
+	struct dmx_requestbuffers req;
+	struct dmx_exportbuffer exp;
+	struct dmx_buffer buf;
+	int ret;
+	int i;
+
+	memset(sc, 0, sizeof(struct stream_ctx));
+	sc->in_fd = in_fd;
+	sc->out_fd = out_fd;
+	sc->buf_size = STREAM_BUF_SIZ;
+	sc->buf_cnt = STREAM_BUF_CNT;
+
+	memzero(req);
+	req.count = sc->buf_cnt;
+	req.size = sc->buf_size;
+
+	ret = ioctl(in_fd, DMX_REQBUFS, &req);
+	if (ret) {
+		PERROR("DMX_REQBUFS failed: error=%d", ret);
+		return ret;
+	}
+
+	if (sc->buf_cnt != req.count) {
+		fprintf(stderr, "buf_cnt %d -> %d changed !!!\n",
+				sc->buf_cnt, req.count);
+		sc->buf_cnt = req.count;
+	}
+
+	for (i = 0; i < sc->buf_cnt; i++) {
+		memzero(buf);
+		buf.index = i;
+
+		ret = ioctl(in_fd, DMX_QUERYBUF, &buf);
+		if (ret) {
+			PERROR("DMX_QUERYBUF failed: buf=%d error=%d", i, ret);
+			return ret;
+		}
+
+		sc->buf[i] = mmap(NULL, buf.length,
+					PROT_READ | PROT_WRITE, MAP_SHARED,
+					in_fd, buf.offset);
+
+		if (sc->buf[i] == MAP_FAILED) {
+			PERROR("Failed to MMAP buffer %d", i);
+			return -1;
+		}
+#if TEST_EXPBUF
+		memzero(exp);
+		exp.index = i;
+		ret = ioctl(in_fd, DMX_EXPBUF, &exp);
+		if (ret) {
+			PERROR("DMX_EXPBUF failed: buf=%d error=%d", i, ret);
+			return ret;
+		}
+		sc->exp_buf[i] = exp.fd;
+		fprintf(stderr, "Export buffer %d (fd=%d)\n",
+				i, sc->exp_buf[i]);
+#endif
+	}
+
+	return 0;
+}
+
+static int stream_qbuf(struct stream_ctx *sc, int n)
+{
+	struct dmx_buffer buf;
+	int ret;
+
+	memzero(buf);
+	buf.index = n;
+
+	ret = ioctl(sc->in_fd, DMX_QBUF, &buf);
+
+	if (ret) {
+		PERROR("DMX_QBUF failed: buf=%d error=%d", n, ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int stream_dqbuf(struct stream_ctx *sc, struct dmx_buffer *buf)
+{
+	int ret;
+
+	ret = ioctl(sc->in_fd, DMX_DQBUF, buf);
+
+	if (ret) {
+		PERROR("DMX_DQBUF failed: error=%d", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void stream_to_file(int in_fd, int out_fd, int timeout, int silent)
+{
+	struct stream_ctx sc;
+	int ret;
+	int n;
+	long long int rc = 0LL;
+
+	ret = stream_init(&sc, in_fd, out_fd);
+	if (ret) {
+		PERROR("[%s] Failed to setup buffers!!!", __func__);
+		sc.error = 1;
+	}
+	fprintf(stderr, "start streaming!!!\n");
+
+	while (timeout_flag == 0 && !sc.error) {
+		n = 0;
+		/* find empty buffer */
+		while (n < sc.buf_cnt && sc.buf_flag[n])
+			n++;
+
+		/* enqueue the empty buffer */
+		if (n < sc.buf_cnt) {
+			ret = stream_qbuf(&sc, n);
+			if (ret)
+				sc.error = 1;
+			else
+				sc.buf_flag[n] = 1;
+		} else {
+			/* if empty buffer is not found, dequeue buffer */
+			struct dmx_buffer b;
+
+			ret = stream_dqbuf(&sc, &b);
+			if (ret)
+				sc.error = 1;
+			else
+			{
+				sc.buf_flag[b.index] = 0;
+				if (sc.out_fd && write(sc.out_fd,
+					sc.buf[b.index], b.bytesused))
+					rc += b.bytesused;
+			}
+		}
+	}
+
+	if (silent < 2) {
+		fprintf(stderr, "copied %lld bytes (%lld Kbytes/sec)\n", rc,
+			rc / (1024 * timeout));
+	}
+}
+
 #define BUFLEN (188 * 256)
 static void copy_to_file(struct dvb_open_descriptor *in_fd, int out_fd,
 			 int timeout, int silent)
@@ -551,6 +719,10 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
 	case 'r':
 		args->dvr = 1;
 		break;
+	case 'R':
+		args->dvr = 1;
+		args->streaming = 1;
+		break;
 	case 'p':
 		args->rec_psi = 1;
 		break;
@@ -1083,14 +1255,23 @@ int main(int argc, char **argv)
 			get_show_stats(&args, parms, 0);
 
 		if (file_fd >= 0) {
-			dvr_fd = dvb_dev_open(dvb, args.dvr_dev, O_RDONLY);
+			int flag;
+
+			if (args.streaming)
+				flag = O_RDWR;
+			else
+				flag = O_RDONLY;
+			dvr_fd = dvb_dev_open(dvb, args.dvr_dev, flag);
 			if (!dvr_fd) {
 				ERROR("failed opening '%s'", args.dvr_dev);
 				goto err;
 			}
 			if (!timeout_flag)
 				fprintf(stderr, _("Record to file '%s' started\n"), args.filename);
-			copy_to_file(dvr_fd, file_fd, args.timeout, args.silent);
+			if (args.streaming)
+				stream_to_file(dvb_dev_get_fd(dvr_fd), file_fd, args.timeout, args.silent);
+			else
+				copy_to_file(dvr_fd, file_fd, args.timeout, args.silent);
 		} else if (args.server && args.port) {
 			struct stat st;
 			if (stat(args.dvr_pipe, &st) == -1) {
-- 
2.14.3
