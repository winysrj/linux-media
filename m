Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48593 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272AbcGJQeg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 12:34:36 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [V4L-UTILS] ir-ctl: add new tool for sending & receiving raw IR
Date: Sun, 10 Jul 2016 17:34:31 +0100
Message-Id: <1468168473-27499-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently v4l-utils has no tooling provided for receiving and sending
raw IR using the lirc interface. Some of this can be done using various
tools from the user-space lirc package, but not everything is covered.

We want to be able to do the following:
 - List all the features that a lirc device provides
 - Set all possible receiving and sending parameters
 - Send raw IR, formatted as a text file
 - Record raw IR, with output in the same format as for sending
 - Testbed for lirc drivers. Driver misbehaviour is reported

The need for this is not new. The manufacturer of the IguanaWorks IR
device have a similar tool which is IguanaIR specific:

        http://www.iguanaworks.net/2012/igclient-examples/

Also RedRat3 provide a similar tools but this uses a signal database
for sending IR, and is redrat specific.

        http://www.redrat.co.uk/software/redrat-linux-ir-tools/

Lirc provides a tool for reading raw IR but no method of sending it.

        http://www.lirc.org/html/mode2.html

None of these provides full coverage of the basic raw IR lirc interface,
hence v4l-utils seems like logical place to provide this functionality. It
can be used as a tool for testing features of lirc drivers.

Signed-off-by: Sean Young <sean@mess.org>
---
 configure.ac             |   2 +
 include/media/lirc.h     | 168 +++++++++++
 utils/Makefile.am        |   1 +
 utils/ir-ctl/.gitignore  |   2 +
 utils/ir-ctl/Makefile.am |   6 +
 utils/ir-ctl/ir-ctl.1.in | 192 ++++++++++++
 utils/ir-ctl/ir-ctl.c    | 759 +++++++++++++++++++++++++++++++++++++++++++++++
 v4l-utils.spec.in        |   6 +-
 8 files changed, 1134 insertions(+), 2 deletions(-)
 create mode 100644 include/media/lirc.h
 create mode 100644 utils/ir-ctl/.gitignore
 create mode 100644 utils/ir-ctl/Makefile.am
 create mode 100644 utils/ir-ctl/ir-ctl.1.in
 create mode 100644 utils/ir-ctl/ir-ctl.c

