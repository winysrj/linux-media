Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbcGDLr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 22/51] Documentation: linux_tv: supress lots of warnings
Date: Mon,  4 Jul 2016 08:46:43 -0300
Message-Id: <563ff6033fa9921d17e18f6ac62406e7c54b4c5c.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The c language parser checks if there are duplicated object
definitions. That causes lots of warnings like:
	WARNING: duplicate C object description of ioctl

Let's remove those by telling Sphinx that the language for
those objects are c++. The look of the descriptions will
be close, and the warnings will be gone.

Please notice that we had to keep a few of them as C, as
the c++ parser seems to be broken when it finds an enum.

Yet, this reduced from 219 warnings to 143, with is
a good thing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst     | 2 +-
 Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst       | 2 +-
 Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst      | 2 +-
 Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst     | 2 +-
 Documentation/linux_tv/media/dvb/fe-get-info.rst                    | 2 +-
 Documentation/linux_tv/media/dvb/fe-get-property.rst                | 2 +-
 Documentation/linux_tv/media/dvb/fe-read-status.rst                 | 2 +-
 Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst      | 2 +-
 Documentation/linux_tv/media/dvb/frontend_f_close.rst               | 2 +-
 Documentation/linux_tv/media/dvb/frontend_f_open.rst                | 2 +-
 Documentation/linux_tv/media/dvb/net.rst                            | 6 +++---
 Documentation/linux_tv/media/v4l/func-close.rst                     | 2 +-
 Documentation/linux_tv/media/v4l/func-ioctl.rst                     | 2 +-
 Documentation/linux_tv/media/v4l/func-mmap.rst                      | 2 +-
 Documentation/linux_tv/media/v4l/func-munmap.rst                    | 2 +-
 Documentation/linux_tv/media/v4l/func-open.rst                      | 2 +-
 Documentation/linux_tv/media/v4l/func-poll.rst                      | 2 +-
 Documentation/linux_tv/media/v4l/func-read.rst                      | 2 +-
 Documentation/linux_tv/media/v4l/func-select.rst                    | 2 +-
 Documentation/linux_tv/media/v4l/func-write.rst                     | 2 +-
 Documentation/linux_tv/media/v4l/media-func-close.rst               | 2 +-
 Documentation/linux_tv/media/v4l/media-func-ioctl.rst               | 2 +-
 Documentation/linux_tv/media/v4l/media-func-open.rst                | 2 +-
 Documentation/linux_tv/media/v4l/media-ioc-device-info.rst          | 2 +-
 Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst        | 2 +-
 Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst           | 2 +-
 Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst           | 2 +-
 Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst           | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst             | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-cropcap.rst                 | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst         | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst          | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst             | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-dqevent.rst                 | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst          | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst             | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst         | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst                | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst     | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst         | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst         | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst               | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst            | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enuminput.rst               | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst              | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enumstd.rst                 | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst                  | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-audio.rst                 | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst              | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst                  | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst                  | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst            | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst                  | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst             | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst             | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst                  | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst                   | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst             | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-input.rst                 | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst              | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst             | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-output.rst                | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst                  | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-selection.rst             | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst        | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst                   | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst                 | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-log-status.rst              | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-overlay.rst                 | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst             | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst                    | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst        | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-querybuf.rst                | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-querycap.rst                | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst               | 6 +++---
 Documentation/linux_tv/media/v4l/vidioc-querystd.rst                | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst                 | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst          | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-streamon.rst                | 2 +-
 .../linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst        | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst  | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst   | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst           | 4 ++--
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst            | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst      | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst         | 2 +-
 scripts/kernel-doc                                                  | 2 +-
 88 files changed, 104 insertions(+), 104 deletions(-)
 mode change 100755 => 100644 scripts/kernel-doc

diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
index 309930f9b3cd..0f01584c8d4e 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
@@ -14,7 +14,7 @@ Receives reply from a DiSEqC 2.0 command
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_diseqc_slave_reply *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct dvb_diseqc_slave_reply *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
index dc7ae1a02725..50d0d651d270 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
@@ -15,7 +15,7 @@ to power overload.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, NULL )
+.. cpp:function:: int ioctl( int fd, int request, NULL )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
index 974a45f632a6..7a85632e64b4 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
@@ -14,7 +14,7 @@ Sends a DiSEqC command
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_diseqc_master_cmd *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct dvb_diseqc_master_cmd *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
index 207c65a44120..f2705a383d8c 100644
--- a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
+++ b/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
@@ -15,7 +15,7 @@ voltages.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, unsigned int high )
+.. cpp:function:: int ioctl( int fd, int request, unsigned int high )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/fe-get-info.rst b/Documentation/linux_tv/media/dvb/fe-get-info.rst
index 5ac74c232b12..d7990c80ef87 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-info.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-info.rst
@@ -15,7 +15,7 @@ front-end. This call only requires read-only access to the device
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_frontend_info *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct dvb_frontend_info *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/fe-get-property.rst b/Documentation/linux_tv/media/dvb/fe-get-property.rst
index 8a6c5de041e8..5b73ee8e790b 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-property.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-property.rst
@@ -16,7 +16,7 @@ FE_GET_PROPERTY returns one or more frontend properties.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dtv_properties *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct dtv_properties *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/fe-read-status.rst b/Documentation/linux_tv/media/dvb/fe-read-status.rst
index 41396a8f1c3d..c032cda4e5a6 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-status.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-status.rst
@@ -15,7 +15,7 @@ read-only access to the device
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, unsigned int *status )
+.. cpp:function:: int ioctl( int fd, int request, unsigned int *status )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst b/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
index 1167d22c2382..82665279b840 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
@@ -14,7 +14,7 @@ Allow setting tuner mode flags to the frontend.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, unsigned int flags )
+.. cpp:function:: int ioctl( int fd, int request, unsigned int flags )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_close.rst b/Documentation/linux_tv/media/dvb/frontend_f_close.rst
index cde87322859a..faae1c7381e2 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_close.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_close.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. c:function:: int close( int fd )
+.. cpp:function:: int close( int fd )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_open.rst b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
index 91ac9ef8c356..9ef430abcba4 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_open.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <fcntl.h>
 
 
-.. c:function:: int open( const char *device_name, int flags )
+.. cpp:function:: int open( const char *device_name, int flags )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/dvb/net.rst b/Documentation/linux_tv/media/dvb/net.rst
index 040ffc70601d..830076fadda2 100644
--- a/Documentation/linux_tv/media/dvb/net.rst
+++ b/Documentation/linux_tv/media/dvb/net.rst
@@ -46,7 +46,7 @@ Creates a new network interface for a given Packet ID.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
+.. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
 
 Arguments
 =========
@@ -135,7 +135,7 @@ Removes a network interface.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, int ifnum )
+.. cpp:function:: int ioctl( int fd, int request, int ifnum )
 
 Arguments
 =========
