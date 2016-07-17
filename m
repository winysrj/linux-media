Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbcGQRHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 06/15] [media] doc-rst: Convert ci.txt to a rst file
Date: Sun, 17 Jul 2016 14:07:01 -0300
Message-Id: <c1eaa6c478a588ede95a2b458d75398fd5537347.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The old ci.txt file had a very peculiar format, with doesn't
match any markup language I know. Change it to be on ReST
format, for it to be parsed by Sphinx.

Also, as this is an old document, add a note about it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/ci.rst    | 186 ++++++++++++++++--------------
 Documentation/media/dvb-drivers/index.rst |   1 +
 2 files changed, 103 insertions(+), 84 deletions(-)

diff --git a/Documentation/media/dvb-drivers/ci.rst b/Documentation/media/dvb-drivers/ci.rst
index 6c3bda50f7dc..8124bf5ce5ef 100644
--- a/Documentation/media/dvb-drivers/ci.rst
+++ b/Documentation/media/dvb-drivers/ci.rst
@@ -1,52 +1,68 @@
-* For the user
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-NOTE: This document describes the usage of the high level CI API as
+Digital TV Conditional Access Interface (CI API)
+================================================
+
+
+.. note::
+
+   This documentation is outdated.
+
+This document describes the usage of the high level CI API as
 in accordance to the Linux DVB API. This is a not a documentation for the,
 existing low level CI API.
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-To utilize the High Level CI capabilities,
+.. note::
 
-(1*) This point is valid only for the Twinhan/clones
-  For the Twinhan/Twinhan clones, the dst_ca module handles the CI
-  hardware handling.This module is loaded automatically if a CI
-  (Common Interface, that holds the CAM (Conditional Access Module)
-  is detected.
+   For the Twinhan/Twinhan clones, the dst_ca module handles the CI
+   hardware handling.This module is loaded automatically if a CI
+   (Common Interface, that holds the CAM (Conditional Access Module)
+   is detected.
 
-(2) one requires a userspace application, ca_zap. This small userland
-  application is in charge of sending the descrambling related information
-  to the CAM.
+ca_zap
+~~~~~~
+
+An userspace application, like ``ca_zap`` is required to handle encrypted
+MPEG-TS streams.
+
+The ``ca_zap`` userland application is in charge of sending the
+descrambling related information to the Conditional Access Module (CAM).
 
 This application requires the following to function properly as of now.
 
-	(a) Tune to a valid channel, with szap.
-	  eg: $ szap -c channels.conf -r "TMC" -x
+a) Tune to a valid channel, with szap.
 
-	(b) a channels.conf containing a valid PMT PID
-	  eg: TMC:11996:h:0:27500:278:512:650:321
+  eg: $ szap -c channels.conf -r "TMC" -x
 
-	  here 278 is a valid PMT PID. the rest of the values are the
-	  same ones that szap uses.
+b) a channels.conf containing a valid PMT PID
 
-	(c) after running a szap, you have to run ca_zap, for the
-	  descrambler to function,
-	  eg: $ ca_zap channels.conf "TMC"
+  eg: TMC:11996:h:0:27500:278:512:650:321
 
-	(d) Hopefully enjoy your favourite subscribed channel as you do with
-	  a FTA card.
+  here 278 is a valid PMT PID. the rest of the values are the
+  same ones that szap uses.
 
-(3) Currently ca_zap, and dst_test, both are meant for demonstration
+c) after running a szap, you have to run ca_zap, for the
+   descrambler to function,
+
+  eg: $ ca_zap channels.conf "TMC"
+
+d) Hopefully enjoy your favourite subscribed channel as you do with
+   a FTA card.
+
+.. note::
+
+  Currently ca_zap, and dst_test, both are meant for demonstration
   purposes only, they can become full fledged applications if necessary.
 
 
-* Cards that fall in this category
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Cards that fall in this category
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 At present the cards that fall in this category are the Twinhan and its
 clones, these cards are available as VVMER, Tomato, Hercules, Orange and
 so on.
 
-* CI modules that are supported
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+CI modules that are supported
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 The CI module support is largely dependent upon the firmware on the cards
 Some cards do support almost all of the available CI modules. There is
 nothing much that can be done in order to make additional CI modules
@@ -58,11 +74,12 @@ Modules that have been tested by this driver at present are
 (2) Viaccess from SCM
 (3) Dragoncam
 
-* The High level CI API
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The High level CI API
+~~~~~~~~~~~~~~~~~~~~~
+
+For the programmer
+^^^^^^^^^^^^^^^^^^
 
-* For the programmer
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 With the High Level CI approach any new card with almost any random
 architecture can be implemented with this style, the definitions
 inside the switch statement can be easily adapted for any card, thereby
@@ -74,29 +91,30 @@ array to/from the CI ioctls as defined in the Linux DVB API. No changes
 have been made in the API to accommodate this feature.
 
 
-* Why the need for another CI interface ?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Why the need for another CI interface?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 This is one of the most commonly asked question. Well a nice question.
 Strictly speaking this is not a new interface.
 
-The CI interface is defined in the DVB API in ca.h as
+The CI interface is defined in the DVB API in ca.h as:
 
