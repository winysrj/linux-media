Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbcGMLQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 07:16:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/2] [media] docs-rst: escape [] characters
Date: Wed, 13 Jul 2016 08:15:48 -0300
Message-Id: <ffbab694ede33c294e5864a5e0bf4d1474446a71.1468408280.git.mchehab@s-opensource.com>
In-Reply-To: <4855307b81f02af4853e02cba2ce16eb29376548.1468408280.git.mchehab@s-opensource.com>
References: <4855307b81f02af4853e02cba2ce16eb29376548.1468408280.git.mchehab@s-opensource.com>
In-Reply-To: <4855307b81f02af4853e02cba2ce16eb29376548.1468408280.git.mchehab@s-opensource.com>
References: <4855307b81f02af4853e02cba2ce16eb29376548.1468408280.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those characters are used for citations. Better to escape, to
avoid them to be misinterpreted.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   6 +--
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |   2 +-
 Documentation/media/uapi/dvb/ca_data_types.rst     |   4 +-
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  |   4 +-
 Documentation/media/uapi/dvb/dtv-property.rst      |   6 +--
 Documentation/media/uapi/dvb/examples.rst          |  18 +++----
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |   4 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |   4 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |   2 +-
 Documentation/media/uapi/dvb/video_types.rst       |   4 +-
 .../media/uapi/mediactl/media-ioc-device-info.rst  |  10 ++--
 .../uapi/mediactl/media-ioc-enum-entities.rst      |   4 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |  10 ++--
 Documentation/media/uapi/rc/keytable.c.rst         |  42 +++++++--------
 Documentation/media/uapi/v4l/buffer.rst            |   4 +-
 Documentation/media/uapi/v4l/capture.c.rst         |  14 ++---
 Documentation/media/uapi/v4l/dev-osd.rst           |   2 +-
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       |   4 +-
 .../media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf   | Bin 3683 -> 3685 bytes
 Documentation/media/uapi/v4l/dev-sdr.rst           |   2 +-
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |  58 ++++++++++-----------
 Documentation/media/uapi/v4l/hist-v4l2.rst         |  10 ++--
 Documentation/media/uapi/v4l/pixfmt-003.rst        |   4 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |   2 +-
 Documentation/media/uapi/v4l/v4l2grab.c.rst        |   2 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |   2 +-
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |   6 +--
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |   2 +-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          |   2 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   4 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   6 +--
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |   2 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |   2 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   4 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |   2 +-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |   2 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |   2 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   4 +-
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |   4 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |   4 +-
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |   4 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |   2 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |   4 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |   2 +-
 .../media/uapi/v4l/vidioc-g-frequency.rst          |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |   4 +-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |   6 +--
 .../media/uapi/v4l/vidioc-g-selection.rst          |   2 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |  16 +++---
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |   4 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   8 +--
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  12 ++---
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |   2 +-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |   2 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |   2 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |   2 +-
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |   2 +-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |   2 +-
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |   2 +-
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |   2 +-
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |   2 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |   2 +-
 68 files changed, 188 insertions(+), 188 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 2ca9199c3305..8d9d55757d45 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -52,7 +52,7 @@ returns the information to the application. The ioctl never fails.
 
        -  char
 
-       -  ``driver[32]``
+       -  ``driver\[32\]``
 
        -  The name of the cec adapter driver.
 
@@ -60,7 +60,7 @@ returns the information to the application. The ioctl never fails.
 
        -  char
 