@@ -178,7 +178,7 @@ Read the configuration data of an interface created via
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
+.. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/func-close.rst b/Documentation/linux_tv/media/v4l/func-close.rst
index 28fd055bf71b..991a34a163af 100644
--- a/Documentation/linux_tv/media/v4l/func-close.rst
+++ b/Documentation/linux_tv/media/v4l/func-close.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. c:function:: int close( int fd )
+.. cpp:function:: int close( int fd )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/func-ioctl.rst b/Documentation/linux_tv/media/v4l/func-ioctl.rst
index 774ac4cbb6b8..26b072cfe850 100644
--- a/Documentation/linux_tv/media/v4l/func-ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/func-ioctl.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <sys/ioctl.h>
 
 
-.. c:function:: int ioctl( int fd, int request, void *argp )
+.. cpp:function:: int ioctl( int fd, int request, void *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/func-mmap.rst b/Documentation/linux_tv/media/v4l/func-mmap.rst
index b908c0253c07..51502a906c3c 100644
--- a/Documentation/linux_tv/media/v4l/func-mmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-mmap.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <sys/mman.h>
 
 
-.. c:function:: void *mmap( void *start, size_t length, int prot, int flags, int fd, off_t offset )
+.. cpp:function:: void *mmap( void *start, size_t length, int prot, int flags, int fd, off_t offset )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/func-munmap.rst b/Documentation/linux_tv/media/v4l/func-munmap.rst
index 46c837457cae..80f9ecd92774 100644
--- a/Documentation/linux_tv/media/v4l/func-munmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-munmap.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <sys/mman.h>
 
 
-.. c:function:: int munmap( void *start, size_t length )
+.. cpp:function:: int munmap( void *start, size_t length )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/linux_tv/media/v4l/func-open.rst
index 370a6858d65d..06937b925be3 100644
--- a/Documentation/linux_tv/media/v4l/func-open.rst
+++ b/Documentation/linux_tv/media/v4l/func-open.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <fcntl.h>
 
 
-.. c:function:: int open( const char *device_name, int flags )
+.. cpp:function:: int open( const char *device_name, int flags )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/linux_tv/media/v4l/func-poll.rst
index 782531fe964c..2de7f8a3a971 100644
--- a/Documentation/linux_tv/media/v4l/func-poll.rst
+++ b/Documentation/linux_tv/media/v4l/func-poll.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <sys/poll.h>
 
 
-.. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
+.. cpp:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
 
 Description
 ===========
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index 497bc9a9dd5a..94349fa19215 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. c:function:: ssize_t read( int fd, void *buf, size_t count )
+.. cpp:function:: ssize_t read( int fd, void *buf, size_t count )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/linux_tv/media/v4l/func-select.rst
index 77302800e6ca..56d01b33e25d 100644
--- a/Documentation/linux_tv/media/v4l/func-select.rst
+++ b/Documentation/linux_tv/media/v4l/func-select.rst
@@ -21,7 +21,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. c:function:: int select( int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout )
+.. cpp:function:: int select( int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout )
 
 Description
 ===========
diff --git a/Documentation/linux_tv/media/v4l/func-write.rst b/Documentation/linux_tv/media/v4l/func-write.rst
index d2265ba0d92d..402beed3231c 100644
--- a/Documentation/linux_tv/media/v4l/func-write.rst
+++ b/Documentation/linux_tv/media/v4l/func-write.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. c:function:: ssize_t write( int fd, void *buf, size_t count )
+.. cpp:function:: ssize_t write( int fd, void *buf, size_t count )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/media-func-close.rst b/Documentation/linux_tv/media/v4l/media-func-close.rst
index 4049db61ac73..e142ee73d15d 100644
--- a/Documentation/linux_tv/media/v4l/media-func-close.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-close.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. c:function:: int close( int fd )
+.. cpp:function:: int close( int fd )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/media-func-ioctl.rst b/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
index c07f4c05d0bc..7a5c01d6cb4a 100644
--- a/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <sys/ioctl.h>
 
 
-.. c:function:: int ioctl( int fd, int request, void *argp )
+.. cpp:function:: int ioctl( int fd, int request, void *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/media-func-open.rst b/Documentation/linux_tv/media/v4l/media-func-open.rst
index 59b01c294c9c..573292ac9a94 100644
--- a/Documentation/linux_tv/media/v4l/media-func-open.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-open.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <fcntl.h>
 
 
-.. c:function:: int open( const char *device_name, int flags )
+.. cpp:function:: int open( const char *device_name, int flags )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst b/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst
index 7c1b3904fbb2..230f9fd9b4fb 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst
@@ -14,7 +14,7 @@ Query device information
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_device_info *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct media_device_info *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst b/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
index 842b05438edb..2549857e681e 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
@@ -14,7 +14,7 @@ Enumerate entities and their properties
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_entity_desc *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct media_entity_desc *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst b/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
index 17aeb6d210f6..f3a4e41b3696 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
@@ -14,7 +14,7 @@ Enumerate all pads and links for a given entity
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_links_enum *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct media_links_enum *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst b/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst
index 65c817312df4..f22310319264 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst
@@ -14,7 +14,7 @@ Enumerate the graph topology and graph element properties
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_v2_topology *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct media_v2_topology *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst b/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
index 969a71c61309..aa6495fe3608 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
@@ -14,7 +14,7 @@ Modify the properties of a link
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct media_link_desc *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct media_link_desc *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index 53db867aa9db..fc9542e4204c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -14,7 +14,7 @@ Create buffers for Memory Mapped or User Pointer or DMA Buffer I/O
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_create_buffers *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_create_buffers *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
index 25ad9b29b160..22c4268ea54f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
@@ -14,7 +14,7 @@ Information about the video cropping and scaling abilities
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_cropcap *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_cropcap *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
index a1534a326bb3..4baf472b658b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
@@ -14,7 +14,7 @@ Identify the chips on a TV card
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dbg_chip_info *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dbg_chip_info *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
index b50c1be72f15..2c5afc9a4012 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
@@ -15,9 +15,9 @@ Read or write hardware registers
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dbg_register *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dbg_register *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_dbg_register *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_dbg_register *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
index a56c5fc1ed6f..d3b3c8a2ad08 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
@@ -15,7 +15,7 @@ Execute an decoder command
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_decoder_cmd *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_decoder_cmd *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
index 9e41fc818b90..509f0df19746 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
@@ -14,7 +14,7 @@ Dequeue event
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_event *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_event *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
index b5b8e41dc693..50133087af5b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
@@ -15,7 +15,7 @@ The capabilities of the Digital Video receiver/transmitter
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings_cap *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings_cap *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
index 43c7a3928e7b..7d029498d700 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
@@ -15,7 +15,7 @@ Execute an encoder command
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_encoder_cmd *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_encoder_cmd *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
index 07462519cbf4..4639d9a9f0a6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
@@ -15,7 +15,7 @@ Enumerate supported Digital Video timings
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_enum_dv_timings *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_enum_dv_timings *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
index c838f3dbb808..a20ed3ae3417 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
@@ -14,7 +14,7 @@ Enumerate image formats
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_fmtdesc *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_fmtdesc *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
index a9182898b6dc..24acbd928b9c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
@@ -14,7 +14,7 @@ Enumerate frame intervals
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_frmivalenum *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_frmivalenum *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
index 5e171dbc975c..1d2969220857 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
@@ -14,7 +14,7 @@ Enumerate frame sizes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_frmsizeenum *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_frmsizeenum *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
index 3999c419589a..bc0826bec1cb 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
@@ -14,7 +14,7 @@ Enumerate supported frequency bands
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_frequency_band *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_frequency_band *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
index 8ae7b8bd9333..32ef1fcb013d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
@@ -14,7 +14,7 @@ Enumerate audio inputs
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
index 0e45f41fa608..8412f1c0e4cf 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
@@ -14,7 +14,7 @@ Enumerate audio outputs
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
index 131f331462b1..3b0577a307e9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
@@ -14,7 +14,7 @@ Enumerate video inputs
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_input *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_input *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
index cb0107b9c03b..1ad68a88e594 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
@@ -14,7 +14,7 @@ Enumerate video outputs
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_output *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_output *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index 03353b92449a..6421b37b5ace 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -14,7 +14,7 @@ Enumerate supported video standards
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_standard *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_standard *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
index 2933640e8c4e..04216a0d658e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
@@ -14,7 +14,7 @@ Export a buffer as a DMABUF file descriptor.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_exportbuffer *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_exportbuffer *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index 4b79523bfbab..66d74f3964f3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -15,9 +15,9 @@ Query or select the current audio input and its attributes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_audio *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_audio *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
index 1da1e7ad51a6..990f86a20bd2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
@@ -15,9 +15,9 @@ Query or select the current audio output
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_audioout *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_audioout *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index b0503710c2dd..e2ffef351edf 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -15,9 +15,9 @@ Get or set the current cropping rectangle
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_crop *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_crop *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_crop *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_crop *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 55bb8ae9be10..333eb4fa5099 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -15,7 +15,7 @@ Get or set the value of a control
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_control *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_control *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index 43734bb649c5..c9de292ca1d2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -17,7 +17,7 @@ Get or set DV timings for input or output
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index d6ccae92e107..54f364bdde8e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -17,9 +17,9 @@ Get or set the EDID of a video receiver/transmitter
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
index c22907cddfac..35df295e1809 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
@@ -14,7 +14,7 @@ Get meta data about a compressed video stream
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_enc_idx *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_enc_idx *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index 040deef04f7d..91a0b8227423 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -16,7 +16,7 @@ Get or set the value of several controls, try control values
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_ext_controls *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_ext_controls *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index dbc68cfc608a..abf997fea991 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -15,9 +15,9 @@ Get or set frame buffer overlay parameters
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_framebuffer *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_framebuffer *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_framebuffer *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_framebuffer *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index 3ac4fb764a7e..173e4aca7ee1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -16,7 +16,7 @@ Get or set the data format, try a format
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_format *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_format *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
index b187f1345bb4..40ef31938f79 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
@@ -15,9 +15,9 @@ Get or set tuner or modulator radio frequency
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_frequency *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_frequency *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_frequency *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_frequency *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index bb5944449650..6b1fc39c602f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -15,7 +15,7 @@ Query or select the current video input
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, int *argp )
+.. cpp:function:: int ioctl( int fd, int request, int *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
index acd05bf0d7b6..b2da34012df6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
@@ -13,9 +13,9 @@ VIDIOC_S_JPEGCOMP
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, v4l2_jpegcompression *argp )
+.. cpp:function:: int ioctl( int fd, int request, v4l2_jpegcompression *argp )
 
-.. c:function:: int ioctl( int fd, int request, const v4l2_jpegcompression *argp )
+.. cpp:function:: int ioctl( int fd, int request, const v4l2_jpegcompression *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
index 913b7d96faba..b41ec0fe6acc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
@@ -15,9 +15,9 @@ Get or set modulator attributes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_modulator *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_modulator *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_modulator *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_modulator *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index e48bf39cfa10..95d7a9b19166 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -15,7 +15,7 @@ Query or select the current video output
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, int *argp )
+.. cpp:function:: int ioctl( int fd, int request, int *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 0567fce18144..2fbec8a6adfc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -15,7 +15,7 @@ Get or set streaming parameters
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, v4l2_streamparm *argp )
+.. cpp:function:: int ioctl( int fd, int request, v4l2_streamparm *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
index fd07c87a369c..271610e06b2b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
@@ -15,7 +15,7 @@ Get or set one of the selection rectangles
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_selection *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_selection *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
index a051f93252d0..00a9b61002de 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -14,7 +14,7 @@ Query sliced VBI capabilities
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_sliced_vbi_cap *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_sliced_vbi_cap *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index a7257f0b38a2..5644cc670381 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -15,9 +15,9 @@ Query or select the video standard of the current input
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
+.. cpp:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
 
-.. c:function:: int ioctl( int fd, int request, const v4l2_std_id *argp )
+.. cpp:function:: int ioctl( int fd, int request, const v4l2_std_id *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
index 1e01010fd2e2..8e119fa28ccd 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
@@ -15,9 +15,9 @@ Get or set tuner attributes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_tuner *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_tuner *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_tuner *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_tuner *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
index 6df7c2fd5b6c..af89f8f2dca6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
@@ -14,7 +14,7 @@ Log driver status information
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request )
+.. cpp:function:: int ioctl( int fd, int request )
 
 Description
 ===========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
index 10faf2517392..990907643869 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
@@ -14,7 +14,7 @@ Start or stop video overlay
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, const int *argp )
+.. cpp:function:: int ioctl( int fd, int request, const int *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
index 0b51c587701b..79a6a1009703 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
@@ -14,7 +14,7 @@ Prepare a buffer for I/O
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
index 57a0bc470f36..380970ba9a12 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
@@ -15,7 +15,7 @@ Exchange a buffer with the driver
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
index 0120432de989..9f067f587e42 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
@@ -15,7 +15,7 @@ Sense the DV preset received by the current input
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
index 280fb795c0b9..efc8143edc34 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
@@ -14,7 +14,7 @@ Query the status of a buffer
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
index 74589501b95d..91551fe448fc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
@@ -14,7 +14,7 @@ Query device capabilities
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index 2e93caeafe9e..a08c68262871 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -16,11 +16,11 @@ Enumerate controls and menu control items
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_queryctrl *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_queryctrl *argp )
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_query_ext_ctrl *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_query_ext_ctrl *argp )
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_querymenu *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_querymenu *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
index 29ce879a708b..de2fe176fc6d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
@@ -14,7 +14,7 @@ Sense the video standard received by the current input
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
+.. cpp:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
index 451cf7b11c3d..23b2fee646a1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
@@ -14,7 +14,7 @@ Initiate Memory Mapping or User Pointer I/O
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_requestbuffers *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_requestbuffers *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
index cd59ba9ab1b0..226440e4bb76 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
@@ -14,7 +14,7 @@ Perform a hardware frequency seek
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_hw_freq_seek *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_hw_freq_seek *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
index 7663339d30be..960c5965c7a6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
@@ -15,7 +15,7 @@ Start or stop streaming I/O
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, const int *argp )
+.. cpp:function:: int ioctl( int fd, int request, const int *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
index 07ad0a98ead2..bcf161cd5012 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -14,7 +14,7 @@ Enumerate frame intervals
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval_enum * argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval_enum * argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
index 39393ef11590..5ddb766f4a16 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
@@ -14,7 +14,7 @@ Enumerate media bus frame sizes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_size_enum * argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_size_enum * argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
index f50a1f1c68d5..dbaf866e82fe 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -14,7 +14,7 @@ Enumerate media bus formats
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_mbus_code_enum * argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_mbus_code_enum * argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
index 6fb1ea143f9e..46776cdfa7b5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
@@ -15,9 +15,9 @@ Get or set the crop rectangle on a subdev pad
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_crop *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_crop *argp )
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_subdev_crop *argp )
+.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_subdev_crop *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
index 789277a2647a..b4d109943fd2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
@@ -15,7 +15,7 @@ Get or set the data format on a subdev pad
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_format *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_format *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
index bcc54e2e396f..9504e8b5de8a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
@@ -15,7 +15,7 @@ Get or set the frame interval on a subdev pad
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
index 7b60c9b99aad..d95b5431004c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
@@ -15,7 +15,7 @@ Get or set selection rectangles on a subdev pad
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_selection *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_selection *argp )
 
 Arguments
 =========
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
index 182353f544eb..a127622d47b8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
@@ -15,7 +15,7 @@ Subscribe or unsubscribe event
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_event_subscription *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_event_subscription *argp )
 
 Arguments
 =========
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
old mode 100755
new mode 100644
index 932b3f34ff06..41eade332307
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1833,7 +1833,7 @@ sub output_function_rst(%) {
     my $oldprefix = $lineprefix;
     my $start;
 
-    print ".. c:function:: ";
+    print ".. cpp:function:: ";
     if ($args{'functiontype'} ne "") {
 	$start = $args{'functiontype'} . " " . $args{'function'} . " (";
     } else {
-- 
2.7.4


