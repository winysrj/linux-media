Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54105 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2DKIVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 04:21:21 -0400
Received: by iagz16 with SMTP id z16so956097iag.19
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2012 01:21:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F845C16.8070003@samsung.com>
References: <4F845C16.8070003@samsung.com>
Date: Wed, 11 Apr 2012 17:21:20 +0900
Message-ID: <CAH9JG2V+AYq0zn9hg4ZjdSdzDA0aYFyvSngt4D6uYaSeQpUhAA@mail.gmail.com>
Subject: Re: Test application for DMABUF sharing between V4L2 and DRM
From: Kyungmin Park <kmpark@infradead.org>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	dri-devel@lists.freedesktop.org,
	"???/Mobile S/W Platform Lab.(???)/E3(??)/????"
	<inki.dae@samsung.com>, Sumit Semwal <sumit.semwal@linaro.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Clark <rob@ti.com>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

How about to add this program to tools directory? tools/drm or tools/media?

Thank you,
Kyungmin Park

On Wed, Apr 11, 2012 at 1:13 AM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> Hi Everyone,
> This email contains a test application showing DMABUF sharing
> between DRM/KMS display and capture node including VIVI.
> It shows a simple preview on LCD display. The similar application
> was posted in thread:
> http://thread.gmane.org/gmane.comp.video.dri.devel/65997
>
> This version makes use of single-plane API for V4L2 capture instead
> of multiplanar. This change allows VIVI driver to be tested as
> DMABUF importer.
>
> The program is written in C99 and it was tested using Exynos/DRM
> and VIVI capture.
>
> This application shows how buffer sharing between V4L2/DRM may look like.
> Please let me know if/where I use DRM/V4L2 incorrectly.
>
> The application was tested against 3.4-rc1 kernel with patches:
>
> - Integration of videobuf2 with dmabuf
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/46586
>
> - Integration of vb2-vmalloc and VIVI with dmabuf
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/46713
>
> - Support for DRM prime for Exynos by Inki Dae
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/exynos-drm-prime
>
> - patch fixing kmap/vmap support for EXYNOS-DRM prime.
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/3c483f24e418f342eac40dc5fb3991e058deb270
>
>
> The branch containing all mentioned patches (without platform code)
> rebased on 3.4-rc1 is available at link:
>
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/v3.4-rc1-v4l-drm-dmabuf-for-test
>
> Regards,
> Tomasz Stanislawski
>
> ---
>
>
> #include <errno.h>
> #include <fcntl.h>
> #include <linux/videodev2.h>
> #include <math.h>
> #include <poll.h>
> #include <stdio.h>
> #include <stdint.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/ioctl.h>
> #include <sys/mman.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <unistd.h>
>
> #include <xf86drm.h>
> #include <xf86drmMode.h>
> #include <exynos_drm.h>
>
> #define ERRSTR strerror(errno)
>
> #define BYE_ON(cond, ...) \
> do { \
> � � � �if (cond) { \
> � � � � � � � �int errsv = errno; \
> � � � � � � � �fprintf(stderr, "ERROR(%s:%d) : ", \
> � � � � � � � � � � � �__FILE__, __LINE__); \
> � � � � � � � �errno = errsv; \
> � � � � � � � �fprintf(stderr, �__VA_ARGS__); \
> � � � � � � � �abort(); \
> � � � �} \
> } while(0)
>
> static inline int warn(const char *file, int line, const char *fmt, ...)
> {
> � � � �int errsv = errno;
> � � � �va_list va;
> � � � �va_start(va, fmt);
> � � � �fprintf(stderr, "WARN(%s:%d): ", file, line);
> � � � �vfprintf(stderr, fmt, va);
> � � � �va_end(va);
> � � � �errno = errsv;
> � � � �return 1;
> }
>
> #define WARN_ON(cond, ...) \
> � � � �((cond) ? warn(__FILE__, __LINE__, __VA_ARGS__) : 0)
>
> struct setup {
> � � � �char module[32];
> � � � �uint32_t conId;
> � � � �uint32_t crtId;
> � � � �char modestr[32];
> � � � �char video[32];
> � � � �unsigned int w, h;
> � � � �unsigned int use_wh : 1;
> � � � �unsigned int in_fourcc;
> � � � �unsigned int out_fourcc;
> � � � �unsigned int buffer_count;
> � � � �unsigned int use_crop : 1;
> � � � �unsigned int use_compose : 1;
> � � � �struct v4l2_rect crop;
> � � � �struct v4l2_rect compose;
> };
>
> struct buffer {
> � � � �unsigned int bo_handle;
> � � � �unsigned int fb_handle;
> � � � �int dbuf_fd;
> };
>
> struct stream {
> � � � �int v4lfd;
> � � � �int current_buffer;
> � � � �int buffer_count;
> � � � �struct buffer *buffer;
> } stream;
>
> static void usage(char *name)
> {
> � � � �fprintf(stderr, "usage: %s [-Moisth]\n", name);
> � � � �fprintf(stderr, "\t-M <drm-module>\tset DRM module\n");
> � � � �fprintf(stderr, "\t-o <connector_id>:<crtc_id>:<mode>\tset a mode\n");
> � � � �fprintf(stderr, "\t-i <video-node>\tset video node like /dev/video*\n");
> � � � �fprintf(stderr, "\t-S <width,height>\tset input resolution\n");
> � � � �fprintf(stderr, "\t-f <fourcc>\tset input format using 4cc\n");
> � � � �fprintf(stderr, "\t-F <fourcc>\tset output format using 4cc\n");
> � � � �fprintf(stderr, "\t-s <width,height>@<left,top>\tset crop area\n");
> � � � �fprintf(stderr, "\t-t <width,height>@<left,top>\tset compose area\n");
> � � � �fprintf(stderr, "\t-b buffer_count\tset number of buffers\n");
> � � � �fprintf(stderr, "\t-h\tshow this help\n");
> � � � �fprintf(stderr, "\n\tDefault is to dump all info.\n");
> }
>
> static inline int parse_rect(char *s, struct v4l2_rect *r)
> {
> � � � �return sscanf(s, "%d,%d@%d,%d", &r->width, &r->height,
> � � � � � � � �&r->top, &r->left) != 4;
> }
>
> static int parse_args(int argc, char *argv[], struct setup *s)
> {
> � � � �if (argc <= 1)
> � � � � � � � �usage(argv[0]);
>
> � � � �int c, ret;
> � � � �memset(s, 0, sizeof(*s));
>
> � � � �while ((c = getopt(argc, argv, "M:o:i:S:f:F:s:t:b:h")) != -1) {
> � � � � � � � �switch (c) {
> � � � � � � � �case 'M':
> � � � � � � � � � � � �strncpy(s->module, optarg, 31);
> � � � � � � � � � � � �break;
> � � � � � � � �case 'o':
> � � � � � � � � � � � �ret = sscanf(optarg, "%u:%u:%31s", &s->conId, &s->crtId,
> � � � � � � � � � � � � � � � �s->modestr);
> � � � � � � � � � � � �if (WARN_ON(ret != 3, "incorrect mode description\n"))
> � � � � � � � � � � � � � � � �return -1;
> � � � � � � � � � � � �break;
> � � � � � � � �case 'i':
> � � � � � � � � � � � �strncpy(s->video, optarg, 31);
> � � � � � � � � � � � �break;
> � � � � � � � �case 'S':
> � � � � � � � � � � � �ret = sscanf(optarg, "%u,%u", &s->w, &s->h);
> � � � � � � � � � � � �if (WARN_ON(ret != 2, "incorrect input size\n"))
> � � � � � � � � � � � � � � � �return -1;
> � � � � � � � � � � � �s->use_wh = 1;
> � � � � � � � � � � � �break;
> � � � � � � � �case 'f':
> � � � � � � � � � � � �if (WARN_ON(strlen(optarg) != 4, "invalid fourcc\n"))
> � � � � � � � � � � � � � � � �return -1;
> � � � � � � � � � � � �s->in_fourcc = ((unsigned)optarg[0] << 0) |
> � � � � � � � � � � � � � � � �((unsigned)optarg[1] << 8) |
> � � � � � � � � � � � � � � � �((unsigned)optarg[2] << 16) |
> � � � � � � � � � � � � � � � �((unsigned)optarg[3] << 24);
> � � � � � � � � � � � �break;
> � � � � � � � �case 'F':
> � � � � � � � � � � � �if (WARN_ON(strlen(optarg) != 4, "invalid fourcc\n"))
> � � � � � � � � � � � � � � � �return -1;
> � � � � � � � � � � � �s->out_fourcc = ((unsigned)optarg[0] << 0) |
> � � � � � � � � � � � � � � � �((unsigned)optarg[1] << 8) |
> � � � � � � � � � � � � � � � �((unsigned)optarg[2] << 16) |
> � � � � � � � � � � � � � � � �((unsigned)optarg[3] << 24);
> � � � � � � � � � � � �break;
> � � � � � � � �case 's':
> � � � � � � � � � � � �ret = parse_rect(optarg, &s->crop);
> � � � � � � � � � � � �if (WARN_ON(ret, "incorrect crop area\n"))
> � � � � � � � � � � � � � � � �return -1;
> � � � � � � � � � � � �s->use_crop = 1;
> � � � � � � � � � � � �break;
> � � � � � � � �case 't':
> � � � � � � � � � � � �ret = parse_rect(optarg, &s->compose);
> � � � � � � � � � � � �if (WARN_ON(ret, "incorrect compose area\n"))
> � � � � � � � � � � � � � � � �return -1;
> � � � � � � � � � � � �s->use_compose = 1;
> � � � � � � � � � � � �break;
> � � � � � � � �case 'b':
> � � � � � � � � � � � �ret = sscanf(optarg, "%u", &s->buffer_count);
> � � � � � � � � � � � �if (WARN_ON(ret != 1, "incorrect buffer count\n"))
> � � � � � � � � � � � � � � � �return -1;
> � � � � � � � � � � � �break;
> � � � � � � � �case '?':
> � � � � � � � �case 'h':
> � � � � � � � � � � � �usage(argv[0]);
> � � � � � � � � � � � �return -1;
> � � � � � � � �}
> � � � �}
>
> � � � �return 0;
> }
>
> static int buffer_create(struct buffer *b, int drmfd, struct setup *s,
> � � � �uint64_t size, uint32_t pitch)
> {
> � � � �int ret = strncmp(s->module, "exynos", 6);
> � � � �if (WARN_ON(ret, "drm: only exynos GEM is supported\n"))
> � � � � � � � �return -1;
>
> � � � �struct drm_exynos_gem_create gem;
> � � � �struct drm_gem_close gem_close;
>
> � � � �memset(&gem, 0, sizeof gem);
> � � � �gem.size = size;
> � � � �ret = ioctl(drmfd, DRM_IOCTL_EXYNOS_GEM_CREATE, &gem);
> � � � �if (WARN_ON(ret, "EXYNOS_GEM_CREATE failed: %s\n", ERRSTR))
> � � � � � � � �return -1;
> � � � �b->bo_handle = gem.handle;
>
> � � � �struct drm_prime_handle prime;
> � � � �memset(&prime, 0, sizeof prime);
> � � � �prime.handle = b->bo_handle;
>
> � � � �ret = ioctl(drmfd, DRM_IOCTL_PRIME_HANDLE_TO_FD, &prime);
> � � � �if (WARN_ON(ret, "PRIME_HANDLE_TO_FD failed: %s\n", ERRSTR))
> � � � � � � � �goto fail_gem;
> � � � �printf("dbuf_fd = %d\n", prime.fd);
> � � � �b->dbuf_fd = prime.fd;
>
> � � � �uint32_t offsets[4] = { 0 };
> � � � �uint32_t pitches[4] = { pitch };
> � � � �uint32_t bo_handles[4] = { b->bo_handle };
> � � � �unsigned int fourcc = s->out_fourcc;
> � � � �if (!fourcc)
> � � � � � � � �fourcc = s->in_fourcc;
> � � � �ret = drmModeAddFB2(drmfd, s->w, s->h, fourcc, bo_handles,
> � � � � � � � �pitches, offsets, &b->fb_handle, 0);
> � � � �if (WARN_ON(ret, "drmModeAddFB2 failed: %s\n", ERRSTR))
> � � � � � � � �goto fail_prime;
>
> � � � �return 0;
>
> fail_prime:
> � � � �close(b->dbuf_fd);
>
> fail_gem:
> � � � �memset(&gem_close, 0, sizeof gem_close);
> � � � �gem_close.handle = b->bo_handle,
> � � � �ret = ioctl(drmfd, DRM_IOCTL_GEM_CLOSE, gem_close);
> � � � �WARN_ON(ret, "GEM_CLOSE failed: %s\n", ERRSTR);
>
> � � � �return -1;
> }
>
> static int find_mode(drmModeModeInfo *m, int drmfd, struct setup *s,
> � � � �uint32_t *con)
> {
> � � � �int ret = -1;
> � � � �drmModeRes *res = drmModeGetResources(drmfd);
> � � � �if (WARN_ON(!res, "drmModeGetResources failed: %s\n", ERRSTR))
> � � � � � � � �return -1;
>
> � � � �if (WARN_ON(res->count_crtcs <= 0, "drm: no crts\n"))
> � � � � � � � �goto fail_res;
>
> � � � �if (WARN_ON(res->count_connectors <= 0, "drm: no connectors\n"))
> � � � � � � � �goto fail_res;
>
> � � � �if (WARN_ON(s->conId >= res->count_connectors, "connector %d "
> � � � � � � � �"is not supported\n", s->conId))
> � � � � � � � �goto fail_res;
>
> � � � �drmModeConnector *c;
> � � � �c = drmModeGetConnector(drmfd, res->connectors[s->conId]);
>
> � � � �if (WARN_ON(!c, "drmModeGetConnector failed: %s\n", ERRSTR))
> � � � � � � � �goto fail_res;
>
> � � � �if (WARN_ON(!c->count_modes, "connector supports no mode\n"))
> � � � � � � � �goto fail_conn;
>
> � � � �drmModeModeInfo *found = NULL;
> � � � �for (int i = 0; i < c->count_modes; ++i)
> � � � � � � � �if (strcmp(c->modes[i].name, s->modestr) == 0)
> � � � � � � � � � � � �found = &c->modes[i];
>
> � � � �if (WARN_ON(!found, "mode %s not supported\n", s->modestr)) {
> � � � � � � � �fprintf(stderr, "Valid modes:");
> � � � � � � � �for (int i = 0; i < c->count_modes; ++i)
> � � � � � � � � � � � �fprintf(stderr, " %s", c->modes[i].name);
> � � � � � � � �fprintf(stderr, "\n");
> � � � � � � � �goto fail_conn;
> � � � �}
>
> � � � �memcpy(m, found, sizeof *found);
> � � � �if (con)
> � � � � � � � �*con = c->connector_id;
> � � � �ret = 0;
>
> fail_conn:
> � � � �drmModeFreeConnector(c);
>
> fail_res:
> � � � �drmModeFreeResources(res);
>
> � � � �return ret;
> }
>
> static void page_flip_handler(int fd, unsigned int frame,
> � � � �unsigned int sec, unsigned int usec, void *data)
> {
> � � � �int index = stream.current_buffer;
> � � � �struct v4l2_buffer buf;
> � � � �int ret;
>
> � � � �stream.current_buffer = (int)data;
> � � � �if (index < 0)
> � � � � � � � �return;
>
> � � � �memset(&buf, 0, sizeof buf);
> � � � �buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> � � � �buf.memory = V4L2_MEMORY_DMABUF;
> � � � �buf.index = index;
> � � � �buf.m.fd = stream.buffer[index].dbuf_fd;
>
> � � � �ret = ioctl(stream.v4lfd, VIDIOC_QBUF, &buf);
> � � � �BYE_ON(ret, "VIDIOC_QBUF(index = %d) failed: %s\n", index, ERRSTR);
> }
>
> int main(int argc, char *argv[])
> {
> � � � �int ret;
> � � � �struct setup s;
>
> � � � �ret = parse_args(argc, argv, &s);
> � � � �BYE_ON(ret, "failed to parse arguments\n");
> � � � �BYE_ON(s.module[0] == 0, "DRM module is missing\n");
> � � � �BYE_ON(s.video[0] == 0, "video node is missing\n");
>
> � � � �int drmfd = drmOpen(s.module, NULL);
> � � � �BYE_ON(drmfd < 0, "drmOpen(%s) failed: %s\n", s.module, ERRSTR);
>
> � � � �int v4lfd = open(s.video, O_RDWR);
> � � � �BYE_ON(v4lfd < 0, "failed to open %s: %s\n", s.video, ERRSTR);
>
> � � � �struct v4l2_capability caps;
> � � � �memset(&caps, 0, sizeof caps);
>
> � � � �ret = ioctl(v4lfd, VIDIOC_QUERYCAP, &caps);
> � � � �BYE_ON(ret, "VIDIOC_QUERYCAP failed: %s\n", ERRSTR);
>
> � � � �/* TODO: add single plane support */
> � � � �BYE_ON(~caps.capabilities & V4L2_CAP_VIDEO_CAPTURE,
> � � � � � � � �"video: singleplanar capture is not supported\n");
>
> � � � �struct v4l2_format fmt;
> � � � �memset(&fmt, 0, sizeof fmt);
> � � � �fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>
> � � � �ret = ioctl(v4lfd, VIDIOC_G_FMT, &fmt);
> � � � �BYE_ON(ret < 0, "VIDIOC_G_FMT failed: %s\n", ERRSTR);
> � � � �printf("G_FMT(start): width = %u, height = %u, 4cc = %.4s\n",
> � � � � � � � �fmt.fmt.pix.width, fmt.fmt.pix.height,
> � � � � � � � �(char*)&fmt.fmt.pix.pixelformat);
>
> � � � �if (s.use_wh) {
> � � � � � � � �fmt.fmt.pix.width = s.w;
> � � � � � � � �fmt.fmt.pix.height = s.h;
> � � � �}
> � � � �if (s.in_fourcc)
> � � � � � � � �fmt.fmt.pix.pixelformat = s.in_fourcc;
>
> � � � �ret = ioctl(v4lfd, VIDIOC_S_FMT, &fmt);
> � � � �BYE_ON(ret < 0, "VIDIOC_S_FMT failed: %s\n", ERRSTR);
>
> � � � �ret = ioctl(v4lfd, VIDIOC_G_FMT, &fmt);
> � � � �BYE_ON(ret < 0, "VIDIOC_G_FMT failed: %s\n", ERRSTR);
> � � � �printf("G_FMT(final): width = %u, height = %u, 4cc = %.4s\n",
> � � � � � � � �fmt.fmt.pix.width, fmt.fmt.pix.height,
> � � � � � � � �(char*)&fmt.fmt.pix.pixelformat);
>
> � � � �struct v4l2_requestbuffers rqbufs;
> � � � �memset(&rqbufs, 0, sizeof(rqbufs));
> � � � �rqbufs.count = s.buffer_count;
> � � � �rqbufs.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> � � � �rqbufs.memory = V4L2_MEMORY_DMABUF;
>
> � � � �ret = ioctl(v4lfd, VIDIOC_REQBUFS, &rqbufs);
> � � � �BYE_ON(ret < 0, "VIDIOC_REQBUFS failed: %s\n", ERRSTR);
> � � � �BYE_ON(rqbufs.count < s.buffer_count, "video node allocated only "
> � � � � � � � �"%u of %u buffers\n", rqbufs.count, s.buffer_count);
>
> � � � �s.in_fourcc = fmt.fmt.pix.pixelformat;
> � � � �s.w = fmt.fmt.pix.width;
> � � � �s.h = fmt.fmt.pix.height;
>
> � � � �/* TODO: add support for multiplanar formats */
> � � � �struct buffer buffer[s.buffer_count];
> � � � �uint64_t size = fmt.fmt.pix.sizeimage;
> � � � �uint32_t pitch = fmt.fmt.pix.bytesperline;
> � � � �printf("size = %llu pitch = %u\n", size, pitch);
> � � � �for (int i = 0; i < s.buffer_count; ++i) {
> � � � � � � � �ret = buffer_create(&buffer[i], drmfd, &s, size, pitch);
> � � � � � � � �BYE_ON(ret, "failed to create buffer%d\n", i);
> � � � �}
> � � � �printf("buffers ready\n");
>
> � � � �drmModeModeInfo drmmode;
> � � � �uint32_t con;
> � � � �ret = find_mode(&drmmode, drmfd, &s, &con);
> � � � �BYE_ON(ret, "failed to find valid mode\n");
>
> � � � �ret = drmModeSetCrtc(drmfd, s.crtId, buffer[0].fb_handle, 0, 0,
> � � � � � � � �&con, 1, &drmmode);
> � � � �BYE_ON(ret, "drmModeSetCrtc failed: %s\n", ERRSTR);
>
> � � � �/* enqueueing first buffer to DRM */
> � � � �ret = drmModePageFlip(drmfd, s.crtId, buffer[0].fb_handle,
> � � � � � � � �DRM_MODE_PAGE_FLIP_EVENT, 0);
> � � � �BYE_ON(ret, "drmModePageFlip failed: %s\n", ERRSTR);
>
> � � � �for (int i = 1; i < s.buffer_count; ++i) {
> � � � � � � � �struct v4l2_buffer buf;
> � � � � � � � �memset(&buf, 0, sizeof buf);
>
> � � � � � � � �buf.index = i;
> � � � � � � � �buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> � � � � � � � �buf.memory = V4L2_MEMORY_DMABUF;
> � � � � � � � �buf.m.fd = buffer[i].dbuf_fd;
> � � � � � � � �ret = ioctl(v4lfd, VIDIOC_QBUF, &buf);
> � � � � � � � �BYE_ON(ret < 0, "VIDIOC_QBUF for buffer %d failed: %s\n",
> � � � � � � � � � � � �buf.index, ERRSTR);
> � � � �}
>
> � � � �int type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> � � � �ret = ioctl(v4lfd, VIDIOC_STREAMON, &type);
> � � � �BYE_ON(ret < 0, "STREAMON failed: %s\n", ERRSTR);
>
> � � � �struct pollfd fds[] = {
> � � � � � � � �{ .fd = v4lfd, .events = POLLIN },
> � � � � � � � �{ .fd = drmfd, .events = POLLIN },
> � � � �};
>
> � � � �/* buffer currently used by drm */
> � � � �stream.v4lfd = v4lfd;
> � � � �stream.current_buffer = -1;
> � � � �stream.buffer = buffer;
>
> � � � �while ((ret = poll(fds, 2, 5000)) > 0) {
> � � � � � � � �if (fds[0].revents & POLLIN) {
> � � � � � � � � � � � �struct v4l2_buffer buf;
> � � � � � � � � � � � �memset(&buf, 0, sizeof buf);
> � � � � � � � � � � � �/* dequeue buffer */
> � � � � � � � � � � � �buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> � � � � � � � � � � � �buf.memory = V4L2_MEMORY_DMABUF;
> � � � � � � � � � � � �ret = ioctl(v4lfd, VIDIOC_DQBUF, &buf);
> � � � � � � � � � � � �BYE_ON(ret, "VIDIOC_DQBUF failed: %s\n", ERRSTR);
>
> � � � � � � � � � � � �ret = drmModePageFlip(drmfd, s.crtId, buffer[buf.index].fb_handle,
> � � � � � � � � � � � � � � � �DRM_MODE_PAGE_FLIP_EVENT, (void*)buf.index);
> � � � � � � � � � � � �BYE_ON(ret, "drmModePageFlip failed: %s\n", ERRSTR);
>
> � � � � � � � �}
> � � � � � � � �if (fds[1].revents & POLLIN) {
> � � � � � � � � � � � �drmEventContext evctx;
> � � � � � � � � � � � �memset(&evctx, 0, sizeof evctx);
> � � � � � � � � � � � �evctx.version = DRM_EVENT_CONTEXT_VERSION;
> � � � � � � � � � � � �evctx.page_flip_handler = page_flip_handler;
>
> � � � � � � � � � � � �ret = drmHandleEvent(drmfd, &evctx);
> � � � � � � � � � � � �BYE_ON(ret, "drmHandleEvent failed: %s\n", ERRSTR);
> � � � � � � � �}
> � � � �}
>
> � � � �return 0;
> }
>
>
>
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at �http://vger.kernel.org/majordomo-info.html
