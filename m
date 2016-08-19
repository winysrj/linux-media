Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754943AbcHSNFP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 14/15] [media] uapi/cec: adjust tables on LaTeX output
Date: Fri, 19 Aug 2016 10:05:04 -0300
Message-Id: <23d7ac5c876b636f521cce2ae98afe5f2e3aa7c9.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix tables to avoid text to overflow the cell limits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |  4 ++--
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |  6 ++++--
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   | 23 +++++++++-------------
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |  6 +++---
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |  6 +++---
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 4e70eae7e6ab..e0eaadaf2305 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -44,7 +44,7 @@ returns the information to the application. The ioctl never fails.
 
 .. _cec-caps:
 
-.. tabularcolumns:: |p{1.0cm}|p{1.0cm}|p{15.5cm}|
+.. tabularcolumns:: |p{1.2cm}|p{2.5cm}|p{13.8cm}|
 
 .. flat-table:: struct cec_caps
     :header-rows:  0
@@ -91,7 +91,7 @@ returns the information to the application. The ioctl never fails.
 
 .. _cec-capabilities:
 
-.. tabularcolumns:: |p{4.4cm}|p{1.5cm}|p{11.6cm}|
+.. tabularcolumns:: |p{4.4cm}|p{2.5cm}|p{10.6cm}|
 
 .. flat-table:: CEC Capabilities Flags
     :header-rows:  0
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 11fac7e24554..959e920eb7c3 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -69,7 +69,9 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. _cec-log-addrs:
 
-.. tabularcolumns:: |p{1.0cm}|p{1.0cm}|p{15.5cm}|
+.. tabularcolumns:: |p{1.0cm}|p{7.5cm}|p{8.0cm}|
+
+.. cssclass:: longtable
 
 .. flat-table:: struct cec_log_addrs
     :header-rows:  0
@@ -311,7 +313,7 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. _cec-log-addr-types:
 
-.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
 .. flat-table:: CEC Logical Address Types
     :header-rows:  0
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index b4c73ed50509..c27b56881a4a 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -54,7 +54,7 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-event-state-change_s:
 
-.. tabularcolumns:: |p{1.8cm}|p{1.8cm}|p{13.9cm}|
+.. tabularcolumns:: |p{1.2cm}|p{2.9cm}|p{13.4cm}|
 
 .. flat-table:: struct cec_event_state_change
     :header-rows:  0
@@ -82,7 +82,7 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-event-lost-msgs_s:
 
-.. tabularcolumns:: |p{1.0cm}|p{1.0cm}|p{15.5cm}|
+.. tabularcolumns:: |p{1.0cm}|p{2.0cm}|p{14.5cm}|
 
 .. flat-table:: struct cec_event_lost_msgs
     :header-rows:  0
@@ -110,7 +110,7 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-event:
 
-.. tabularcolumns:: |p{1.6cm}|p{1.6cm}|p{1.6cm}|p{12.7cm}|
+.. tabularcolumns:: |p{1.0cm}|p{4.2cm}|p{2.5cm}|p{8.8cm}|
 
 .. flat-table:: struct cec_event
     :header-rows:  0
@@ -124,21 +124,18 @@ it is guaranteed that the state did change in between the two events.
 
        -  ``ts``
 
-       -  Timestamp of the event in ns.
+       -  :cspan:`1` Timestamp of the event in ns.
+
 	  The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
 	  the same clock from userspace use :c:func:`clock_gettime(2)`.
 
-       -
-
     -  .. row 2
 
        -  __u32
 
        -  ``event``
 
-       -  The CEC event type, see :ref:`cec-events`.
-
-       -
+       -  :cspan:`1` The CEC event type, see :ref:`cec-events`.
 
     -  .. row 3
 
@@ -146,9 +143,7 @@ it is guaranteed that the state did change in between the two events.
 
        -  ``flags``
 
-       -  Event flags, see :ref:`cec-event-flags`.
-
-       -
+       -  :cspan:`1` Event flags, see :ref:`cec-event-flags`.
 
     -  .. row 4
 
@@ -183,7 +178,7 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-events:
 
-.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+.. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
 .. flat-table:: CEC Events Types
     :header-rows:  0
@@ -214,7 +209,7 @@ it is guaranteed that the state did change in between the two events.
 
 .. _cec-event-flags:
 
-.. tabularcolumns:: |p{4.4cm}|p{1.5cm}|p{11.6cm}|
+.. tabularcolumns:: |p{6.0cm}|p{0.6cm}|p{10.9cm}|
 
 .. flat-table:: CEC Event Flags
     :header-rows:  0
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index d213432eedd7..32261e0510ca 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -76,7 +76,7 @@ Available initiator modes are:
 
 .. _cec-mode-initiator_e:
 
-.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+.. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
 .. flat-table:: Initiator Modes
     :header-rows:  0
@@ -121,7 +121,7 @@ Available follower modes are:
 
 .. _cec-mode-follower_e:
 
-.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+.. tabularcolumns:: |p{6.6cm}|p{0.9cm}|p{10.0cm}|
 
 .. flat-table:: Follower Modes
     :header-rows:  0
@@ -215,7 +215,7 @@ Core message processing details:
 
 .. _cec-core-processing:
 
-.. tabularcolumns:: |p{1.9cm}|p{15.6cm}|
+.. tabularcolumns:: |p{6.6cm}|p{10.9cm}|
 
 .. flat-table:: Core Message Processing
     :header-rows:  0
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 1a06c8d62ac9..7615c94dc826 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -75,7 +75,7 @@ result.
 
 .. _cec-msg:
 
-.. tabularcolumns:: |p{1.0cm}|p{1.0cm}|p{15.5cm}|
+.. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{13.0cm}|
 
 .. flat-table:: struct cec_msg
     :header-rows:  0
@@ -254,7 +254,7 @@ result.
 
 .. _cec-tx-status:
 
-.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+.. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
 .. flat-table:: CEC Transmit Status
     :header-rows:  0
@@ -324,7 +324,7 @@ result.
 
 .. _cec-rx-status:
 
-.. tabularcolumns:: |p{2.6cm}|p{0.9cm}|p{14.0cm}|
+.. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
 .. flat-table:: CEC Receive Status
     :header-rows:  0
-- 
2.7.4


