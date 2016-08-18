Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754211AbcHSDqP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:46:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 02/20] [media] docs-rst: add tabularcolumns to all tables
Date: Thu, 18 Aug 2016 13:15:31 -0300
Message-Id: <259400b5ffbea0925e0875163ee76cfde4be75e9.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LaTeX doesn't handle too well auto-width on tables, and ReST
markup requires an special tag to give it the needed hints.

As we're using A4 paper, we have 17cm of useful spaces. As
most media tables have widths, let's use it to generate the
needed via the following perl script:

my ($line_size, $table_header, $has_cols) = (17.5, 0, 0);
my $out;
my $header = "";
my @widths = ();
sub round { $_[0] > 0 ? int($_[0] + .5) : -int(-$_[0] + .5) }
while (<>) {
	if (!$table_header) {
		$has_cols = 1 if (m/..\s+tabularcolumns::/);
		if (m/..\s+flat-table::/) {
			$table_header = 1;
			$header = $_;
			next;
		}
		$out .= $_;
		next;
	}
	$header .= $_;
	@widths = split(/ /, $1) if (m/:widths:\s+(.*)/);
	if (m/^\n$/) {
		if (!$has_cols && @widths) {
			my ($tot, $t, $i) = (0, 0, 0);
			foreach my $v(@widths) { $tot += $v; };
			$out .= ".. tabularcolumns:: |";
			for ($i = 0; $i < scalar @widths - 1; $i++) {
				my $v = $widths[$i];
				my $w = round(10 * ($v * $line_size) / $tot) / 10;
				$out .= sprintf "p{%.1fcm}|", $w;
				$t += $w;
			}
			my $w = $line_size - $t;
			$out .= sprintf "p{%.1fcm}|\n\n", $w;
		}
		$out .= $header;
		$table_header = 0;
		$has_cols = 0;
		$header = "";
		@widths = ();
	}
}
print $out;

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst   |  4 ++++
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst        | 10 ++++++++++
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst       | 10 ++++++++++
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst        |  6 ++++++
 Documentation/media/uapi/cec/cec-ioc-receive.rst       |  6 ++++++
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst      |  2 ++
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst       |  2 ++
 Documentation/media/uapi/dvb/fe-get-info.rst           |  2 ++
 Documentation/media/uapi/dvb/fe-type-t.rst             |  2 ++
 Documentation/media/uapi/gen-errors.rst                |  2 ++
 .../media/uapi/mediactl/media-ioc-device-info.rst      |  2 ++
 .../media/uapi/mediactl/media-ioc-enum-entities.rst    |  2 ++
 .../media/uapi/mediactl/media-ioc-enum-links.rst       |  6 ++++++
 .../media/uapi/mediactl/media-ioc-g-topology.rst       | 12 ++++++++++++
 Documentation/media/uapi/rc/rc-tables.rst              |  2 ++
 Documentation/media/uapi/v4l/buffer.rst                | 16 ++++++++++++++++
 Documentation/media/uapi/v4l/dev-raw-vbi.rst           |  4 ++++
 Documentation/media/uapi/v4l/dev-rds.rst               |  6 ++++++
 Documentation/media/uapi/v4l/dev-sdr.rst               |  2 ++
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst        | 18 ++++++++++++++++++
 Documentation/media/uapi/v4l/field-order.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-002.rst            |  2 ++
 Documentation/media/uapi/v4l/pixfmt-003.rst            |  4 ++++
 Documentation/media/uapi/v4l/pixfmt-007.rst            | 18 ++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-013.rst            |  2 ++
 Documentation/media/uapi/v4l/pixfmt-grey.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-m420.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-nv12.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst          |  2 ++
 Documentation/media/uapi/v4l/pixfmt-nv16.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst          |  2 ++
 Documentation/media/uapi/v4l/pixfmt-nv24.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst     |  2 ++
 Documentation/media/uapi/v4l/pixfmt-reserved.rst       |  4 ++++
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst        |  2 ++
 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst         |  2 ++
 Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst       |  2 ++
 Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst     |  2 ++
 Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst       |  2 ++
 Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst     |  2 ++
 Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst     |  2 ++
 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst         |  2 ++
 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst         |  2 ++
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst        |  2 ++
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst       |  2 ++
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst        |  2 ++
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst         |  2 ++
 Documentation/media/uapi/v4l/pixfmt-uv8.rst            |  2 ++
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-y10.rst            |  2 ++
 Documentation/media/uapi/v4l/pixfmt-y10b.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-y12.rst            |  2 ++
 Documentation/media/uapi/v4l/pixfmt-y12i.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst         |  2 ++
 Documentation/media/uapi/v4l/pixfmt-y16.rst            |  2 ++
 Documentation/media/uapi/v4l/pixfmt-y41p.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-y8i.rst            |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yuv410.rst         |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst        |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yuv420.rst         |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst        |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst        |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst        |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst        |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst           |  2 ++
 Documentation/media/uapi/v4l/pixfmt-z16.rst            |  2 ++
 Documentation/media/uapi/v4l/subdev-formats.rst        |  2 ++
 Documentation/media/uapi/v4l/vidioc-create-bufs.rst    |  2 ++
 Documentation/media/uapi/v4l/vidioc-cropcap.rst        |  4 ++++
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst          |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst |  4 ++++
 Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst    |  4 ++++
 Documentation/media/uapi/v4l/vidioc-dqevent.rst        | 18 ++++++++++++++++++
 Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst |  4 ++++
 Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst    |  6 ++++++
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst          |  2 ++
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst       |  4 ++++
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst      |  4 ++++
 .../media/uapi/v4l/vidioc-enum-framesizes.rst          |  6 ++++++
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst          |  4 ++++
 Documentation/media/uapi/v4l/vidioc-enuminput.rst      |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst     |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-enumstd.rst        |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-expbuf.rst         |  2 ++
 Documentation/media/uapi/v4l/vidioc-g-audio.rst        |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst     |  2 ++
 Documentation/media/uapi/v4l/vidioc-g-crop.rst         |  2 ++
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst         |  2 ++
 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst   |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-g-edid.rst         |  2 ++
 Documentation/media/uapi/v4l/vidioc-g-enc-index.rst    |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst    |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst         |  6 ++++++
 Documentation/media/uapi/v4l/vidioc-g-frequency.rst    |  2 ++
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst     |  4 ++++
 Documentation/media/uapi/v4l/vidioc-g-modulator.rst    |  4 ++++
 Documentation/media/uapi/v4l/vidioc-g-parm.rst         | 10 ++++++++++
 Documentation/media/uapi/v4l/vidioc-g-priority.rst     |  2 ++
 Documentation/media/uapi/v4l/vidioc-g-selection.rst    |  2 ++
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst         |  4 ++++
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst        |  8 ++++++++
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst      | 10 ++++++++++
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst        |  2 ++
 Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst |  2 ++
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst     |  2 ++
 .../media/uapi/v4l/vidioc-subdev-enum-frame-size.rst   |  2 ++
 .../media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst    |  2 ++
 Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst  |  2 ++
 Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst   |  4 ++++
 .../media/uapi/v4l/vidioc-subdev-g-frame-interval.rst  |  2 ++
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst       |  2 ++
 .../media/uapi/v4l/vidioc-subscribe-event.rst          |  4 ++++
 114 files changed, 430 insertions(+)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 2516d4c3a4c8..4e70eae7e6ab 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -44,6 +44,8 @@ returns the information to the application. The ioctl never fails.
 
 .. _cec-caps:
 