-typedef struct ca_slot_info {
-	int num;               /* slot number */
+.. code-block:: c
 
-	int type;              /* CA interface this slot supports */
-#define CA_CI            1     /* CI high level interface */
-#define CA_CI_LINK       2     /* CI link layer level interface */
-#define CA_CI_PHYS       4     /* CI physical layer level interface */
-#define CA_DESCR         8     /* built-in descrambler */
-#define CA_SC          128     /* simple smart card interface */
-
-	unsigned int flags;
-#define CA_CI_MODULE_PRESENT 1 /* module (or card) inserted */
-#define CA_CI_MODULE_READY   2
-} ca_slot_info_t;
+	typedef struct ca_slot_info {
+		int num;               /* slot number */
 
+		int type;              /* CA interface this slot supports */
+	#define CA_CI            1     /* CI high level interface */
+	#define CA_CI_LINK       2     /* CI link layer level interface */
+	#define CA_CI_PHYS       4     /* CI physical layer level interface */
+	#define CA_DESCR         8     /* built-in descrambler */
+	#define CA_SC          128     /* simple smart card interface */
 
+		unsigned int flags;
+	#define CA_CI_MODULE_PRESENT 1 /* module (or card) inserted */
+	#define CA_CI_MODULE_READY   2
+	} ca_slot_info_t;
 
 This CI interface follows the CI high level interface, which is not
 implemented by most applications. Hence this area is revisited.
@@ -113,7 +131,6 @@ means that no session management, link layer or a transport layer do
 exist in this case in the application to driver communication. It is
 as simple as that. The driver/hardware has to take care of that.
 
-
 With this High Level CI interface, the interface can be defined with the
 regular ioctls.
 
@@ -129,34 +146,36 @@ All these ioctls are also valid for the High level CI interface
 #define CA_SET_PID        _IOW('o', 135, ca_pid_t)
 
 
-On querying the device, the device yields information thus
+On querying the device, the device yields information thus:
 
-CA_GET_SLOT_INFO
-----------------------------
-Command = [info]
-APP: Number=[1]
-APP: Type=[1]
-APP: flags=[1]
-APP: CI High level interface
-APP: CA/CI Module Present
+.. code-block:: none
 
-CA_GET_CAP
-----------------------------
-Command = [caps]
-APP: Slots=[1]
-APP: Type=[1]
-APP: Descrambler keys=[16]
-APP: Type=[1]
+	CA_GET_SLOT_INFO
+	----------------------------
+	Command = [info]
+	APP: Number=[1]
+	APP: Type=[1]
+	APP: flags=[1]
+	APP: CI High level interface
+	APP: CA/CI Module Present
 
-CA_SEND_MSG
-----------------------------
-Descriptors(Program Level)=[ 09 06 06 04 05 50 ff f1]
-Found CA descriptor @ program level
+	CA_GET_CAP
+	----------------------------
+	Command = [caps]
+	APP: Slots=[1]
+	APP: Type=[1]
+	APP: Descrambler keys=[16]
+	APP: Type=[1]
 
-(20) ES type=[2] ES pid=[201]  ES length =[0 (0x0)]
-(25) ES type=[4] ES pid=[301]  ES length =[0 (0x0)]
-ca_message length is 25 (0x19) bytes
-EN50221 CA MSG=[ 9f 80 32 19 03 01 2d d1 f0 08 01 09 06 06 04 05 50 ff f1 02 e0 c9 00 00 04 e1 2d 00 00]
+	CA_SEND_MSG
+	----------------------------
+	Descriptors(Program Level)=[ 09 06 06 04 05 50 ff f1]
+	Found CA descriptor @ program level
+
+	(20) ES type=[2] ES pid=[201]  ES length =[0 (0x0)]
+	(25) ES type=[4] ES pid=[301]  ES length =[0 (0x0)]
+	ca_message length is 25 (0x19) bytes
+	EN50221 CA MSG=[ 9f 80 32 19 03 01 2d d1 f0 08 01 09 06 06 04 05 50 ff f1 02 e0 c9 00 00 04 e1 2d 00 00]
 
 
 Not all ioctl's are implemented in the driver from the API, the other
@@ -164,21 +183,20 @@ features of the hardware that cannot be implemented by the API are achieved
 using the CA_GET_MSG and CA_SEND_MSG ioctls. An EN50221 style wrapper is
 used to exchange the data to maintain compatibility with other hardware.
 
+.. code-block:: c
 
-/* a message to/from a CI-CAM */
-typedef struct ca_msg {
-	unsigned int index;
-	unsigned int type;
-	unsigned int length;
-	unsigned char msg[256];
-} ca_msg_t;
+	/* a message to/from a CI-CAM */
+	typedef struct ca_msg {
+		unsigned int index;
+		unsigned int type;
+		unsigned int length;
+		unsigned char msg[256];
+	} ca_msg_t;
 
 
 The flow of data can be described thus,
 
-
-
-
+.. code-block:: none
 
 	App (User)
 	-----
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index b5b39d637a17..c8e5a742e351 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -22,3 +22,4 @@ License".
 	avermedia
 	bt8xx
 	cards
+	ci
-- 
2.7.4