diff --git a/configure.ac b/configure.ac
index 2616f92..41ab97b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -24,6 +24,7 @@ AC_CONFIG_FILES([Makefile
 	utils/decode_tm6000/Makefile
 	utils/dvb/Makefile
 	utils/keytable/Makefile
+	utils/ir-ctl/Makefile
 	utils/cx18-ctl/Makefile
 	utils/ivtv-ctl/Makefile
 	utils/media-ctl/Makefile
@@ -59,6 +60,7 @@ AC_CONFIG_FILES([Makefile
 	utils/v4l2-compliance/v4l2-compliance.1
 	utils/v4l2-ctl/v4l2-ctl.1
 	utils/keytable/ir-keytable.1
+	utils/ir-ctl/ir-ctl.1
 	utils/dvb/dvb-fe-tool.1
 	utils/dvb/dvbv5-scan.1
 	utils/dvb/dvb-format-convert.1
diff --git a/include/media/lirc.h b/include/media/lirc.h
new file mode 100644
index 0000000..4b3ab29
--- /dev/null
+++ b/include/media/lirc.h
@@ -0,0 +1,168 @@
+/*
+ * lirc.h - linux infrared remote control header file
+ * last modified 2010/07/13 by Jarod Wilson
+ */
+
+#ifndef _LINUX_LIRC_H
+#define _LINUX_LIRC_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define PULSE_BIT       0x01000000
+#define PULSE_MASK      0x00FFFFFF
+
+#define LIRC_MODE2_SPACE     0x00000000
+#define LIRC_MODE2_PULSE     0x01000000
+#define LIRC_MODE2_FREQUENCY 0x02000000
+#define LIRC_MODE2_TIMEOUT   0x03000000
+
+#define LIRC_VALUE_MASK      0x00FFFFFF
+#define LIRC_MODE2_MASK      0xFF000000
+
+#define LIRC_SPACE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_SPACE)
+#define LIRC_PULSE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_PULSE)
+#define LIRC_FREQUENCY(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_FREQUENCY)
+#define LIRC_TIMEOUT(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_TIMEOUT)
+
+#define LIRC_VALUE(val) ((val)&LIRC_VALUE_MASK)
+#define LIRC_MODE2(val) ((val)&LIRC_MODE2_MASK)
+
+#define LIRC_IS_SPACE(val) (LIRC_MODE2(val) == LIRC_MODE2_SPACE)
+#define LIRC_IS_PULSE(val) (LIRC_MODE2(val) == LIRC_MODE2_PULSE)
+#define LIRC_IS_FREQUENCY(val) (LIRC_MODE2(val) == LIRC_MODE2_FREQUENCY)
+#define LIRC_IS_TIMEOUT(val) (LIRC_MODE2(val) == LIRC_MODE2_TIMEOUT)
+
+/* used heavily by lirc userspace */
+#define lirc_t int
+
+/*** lirc compatible hardware features ***/
+
+#define LIRC_MODE2SEND(x) (x)
+#define LIRC_SEND2MODE(x) (x)
+#define LIRC_MODE2REC(x) ((x) << 16)
+#define LIRC_REC2MODE(x) ((x) >> 16)
+
+#define LIRC_MODE_RAW                  0x00000001
+#define LIRC_MODE_PULSE                0x00000002
+#define LIRC_MODE_MODE2                0x00000004
+#define LIRC_MODE_LIRCCODE             0x00000010
+
+
+#define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
+#define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
+#define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
+#define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
+
+#define LIRC_CAN_SEND_MASK             0x0000003f
+
+#define LIRC_CAN_SET_SEND_CARRIER      0x00000100
+#define LIRC_CAN_SET_SEND_DUTY_CYCLE   0x00000200
+#define LIRC_CAN_SET_TRANSMITTER_MASK  0x00000400
+
+#define LIRC_CAN_REC_RAW               LIRC_MODE2REC(LIRC_MODE_RAW)
+#define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
+#define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
+#define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
+
+#define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
+
+#define LIRC_CAN_SET_REC_CARRIER       (LIRC_CAN_SET_SEND_CARRIER << 16)
+#define LIRC_CAN_SET_REC_DUTY_CYCLE    (LIRC_CAN_SET_SEND_DUTY_CYCLE << 16)
+
+#define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE 0x40000000
+#define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
+#define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
+#define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
+#define LIRC_CAN_SET_REC_FILTER           0x08000000
+
+#define LIRC_CAN_MEASURE_CARRIER          0x02000000
+#define LIRC_CAN_USE_WIDEBAND_RECEIVER    0x04000000
+
+#define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
+#define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
+
+#define LIRC_CAN_NOTIFY_DECODE            0x01000000
+
+/*** IOCTL commands for lirc driver ***/
+
+#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
+
+#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
+#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
+#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, __u32)
+#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, __u32)
+#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, __u32)
+#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, __u32)
+#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
+
+#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
+#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
+
+#define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, __u32)
+#define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, __u32)
+#define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, __u32)
+#define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, __u32)
+
+/* code length in bits, currently only for LIRC_MODE_LIRCCODE */
+#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
+
+#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
+#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
+/* Note: these can reset the according pulse_width */
+#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
+#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
+#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
+#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, __u32)
+#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
+
+/*
+ * when a timeout != 0 is set the driver will send a
+ * LIRC_MODE2_TIMEOUT data packet, otherwise LIRC_MODE2_TIMEOUT is
+ * never sent, timeout is disabled by default
+ */
+#define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, __u32)
+
+/* 1 enables, 0 disables timeout reports in MODE2 */
+#define LIRC_SET_REC_TIMEOUT_REPORTS   _IOW('i', 0x00000019, __u32)
+
+/*
+ * pulses shorter than this are filtered out by hardware (software
+ * emulation in lirc_dev?)
+ */
+#define LIRC_SET_REC_FILTER_PULSE      _IOW('i', 0x0000001a, __u32)
+/*
+ * spaces shorter than this are filtered out by hardware (software
+ * emulation in lirc_dev?)
+ */
+#define LIRC_SET_REC_FILTER_SPACE      _IOW('i', 0x0000001b, __u32)
+/*
+ * if filter cannot be set independently for pulse/space, this should
+ * be used
+ */
+#define LIRC_SET_REC_FILTER            _IOW('i', 0x0000001c, __u32)
+
+/*
+ * if enabled from the next key press on the driver will send
+ * LIRC_MODE2_FREQUENCY packets
+ */
+#define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
+
+/*
+ * to set a range use
+ * LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE with the
+ * lower bound first and later
+ * LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER with the upper bound
+ */
+
+#define LIRC_SET_REC_DUTY_CYCLE_RANGE  _IOW('i', 0x0000001e, __u32)
+#define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
+
+#define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
+
+#define LIRC_SETUP_START               _IO('i', 0x00000021)
+#define LIRC_SETUP_END                 _IO('i', 0x00000022)
+
+#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
+
+#endif
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 2cb56f0..a19617a 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -4,6 +4,7 @@ SUBDIRS = \
 	libmedia_dev \
 	decode_tm6000 \
 	ivtv-ctl \
+	ir-ctl \
 	cx18-ctl \
 	keytable \
 	media-ctl \
diff --git a/utils/ir-ctl/.gitignore b/utils/ir-ctl/.gitignore
new file mode 100644
index 0000000..3220d69
--- /dev/null
+++ b/utils/ir-ctl/.gitignore
@@ -0,0 +1,2 @@
+ir-ctl
+ir-ctl.1
diff --git a/utils/ir-ctl/Makefile.am b/utils/ir-ctl/Makefile.am
new file mode 100644
index 0000000..9a1bfed
--- /dev/null
+++ b/utils/ir-ctl/Makefile.am
@@ -0,0 +1,6 @@
+bin_PROGRAMS = ir-ctl
+man_MANS = ir-ctl.1
+
+ir_ctl_SOURCES = ir-ctl.c
+ir_ctl_LDADD = @LIBINTL@
+ir_ctl_LDFLAGS = $(ARGP_LIBS)
diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
new file mode 100644
index 0000000..4bdf47e
--- /dev/null
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -0,0 +1,192 @@
+.TH "IR\-CTL" "1" "Tue Jul 5 2016" "v4l-utils @PACKAGE_VERSION@" "User Commands"
+.SH NAME
+ir\-ctl \- a swiss\-knife tool to handle raw IR and to set lirc options
+.SH SYNOPSIS
+.B ir\-ctl
+[\fIOPTION\fR]...
+.br
+.B ir\-ctl
+[\fIOPTION\fR]... \fI\-\-features\fR
+.br
+.B ir\-ctl
+[\fIOPTION\fR]... \fI\-\-send\fR [\fIpulse and space file to send\fR]
+.br
+.B ir\-ctl
+[\fIOPTION\fR]... \fI\-\-record\fR [\fIsave to file\fR]
+.SH DESCRIPTION
+ir\-ctl is a tool that allows one to list the features of a lirc device,
+set its options, record raw IR and send raw IR.
+.PP
+Note: You need to have read or write permissions on the /dev/lirc device
+for options to work.
+.SH OPTIONS
+.TP
+\fB\-d\fR, \fB\-\-device\fR=\fIDEV\fR
+lirc device to control, /dev/lirc0 by default
+.TP
+\fB\-f\fR, \fB\-\-features\fR
+List the features of the lirc device.
+.TP
+\fB\-r\fR, \fB\-\-record\fR=[\fIFILE\fR]
+Record IR and print to standard output if no file is specified, else
+save to the filename.
+.TP
+\fB\-s\fR, \fB\-\-send\fR=\fIFILE\fR
+Send IR in text file. It must be in the format described below. If this
+option is specified multiple times, send all files in order with 125ms delay
+between them.
+.TP
+\fB\-1\fR, \fB\-\-oneshot\fR
+When recording, stop recording after the first message, i.e. after a space or
+timeout of more than 19ms is received.
+.TP
+\fB\-w\fR, \fB\-\-wideband\fR
+Use the wideband receiver if available on the hardware. This is also
+known as learning mode. The measurements should be more precise and any
+carrier frequency should be accepted.
+.TP
+\fB\-n\fR, \fB\-\-no-wideband\fR
+Switches back to the normal, narrowband receiver if the wideband receiver
+was enabled.
+.TP
+\fB\-R\fR, \fB\-\-carrier-range\fR=\fIRANGE\fR
+Set the accepted carrier range for the narrowband receiver. It should be
+specified in the form \fI30000-50000\fR.
+.TP
+\fB\-m\fR, \fB\-\-measure\-carrier\fR
+If the hardware supports it, report what the carrier frequency is on
+recording. You will get the keyword \fIcarrier\fR followed by the frequency.
+This might use the wideband receiver although this is hardware specific.
+.TP
+\fB\-M\fR, \fB\-\-no\-measure\-carrier\fR
+Disable reporting of the carrier frequency. This should make it possible
+to use the narrowband receiver. This is the default.
+.TP
+\fB\-p\fR, \fB\-\-timeout\-reports\fR
+When the IR receiver times out due to inactivity, a timeout message is
+reported. When recording you will get the keyword \fItimeout\fR followed by
+the length of time that no IR was detected for.
+.TP
+\fB\-P\fR, \fB\-\-no\-timeout\-reports\fR
+When the IR receiver times out due to inactivity, do not report this.
+This is the default.
+.TP
+\fB\-t\fR, \fB\-\-timeout\fR=\fITIMEOUT\fR
+Set the length of a space at which the recorder goes idle, specified in
+microseconds.
+.TP
+\fB\-c\fR, \fB\-\-carrier\fR=\fICARRIER\fR
+Sets the send carrier frequency.
+.TP
+\fB\-D\fR, \fB\-\-duty\-cycle\fR=\fIDUTY\fR
+Set the duty cycle for sending in percent if the hardware support it.
+.TP
+\fB\-e\fR, \fB\-\-emitters\fR=\fIEMITTERS\fR
+Comma separated list of emitters to use for sending. The first emitter is
+number 1. Some devices only support enabling one emitter (the winbond-cir
+driver).
+.TP
+\fB\-?\fR, \fB\-\-help\fR
+Prints the help message
+.TP
+\fB\-\-usage\fR
+Give a short usage message
+.TP
+\fB\-V\fR, \fB\-\-version\fR
+print the v4l2\-utils version
+.PP
+.SS Format of pulse and space file
+When sending IR, the format of the file should be as follows. A comment
+start with #. The carrier frequency can be specified as:
+.PP
+	carrier 38000
+.PP
+The file should contain alternating lines with pulse and space, followed
+by length in microseconds. The following is a rc-5 encoded message:
+.PP
+	carrier 36000
+.br
+	pulse 920
+.br
+	space 110
+.br
+	pulse 270
+.br
+	space 380
+.br
+	pulse 1800
+.br
+	space 1560
+.br
+	pulse 1730
+.br
+	space 1630
+.br
+	pulse 1730
+.br
+	space 1640
+.br
+	pulse 850
+.br
+	space 830
+.br
+	pulse 1690
+.br
+	space 820
+.br
+	pulse 860
+.br
+	space 1660
+.br
+	pulse 1690
+.br
+	space 830
+.br
+	pulse 850
+.SS Wideband and narrowband receiver
+Most IR receivers have a narrowband and wideband receiver. The narrowband
+receiver can receive over longer distances (usually around 10 metres without
+interference) and is limited to certain carrier frequencies.
+.PP
+The wideband receiver is for higher precision measurements and when the
+carrier frequency is unknown; however it only works over very short
+distances (about 5 centimetres). This is also known as \fBlearning mode\fR.
+.PP
+For most drivers, enabling \fBcarrier reports\fR using \fB\-m\fR also enables
+the wideband receiver.
+.SS Global state
+All the options which can be set for lirc devices are maintained until
+the device is powered down or a new option is set.
+.SH EXIT STATUS
+On success, it returns 0. Otherwise, it will return the error code.
+.SH EXAMPLES
+To list all capabilities of /dev/lirc2:
+.br
+	\fBir\-ctl \-f \-d /dev/lirc2\fR
+.PP
+To show the IR of the first button press on a remote in learning mode:
+.br
+	\fBir\-ctl \-r \-m \-w\fR
+.PP
+Note that \fBir\-ctl \-rmw\fR would record to a file called \fBmw\fR.
+.PP
+To restore the normal (longer distance) receiver:
+.br
+	\fBir\-ctl \-n \-M\fR
+.PP
+To send the pulse and space file \fBplay\fR on emitter 3:
+.br
+	\fBir\-ctl \-e 3 \-\-send=play\fR
+.PP
+To restore the IR receiver on /dev/lirc2 to the default state:
+.br
+	\fBir\-ctl \-PMn \-\-timeout 125000 \-\-device=/dev/lirc2\fR
+.SH BUGS
+Report bugs to \fBLinux Media Mailing List <linux-media@vger.kernel.org>\fR
+.SH COPYRIGHT
+Copyright (c) 2016 by Sean Young.
+.PP
+License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
+.br
+This is free software: you are free to change and redistribute it.
+There is NO WARRANTY, to the extent permitted by law.
diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
new file mode 100644
index 0000000..7f2afc0
--- /dev/null
+++ b/utils/ir-ctl/ir-ctl.c
@@ -0,0 +1,759 @@
+/*
+ *  ir-ctl.c - Program to send and record IR using lirc interface
+ *
+ *  Copyright (C) 2016 Sean Young <sean@mess.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation, version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+#include <argp.h>
+#include <sysexits.h>
+
+#include <config.h>
+
+#include <media/lirc.h>
+
+#ifdef ENABLE_NLS
+# define _(string) gettext(string)
+# include "gettext.h"
+# include <locale.h>
+# include <langinfo.h>
+# include <iconv.h>
+#else
+# define _(string) string
+#endif
+
+# define N_(string) string
+
+
+/* See drivers/media/rc/ir-lirc-codec.c line 23 */
+#define LIRCBUF_SIZE	512
+#define IR_DEFAULT_TIMEOUT 125000
+
+const char *argp_program_version = "IR raw version " V4L_UTILS_VERSION;
+const char *argp_program_bug_address = "Sean Young <sean@mess.org>";
+
+/*
+ * Since this program drives the lirc interface, use the same terminology
+ */
+struct file {
+	struct file *next;
+	const char *fname;
+	unsigned carrier;
+	unsigned len;
+	unsigned buf[LIRCBUF_SIZE];
+};
+
+struct arguments {
+	char *device;
+	bool features;
+	bool record;
+	struct file *send;
+	bool oneshot;
+	char *savetofile;
+	int wideband;
+	unsigned carrier_low, carrier_high;
+	unsigned timeout;
+	int carrier_reports;
+	int timeout_reports;
+	unsigned carrier;
+	unsigned duty;
+	unsigned emitters;
+	bool work_to_do;
+};
+
+static const struct argp_option options[] = {
+	{ "device",	'd',	N_("DEV"),	0,	N_("lirc device to use") },
+	{ "features",	'f',	0,		0,	N_("list lirc device features") },
+	{ "record",	'r',	N_("FILE"),	OPTION_ARG_OPTIONAL,	N_("record IR to stdout or file") },
+	{ "send",	's',	N_("FILE"),	0,	N_("send IR pulse and space file") },
+		{ .doc = N_("Recording options:") },
+	{ "one-shot",	'1',	0,		0,	N_("end recording after first message") },
+	{ "wideband",	'w',	0,		0,	N_("use wideband receiver aka learning mode") },
+	{ "no-wideband",'n',	0,		0,	N_("use normal narrowband receiver, disable learning mode") },
+	{ "carrier-range", 'R', N_("RANGE"),	0,	N_("set receiver carrier range") },
+	{ "measure-carrier", 'm', 0,		0,	N_("report carrier frequency") },
+	{ "no-measure-carrier", 'M', 0,		0,	N_("disable reporting carrier frequency") },
+	{ "timeout-reports", 'p', 0,		0,	N_("report when a timeout occurs") },
+	{ "no-timeout-reports", 'P', 0,		0,	N_("disable reporting when a timeout occurs") },
+	{ "timeout",	't',	N_("TIMEOUT"),	0,	N_("set recording timeout") },
+		{ .doc = "Sending options:" },
+	{ "carrier",	'c',	N_("CARRIER"),	0,	N_("set send carrier") },
+	{ "duty-cycle",	'D',	N_("DUTY"),	0,	N_("set duty cycle") },
+	{ "emitters",	'e',	N_("EMITTERS"),	0,	N_("set send emitters") },
+	{ }
+};
+
+static const char args_doc[] = N_(
+	"--features\n"
+	"--record [save to file]\n"
+	"--send [file to send]\n"
+	"[to set lirc option]");
+
+static const char doc[] = N_(
+	"\nRecord IR, send IR and list features of lirc device\n"
+	"You will need permission on /dev/lirc for the program to work\n"
+	"\nOn the options below, the arguments are:\n"
+	"  DEV	    - the /dev/lirc* device to use\n"
+	"  FILE     - a text file containing pulses and spaces\n"
+	"  CARRIER  - the carrier frequency to use for sending\n"
+	"  DUTY     - the duty cycle to use for sending\n"
+	"  EMITTERS - comma separated list of emitters to use for sending, e.g. 1,2\n"
+	"  RANGE    - set range of accepted carrier frequencies, e.g. 20000-40000\n"
+	"  TIMEOUT  - set length of space before recording stops in µs (microseonds)\n"
+	"\nNote that most lirc setting have global state, i.e. the device will remain\n"
+	"in this state until set otherwise.");
+
+static int strtoint(const char *p, const char *unit)
+{
+	char *end;
+	long arg = strtol(p, &end, 10);
+	if (end == NULL || (end[0] != 0 && strcasecmp(end, unit) != 0))
+		return 0;
+
+	if (arg <= 0 || arg >= 0xffffff)
+		return 0;
+
+	return arg;
+}
+
+static unsigned parse_emitters(char *p)
+{
+	unsigned emit = 0;
+	const char *sep = " ,;:";
+	char *saveptr, *q;
+
+	q = strtok_r(p, sep, &saveptr);
+	while (q) {
+		if (*q) {
+			char *endptr;
+			long e = strtol(q, &endptr, 10);
+			if ((endptr && *endptr) || e <= 0 || e > 32)
+				return 0;
+
+			emit |= 1 << (e - 1);
+		}
+		q = strtok_r(NULL, sep, &saveptr);
+	}
+
+	return emit;
+}
+
+static struct file *read_file(const char *fname)
+{
+	bool expect_pulse = true;
+	int lineno = 0, lastspace = 0;
+	char line[1024];
+	int len = 0;
+	const char *whitespace = " \n\r\t";
+	struct file *f;
+
+	FILE *input = fopen(fname, "r");
+
+	if (!input) {
+		fprintf(stderr, _("%s: could not open: %m\n"), fname);
+		return NULL;
+	}
+
+	f = malloc(sizeof(*f));
+	if (f == NULL) {
+		fprintf(stderr, _("Failed to allocate memory\n"));
+		return NULL;
+	}
+	f->carrier = 0;
+	f->fname = fname;
+
+	while (fgets(line, sizeof(line), input)) {
+		char *p, *saveptr;
+		lineno++;
+		char *keyword = strtok_r(line, whitespace, &saveptr);
+
+		if (keyword == NULL || *keyword == 0 || *keyword == '#' ||
+				(keyword[0] == '/' && keyword[1] == '/'))
+			continue;
+
+		p = strtok_r(NULL, whitespace, &saveptr);
+		if (p == NULL) {
+			fprintf(stderr, _("warning: %s:%d: missing argument\n"), fname, lineno);
+			continue;
+		}
+
+		int arg = strtoint(p, "");
+		if (arg == 0) {
+			fprintf(stderr, _("warning: %s:%d: invalid argument '%s'\n"), fname, lineno, p);
+			continue;
+		}
+
+		p = strtok_r(NULL, whitespace, &saveptr);
+		if (p && p[0] != '#' && !(p[0] == '/' && p[1] == '/')) {
+			fprintf(stderr, _("warning: %s:%d: '%s' unexpected\n"), fname, lineno, p);
+			continue;
+		}
+
+		if (strcmp(keyword, "space") == 0) {
+			if (expect_pulse) {
+				if (len == 0) {
+					fprintf(stderr, _("warning: %s:%d: leading space ignored\n"),
+						fname, lineno);
+				} else {
+					f->buf[len] += arg;
+				}
+			} else {
+				f->buf[len++] = arg;
+			}
+			lastspace = lineno;
+			expect_pulse = true;
+		} else if (strcmp(keyword, "pulse") == 0) {
+			if (!expect_pulse)
+				f->buf[len] += arg;
+			else
+				f->buf[len++] = arg;
+			expect_pulse = false;
+		} else if (strcmp(keyword, "carrier") == 0) {
+			if (f->carrier) {
+				fprintf(stderr, _("warning: %s:%d: carrier already specified\n"), fname, lineno);
+			} else {
+				f->carrier = arg;
+			}
+		} else {
+			fprintf(stderr, _("warning: %s:%d: unknown keyword '%s' ignored\n"), fname, lineno, keyword);
+			continue;
+		}
+
+		if (len >= LIRCBUF_SIZE) {
+			fprintf(stderr, _("warning: %s:%d: IR cannot exceed %u edges\n"), fname, lineno, LIRCBUF_SIZE);
+			break;
+		}
+	}
+
+	fclose(input);
+
+	if (len == 0) {
+		fprintf(stderr, _("%s: no pulses or spaces found\n"), fname);
+		free(f);
+		return NULL;
+	}
+
+	if ((len % 2) == 0) {
+		fprintf(stderr, _("warning: %s:%d: trailing space ignored\n"),
+							fname, lastspace);
+		len--;
+	}
+
+	f->len = len;
+
+	return f;
+}
+
+
+static error_t parse_opt(int k, char *arg, struct argp_state *state)
+{
+	struct arguments *arguments = state->input;
+	struct file *s;
+
+	switch (k) {
+	case 'f':
+		if (arguments->record || arguments->send)
+			argp_error(state, _("features can not be combined with record or send option"));
+		arguments->features = true;
+		break;
+	// recording
+	case 'r':
+		if (arguments->features || arguments->send)
+			argp_error(state, _("record can not be combined with features or send option"));
+
+		arguments->record = true;
+		if (arg) {
+			if (arguments->savetofile)
+				argp_error(state, _("record filename already set"));
+
+			arguments->savetofile = arg;
+		}
+		break;
+	case '1':
+		arguments->oneshot = true;
+		break;
+	case 'm':
+		if (arguments->carrier_reports == 2)
+			argp_error(state, _("cannot enable and disable carrier reports"));
+
+		arguments->carrier_reports = 1;
+		break;
+	case 'M':
+		if (arguments->carrier_reports == 1)
+			argp_error(state, _("cannot enable and disable carrier reports"));
+
+		arguments->carrier_reports = 2;
+		break;
+	case 'p':
+		if (arguments->timeout_reports == 2)
+			argp_error(state, _("cannot enable and disable timeout reports"));
+
+		arguments->timeout_reports = 1;
+		break;
+	case 'P':
+		if (arguments->timeout_reports == 1)
+			argp_error(state, _("cannot enable and disable timeout reports"));
+
+		arguments->timeout_reports = 2;
+		break;
+	case 'n':
+		if (arguments->wideband)
+			argp_error(state, _("cannot use narrowband and wideband receiver at once"));
+
+		arguments->wideband = 2;
+		break;
+	case 'w':
+		if (arguments->wideband)
+			argp_error(state, _("cannot use narrowband and wideband receiver at once"));
+
+		arguments->wideband = 1;
+		break;
+	case 'R': {
+		long low, high;
+		char *end;
+
+		low = strtol(arg, &end, 10);
+		if (end == NULL || end[0] != '-')
+			argp_error(state, _("cannot parse carrier range `%s'"), arg);
+		high = strtol(end + 1, &end, 10);
+		if (end[0] != 0 || low <= 0 || low >= high || high > 1000000)
+			argp_error(state, _("cannot parse carrier range `%s'"), arg);
+
+		arguments->carrier_low = low;
+		arguments->carrier_high = high;
+		break;
+	}
+	case 't':
+		arguments->timeout = strtoint(arg, "µs");
+		if (arguments->timeout == 0)
+			argp_error(state, _("cannot parse timeout `%s'"), arg);
+		break;
+
+	// sending
+	case 'd':
+		arguments->device = arg;
+		break;
+	case 'c':
+		arguments->carrier = strtoint(arg, "Hz");
+		if (arguments->carrier == 0)
+			argp_error(state, _("cannot parse carrier `%s'"), arg);
+		break;
+	case 'e':
+		arguments->emitters = parse_emitters(arg);
+		if (arguments->emitters == 0)
+			argp_error(state, _("cannot parse emitters `%s'"), arg);
+		break;
+	case 'D':
+		arguments->duty = strtoint(arg, "%");
+		if (arguments->duty == 0 || arguments->duty >= 100)
+			argp_error(state, _("invalid duty cycle `%s'"), arg);
+		break;
+	case 's':
+		if (arguments->record || arguments->features)
+			argp_error(state, _("send can not be combined with record or features option"));
+		s = read_file(arg);
+		if (s == NULL)
+			exit(EX_DATAERR);
+
+		s->next = NULL;
+		if (arguments->send == NULL)
+			arguments->send = s;
+		else {
+			struct file *p = arguments->send;
+			while (p->next) p = p->next;
+			p->next = s;
+		}
+		break;
+	case ARGP_KEY_END:
+		if (!arguments->work_to_do)
+			argp_usage(state);
+
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+
+	if (k != '1' && k != 'd')
+		arguments->work_to_do = true;
+
+	return 0;
+}
+
+static const struct argp argp = {
+	.options = options,
+	.parser = parse_opt,
+	.args_doc = args_doc,
+	.doc = doc
+};
+
+static int open_lirc(const char *fname, unsigned *features)
+{
+	int fd;
+
+	fd = TEMP_FAILURE_RETRY(open(fname, O_RDWR | O_CLOEXEC));
+	if (fd == -1) {
+		fprintf(stderr, _("%s: cannot open: %m\n"), fname);
+		return -1;
+	}
+
+	struct stat st;
+	int rc = TEMP_FAILURE_RETRY(fstat(fd, &st));
+	if (rc) {
+		fprintf(stderr, _("%s: cannot stat: %m\n"), fname);
+		close(fd);
+		return -1;
+	}
+
+	if ((st.st_mode & S_IFMT) != S_IFCHR) {
+		fprintf(stderr, _("%s: not character device\n"), fname);
+		close(fd);
+		return -1;
+	}
+
+	rc = ioctl(fd, LIRC_GET_FEATURES, features);
+	if (rc) {
+		fprintf(stderr, _("%s: failed to get lirc features: %m\n"), fname);
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+static void lirc_set_send_carrier(int fd, const char *devname, unsigned features, unsigned carrier)
+{
+	if (features & LIRC_CAN_SET_SEND_CARRIER) {
+		int rc = ioctl(fd, LIRC_SET_SEND_CARRIER, &carrier);
+		if (rc < 0)
+			fprintf(stderr, _("warning: %s: failed to set carrier: %m\n"), devname);
+		if (rc != 0)
+			fprintf(stderr, _("warning: %s: set send carrier returned %d, should return 0\n"), devname, rc);
+	} else
+		fprintf(stderr, _("warning: %s: does not support setting send carrier\n"), devname);
+}
+
+static int lirc_options(struct arguments *args, int fd, unsigned features)
+{
+	const char *dev = args->device;
+	int rc;
+
+	if (args->timeout) {
+		if (features & LIRC_CAN_SET_REC_TIMEOUT) {
+			rc = ioctl(fd, LIRC_SET_REC_TIMEOUT, &args->timeout);
+			if (rc)
+				fprintf(stderr, _("%s: failed to set recording timeout\n"), dev);
+		} else
+			fprintf(stderr, _("%s: device does not support setting timeout\n"), dev);
+	}
+
+	if (args->wideband) {
+		unsigned on = args->wideband == 1;
+		if (features & LIRC_CAN_USE_WIDEBAND_RECEIVER) {
+			rc = ioctl(fd, LIRC_SET_WIDEBAND_RECEIVER, &on);
+			if (rc)
+				fprintf(stderr, _("%s: failed to set wideband receiver %s\n"), dev, on ? _("on") : _("off"));
+		} else
+			fprintf(stderr, _("%s: device does not have wideband receiver\n"), dev);
+	}
+
+	if (args->carrier_reports) {
+		unsigned on = args->carrier_reports == 1;
+		if (features & LIRC_CAN_MEASURE_CARRIER) {
+			rc = ioctl(fd, LIRC_SET_MEASURE_CARRIER_MODE, &on);
+			if (rc)
+				fprintf(stderr, _("%s: failed to set carrier reports %s\n"), dev, on ? _("on") : _("off"));
+		} else
+			fprintf(stderr, _("%s: device cannot measure carrier\n"), dev);
+	}
+
+	if (args->timeout_reports) {
+		unsigned on = args->timeout_reports == 1;
+		rc = ioctl(fd, LIRC_SET_REC_TIMEOUT_REPORTS, &on);
+		if (rc)
+			fprintf(stderr, _("%s: failed to set timeout reports %s: %m\n"), dev, on ? _("on") : _("off"));
+	}
+
+	if (args->carrier_low) {
+		if (features & LIRC_CAN_SET_REC_CARRIER_RANGE) {
+			rc = ioctl(fd, LIRC_SET_REC_CARRIER_RANGE, &args->carrier_low);
+			if (rc)
+				fprintf(stderr, _("%s: failed to set low carrier range: %m\n"), dev);
+			rc = ioctl(fd, LIRC_SET_REC_CARRIER, &args->carrier_high);
+			if (rc)
+				fprintf(stderr, _("%s: failed to set high carrier range: %m\n"), dev);
+		} else
+			fprintf(stderr, _("%s: device does not support setting receiver carrier range\n"), dev);
+	}
+
+	if (args->carrier)
+		lirc_set_send_carrier(fd, dev, features, args->carrier);
+
+	if (args->duty) {
+		if (features & LIRC_CAN_SET_SEND_DUTY_CYCLE) {
+			rc = ioctl(fd, LIRC_SET_SEND_DUTY_CYCLE, &args->duty);
+			if (rc)
+				fprintf(stderr, _("warning: %s: failed to set duty cycle: %m\n"), dev);
+		} else
+			fprintf(stderr, _("warning: %s: does not support setting send duty cycle\n"), dev);
+	}
+
+	if (args->emitters) {
+		if (features & LIRC_CAN_SET_TRANSMITTER_MASK) {
+			rc = ioctl(fd, LIRC_SET_TRANSMITTER_MASK, &args->emitters);
+			if (rc)
+				fprintf(stderr, _("warning: %s: failed to set send transmitters: %m\n"), dev);
+		} else
+			fprintf(stderr, _("warning: %s: does not support setting send transmitters\n"), dev);
+	}
+
+
+	return 0;
+}
+
+static void lirc_features(struct arguments *args, int fd, unsigned features)
+{
+	const char *dev = args->device;
+	unsigned resolution = 0;
+	int rc;
+
+	if (features & LIRC_CAN_GET_REC_RESOLUTION) {
+		rc = ioctl(fd, LIRC_GET_REC_RESOLUTION, &resolution);
+		if (rc == 0 && resolution == 0)
+			fprintf(stderr, _("warning: %s: device returned resolution of 0\n"), dev);
+		else if (rc)
+			fprintf(stderr, _("warning: %s: unexpected error while retrieving resolution: %m\n"), dev);
+	}
+
+	printf(_("Receive features %s:\n"), dev);
+	if (features & LIRC_CAN_REC_MODE2) {
+		printf(_(" - Device can receive raw IR\n"));
+		if (resolution)
+			printf(_(" - Resolution %u nanoseconds\n"), resolution);
+		if (features & LIRC_CAN_SET_REC_CARRIER)
+			printf(_(" - Set receive carrier\n"));
+		if (features & LIRC_CAN_USE_WIDEBAND_RECEIVER)
+			printf(_(" - Use wideband receiver\n"));
+		if (features & LIRC_CAN_MEASURE_CARRIER)
+			printf(_(" - Can measure carrier\n"));
+		if (features & LIRC_CAN_SET_REC_TIMEOUT) {
+			unsigned min_timeout, max_timeout;
+			int rc = ioctl(fd, LIRC_GET_MIN_TIMEOUT, &min_timeout);
+			if (rc) {
+				fprintf(stderr, _("warning: %s: device supports setting recording timeout but LIRC_GET_MIN_TIMEOUT returns: %m\n"), dev);
+				min_timeout = 0;
+			} else if (min_timeout == 0)
+				fprintf(stderr, _("warning: %s: device supports setting recording timeout but min timeout is 0\n"), dev);
+			rc = ioctl(fd, LIRC_GET_MAX_TIMEOUT, &max_timeout);
+			if (rc) {
+				fprintf(stderr, _("warning: %s: device supports setting recording timeout but LIRC_GET_MAX_TIMEOUT returns: %m\n"), dev);
+				max_timeout = 0;
+			} else if (max_timeout == 0) {
+				fprintf(stderr, _("warning: %s: device supports setting recording timeout but max timeout is 0\n"), dev);
+			}
+
+			if (min_timeout || max_timeout)
+				printf(_(" - Can set recording timeout min:%uµs max:%uµs\n"), min_timeout, max_timeout);
+		}
+	} else {
+		printf(_(" - Device cannot receive\n"));
+	}
+
+	printf(_("Send features %s:\n"), dev);
+	if (features & LIRC_CAN_SEND_PULSE) {
+		printf(_(" - Device can send raw IR\n"));
+		if (features & LIRC_CAN_SET_SEND_CARRIER)
+			printf(_(" - Set carrier\n"));
+		if (features & LIRC_CAN_SET_SEND_DUTY_CYCLE)
+			printf(_(" - Set duty cycle\n"));
+		if (features & LIRC_CAN_SET_TRANSMITTER_MASK) {
+			unsigned mask = ~0;
+			rc = ioctl(fd, LIRC_SET_TRANSMITTER_MASK, &mask);
+			if (rc == 0)
+				fprintf(stderr, _("warning: %s: device supports setting transmitter mask but returns 0 as number of transmitters\n"), dev);
+			else if (rc < 0)
+				fprintf(stderr, _("warning: %s: device supports setting transmitter mask but returns: %m\n"), dev);
+			else
+				printf(_(" - Set transmitter (%d available)\n"), rc);
+		}
+	} else {
+		printf(_(" - Device cannot send\n"));
+	}
+}
+
+static int lirc_send(struct arguments *args, int fd, unsigned features, struct file *f)
+{
+	const char *dev = args->device;
+
+	if (!(features & LIRC_CAN_SEND_PULSE)) {
+		fprintf(stderr, _("%s: device cannot send\n"), dev);
+		return EX_UNAVAILABLE;
+	}
+
+	if (args->carrier && f->carrier)
+		fprintf(stderr, _("warning: %s: carrier specified but overwritten on command line\n"), f->fname);
+	else if (f->carrier && args->carrier == 0)
+		lirc_set_send_carrier(fd, dev, features, f->carrier);
+
+	size_t size = f->len * sizeof(unsigned);
+	ssize_t ret = TEMP_FAILURE_RETRY(write(fd, f->buf, size));
+	if (ret < 0) {
+		fprintf(stderr, _("%s: failed to send: %m\n"), dev);
+		return EX_IOERR;
+	}
+
+	if (size < ret) {
+		fprintf(stderr, _("warning: %s: sent %zd out %zd edges\n"),
+				dev,
+				ret / sizeof(unsigned),
+				size / sizeof(unsigned));
+		return EX_IOERR;
+	}
+
+	return 0;
+}
+
+int lirc_record(struct arguments *args, int fd, unsigned features)
+{
+	char *dev = args->device;
+	FILE *out = stdout;
+	int rc = EX_IOERR;
+
+	if (args->savetofile) {
+		out = fopen(args->savetofile, "w");
+		if (!out) {
+			fprintf(stderr, _("%s: failed to open for writing: %m\n"), args->savetofile);
+			return EX_CANTCREAT;
+		}
+	}
+	unsigned buf[LIRCBUF_SIZE];
+
+	bool keep_reading = true;
+	bool leading_space = true;
+
+	while (keep_reading) {
+		ssize_t ret = TEMP_FAILURE_RETRY(read(fd, buf, sizeof(buf)));
+		if (ret < 0) {
+			fprintf(stderr, _("%s: failed read: %m\n"), dev);
+			goto err;
+		}
+
+		if (ret == 0 || ret % sizeof(unsigned)) {
+			fprintf(stderr, _("%s: read returned %zd bytes\n"),
+								dev, ret);
+			goto err;
+		}
+
+		for (int i=0; i<ret / sizeof(unsigned); i++) {
+			unsigned val = buf[i] & LIRC_VALUE_MASK;
+			unsigned msg = buf[i] & LIRC_MODE2_MASK;
+
+			// FIXME: the kernel often send us a space after
+			// the IR receiver comes out of idle mode. This
+			// is meaningless, maybe fix the kernel?
+			if (leading_space && msg == LIRC_MODE2_SPACE)
+				continue;
+			else
+				leading_space = false;
+
+			if (args->oneshot &&
+				(msg == LIRC_MODE2_TIMEOUT ||
+				(msg == LIRC_MODE2_SPACE && val > 19000))) {
+				keep_reading = false;
+				break;
+			}
+
+			switch (msg) {
+			case LIRC_MODE2_TIMEOUT:
+				fprintf(out, "timeout %u\n", val);
+				leading_space = true;
+				break;
+			case LIRC_MODE2_PULSE:
+				fprintf(out, "pulse %u\n", val);
+				break;
+			case LIRC_MODE2_SPACE:
+				fprintf(out, "space %u\n", val);
+				break;
+			case LIRC_MODE2_FREQUENCY:
+				fprintf(out, "carrier %u\n", val);
+				break;
+			}
+
+			fflush(out);
+		}
+	}
+
+	rc = 0;
+err:
+	if (args->savetofile)
+		fclose(out);
+
+	return rc;
+}
+
+int main(int argc, char *argv[])
+{
+	struct arguments args = {};
+
+	argp_parse(&argp, argc, argv, 0, 0, &args);
+
+	if (args.device == NULL)
+		args.device = "/dev/lirc0";
+
+	int rc, fd;
+	unsigned features;
+
+	fd = open_lirc(args.device, &features);
+	if (fd < 0)
+		exit(EX_NOINPUT);
+
+	rc = lirc_options(&args, fd, features);
+	if (rc)
+		exit(EX_IOERR);
+
+	struct file *s = args.send;
+	while (s) {
+		struct file *next = s->next;
+		if (s != args.send)
+			usleep(IR_DEFAULT_TIMEOUT);
+
+		rc = lirc_send(&args, fd, features, s);
+		if (rc) {
+			close(fd);
+			exit(rc);
+		}
+
+		free(s);
+		s = next;
+	}
+
+	if (args.record) {
+		rc = lirc_record(&args, fd, features);
+		if (rc) {
+			close(fd);
+			exit(rc);
+		}
+	}
+
+	if (args.features)
+		lirc_features(&args, fd, features);
+
+	close(fd);
+
+	return 0;
+}
diff --git a/v4l-utils.spec.in b/v4l-utils.spec.in
index dd8959b..bdbb27b 100644
--- a/v4l-utils.spec.in
+++ b/v4l-utils.spec.in
@@ -17,8 +17,8 @@ Requires:       libv4l = %{version}-%{release}
 
 %description
 v4l-utils is a collection of various video4linux (V4L) and DVB utilities. The
-main v4l-utils package contains cx18-ctl, ir-keytable, ivtv-ctl, v4l2-ctl and
-v4l2-sysfs-path.
+main v4l-utils package contains cx18-ctl, ir-keytable, ir-ctl, ivtv-ctl,
+v4l2-ctl and v4l2-sysfs-path.
 
 
 %package        devel-tools
@@ -129,10 +129,12 @@ gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
 %config(noreplace) %{_sysconfdir}/udev/rules.d/70-infrared.rules
 %{_bindir}/cx18-ctl
 %{_bindir}/ir-keytable
+%{_bindir}/ir-ctl
 %{_bindir}/ivtv-ctl
 %{_bindir}/v4l2-ctl
 %{_bindir}/v4l2-sysfs-path
 %{_mandir}/man1/ir-keytable.1*
+%{_mandir}/man1/ir-ctl.1*
 
 %files devel-tools
 %defattr(-,root,root,-)
-- 
2.7.4