+.. tabularcolumns:: |p{1.0cm}|p{1.0cm}|p{15.5cm}|
+
 .. flat-table:: struct cec_caps
     :header-rows:  0
     :stub-columns: 0
@@ -89,6 +91,8 @@ returns the information to the application. The ioctl never fails.
 
 .. _cec-capabilities:
 
+.. tabularcolumns:: |p{4.4cm}|p{1.5cm}|p{11.6cm}|
+
 .. flat-table:: CEC Capabilities Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 359f7b3aa91a..11fac7e24554 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -69,6 +69,8 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. _cec-log-addrs:
 
+.. tabularcolumns:: |p{1.0cm}|p{1.0cm}|p{15.5cm}|
+
 .. flat-table:: struct cec_log_addrs
     :header-rows:  0
     :stub-columns: 0
@@ -205,6 +207,8 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. _cec-versions:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: CEC Versions
     :header-rows:  0
     :stub-columns: 0
@@ -239,6 +243,8 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. _cec-prim-dev-types:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: CEC Primary Device Types
     :header-rows:  0
     :stub-columns: 0
@@ -305,6 +311,8 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. _cec-log-addr-types:
 
+.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+
 .. flat-table:: CEC Logical Address Types
     :header-rows:  0
     :stub-columns: 0
@@ -373,6 +381,8 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. _cec-all-dev-types-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: CEC All Device Types Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 36eb4f907d30..b4c73ed50509 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -54,6 +54,8 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-event-state-change_s:
 
+.. tabularcolumns:: |p{1.8cm}|p{1.8cm}|p{13.9cm}|
+
 .. flat-table:: struct cec_event_state_change
     :header-rows:  0
     :stub-columns: 0
@@ -80,6 +82,8 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-event-lost-msgs_s:
 
+.. tabularcolumns:: |p{1.0cm}|p{1.0cm}|p{15.5cm}|
+
 .. flat-table:: struct cec_event_lost_msgs
     :header-rows:  0
     :stub-columns: 0
@@ -106,6 +110,8 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-event:
 
+.. tabularcolumns:: |p{1.6cm}|p{1.6cm}|p{1.6cm}|p{12.7cm}|
+
 .. flat-table:: struct cec_event
     :header-rows:  0
     :stub-columns: 0
@@ -177,6 +183,8 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-events:
 
+.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+
 .. flat-table:: CEC Events Types
     :header-rows:  0
     :stub-columns: 0
@@ -206,6 +214,8 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-event-flags:
 
+.. tabularcolumns:: |p{4.4cm}|p{1.5cm}|p{11.6cm}|
+
 .. flat-table:: CEC Event Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index c0e851f357d0..d213432eedd7 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -76,6 +76,8 @@ Available initiator modes are:
 
 .. _cec-mode-initiator_e:
 
+.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+
 .. flat-table:: Initiator Modes
     :header-rows:  0
     :stub-columns: 0
@@ -119,6 +121,8 @@ Available follower modes are:
 
 .. _cec-mode-follower_e:
 
+.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+
 .. flat-table:: Follower Modes
     :header-rows:  0
     :stub-columns: 0
@@ -211,6 +215,8 @@ Core message processing details:
 
 .. _cec-core-processing:
 
+.. tabularcolumns:: |p{1.9cm}|p{15.6cm}|
+
 .. flat-table:: Core Message Processing
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 7167a90209df..1a06c8d62ac9 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -75,6 +75,8 @@ result.
 
 .. _cec-msg:
 
+.. tabularcolumns:: |p{1.0cm}|p{1.0cm}|p{15.5cm}|
+
 .. flat-table:: struct cec_msg
     :header-rows:  0
     :stub-columns: 0
@@ -252,6 +254,8 @@ result.
 
 .. _cec-tx-status:
 
+.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+
 .. flat-table:: CEC Transmit Status
     :header-rows:  0
     :stub-columns: 0
@@ -320,6 +324,8 @@ result.
 
 .. _cec-rx-status:
 
+.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+
 .. flat-table:: CEC Receive Status
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index 7bd02ac7bff4..7b32566b77a3 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -42,6 +42,8 @@ Receives reply from a DiSEqC 2.0 command.
 struct dvb_diseqc_slave_reply
 -----------------------------
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct dvb_diseqc_slave_reply
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index 58a5e6ac10bd..865914bf4efe 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -42,6 +42,8 @@ Sends a DiSEqC command to the antenna subsystem.
 struct dvb_diseqc_master_cmd
 ============================
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct dvb_diseqc_master_cmd
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index dfc7644f9dac..80644072087f 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -47,6 +47,8 @@ returns an error.
 struct dvb_frontend_info
 ========================
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct dvb_frontend_info
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/fe-type-t.rst b/Documentation/media/uapi/dvb/fe-type-t.rst
index 8ca762b42e4d..fa377fe9e104 100644
--- a/Documentation/media/uapi/dvb/fe-type-t.rst
+++ b/Documentation/media/uapi/dvb/fe-type-t.rst
@@ -13,6 +13,8 @@ fe_type_t type, defined as:
 
 .. _fe-type:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Frontend types
     :header-rows:  1
     :stub-columns: 0
diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
index d6b0cfd00a3f..d37284d50e56 100644
--- a/Documentation/media/uapi/gen-errors.rst
+++ b/Documentation/media/uapi/gen-errors.rst
@@ -9,6 +9,8 @@ Generic Error Codes
 
 .. _gen-errors:
 
+.. tabularcolumns:: |p{1.0cm}|p{16.5cm}|
+
 .. flat-table:: Generic error codes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index 467d82cbb81e..567f5515a791 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -42,6 +42,8 @@ ioctl never fails.
 
 .. _media-device-info:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct media_device_info
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 12d4b25d5b94..a51c4cc9f6d3 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -53,6 +53,8 @@ id's until they get an error.
 
 .. _media-entity-desc:
 
+.. tabularcolumns:: |p{1.5cm}|p{1.5cm}|p{1.5cm}|p{1.5cm}|p{11.5cm}|
+
 .. flat-table:: struct media_entity_desc
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index 87443b1ce42d..f4334f5765c6 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -57,6 +57,8 @@ returned during the enumeration process.
 
 .. _media-links-enum:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct media_links_enum
     :header-rows:  0
     :stub-columns: 0
@@ -93,6 +95,8 @@ returned during the enumeration process.
 
 .. _media-pad-desc:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct media_pad_desc
     :header-rows:  0
     :stub-columns: 0
@@ -127,6 +131,8 @@ returned during the enumeration process.
 
 .. _media-link-desc:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct media_link_desc
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 2e382cc7762c..750dd11dbe03 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -51,6 +51,8 @@ desired arrays with the media graph elements.
 
 .. _media-v2-topology:
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
+
 .. flat-table:: struct media_v2_topology
     :header-rows:  0
     :stub-columns: 0
@@ -145,6 +147,8 @@ desired arrays with the media graph elements.
 
 .. _media-v2-entity:
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
+
 .. flat-table:: struct media_v2_entity
     :header-rows:  0
     :stub-columns: 0
@@ -188,6 +192,8 @@ desired arrays with the media graph elements.
 
 .. _media-v2-interface:
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
+
 .. flat-table:: struct media_v2_interface
     :header-rows:  0
     :stub-columns: 0
@@ -239,6 +245,8 @@ desired arrays with the media graph elements.
 
 .. _media-v2-intf-devnode:
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
+
 .. flat-table:: struct media_v2_interface
     :header-rows:  0
     :stub-columns: 0
@@ -265,6 +273,8 @@ desired arrays with the media graph elements.
 
 .. _media-v2-pad:
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
+
 .. flat-table:: struct media_v2_pad
     :header-rows:  0
     :stub-columns: 0
@@ -308,6 +318,8 @@ desired arrays with the media graph elements.
 
 .. _media-v2-link:
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
+
 .. flat-table:: struct media_v2_pad
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/rc/rc-tables.rst b/Documentation/media/uapi/rc/rc-tables.rst
index 0bb16c4af27d..c8ae9479f842 100644
--- a/Documentation/media/uapi/rc/rc-tables.rst
+++ b/Documentation/media/uapi/rc/rc-tables.rst
@@ -25,6 +25,8 @@ the remote via /dev/input/event devices.
 
 .. _rc_standard_keymap:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: IR default keymapping
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index f75f959b960b..064bc03b7a1d 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -39,6 +39,8 @@ buffer.
 struct v4l2_buffer
 ==================
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+
 .. flat-table:: struct v4l2_buffer
     :header-rows:  0
     :stub-columns: 0
@@ -282,6 +284,8 @@ struct v4l2_buffer
 struct v4l2_plane
 =================
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -399,6 +403,8 @@ struct v4l2_plane
 enum v4l2_buf_type
 ==================
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -513,6 +519,8 @@ enum v4l2_buf_type
 Buffer Flags
 ============
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -762,6 +770,8 @@ Buffer Flags
 enum v4l2_memory
 ================
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -816,6 +826,8 @@ The :ref:`struct v4l2_timecode <v4l2-timecode>` structure is designed to hold a
 struct v4l2_timecode
 --------------------
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -886,6 +898,8 @@ struct v4l2_timecode
 Timecode Types
 --------------
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -939,6 +953,8 @@ Timecode Types
 Timecode Flags
 --------------
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index d5a4b3530b69..95de08b8fbf2 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -102,6 +102,8 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _v4l2-vbi-format:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_vbi_format
     :header-rows:  0
     :stub-columns: 0
@@ -227,6 +229,8 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _vbifmt-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Raw VBI Format Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/dev-rds.rst b/Documentation/media/uapi/v4l/dev-rds.rst
index fa32538d4c1f..35117414c86b 100644
--- a/Documentation/media/uapi/v4l/dev-rds.rst
+++ b/Documentation/media/uapi/v4l/dev-rds.rst
@@ -95,6 +95,8 @@ RDS datastructures
 
 .. _v4l2-rds-data:
 
+.. tabularcolumns:: |p{2.5cm}|p{2.5cm}|p{12.5cm}|
+
 .. flat-table:: struct v4l2_rds_data
     :header-rows:  0
     :stub-columns: 0
@@ -129,6 +131,8 @@ RDS datastructures
 
 .. _v4l2-rds-block:
 
+.. tabularcolumns:: |p{2.9cm}|p{14.6cm}|
+
 .. flat-table:: Block description
     :header-rows:  0
     :stub-columns: 0
@@ -166,6 +170,8 @@ RDS datastructures
 
 .. _v4l2-rds-block-codes:
 