-       -  ``name[32]``
+       -  ``name\[32\]``
 
        -  The name of this CEC adapter. The combination ``driver`` and
 	  ``name`` must be unique.
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 7d7a3b43aedc..c52b8888d381 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -70,7 +70,7 @@ by a file handle in initiator mode (see
        -  The actual logical addresses that were claimed. This is set by the
 	  driver. If no logical address could be claimed, then it is set to
 	  ``CEC_LOG_ADDR_INVALID``. If this adapter is Unregistered, then
-	  ``log_addr[0]`` is set to 0xf and all others to
+	  ``log_addr\[0\]`` is set to 0xf and all others to
 	  ``CEC_LOG_ADDR_INVALID``.
 
     -  .. row 2
@@ -138,7 +138,7 @@ by a file handle in initiator mode (see
 
        -  char
 
-       -  ``osd_name``\ [15]
+       -  ``osd_name``\ \[15\]
 
        -  The On-Screen Display name as is returned by the
 	  ``CEC_MSG_SET_OSD_NAME`` message.
@@ -178,7 +178,7 @@ by a file handle in initiator mode (see
 
        -  __u8
 
-       -  ``features`` [CEC_MAX_LOG_ADDRS][12]
+       -  ``features`` [CEC_MAX_LOG_ADDRS]\[12\]
 
        -  Features for each logical address. Used to implement the
 	  ``CEC_MSG_REPORT_FEATURES`` message. The 12 bytes include both the
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 47aadcd553ee..9a16a3d38340 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -139,7 +139,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  __u8
 
-       -  ``msg``\ [16]
+       -  ``msg``\ \[16\]
 
        -  The message payload. For :ref:`CEC_TRANSMIT` this is filled in by the
 	  application. The driver will fill this in for :ref:`CEC_RECEIVE` and
diff --git a/Documentation/media/uapi/dvb/ca_data_types.rst b/Documentation/media/uapi/dvb/ca_data_types.rst
index 025f910ae945..8a776c855aab 100644
--- a/Documentation/media/uapi/dvb/ca_data_types.rst
+++ b/Documentation/media/uapi/dvb/ca_data_types.rst
@@ -77,7 +77,7 @@ ca_msg_t
 	unsigned int index;
 	unsigned int type;
 	unsigned int length;
-	unsigned char msg[256];
+	unsigned char msg\[256\];
     } ca_msg_t;
 
 
@@ -92,7 +92,7 @@ ca_descr_t
     typedef struct ca_descr {
 	unsigned int index;
 	unsigned int parity;
-	unsigned char cw[8];
+	unsigned char cw\[8\];
     } ca_descr_t;
 
 
diff --git a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
index ba5d30c913c8..dcca37c7cec1 100644
--- a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
@@ -15,7 +15,7 @@ DMX_GET_PES_PIDS
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
+.. cpp:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16\[5\])
 
 
 Arguments
@@ -40,7 +40,7 @@ Arguments
 
     -  .. row 3
 
-       -  __u16[5]
+       -  __u16\[5\]
 
        -  Undocumented.
 
diff --git a/Documentation/media/uapi/dvb/dtv-property.rst b/Documentation/media/uapi/dvb/dtv-property.rst
index 5073a49def2a..219111ebc7f5 100644
--- a/Documentation/media/uapi/dvb/dtv-property.rst
+++ b/Documentation/media/uapi/dvb/dtv-property.rst
@@ -13,14 +13,14 @@ struct dtv_property
 
     struct dtv_property {
 	__u32 cmd;
-	__u32 reserved[3];
+	__u32 reserved\[3\];
 	union {
 	    __u32 data;
 	    struct dtv_fe_stats st;
 	    struct {
-		__u8 data[32];
+		__u8 data\[32\];
 		__u32 len;
-		__u32 reserved1[3];
+		__u32 reserved1\[3\];
 		void *reserved2;
 	    } buffer;
 	} u;
diff --git a/Documentation/media/uapi/dvb/examples.rst b/Documentation/media/uapi/dvb/examples.rst
index bf0a8617de92..e23ad9fb2008 100644
--- a/Documentation/media/uapi/dvb/examples.rst
+++ b/Documentation/media/uapi/dvb/examples.rst
@@ -87,7 +87,7 @@ tuners, but can easily be adjusted for QAM.
 	 struct secCmdSequence scmds;
 	 struct dmx_pes_filter_params pesFilterParams;
 	 FrontendParameters frp;
-	 struct pollfd pfd[1];
+	 struct pollfd pfd\[1\];
 	 FrontendEvent event;
 	 int demux1, demux2, demux3, front;
 
@@ -143,7 +143,7 @@ tuners, but can easily be adjusted for QAM.
 	 scmd.u.diseqc.addr=0x10;
 	 scmd.u.diseqc.cmd=0x38;
 	 scmd.u.diseqc.numParams=1;
-	 scmd.u.diseqc.params[0] = 0xF0 | ((diseqc * 4) & 0x0F) |
+	 scmd.u.diseqc.params\[0\] = 0xF0 | ((diseqc * 4) & 0x0F) |
 	     (scmds.continuousTone == SEC_TONE_ON ? 1 : 0) |
 	     (scmds.voltage==SEC_VOLTAGE_18 ? 2 : 0);
 
@@ -168,11 +168,11 @@ tuners, but can easily be adjusted for QAM.
 	     return -1;
 	 }
 
-	 pfd[0].fd = front;
-	 pfd[0].events = POLLIN;
+	 pfd\[0\].fd = front;
+	 pfd\[0\].events = POLLIN;
 
 	 if (poll(pfd,1,3000)){
-	     if (pfd[0].revents & POLLIN){
+	     if (pfd\[0\].revents & POLLIN){
 		 printf("Getting QPSK event\\n");
 		 if ( ioctl(front, FE_GET_EVENT, &event)
 
@@ -324,7 +324,7 @@ recording.
 	 int written;
 	 uint8_t buf[BUFFY];
 	 uint64_t length;
-	 struct pollfd pfd[1];
+	 struct pollfd pfd\[1\];
 	 int dvr, dvr_out;
 
 	 /* open dvr device */
@@ -351,13 +351,13 @@ recording.
 	     return -1;
 	 }
 
-	 pfd[0].fd = dvr;
-	 pfd[0].events = POLLIN;
+	 pfd\[0\].fd = dvr;
+	 pfd\[0\].events = POLLIN;
 
 	 /* poll for dvr data and write to file */
 	 while (length < MAX_LENGTH ) {
 	     if (poll(pfd,1,1)){
-		 if (pfd[0].revents & POLLIN){
+		 if (pfd\[0\].revents & POLLIN){
 		     len = read(dvr, buf, BUFFY);
 		     if (len < 0){
 			 perror("recording");
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index 7bd02ac7bff4..0c356fcb6f08 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -52,9 +52,9 @@ struct dvb_diseqc_slave_reply
 
        -  uint8_t
 
-       -  msg[4]
+       -  msg\[4\]
 
-       -  DiSEqC message (framing, data[3])
+       -  DiSEqC message (framing, data\[3\])
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index 58a5e6ac10bd..a60b8dd157fe 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -52,9 +52,9 @@ struct dvb_diseqc_master_cmd
 
        -  uint8_t
 
-       -  msg[6]
+       -  msg\[6\]
 
-       -  DiSEqC message (framing, address, command, data[3])
+       -  DiSEqC message (framing, address, command, data\[3\])
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index bb6c32e47ce8..4176977f07b3 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -57,7 +57,7 @@ struct dvb_frontend_info
 
        -  char
 
-       -  name[128]
+       -  name\[128\]
 
        -  Name of the frontend
 
diff --git a/Documentation/media/uapi/dvb/video_types.rst b/Documentation/media/uapi/dvb/video_types.rst
index 671f365ceeb4..d4debb36580d 100644
--- a/Documentation/media/uapi/dvb/video_types.rst
+++ b/Documentation/media/uapi/dvb/video_types.rst
@@ -125,7 +125,7 @@ it can be extended safely in the future.
 	    } play;
 
 	    struct {
-		__u32 data[16];
+		__u32 data\[16\];
 	    } raw;
 	};
     };
@@ -352,7 +352,7 @@ passed to the ioctl VIDEO_GET_NAVI:
      typedef
      struct video_navi_pack {
 	 int length;         /* 0 ... 1024 */
-	 uint8_t data[1024];
+	 uint8_t data\[1024\];
      } video_navi_pack_t;
 
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index 467d82cbb81e..e7d9570a020f 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -52,7 +52,7 @@ ioctl never fails.
 
        -  char
 
-       -  ``driver``\ [16]
+       -  ``driver``\ \[16\]
 
        -  Name of the driver implementing the media API as a NUL-terminated
 	  ASCII string. The driver version is stored in the
@@ -66,7 +66,7 @@ ioctl never fails.
 
        -  char
 
-       -  ``model``\ [32]
+       -  ``model``\ \[32\]
 
        -  Device model name as a NUL-terminated UTF-8 string. The device
 	  version is stored in the ``device_version`` field and is not be
@@ -76,7 +76,7 @@ ioctl never fails.
 
        -  char
 
-       -  ``serial``\ [40]
+       -  ``serial``\ \[40\]
 
        -  Serial number as a NUL-terminated ASCII string.
 
@@ -84,7 +84,7 @@ ioctl never fails.
 
        -  char
 
-       -  ``bus_info``\ [32]
+       -  ``bus_info``\ \[32\]
 
        -  Location of the device in the system as a NUL-terminated ASCII
 	  string. This includes the bus type name (PCI, USB, ...) and a
@@ -120,7 +120,7 @@ ioctl never fails.
 
        -  __u32
 
-       -  ``reserved``\ [31]
+       -  ``reserved``\ \[31\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 12d4b25d5b94..181eef6a34e6 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -75,7 +75,7 @@ id's until they get an error.
 
        -  char
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -
        -
@@ -181,7 +181,7 @@ id's until they get an error.
        -
        -  __u8
 
-       -  ``raw``\ [184]
+       -  ``raw``\ \[184\]
 
        -
        -
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 2e382cc7762c..6fc564dde397 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -163,7 +163,7 @@ desired arrays with the media graph elements.
 
        -  char
 
-       -  ``name``\ [64]
+       -  ``name``\ \[64\]
 
        -  Entity name as an UTF-8 NULL-terminated string.
 
@@ -179,7 +179,7 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [12]
+       -  ``reserved``\ \[12\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
@@ -221,7 +221,7 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [9]
+       -  ``reserved``\ \[9\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
@@ -299,7 +299,7 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [9]
+       -  ``reserved``\ \[9\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
@@ -354,7 +354,7 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [5]
+       -  ``reserved``\ \[5\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
diff --git a/Documentation/media/uapi/rc/keytable.c.rst b/Documentation/media/uapi/rc/keytable.c.rst
index e6ce1e3f5a78..5ee6e8c6639d 100644
--- a/Documentation/media/uapi/rc/keytable.c.rst
+++ b/Documentation/media/uapi/rc/keytable.c.rst
@@ -35,16 +35,16 @@ file: uapi/v4l/keytable.c
 	    struct parse_key *p;
 
 	    for (p=keynames;p->name!=NULL;p++) {
-		    if (p->value == (unsigned)codes[1]) {
-			    printf("scancode 0x%04x = %s (0x%02x)\\n", codes[0], p->name, codes[1]);
+		    if (p->value == (unsigned)codes\[1\]) {
+			    printf("scancode 0x%04x = %s (0x%02x)\\n", codes\[0\], p->name, codes\[1\]);
 			    return;
 		    }
 	    }
 
-	    if (isprint (codes[1]))
-		    printf("scancode %d = '%c' (0x%02x)\\n", codes[0], codes[1], codes[1]);
+	    if (isprint (codes\[1\]))
+		    printf("scancode %d = '%c' (0x%02x)\\n", codes\[0\], codes\[1\], codes\[1\]);
 	    else
-		    printf("scancode %d = 0x%02x\\n", codes[0], codes[1]);
+		    printf("scancode %d = 0x%02x\\n", codes\[0\], codes\[1\]);
     }
 
     int parse_code(char *string)
@@ -63,7 +63,7 @@ file: uapi/v4l/keytable.c
     {
 	    int fd;
 	    unsigned int i, j;
-	    int codes[2];
+	    int codes\[2\];
 
 	    if (argc<2 || argc>4) {
 		    printf ("usage: %s <device> to get table; or\\n"
@@ -72,7 +72,7 @@ file: uapi/v4l/keytable.c
 		    return -1;
 	    }
 
-	    if ((fd = open(argv[1], O_RDONLY)) < 0) {
+	    if ((fd = open(argv\[1\], O_RDONLY)) < 0) {
 		    perror("Couldn't open input device");
 		    return(-1);
 	    }
@@ -80,16 +80,16 @@ file: uapi/v4l/keytable.c
 	    if (argc==4) {
 		    int value;
 
-		    value=parse_code(argv[3]);
+		    value=parse_code(argv\[3\]);
 
 		    if (value==-1) {
-			    value = strtol(argv[3], NULL, 0);
+			    value = strtol(argv\[3\], NULL, 0);
 			    if (errno)
 				    perror("value");
 		    }
 
-		    codes [0] = (unsigned) strtol(argv[2], NULL, 0);
-		    codes [1] = (unsigned) value;
+		    codes \[0\] = (unsigned) strtol(argv\[2\], NULL, 0);
+		    codes \[1\] = (unsigned) value;
 
 		    if(ioctl(fd, EVIOCSKEYCODE, codes))
 			    perror ("EVIOCSKEYCODE");
@@ -102,9 +102,9 @@ file: uapi/v4l/keytable.c
 	    if (argc==3) {
 		    FILE *fin;
 		    int value;
-		    char *scancode, *keycode, s[2048];
+		    char *scancode, *keycode, s\[2048\];
 
-		    fin=fopen(argv[2],"r");
+		    fin=fopen(argv\[2\],"r");
 		    if (fin==NULL) {
 			    perror ("opening keycode file");
 			    return -1;
@@ -113,8 +113,8 @@ file: uapi/v4l/keytable.c
 		    /* Clears old table */
 		    for (j = 0; j < 256; j++) {
 			    for (i = 0; i < 256; i++) {
-				    codes[0] = (j << 8) | i;
-				    codes[1] = KEY_RESERVED;
+				    codes\[0\] = (j << 8) | i;
+				    codes\[1\] = KEY_RESERVED;
 				    ioctl(fd, EVIOCSKEYCODE, codes);
 			    }
 		    }
@@ -149,12 +149,12 @@ file: uapi/v4l/keytable.c
 					    perror("value");
 			    }
 
-			    codes [0] = (unsigned) strtol(scancode, NULL, 0);
-			    codes [1] = (unsigned) value;
+			    codes \[0\] = (unsigned) strtol(scancode, NULL, 0);
+			    codes \[1\] = (unsigned) value;
 
-			    // printf("\\t%04x=%04x\\n",codes[0], codes[1]);
+			    // printf("\\t%04x=%04x\\n",codes\[0\], codes\[1\]);
 			    if(ioctl(fd, EVIOCSKEYCODE, codes)) {
-				    fprintf(stderr, "Setting scancode 0x%04x with 0x%04x via ",codes[0], codes[1]);
+				    fprintf(stderr, "Setting scancode 0x%04x with 0x%04x via ",codes\[0\], codes\[1\]);
 				    perror ("EVIOCSKEYCODE");
 			    }
 
@@ -167,8 +167,8 @@ file: uapi/v4l/keytable.c
 	    /* Get scancode table */
 	    for (j = 0; j < 256; j++) {
 		    for (i = 0; i < 256; i++) {
-			    codes[0] = (j << 8) | i;
-			    if (!ioctl(fd, EVIOCGKEYCODE, codes) && codes[1] != KEY_RESERVED)
+			    codes\[0\] = (j << 8) | i;
+			    if (!ioctl(fd, EVIOCGKEYCODE, codes) && codes\[1\] != KEY_RESERVED)
 				    prtcode(codes);
 		    }
 	    }
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 5deb4a46f992..ba22464c0fcc 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -379,7 +379,7 @@ struct v4l2_plane
 
        -  __u32
 
-       -  ``reserved[11]``
+       -  ``reserved\[11\]``
 
        -
        -  Reserved for future use. Should be zeroed by drivers and
@@ -868,7 +868,7 @@ struct v4l2_timecode
 
        -  __u8
 
-       -  ``userbits``\ [4]
+       -  ``userbits``\ \[4\]
 
        -  The "user group" bits from the timecode.
 
diff --git a/Documentation/media/uapi/v4l/capture.c.rst b/Documentation/media/uapi/v4l/capture.c.rst
index 56525a0fb2fa..4f0dead97ad2 100644
--- a/Documentation/media/uapi/v4l/capture.c.rst
+++ b/Documentation/media/uapi/v4l/capture.c.rst
@@ -88,7 +88,7 @@ file: media/v4l/capture.c
 
 	    switch (io) {
 	    case IO_METHOD_READ:
-		    if (-1 == read(fd, buffers[0].start, buffers[0].length)) {
+		    if (-1 == read(fd, buffers\[0\].start, buffers\[0\].length)) {
 			    switch (errno) {
 			    case EAGAIN:
 				    return 0;
@@ -103,7 +103,7 @@ file: media/v4l/capture.c
 			    }
 		    }
 
-		    process_image(buffers[0].start, buffers[0].length);
+		    process_image(buffers\[0\].start, buffers\[0\].length);
 		    break;
 
 	    case IO_METHOD_MMAP:
@@ -284,7 +284,7 @@ file: media/v4l/capture.c
 
 	    switch (io) {
 	    case IO_METHOD_READ:
-		    free(buffers[0].start);
+		    free(buffers\[0\].start);
 		    break;
 
 	    case IO_METHOD_MMAP:
@@ -311,10 +311,10 @@ file: media/v4l/capture.c
 		    exit(EXIT_FAILURE);
 	    }
 
-	    buffers[0].length = buffer_size;
-	    buffers[0].start = malloc(buffer_size);
+	    buffers\[0\].length = buffer_size;
+	    buffers\[0\].start = malloc(buffer_size);
 
-	    if (!buffers[0].start) {
+	    if (!buffers\[0\].start) {
 		    fprintf(stderr, "Out of memory\\n");
 		    exit(EXIT_FAILURE);
 	    }
@@ -575,7 +575,7 @@ file: media/v4l/capture.c
 		     "-f | --format        Force format to 640x480 YUYVn"
 		     "-c | --count         Number of frames to grab [%i]n"
 		     "",
-		     argv[0], dev_name, frame_count);
+		     argv\[0\], dev_name, frame_count);
     }
 
     static const char short_options[] = "d:hmruofc:";
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
index fadda131f020..36129cf4e92a 100644
--- a/Documentation/media/uapi/v4l/dev-osd.rst
+++ b/Documentation/media/uapi/v4l/dev-osd.rst
@@ -68,7 +68,7 @@ Example: Finding a framebuffer device for OSD
     }
 
     for (i = 0; i < 30; i++) {
-	char dev_name[16];
+	char dev_name\[16\];
 	struct fb_fix_screeninfo si;
 
 	snprintf(dev_name, sizeof(dev_name), "/dev/fb%u", i);
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index d5a4b3530b69..eea4c05a0cd4 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -188,7 +188,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 	  service transmissions embedded in the picture.
 
 	  An application can set the first or second ``count`` value to zero
-	  if no data is required from the respective field; ``count``\ [1]
+	  if no data is required from the respective field; ``count``\ \[1\]
 	  if the scanning system is progressive, i. e. not interlaced. The
 	  corresponding start value shall be ignored by the application and
 	  driver. Anyway, drivers may not support single field capturing and
@@ -318,7 +318,7 @@ The total size of a frame computes as follows:
 
 .. code-block:: c
 
-    (count[0] + count[1]) * samples_per_line * sample size in bytes
+    (count\[0\] + count\[1\]) * samples_per_line * sample size in bytes
 
 The sample size is most likely always one byte, applications must check
 the ``sample_format`` field though, to function properly with other
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf
index 765235e33a4de256a0b3fbf64ffe52946190cac4..f672b52ef683b3b6da4a43167f67ecbecfd6dc36 100644
GIT binary patch
delta 18
ZcmaDX^HgR-AtP%{w54Ut<`TyDJOD)g2G9Ti

delta 16
XcmaDV^H^p>AtQ6NrRC-_#`in`I2#5S

diff --git a/Documentation/media/uapi/v4l/dev-sdr.rst b/Documentation/media/uapi/v4l/dev-sdr.rst
index fc4053f957fb..2bb560580b75 100644
--- a/Documentation/media/uapi/v4l/dev-sdr.rst
+++ b/Documentation/media/uapi/v4l/dev-sdr.rst
@@ -110,7 +110,7 @@ data transfer, set by the driver in order to inform application.
 
        -  __u8
 
-       -  ``reserved[24]``
+       -  ``reserved\[24\]``
 
        -  This array is reserved for future extensions. Drivers and
 	  applications must set it to zero.
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index ec52a825f4d6..7df760367021 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -140,7 +140,7 @@ struct v4l2_sliced_vbi_format
 
        -  __u16
 
-       -  ``service_lines``\ [2][24]
+       -  ``service_lines``\ \[2\]\[24\]
 
        -  :cspan:`2`
 
@@ -170,7 +170,7 @@ struct v4l2_sliced_vbi_format
 
        -
        -
-       -  ``service_lines``\ [0][1]
+       -  ``service_lines``\ \[0\]\[1\]
 
        -  1
 
@@ -180,7 +180,7 @@ struct v4l2_sliced_vbi_format
 
        -
        -
-       -  ``service_lines``\ [0][23]
+       -  ``service_lines``\ \[0\]\[23\]
 
        -  23
 
@@ -190,7 +190,7 @@ struct v4l2_sliced_vbi_format
 
        -
        -
-       -  ``service_lines``\ [1][1]
+       -  ``service_lines``\ \[1\]\[1\]
 
        -  264
 
@@ -200,7 +200,7 @@ struct v4l2_sliced_vbi_format
 
        -
        -
-       -  ``service_lines``\ [1][23]
+       -  ``service_lines``\ \[1\]\[23\]
 
        -  286
 
@@ -210,8 +210,8 @@ struct v4l2_sliced_vbi_format
 
        -
        -
-       -  :cspan:`2` Drivers must set ``service_lines`` [0][0] and
-	  ``service_lines``\ [1][0] to zero. The
+       -  :cspan:`2` Drivers must set ``service_lines`` \[0\]\[0\] and
+	  ``service_lines``\ \[1\]\[0\] to zero. The
 	  ``V4L2_VBI_ITU_525_F1_START``, ``V4L2_VBI_ITU_525_F2_START``,
 	  ``V4L2_VBI_ITU_625_F1_START`` and ``V4L2_VBI_ITU_625_F2_START``
 	  defines give the start line numbers for each field for each 525 or
@@ -238,7 +238,7 @@ struct v4l2_sliced_vbi_format
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  :cspan:`2` This array is reserved for future extensions.
 	  Applications and drivers must set it to zero.
@@ -427,7 +427,7 @@ struct v4l2_sliced_vbi_data
 
        -  __u8
 
-       -  ``data``\ [48]
+       -  ``data``\ \[48\]
 
        -  The packet payload. See :ref:`vbi-services` for the contents and
 	  number of bytes passed for each data type. The contents of padding
@@ -566,7 +566,7 @@ struct v4l2_mpeg_vbi_fmt_ivtv
 
        -  __u8
 
-       -  ``magic``\ [4]
+       -  ``magic``\ \[4\]
 
        -
        -  A "magic" constant from :ref:`v4l2-mpeg-vbi-fmt-ivtv-magic` that
@@ -662,7 +662,7 @@ struct v4l2_mpeg_vbi_itv0
 
        -  __le32
 
-       -  ``linemask``\ [2]
+       -  ``linemask``\ \[2\]
 
        -  Bitmasks indicating the VBI service lines present. These
 	  ``linemask`` values are stored in little endian byte order in the
@@ -675,30 +675,30 @@ struct v4l2_mpeg_vbi_itv0
 
 	  ::
 
-	      linemask[0] b0:     line  6     first field
-	      linemask[0] b17:        line 23     first field
-	      linemask[0] b18:        line  6     second field
-	      linemask[0] b31:        line 19     second field
-	      linemask[1] b0:     line 20     second field
-	      linemask[1] b3:     line 23     second field
-	      linemask[1] b4-b31: unused and set to 0
+	      linemask\[0\] b0:     line  6     first field
+	      linemask\[0\] b17:        line 23     first field
+	      linemask\[0\] b18:        line  6     second field
+	      linemask\[0\] b31:        line 19     second field
+	      linemask\[1\] b0:     line 20     second field
+	      linemask\[1\] b3:     line 23     second field
+	      linemask\[1\] b4-b31: unused and set to 0
 
     -  .. row 2
 
        -  struct
 	  :ref:`v4l2_mpeg_vbi_itv0_line <v4l2-mpeg-vbi-itv0-line>`
 
-       -  ``line``\ [35]
+       -  ``line``\ \[35\]
 
        -  This is a variable length array that holds from 1 to 35 lines of
 	  sliced VBI data. The sliced VBI data lines present correspond to
 	  the bits set in the ``linemask`` array, starting from b\ :sub:`0`
-	  of ``linemask``\ [0] up through b\ :sub:`31` of ``linemask``\ [0],
-	  and from b\ :sub:`0` of ``linemask``\ [1] up through b\ :sub:`3` of
-	  ``linemask``\ [1]. ``line``\ [0] corresponds to the first bit
-	  found set in the ``linemask`` array, ``line``\ [1] corresponds to
+	  of ``linemask``\ \[0\] up through b\ :sub:`31` of ``linemask``\ \[0\],
+	  and from b\ :sub:`0` of ``linemask``\ \[1\] up through b\ :sub:`3` of
+	  ``linemask``\ \[1\]. ``line``\ \[0\] corresponds to the first bit
+	  found set in the ``linemask`` array, ``line``\ \[1\] corresponds to
 	  the second bit found set in the ``linemask`` array, etc. If no
-	  ``linemask`` array bits are set, then ``line``\ [0] may contain
+	  ``linemask`` array bits are set, then ``line``\ \[0\] may contain
 	  one line of unspecified data that should be ignored by
 	  applications.
 
@@ -720,11 +720,11 @@ struct v4l2_mpeg_vbi_ITV0
        -  struct
 	  :ref:`v4l2_mpeg_vbi_itv0_line <v4l2-mpeg-vbi-itv0-line>`
 
-       -  ``line``\ [36]
+       -  ``line``\ \[36\]
 
-       -  A fixed length array of 36 lines of sliced VBI data. ``line``\ [0]
-	  through ``line``\ [17] correspond to lines 6 through 23 of the
-	  first field. ``line``\ [18] through ``line``\ [35] corresponds to
+       -  A fixed length array of 36 lines of sliced VBI data. ``line``\ \[0\]
+	  through ``line``\ \[17\] correspond to lines 6 through 23 of the
+	  first field. ``line``\ \[18\] through ``line``\ \[35\] corresponds to
 	  lines 6 through 23 of the second field.
 
 
@@ -754,7 +754,7 @@ struct v4l2_mpeg_vbi_itv0_line
 
        -  __u8
 
-       -  ``data``\ [42]
+       -  ``data``\ \[42\]
 
        -  The sliced VBI data for the line.
 
diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
index 3ba1c0c2df1a..3882fc7782d0 100644
--- a/Documentation/media/uapi/v4l/hist-v4l2.rst
+++ b/Documentation/media/uapi/v4l/hist-v4l2.rst
@@ -266,7 +266,7 @@ V4L2 Version 0.20 2000-11-23
 A number of changes were made to the raw VBI interface.
 
 1. Figures clarifying the line numbering scheme were added to the V4L2
-   API specification. The ``start``\ [0] and ``start``\ [1] fields no
+   API specification. The ``start``\ \[0\] and ``start``\ \[1\] fields no
    longer count line numbers beginning at zero. Rationale: a) The
    previous definition was unclear. b) The ``start``\ [] values are
    ordinal numbers. c) There is no point in inventing a new line
@@ -274,8 +274,8 @@ A number of changes were made to the raw VBI interface.
    Compatibility: Add one to the start values. Applications depending on
    the previous semantics may not function correctly.
 
-2. The restriction "count[0] > 0 and count[1] > 0" has been relaxed to
-   "(count[0] + count[1]) > 0". Rationale: Drivers may allocate
+2. The restriction "count\[0\] > 0 and count\[1\] > 0" has been relaxed to
+   "(count\[0\] + count\[1\]) > 0". Rationale: Drivers may allocate
    resources at scan line granularity and some data services are
    transmitted only on the first field. The comment that both ``count``
    values will usually be equal is misleading and pointless and has been
@@ -649,7 +649,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     memory. It was barely useful and so was removed.
 
 14. In struct :ref:`v4l2_framebuffer <v4l2-framebuffer>` the
-    ``base[3]`` array anticipating double- and triple-buffering in
+    ``base\[3\]`` array anticipating double- and triple-buffering in
     off-screen video memory, however without defining a synchronization
     mechanism, was replaced by a single pointer. The
     ``V4L2_FBUF_CAP_SCALEUP`` and ``V4L2_FBUF_CAP_SCALEDOWN`` flags were
@@ -833,7 +833,7 @@ V4L2 in Linux 2.6.6, 2004-05-09
 V4L2 in Linux 2.6.8
 ===================
 
-1. A new field ``input`` (former ``reserved[0]``) was added to the
+1. A new field ``input`` (former ``reserved\[0\]``) was added to the
    struct :ref:`v4l2_buffer <v4l2-buffer>` structure. Purpose of this
    field is to alternate between video inputs (e. g. cameras) in step
    with the video capturing process. This function must be enabled with
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
index 25c54872fbe1..d6a80d16afbc 100644
--- a/Documentation/media/uapi/v4l/pixfmt-003.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-003.rst
@@ -41,7 +41,7 @@ describing all planes of that format.
 
        -  __u16
 
-       -  ``reserved[6]``
+       -  ``reserved\[6\]``
 
        -  Reserved for future extensions. Should be zeroed by drivers and
 	  applications.
@@ -160,7 +160,7 @@ describing all planes of that format.
 
        -  __u8
 
-       -  ``reserved[7]``
+       -  ``reserved\[7\]``
 
        -  Reserved for future extensions. Should be zeroed by drivers and
 	  applications.
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 6dbb27b09c34..c365cf116308 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -92,7 +92,7 @@ Media Bus Formats
 
        -  __u16
 
-       -  ``reserved``\ [11]
+       -  ``reserved``\ \[11\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/v4l2grab.c.rst b/Documentation/media/uapi/v4l/v4l2grab.c.rst
index 5aabd0b7b089..5d0263aab18c 100644
--- a/Documentation/media/uapi/v4l/v4l2grab.c.rst
+++ b/Documentation/media/uapi/v4l/v4l2grab.c.rst
@@ -62,7 +62,7 @@ file: media/v4l/v4l2grab.c
 	    int                             r, fd = -1;
 	    unsigned int                    i, n_buffers;
 	    char                            *dev_name = "/dev/video0";
-	    char                            out_name[256];
+	    char                            out_name\[256\];
 	    FILE                            *fout;
 	    struct buffer                   *buffers;
 
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index abdc0b4d83d5..45c28af5c523 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -125,7 +125,7 @@ than the number requested.
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -  A place holder for future extensions. Drivers and applications
 	  must set the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index f7e1b80af29e..4c683a3457c2 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -115,7 +115,7 @@ instructions.
        -
        -  char
 
-       -  ``name[32]``
+       -  ``name\[32\]``
 
        -  Match a chip by this name, interpreted according to the ``type``
 	  field. Currently unused.
@@ -142,7 +142,7 @@ instructions.
 
        -  char
 
-       -  ``name[32]``
+       -  ``name\[32\]``
 
        -  The name of the chip.
 
@@ -161,7 +161,7 @@ instructions.
 
        -  __u32
 
-       -  ``reserved[8]``
+       -  ``reserved\[8\]``
 
        -  Reserved fields, both application and driver must set these to 0.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index 09d2880e6170..d8ab629b087d 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -123,7 +123,7 @@ instructions.
        -
        -  char
 
-       -  ``name[32]``
+       -  ``name\[32\]``
 
        -  Match a chip by this name, interpreted according to the ``type``
 	  field. Currently unused.
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
index 2a36e91b57b9..24419de4230e 100644
--- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
@@ -178,7 +178,7 @@ introduced in Linux 3.3.
        -
        -  __u32
 
-       -  ``data``\ [16]
+       -  ``data``\ \[16\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 73c0d5be62ee..f426b195ceb8 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -116,7 +116,7 @@ call.
        -
        -  __u8
 
-       -  ``data``\ [64]
+       -  ``data``\ \[64\]
 
        -  Event data. Defined by the event type. The union should be used to
 	  define easily accessible type for events.
@@ -167,7 +167,7 @@ call.
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -
        -  Reserved for future extensions. Drivers must set the array to
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 6e05957013bb..1a78407896fe 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -130,7 +130,7 @@ that doesn't support them will return an ``EINVAL`` error code.
 
        -  __u32
 
-       -  ``reserved``\ [16]
+       -  ``reserved``\ \[16\]
 
        -  Reserved for future extensions. Drivers must set the array to
 	  zero.
@@ -167,7 +167,7 @@ that doesn't support them will return an ``EINVAL`` error code.
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
@@ -193,7 +193,7 @@ that doesn't support them will return an ``EINVAL`` error code.
        -
        -  __u32
 
-       -  ``raw_data``\ [32]
+       -  ``raw_data``\ \[32\]
 
        -
 
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
index 69bd9b4e0e56..19b86603f4d7 100644
--- a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
@@ -94,7 +94,7 @@ introduced in Linux 2.6.21.
 
        -  __u32
 
-       -  ``data``\ [8]
+       -  ``data``\ \[8\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index 3ba75d3fb93c..71e0ae65abd1 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -92,7 +92,7 @@ return an ``EINVAL`` error code.
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 90996f69d6ae..3846009a39a7 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -86,7 +86,7 @@ one until ``EINVAL`` is returned.
 
        -  __u8
 
-       -  ``description``\ [32]
+       -  ``description``\ \[32\]
 
        -  Description of the format, a NUL-terminated ASCII string. This
 	  information is intended for the user, for example: "YUV 4:2:2".
@@ -120,7 +120,7 @@ one until ``EINVAL`` is returned.
 
        -  __u32
 
-       -  ``reserved``\ [4]
+       -  ``reserved``\ \[4\]
 
        -  Reserved for future extensions. Drivers must set the array to
 	  zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index ceae6003039e..6a2060b4a35c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -217,7 +217,7 @@ application should zero out all members except for the *IN* fields.
 
        -  __u32
 
-       -  ``reserved[2]``
+       -  ``reserved\[2\]``
 
        -
        -  Reserved space for future use. Must be zeroed by drivers and
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 8b268354d442..7a6a43b519df 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -238,7 +238,7 @@ application should zero out all members except for the *IN* fields.
 
        -  __u32
 
-       -  ``reserved[2]``
+       -  ``reserved\[2\]``
 
        -
        -  Reserved space for future use. Must be zeroed by drivers and
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index 00ab5e19cc1d..19e86cfdbf39 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -140,7 +140,7 @@ of the corresponding tuner/modulator is set.
 
        -  __u32
 
-       -  ``reserved``\ [9]
+       -  ``reserved``\ \[9\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 5060f54e3d18..1ea77135683a 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -61,7 +61,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
        -  __u8
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  Name of the video input, a NUL-terminated ASCII string, for
 	  example: "Vin (Composite 2)". This information is intended for the
@@ -141,7 +141,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
        -  __u32
 
-       -  ``reserved``\ [3]
+       -  ``reserved``\ \[3\]
 
        -  Reserved for future extensions. Drivers must set the array to
 	  zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index 82fc9d3b237f..83397f29903c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -62,7 +62,7 @@ EINVAL.
 
        -  __u8
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  Name of the video output, a NUL-terminated ASCII string, for
 	  example: "Vout". This information is intended for the user,
@@ -131,7 +131,7 @@ EINVAL.
 
        -  __u32
 
-       -  ``reserved``\ [3]
+       -  ``reserved``\ \[3\]
 
        -  Reserved for future extensions. Drivers must set the array to
 	  zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 6699b26cdeb4..e68a62803ac2 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -78,7 +78,7 @@ or output. [#f1]_
 
        -  __u8
 
-       -  ``name``\ [24]
+       -  ``name``\ \[24\]
 
        -  Name of the standard, a NUL-terminated ASCII string, for example:
 	  "PAL-B/G", "NTSC Japan". This information is intended for the
@@ -105,7 +105,7 @@ or output. [#f1]_
 
        -  __u32
 
-       -  ``reserved``\ [4]
+       -  ``reserved``\ \[4\]
 
        -  Reserved for future extensions. Drivers must set the array to
 	  zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
index ded708e647fa..bf7e644f9ff0 100644
--- a/Documentation/media/uapi/v4l/vidioc-expbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
@@ -179,7 +179,7 @@ Examples
 
        -  __u32
 
-       -  ``reserved[11]``
+       -  ``reserved\[11\]``
 
        -  Reserved field for future use. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index cccbcdb8c463..0a023c2b67ea 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -70,7 +70,7 @@ return the actual new audio mode.
 
        -  __u8
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  Name of the audio input, a NUL-terminated ASCII string, for
 	  example: "Line In". This information is intended for the user,
@@ -97,7 +97,7 @@ return the actual new audio mode.
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index b1c1bfeb251e..6442cb74ec94 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -75,7 +75,7 @@ as ``VIDIOC_G_AUDOUT`` does.
 
        -  __u8
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  Name of the audio output, a NUL-terminated ASCII string, for
 	  example: "Line Out". This information is intended for the user,
@@ -103,7 +103,7 @@ as ``VIDIOC_G_AUDOUT`` does.
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index f7bf21f49092..5c6aa7ae341e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -259,7 +259,7 @@ EBUSY
        -
        -  __u32
 
-       -  ``reserved``\ [32]
+       -  ``reserved``\ \[32\]
 
        -
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index 1a982b68a72f..cf0d100863ca 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -131,7 +131,7 @@ EDID is no longer available.
 
        -  __u32
 
-       -  ``reserved``\ [5]
+       -  ``reserved``\ \[5\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index f0f41ac56b80..27b8c84dad6a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -86,7 +86,7 @@ video elementary streams.
 
        -  __u32
 
-       -  ``reserved``\ [4]
+       -  ``reserved``\ \[4\]
 
        -  :cspan:`2` Reserved for future extensions. Drivers must set the
 	  array to zero.
@@ -153,7 +153,7 @@ video elementary streams.
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  Reserved for future extensions. Drivers must set the array to
 	  zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 39e24ad4b825..74998e028864 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -136,7 +136,7 @@ still cause this situation.
 
        -  __u32
 
-       -  ``reserved2``\ [1]
+       -  ``reserved2``\ \[1\]
 
        -
        -  Reserved for future extensions. Drivers and applications must set
@@ -338,7 +338,7 @@ still cause this situation.
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index ee6f11978fd6..9dc9e1e203a4 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -171,7 +171,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
        -
        -  __u8
 
-       -  ``raw_data``\ [200]
+       -  ``raw_data``\ \[200\]
 
        -  Place holder for future extensions.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index a1fd2a870de4..8944f3bb5adb 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -102,7 +102,7 @@ write-only ioctl, it does not return the actual new frequency.
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index f5bf8b7915ed..6e084d3c30bb 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -94,7 +94,7 @@ encoding. You usually do want to add them.
 
        -  char
 
-       -  ``APP_data``\ [60]
+       -  ``APP_data``\ \[60\]
 
        -
 
@@ -110,7 +110,7 @@ encoding. You usually do want to add them.
 
        -  char
 
-       -  ``COM_data``\ [60]
+       -  ``COM_data``\ \[60\]
 
        -
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index a2e8c73f0678..ee4cfc07f756 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -81,7 +81,7 @@ To change the radio frequency the
 
        -  __u8
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  Name of the modulator, a NUL-terminated ASCII string. This
 	  information is intended for the user.
@@ -149,7 +149,7 @@ To change the radio frequency the
 
        -  __u32
 
-       -  ``reserved``\ [3]
+       -  ``reserved``\ \[3\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 7116e0decddc..80378272cdef 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -103,7 +103,7 @@ union holding separate parameters for input and output devices.
        -
        -  __u8
 
-       -  ``raw_data``\ [200]
+       -  ``raw_data``\ \[200\]
 
        -  A place holder for future extensions.
 
@@ -183,7 +183,7 @@ union holding separate parameters for input and output devices.
 
        -  __u32
 
-       -  ``reserved``\ [4]
+       -  ``reserved``\ \[4\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
@@ -271,7 +271,7 @@ union holding separate parameters for input and output devices.
 
        -  __u32
 
-       -  ``reserved``\ [4]
+       -  ``reserved``\ \[4\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index 953931fabd00..e17ff45bd208 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -182,7 +182,7 @@ Selection targets and flags are documented in
 
        -  __u32
 
-       -  ``reserved[9]``
+       -  ``reserved\[9\]``
 
        -  Reserved fields for future use. Drivers and applications must zero
 	  this array.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index f1f661d0200c..b9c44b22cda1 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -65,7 +65,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -  __u16
 
-       -  ``service_lines``\ [2][24]
+       -  ``service_lines``\ \[2\]\[24\]
 
        -  :cspan:`2` Each element of this array contains a set of data
 	  services the hardware can look for or insert into a particular
@@ -87,7 +87,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -
        -
-       -  ``service_lines``\ [0][1]
+       -  ``service_lines``\ \[0\]\[1\]
 
        -  1
 
@@ -97,7 +97,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -
        -
-       -  ``service_lines``\ [0][23]
+       -  ``service_lines``\ \[0\]\[23\]
 
        -  23
 
@@ -107,7 +107,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -
        -
-       -  ``service_lines``\ [1][1]
+       -  ``service_lines``\ \[1\]\[1\]
 
        -  264
 
@@ -117,7 +117,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -
        -
-       -  ``service_lines``\ [1][23]
+       -  ``service_lines``\ \[1\]\[23\]
 
        -  286
 
@@ -147,8 +147,8 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -
        -
-       -  :cspan:`2` Drivers must set ``service_lines`` [0][0] and
-	  ``service_lines``\ [1][0] to zero.
+       -  :cspan:`2` Drivers must set ``service_lines`` \[0\]\[0\] and
+	  ``service_lines``\ \[1\]\[0\] to zero.
 
     -  .. row 12
 
@@ -164,7 +164,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -  __u32
 
-       -  ``reserved``\ [3]
+       -  ``reserved``\ \[3\]
 
        -  :cspan:`2` This array is reserved for future extensions.
 	  Applications and drivers must set it to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 614db06b8b4b..f9b0bfeef859 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -79,7 +79,7 @@ To change the radio frequency the
 
        -  __u8
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  :cspan:`1`
 
@@ -246,7 +246,7 @@ To change the radio frequency the
 
        -  __u32
 
-       -  ``reserved``\ [4]
+       -  ``reserved``\ \[4\]
 
        -  :cspan:`1` Reserved for future extensions. Drivers and
 	  applications must set the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index b10fed313f99..769a554dd8b9 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -53,7 +53,7 @@ specification the ioctl returns an ``EINVAL`` error code.
 
        -  __u8
 
-       -  ``driver``\ [16]
+       -  ``driver``\ \[16\]
 
        -  Name of the driver, a unique NUL-terminated ASCII string. For
 	  example: "bttv". Driver specific applications can use this
@@ -69,7 +69,7 @@ specification the ioctl returns an ``EINVAL`` error code.
 
        -  __u8
 
-       -  ``card``\ [32]
+       -  ``card``\ \[32\]
 
        -  Name of the device, a NUL-terminated UTF-8 string. For example:
 	  "Yoyodyne TV/FM". One driver may support different brands or
@@ -84,7 +84,7 @@ specification the ioctl returns an ``EINVAL`` error code.
 
        -  __u8
 
-       -  ``bus_info``\ [32]
+       -  ``bus_info``\ \[32\]
 
        -  Location of the device in the system, a NUL-terminated ASCII
 	  string. For example: "PCI:0000:05:06.0". This information is
@@ -166,7 +166,7 @@ specification the ioctl returns an ``EINVAL`` error code.
 
        -  __u32
 
-       -  ``reserved``\ [3]
+       -  ``reserved``\ \[3\]
 
        -  Reserved for future extensions. Drivers must set this array to
 	  zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 8d6e61a7284d..72bc7b1b067c 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -124,7 +124,7 @@ See also the examples in :ref:`control`.
 
        -  __u8
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  Name of the control, a NUL-terminated ASCII string. This
 	  information is intended for the user.
@@ -203,7 +203,7 @@ See also the examples in :ref:`control`.
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  Reserved for future extensions. Drivers must set the array to
 	  zero.
@@ -245,7 +245,7 @@ See also the examples in :ref:`control`.
 
        -  char
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  Name of the control, a NUL-terminated ASCII string. This
 	  information is intended for the user.
@@ -326,7 +326,7 @@ See also the examples in :ref:`control`.
        -  The size in bytes of a single element of the array. Given a char
 	  pointer ``p`` to a 3-dimensional array you can find the position
 	  of cell ``(z, y, x)`` as follows:
-	  ``p + ((z * dims[1] + y) * dims[0] + x) * elem_size``.
+	  ``p + ((z * dims\[1\] + y) * dims\[0\] + x) * elem_size``.
 	  ``elem_size`` is always valid, also when the control isn't an
 	  array. For string controls ``elem_size`` is equal to
 	  ``maximum + 1``.
@@ -363,7 +363,7 @@ See also the examples in :ref:`control`.
 
        -  __u32
 
-       -  ``reserved``\ [32]
+       -  ``reserved``\ \[32\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
@@ -410,7 +410,7 @@ See also the examples in :ref:`control`.
        -
        -  __u8
 
-       -  ``name``\ [32]
+       -  ``name``\ \[32\]
 
        -  Name of the menu item, a NUL-terminated ASCII string. This
 	  information is intended for the user. This field is valid for
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index 5d0bc6d31c07..75dc34548ab7 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -107,7 +107,7 @@ any DMA in progress, an implicit
 
        -  __u32
 
-       -  ``reserved``\ [2]
+       -  ``reserved``\ \[2\]
 
        -  A place holder for future extensions. Drivers and applications
 	  must set the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index 5fd332a5bfee..c96d2edbf72a 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -150,7 +150,7 @@ error code is returned and no seek takes place.
 
        -  __u32
 
-       -  ``reserved``\ [5]
+       -  ``reserved``\ \[5\]
 
        -  Reserved for future extensions. Applications must set the array to
 	  zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index 0aa6482a91a6..f472ea27f9c0 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -132,7 +132,7 @@ multiple pads of the same sub-device is not defined.
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
index 7a5811b71b68..8fcbdc1e73fe 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
@@ -142,7 +142,7 @@ information about try formats.
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
index bc0531eb56fa..3cb62dff3300 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -95,7 +95,7 @@ information about the try formats.
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index ae802f1594e7..7f39d38303e7 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -109,7 +109,7 @@ modified format should be as close as possible to the original request.
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index 90e2a6635ebc..b7f2aca64422 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -113,7 +113,7 @@ should be as close as possible to the original request.
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index d8a1cabbd272..bcb1aae43e82 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -95,7 +95,7 @@ the same sub-device is not defined.
 
        -  __u32
 
-       -  ``reserved``\ [9]
+       -  ``reserved``\ \[9\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index 50838a4a429e..7d6611f0f9d5 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -117,7 +117,7 @@ Selection targets and flags are documented in
 
        -  __u32
 
-       -  ``reserved``\ [8]
+       -  ``reserved``\ \[8\]
 
        -  Reserved for future extensions. Applications and drivers must set
 	  the array to zero.
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index 3ed91c627702..7c00c93c2d95 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -79,7 +79,7 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 
        -  __u32
 
-       -  ``reserved``\ [5]
+       -  ``reserved``\ \[5\]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  the array to zero.
-- 
2.7.4