+.. tabularcolumns:: |p{2.2cm}|p{2.2cm}|p{2.2cm}|p{10.9cm}|
+
 .. flat-table:: Block defines
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/dev-sdr.rst b/Documentation/media/uapi/v4l/dev-sdr.rst
index fc4053f957fb..3b6aa2a58430 100644
--- a/Documentation/media/uapi/v4l/dev-sdr.rst
+++ b/Documentation/media/uapi/v4l/dev-sdr.rst
@@ -80,6 +80,8 @@ data transfer, set by the driver in order to inform application.
 
 .. _v4l2-sdr-format:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_sdr_format
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index ec52a825f4d6..9f59ba6847ec 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -105,6 +105,8 @@ which may return ``EBUSY`` can be the
 struct v4l2_sliced_vbi_format
 -----------------------------
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -250,6 +252,8 @@ struct v4l2_sliced_vbi_format
 Sliced VBI services
 -------------------
 
+.. tabularcolumns:: |p{4.4cm}|p{2.2cm}|p{2.2cm}|p{4.4cm}|p{4.3cm}|
+
 .. flat-table::
     :header-rows:  1
     :stub-columns: 0
@@ -371,6 +375,8 @@ of one video frame. The ``id`` of unused
 struct v4l2_sliced_vbi_data
 ---------------------------
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -556,6 +562,8 @@ number).
 struct v4l2_mpeg_vbi_fmt_ivtv
 -----------------------------
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -611,6 +619,8 @@ struct v4l2_mpeg_vbi_fmt_ivtv
 Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
 -------------------------------------------------------------
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  1
     :stub-columns: 0
@@ -652,6 +662,8 @@ Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
 struct v4l2_mpeg_vbi_itv0
 -------------------------
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -709,6 +721,8 @@ struct v4l2_mpeg_vbi_itv0
 struct v4l2_mpeg_vbi_ITV0
 -------------------------
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -734,6 +748,8 @@ struct v4l2_mpeg_vbi_ITV0
 struct v4l2_mpeg_vbi_itv0_line
 ------------------------------
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -765,6 +781,8 @@ struct v4l2_mpeg_vbi_itv0_line
 Line Identifiers for struct v4l2_mpeg_vbi_itv0_line id field
 ------------------------------------------------------------
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  1
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/field-order.rst b/Documentation/media/uapi/v4l/field-order.rst
index 979fedbb2bda..95e9d2a41f1d 100644
--- a/Documentation/media/uapi/v4l/field-order.rst
+++ b/Documentation/media/uapi/v4l/field-order.rst
@@ -57,6 +57,8 @@ should have the value ``V4L2_FIELD_ANY`` (0).
 enum v4l2_field
 ===============
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-002.rst
index fae9b2d40a85..27d4e78760ba 100644
--- a/Documentation/media/uapi/v4l/pixfmt-002.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-002.rst
@@ -7,6 +7,8 @@ Single-planar format structure
 
 .. _v4l2-pix-format:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_pix_format
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
index 25c54872fbe1..8dc86b490451 100644
--- a/Documentation/media/uapi/v4l/pixfmt-003.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-003.rst
@@ -14,6 +14,8 @@ describing all planes of that format.
 
 .. _v4l2-plane-pix-format:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_plane_pix_format
     :header-rows:  0
     :stub-columns: 0
@@ -50,6 +52,8 @@ describing all planes of that format.
 
 .. _v4l2-pix-format-mplane:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_pix_format_mplane
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 8d4f1033663f..f097268ffc54 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -19,6 +19,8 @@ are:
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: SMPTE 170M Chromaticities
     :header-rows:  1
     :stub-columns: 0
@@ -123,6 +125,8 @@ and the white reference are:
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: Rec. 709 Chromaticities
     :header-rows:  1
     :stub-columns: 0
@@ -262,6 +266,8 @@ The chromaticities of the primary colors and the white reference are:
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: sRGB Chromaticities
     :header-rows:  1
     :stub-columns: 0
@@ -367,6 +373,8 @@ are:
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: Adobe RGB Chromaticities
     :header-rows:  1
     :stub-columns: 0
@@ -457,6 +465,8 @@ of the primary colors and the white reference are:
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: BT.2020 Chromaticities
     :header-rows:  1
     :stub-columns: 0
@@ -579,6 +589,8 @@ is ``V4L2_XFER_FUNC_DCI_P3``. The default Y'CbCr encoding is
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: DCI-P3 Chromaticities
     :header-rows:  1
     :stub-columns: 0
@@ -656,6 +668,8 @@ and the white reference are:
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: SMPTE 240M Chromaticities
     :header-rows:  1
     :stub-columns: 0
@@ -750,6 +764,8 @@ reference are:
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: NTSC 1953 Chromaticities
     :header-rows:  1
     :stub-columns: 0
@@ -852,6 +868,8 @@ are:
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: EBU Tech. 3213 Chromaticities
     :header-rows:  1
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
index 475f6e6fe785..bfef4f4ce6b1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-013.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
@@ -7,6 +7,8 @@ Compressed Formats
 
 .. _compressed-formats:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Compressed Image Formats
     :header-rows:  1
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-grey.rst b/Documentation/media/uapi/v4l/pixfmt-grey.rst
index 761d783d4989..844fb67320be 100644
--- a/Documentation/media/uapi/v4l/pixfmt-grey.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-grey.rst
@@ -22,6 +22,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-m420.rst b/Documentation/media/uapi/v4l/pixfmt-m420.rst
index 4c5b2969c039..ff0ed7abfef3 100644
--- a/Documentation/media/uapi/v4l/pixfmt-m420.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-m420.rst
@@ -33,6 +33,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12.rst b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
index cf59b28f75b7..a5b70b8a1273 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
@@ -37,6 +37,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
index a4e7eaeccea8..cdc24109fdf7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
@@ -47,6 +47,8 @@ many pad bytes after its rows.
 **Byte Order.**
 Each cell is one byte.
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16.rst b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
index 88aa7617f7cf..2cbdc1e6a36d 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
@@ -36,6 +36,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
index b7ee068f491c..98cc0550bf26 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
@@ -39,6 +39,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv24.rst b/Documentation/media/uapi/v4l/pixfmt-nv24.rst
index db98f476446e..ebc27b772a38 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv24.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv24.rst
@@ -36,6 +36,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index 9a909cd99361..8997b51ac230 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -981,6 +981,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{2.5cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{0.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
index 9a5704baf9fe..d6938cd5e03e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
@@ -19,6 +19,8 @@ please make a proposal on the linux-media mailing list.
 
 .. _reserved-formats:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Reserved Image Formats
     :header-rows:  1
     :stub-columns: 0
@@ -341,6 +343,8 @@ please make a proposal on the linux-media mailing list.
 
 .. _format-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Format Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
index 7f295b48748c..c2224c455e8a 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
@@ -29,6 +29,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
index db4c523f49a9..0a65450e017e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
@@ -26,6 +26,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
index 2736275d080f..48c2469ddd19 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
@@ -24,6 +24,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{11.7cm}|p{5.8cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
index bfe5804bd84e..d8d7fd3f0ec2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
@@ -25,6 +25,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{8.8cm}|p{4.4cm}|p{4.3cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
index 68ad1717f6d7..1b7eaf652604 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
@@ -24,6 +24,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{11.7cm}|p{5.8cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
index 2a1c0d4924a1..e12d267423c4 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
@@ -24,6 +24,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{8.8cm}|p{4.4cm}|p{4.3cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
index 378581b27d4a..802aefe44b16 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
@@ -23,6 +23,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{8.8cm}|p{4.4cm}|p{4.3cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst b/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
index 6345c24d86f3..faad9b19dadd 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
@@ -26,6 +26,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst b/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
index 51b7b8ef7519..33a7c4fdf046 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
@@ -26,6 +26,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
index 44a49563917c..6a32ecb7f9ad 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
@@ -33,6 +33,8 @@ Each cell is one byte, high 6 bits in high bytes are 0.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index d71368f69087..b577dbf09a8b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -36,6 +36,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.0cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
index f5303ab9e79c..54355af154c8 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
@@ -34,6 +34,8 @@ Each cell is one byte, high 6 bits in high bytes are 0.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
index e88de4c48d47..1a6966b34c6f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
@@ -26,6 +26,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-uv8.rst b/Documentation/media/uapi/v4l/pixfmt-uv8.rst
index fa8f7ee9fee1..ab73e0b55d05 100644
--- a/Documentation/media/uapi/v4l/pixfmt-uv8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-uv8.rst
@@ -21,6 +21,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
index 87b0081d44ee..4c0c56003355 100644
--- a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
@@ -23,6 +23,8 @@ half the horizontal resolution of the Y component.
 **Byte Order.**
 Each cell is one byte.
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
index 5d8f99f173b6..cdebbd3a5ad2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
@@ -23,6 +23,8 @@ half the horizontal resolution of the Y component.
 **Byte Order.**
 Each cell is one byte.
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10.rst b/Documentation/media/uapi/v4l/pixfmt-y10.rst
index d22f77138289..887e6f052879 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y10.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y10.rst
@@ -23,6 +23,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10b.rst b/Documentation/media/uapi/v4l/pixfmt-y10b.rst
index 5b50cd61e654..5f5219904a62 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y10b.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y10b.rst
@@ -26,6 +26,8 @@ pixels.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y12.rst b/Documentation/media/uapi/v4l/pixfmt-y12.rst
index 7729bcbf3350..6148371909f8 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y12.rst
@@ -23,6 +23,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y12i.rst b/Documentation/media/uapi/v4l/pixfmt-y12i.rst
index 8967e8c33b47..70f2b2c1f57b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y12i.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y12i.rst
@@ -29,6 +29,8 @@ these pixels can be deinterlaced using
 pixels cross the byte boundary and have a ratio of 3 bytes for each
 interleaved pixel.
 
+.. tabularcolumns:: |p{8.8cm}|p{4.4cm}|p{4.3cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
index b16874951f0f..bc968c246ec5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
@@ -27,6 +27,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16.rst b/Documentation/media/uapi/v4l/pixfmt-y16.rst
index 10e2824da147..deb59e2a62a7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16.rst
@@ -27,6 +27,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y41p.rst b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
index 4760174a4668..d160e3dc9115 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y41p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
@@ -30,6 +30,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{2.5cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{0.7cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-y8i.rst b/Documentation/media/uapi/v4l/pixfmt-y8i.rst
index 7fa16ee85ab7..8b13c7476efb 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y8i.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y8i.rst
@@ -24,6 +24,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
index 8a5d1a2ee005..5d343d99922f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
@@ -37,6 +37,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
index f85e3f388cbe..13a31d90bf11 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
@@ -33,6 +33,8 @@ have ¼ as many pad bytes after their rows. In other words, four C x rows
 Each cell is one byte.
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
index b22e64c14f67..43bb676d5184 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
@@ -38,6 +38,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
index 4dab85090d7d..7f7a7dadd07d 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
@@ -45,6 +45,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
index ccb67284133a..5de85f987644 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
@@ -44,6 +44,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
index 9f34762adf18..6cdff74af7c9 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
@@ -34,6 +34,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
index 04f34508b934..8ebef2ce0e85 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
@@ -38,6 +38,8 @@ described in :ref:`planar-apis`.
 **Byte Order.**
 Each cell is one byte.
 
+.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
index 52917dfa9261..24fa9bbb67b6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
@@ -26,6 +26,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
index e466052b68b2..346b003b23ba 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
@@ -23,6 +23,8 @@ half the horizontal resolution of the Y component.
 **Byte Order.**
 Each cell is one byte.
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-z16.rst b/Documentation/media/uapi/v4l/pixfmt-z16.rst
index 4ebc561d0480..dd9a11a6746b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-z16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-z16.rst
@@ -24,6 +24,8 @@ Each cell is one byte.
 
 
 
+.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 6dbb27b09c34..265a6dc5fe92 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -8,6 +8,8 @@ Media Bus Formats
 
 .. _v4l2-mbus-framefmt:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_mbus_framefmt
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index abdc0b4d83d5..b4b16aebac98 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -75,6 +75,8 @@ than the number requested.
 
 .. _v4l2-create-buffers:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_create_buffers
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index 8dcbe6d26219..e3d853356438 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -54,6 +54,8 @@ overlay devices.
 
 .. _v4l2-cropcap:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_cropcap
     :header-rows:  0
     :stub-columns: 0
@@ -114,6 +116,8 @@ overlay devices.
 
 .. _v4l2-rect-crop:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_rect
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index f7e1b80af29e..b433132a7564 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -80,6 +80,8 @@ instructions.
 
 .. _name-v4l2-dbg-match:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+
 .. flat-table:: struct v4l2_dbg_match
     :header-rows:  0
     :stub-columns: 0
@@ -124,6 +126,8 @@ instructions.
 
 .. _v4l2-dbg-chip-info:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_dbg_chip_info
     :header-rows:  0
     :stub-columns: 0
@@ -169,6 +173,8 @@ instructions.
 
 .. _name-chip-match-types:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Chip Match Types
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index 09d2880e6170..28885cff682a 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -88,6 +88,8 @@ instructions.
 
 .. _v4l2-dbg-match:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+
 .. flat-table:: struct v4l2_dbg_match
     :header-rows:  0
     :stub-columns: 0
@@ -173,6 +175,8 @@ instructions.
 
 .. _chip-match-types:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Chip Match Types
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
index 2a36e91b57b9..dad36acbb415 100644
--- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
@@ -58,6 +58,8 @@ introduced in Linux 3.3.
 
 .. _v4l2-decoder-cmd:
 
+.. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table:: struct v4l2_decoder_cmd
     :header-rows:  0
     :stub-columns: 0
@@ -187,6 +189,8 @@ introduced in Linux 3.3.
 
 .. _decoder-cmds:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Decoder Commands
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 73c0d5be62ee..0a84f3a6ed92 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -42,6 +42,8 @@ call.
 
 .. _v4l2-event:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+
 .. flat-table:: struct v4l2_event
     :header-rows:  0
     :stub-columns: 0
@@ -177,6 +179,8 @@ call.
 
 .. _event-type:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Event Types
     :header-rows:  0
     :stub-columns: 0
@@ -304,6 +308,8 @@ call.
 
 .. _v4l2-event-vsync:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_event_vsync
     :header-rows:  0
     :stub-columns: 0
@@ -322,6 +328,8 @@ call.
 
 .. _v4l2-event-ctrl:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+
 .. flat-table:: struct v4l2_event_ctrl
     :header-rows:  0
     :stub-columns: 0
@@ -429,6 +437,8 @@ call.
 
 .. _v4l2-event-frame-sync:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_event_frame_sync
     :header-rows:  0
     :stub-columns: 0
@@ -447,6 +457,8 @@ call.
 
 .. _v4l2-event-src-change:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_event_src_change
     :header-rows:  0
     :stub-columns: 0
@@ -466,6 +478,8 @@ call.
 
 .. _v4l2-event-motion-det:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_event_motion_det
     :header-rows:  0
     :stub-columns: 0
@@ -509,6 +523,8 @@ call.
 
 .. _ctrl-changes-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Control Changes
     :header-rows:  0
     :stub-columns: 0
@@ -548,6 +564,8 @@ call.
 
 .. _src-changes-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Source Changes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index c390412d5aa9..e14e780eb0d1 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -56,6 +56,8 @@ that doesn't support them will return an ``EINVAL`` error code.
 
 .. _v4l2-bt-timings-cap:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_bt_timings_cap
     :header-rows:  0
     :stub-columns: 0
@@ -141,6 +143,8 @@ that doesn't support them will return an ``EINVAL`` error code.
 
 .. _v4l2-dv-timings-cap:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+
 .. flat-table:: struct v4l2_dv_timings_cap
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
index 69bd9b4e0e56..18e955ff917a 100644
--- a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
@@ -66,6 +66,8 @@ introduced in Linux 2.6.21.
 
 .. _v4l2-encoder-cmd:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_encoder_cmd
     :header-rows:  0
     :stub-columns: 0
@@ -103,6 +105,8 @@ introduced in Linux 2.6.21.
 
 .. _encoder-cmds:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Encoder Commands
     :header-rows:  0
     :stub-columns: 0
@@ -164,6 +168,8 @@ introduced in Linux 2.6.21.
 
 .. _encoder-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Encoder Command Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index 764d6cea601c..c386045885f2 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -66,6 +66,8 @@ return an ``EINVAL`` error code.
 
 .. _v4l2-enum-dv-timings:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_enum_dv_timings
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 13d5b509a829..6bb30ade6aad 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -48,6 +48,8 @@ one until ``EINVAL`` is returned.
 
 .. _v4l2-fmtdesc:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_fmtdesc
     :header-rows:  0
     :stub-columns: 0
@@ -129,6 +131,8 @@ one until ``EINVAL`` is returned.
 
 .. _fmtdesc-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Image Format Description Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index 9c22a3a6938f..7541158e16d2 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -105,6 +105,8 @@ application should zero out all members except for the *IN* fields.
 
 .. _v4l2-frmival-stepwise:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_frmival_stepwise
     :header-rows:  0
     :stub-columns: 0
@@ -233,6 +235,8 @@ Enums
 
 .. _v4l2-frmivaltypes:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: enum v4l2_frmivaltypes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 6e2adf6c23a3..1c23da3f26bc 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -94,6 +94,8 @@ application should zero out all members except for the *IN* fields.
 
 .. _v4l2-frmsize-discrete:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_frmsize_discrete
     :header-rows:  0
     :stub-columns: 0
@@ -120,6 +122,8 @@ application should zero out all members except for the *IN* fields.
 
 .. _v4l2-frmsize-stepwise:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_frmsize_stepwise
     :header-rows:  0
     :stub-columns: 0
@@ -254,6 +258,8 @@ Enums
 
 .. _v4l2-frmsizetypes:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: enum v4l2_frmsizetypes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index ccf308bd9423..ea1ccfb43e6d 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -45,6 +45,8 @@ of the corresponding tuner/modulator is set.
 
 .. _v4l2-frequency-band:
 
+.. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table:: struct v4l2_frequency_band
     :header-rows:  0
     :stub-columns: 0
@@ -151,6 +153,8 @@ of the corresponding tuner/modulator is set.
 
 .. _band-modulation:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Band Modulation Systems
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 5060f54e3d18..6b90a1a3506d 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -43,6 +43,8 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 .. _v4l2-input:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_input
     :header-rows:  0
     :stub-columns: 0
@@ -150,6 +152,8 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 .. _input-type:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Input Types
     :header-rows:  0
     :stub-columns: 0
@@ -320,6 +324,8 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 .. _input-capabilities:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Input capabilities
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index 82fc9d3b237f..13939d8d4358 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -44,6 +44,8 @@ EINVAL.
 
 .. _v4l2-output:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_output
     :header-rows:  0
     :stub-columns: 0
@@ -140,6 +142,8 @@ EINVAL.
 
 .. _output-type:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Output Type
     :header-rows:  0
     :stub-columns: 0
@@ -175,6 +179,8 @@ EINVAL.
 
 .. _output-capabilities:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Output capabilities
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index f61f0c6b0723..9d7d77af0161 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -46,6 +46,8 @@ or output. [#f1]_
 
 .. _v4l2-standard:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_standard
     :header-rows:  0
     :stub-columns: 0
@@ -114,6 +116,8 @@ or output. [#f1]_
 
 .. _v4l2-fract:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_fract
     :header-rows:  0
     :stub-columns: 0
@@ -140,6 +144,8 @@ or output. [#f1]_
 
 .. _v4l2-std-id:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: typedef v4l2_std_id
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
index ded708e647fa..67f72ced2a00 100644
--- a/Documentation/media/uapi/v4l/vidioc-expbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
@@ -118,6 +118,8 @@ Examples
 
 .. _v4l2-exportbuffer:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_exportbuffer
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index cccbcdb8c463..21fa5571b647 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -52,6 +52,8 @@ return the actual new audio mode.
 
 .. _v4l2-audio:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_audio
     :header-rows:  0
     :stub-columns: 0
@@ -106,6 +108,8 @@ return the actual new audio mode.
 
 .. _audio-capability:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Audio Capability Flags
     :header-rows:  0
     :stub-columns: 0
@@ -135,6 +139,8 @@ return the actual new audio mode.
 
 .. _audio-mode:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Audio Mode Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index c9e9a550e86d..1420ddebefd0 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -59,6 +59,8 @@ as ``VIDIOC_G_AUDOUT`` does.
 
 .. _v4l2-audioout:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_audioout
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index 6cf76497937c..08df93224a38 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -78,6 +78,8 @@ When cropping is not supported then no parameters are changed and
 
 .. _v4l2-crop:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_crop
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
index ee929f692ebe..e585b04b3f00 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
@@ -56,6 +56,8 @@ These ioctls work only with user controls. For other control classes the
 
 .. _v4l2-control:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_control
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index f7bf21f49092..d2ea3bf01fce 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -70,6 +70,8 @@ EBUSY
 
 .. _v4l2-bt-timings:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_bt_timings
     :header-rows:  0
     :stub-columns: 0
@@ -223,6 +225,8 @@ EBUSY
 
 .. _v4l2-dv-timings:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+
 .. flat-table:: struct v4l2_dv_timings
     :header-rows:  0
     :stub-columns: 0
@@ -267,6 +271,8 @@ EBUSY
 
 .. _dv-timing-types:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: DV Timing types
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index b881098b8964..721d17fc829e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -92,6 +92,8 @@ EDID is no longer available.
 
 .. _v4l2-edid:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_edid
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index f0f41ac56b80..cb094b589f0e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -59,6 +59,8 @@ video elementary streams.
 
 .. _v4l2-enc-idx:
 
+.. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table:: struct v4l2_enc_idx
     :header-rows:  0
     :stub-columns: 0
@@ -105,6 +107,8 @@ video elementary streams.
 
 .. _v4l2-enc-idx-entry:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_enc_idx_entry
     :header-rows:  0
     :stub-columns: 0
@@ -162,6 +166,8 @@ video elementary streams.
 
 .. _enc-idx-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Index Entry Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index c91039b16d49..fee65debfee2 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -97,6 +97,8 @@ still cause this situation.
 
 .. _v4l2-ext-control:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+
 .. flat-table:: struct v4l2_ext_control
     :header-rows:  0
     :stub-columns: 0
@@ -228,6 +230,8 @@ still cause this situation.
 
 .. _v4l2-ext-controls:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+
 .. flat-table:: struct v4l2_ext_controls
     :header-rows:  0
     :stub-columns: 0
@@ -360,6 +364,8 @@ still cause this situation.
 
 .. _ctrl-class:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Control classes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index d182d9f5a50d..dc762325be5e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -78,6 +78,8 @@ destructive video overlay.
 
 .. _v4l2-framebuffer:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+
 .. flat-table:: struct v4l2_framebuffer
     :header-rows:  0
     :stub-columns: 0
@@ -283,6 +285,8 @@ destructive video overlay.
 
 .. _framebuffer-cap:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Frame Buffer Capability Flags
     :header-rows:  0
     :stub-columns: 0
@@ -371,6 +375,8 @@ destructive video overlay.
 
 .. _framebuffer-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Frame Buffer Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index a1fd2a870de4..bf0c1a13ddd7 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -54,6 +54,8 @@ write-only ioctl, it does not return the actual new frequency.
 
 .. _v4l2-frequency:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_frequency
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index f5bf8b7915ed..6f9ee18e005f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -57,6 +57,8 @@ encoding. You usually do want to add them.
 
 .. _v4l2-jpegcompression:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_jpegcompression
     :header-rows:  0
     :stub-columns: 0
@@ -129,6 +131,8 @@ encoding. You usually do want to add them.
 
 .. _jpeg-markers:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: JPEG Markers Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index fcb2e4896d4d..eaa62b6bd931 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -63,6 +63,8 @@ To change the radio frequency the
 
 .. _v4l2-modulator:
 
+.. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
+
 .. flat-table:: struct v4l2_modulator
     :header-rows:  0
     :stub-columns: 0
@@ -160,6 +162,8 @@ To change the radio frequency the
 
 .. _modulator-txsubchans:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Modulator Audio Transmission Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 7116e0decddc..7c32fe94544a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -52,6 +52,8 @@ union holding separate parameters for input and output devices.
 
 .. _v4l2-streamparm:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+
 .. flat-table:: struct v4l2_streamparm
     :header-rows:  0
     :stub-columns: 0
@@ -111,6 +113,8 @@ union holding separate parameters for input and output devices.
 
 .. _v4l2-captureparm:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_captureparm
     :header-rows:  0
     :stub-columns: 0
@@ -192,6 +196,8 @@ union holding separate parameters for input and output devices.
 
 .. _v4l2-outputparm:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_outputparm
     :header-rows:  0
     :stub-columns: 0
@@ -280,6 +286,8 @@ union holding separate parameters for input and output devices.
 
 .. _parm-caps:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Streaming Parameters Capabilites
     :header-rows:  0
     :stub-columns: 0
@@ -299,6 +307,8 @@ union holding separate parameters for input and output devices.
 
 .. _parm-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Capture Parameters Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-priority.rst b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
index 9f774ce400a4..3f021e6b9d0d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-priority.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
@@ -47,6 +47,8 @@ with a pointer to this variable.
 
 .. _v4l2-priority:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: enum v4l2_priority
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index 953931fabd00..8e72f93a358e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -137,6 +137,8 @@ Selection targets and flags are documented in
 
 .. _v4l2-selection:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_selection
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index f3db6f677650..0d4b6b0044a0 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -48,6 +48,8 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
 .. _v4l2-sliced-vbi-cap:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|
+
 .. flat-table:: struct v4l2_sliced_vbi_cap
     :header-rows:  0
     :stub-columns: 0
@@ -175,6 +177,8 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
 .. _vbi-services:
 
+.. tabularcolumns:: |p{4.4cm}|p{2.2cm}|p{2.2cm}|p{4.4cm}|p{4.3cm}|
+
 .. flat-table:: Sliced VBI services
     :header-rows:  1
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index d209736d6a53..762918a1e58a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -255,6 +255,8 @@ To change the radio frequency the
 
 .. _v4l2-tuner-type:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: enum v4l2_tuner_type
     :header-rows:  0
     :stub-columns: 0
@@ -297,6 +299,8 @@ To change the radio frequency the
 
 .. _tuner-capability:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Tuner and Modulator Capability Flags
     :header-rows:  0
     :stub-columns: 0
@@ -455,6 +459,8 @@ To change the radio frequency the
 
 .. _tuner-rxsubchans:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Tuner Audio Reception Flags
     :header-rows:  0
     :stub-columns: 0
@@ -522,6 +528,8 @@ To change the radio frequency the
 
 .. _tuner-audmode:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Tuner Audio Modes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 937ce9e32a79..b2dba5e0822b 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -96,6 +96,8 @@ See also the examples in :ref:`control`.
 
 .. _v4l2-queryctrl:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_queryctrl
     :header-rows:  0
     :stub-columns: 0
@@ -216,6 +218,8 @@ See also the examples in :ref:`control`.
 
 .. _v4l2-query-ext-ctrl:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_query_ext_ctrl
     :header-rows:  0
     :stub-columns: 0
@@ -378,6 +382,8 @@ See also the examples in :ref:`control`.
 
 .. _v4l2-querymenu:
 
+.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+
 .. flat-table:: struct v4l2_querymenu
     :header-rows:  0
     :stub-columns: 0
@@ -446,6 +452,8 @@ See also the examples in :ref:`control`.
 
 .. _v4l2-ctrl-type:
 
+.. tabularcolumns:: |p{5.3cm}|p{0.9cm}|p{0.9cm}|p{0.9cm}|p{9.5cm}|
+
 .. flat-table:: enum v4l2_ctrl_type
     :header-rows:  1
     :stub-columns: 0
@@ -643,6 +651,8 @@ See also the examples in :ref:`control`.
 
 .. _control-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Control Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index 5d0bc6d31c07..8be9343802dc 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -69,6 +69,8 @@ any DMA in progress, an implicit
 
 .. _v4l2-requestbuffers:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_requestbuffers
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index 5fd332a5bfee..3e4e1f12c56c 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -63,6 +63,8 @@ error code is returned and no seek takes place.
 
 .. _v4l2-hw-freq-seek:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_hw_freq_seek
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index 0aa6482a91a6..1c853f3f5676 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -64,6 +64,8 @@ multiple pads of the same sub-device is not defined.
 
 .. _v4l2-subdev-frame-interval-enum:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_subdev_frame_interval_enum
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
index 7a5811b71b68..e1bcc69f67db 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
@@ -66,6 +66,8 @@ information about try formats.
 
 .. _v4l2-subdev-frame-size-enum:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_subdev_frame_size_enum
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
index bc0531eb56fa..418d543ebbbf 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -51,6 +51,8 @@ information about the try formats.
 
 .. _v4l2-subdev-mbus-code-enum:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_subdev_mbus_code_enum
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index ae802f1594e7..7caa04e1c2a8 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -74,6 +74,8 @@ modified format should be as close as possible to the original request.
 
 .. _v4l2-subdev-crop:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_subdev_crop
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index 90e2a6635ebc..a16b3dd4bd3c 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -77,6 +77,8 @@ should be as close as possible to the original request.
 
 .. _v4l2-subdev-format:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_subdev_format
     :header-rows:  0
     :stub-columns: 0
@@ -122,6 +124,8 @@ should be as close as possible to the original request.
 
 .. _v4l2-subdev-format-whence:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: enum v4l2_subdev_format_whence
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index d8a1cabbd272..2df2d8635f2b 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -69,6 +69,8 @@ the same sub-device is not defined.
 
 .. _v4l2-subdev-frame-interval:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_subdev_frame_interval
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index 50838a4a429e..c59a32e0cc20 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -66,6 +66,8 @@ Selection targets and flags are documented in
 
 .. _v4l2-subdev-selection:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_subdev_selection
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index 86b16faa41bb..7ae35af66123 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -40,6 +40,8 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 
 .. _v4l2-event-subscription:
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. flat-table:: struct v4l2_event_subscription
     :header-rows:  0
     :stub-columns: 0
@@ -91,6 +93,8 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 
 .. _event-flags:
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. flat-table:: Event Flags
     :header-rows:  0
     :stub-columns: 0
-- 
2.7.4


