Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46986
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752123AbdIANZD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 05/27] media: dvb/intro: update the history part of the document
Date: Fri,  1 Sep 2017 10:24:27 -0300
Message-Id: <56079ca520ffd538486e06ebefa69a6589428deb.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convergence doesn't exist anymore. The community itself maintains
the spec. Update accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/intro.rst | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index 991643d3b461..4e1594816ef4 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -39,15 +39,19 @@ grabber cards. As such it was not really well suited to be used for DVB
 cards and their new features like recording MPEG streams and filtering
 several section and PES data streams at the same time.
 
-In early 2000, we were approached by Nokia with a proposal for a new
+In early 2000, Convergence was approached by Nokia with a proposal for a new
 standard Linux DVB API. As a commitment to the development of terminals
 based on open standards, Nokia and Convergence made it available to all
 Linux developers and published it on https://linuxtv.org in September
-2000. Convergence is the maintainer of the Linux DVB API. Together with
-the LinuxTV community (i.e. you, the reader of this document), the Linux
-DVB API will be constantly reviewed and improved. With the Linux driver
-for the Siemens/Hauppauge DVB PCI card Convergence provides a first
-implementation of the Linux DVB API.
+2000. With the Linux driver for the Siemens/Hauppauge DVB PCI card,
+Convergence provided a first implementation of the Linux DVB API.
+Convergence was the maintainer of the Linux DVB API in the early
+days.
+
+Now, the API is maintained by the LinuxTV community (i.e. you, the reader
+of this document). The Linux  Digital TV API is constantly reviewed and
+improved together with the improvements at the subsystem's core at the
+Kernel.
 
 
 .. _overview:
-- 
2.13.5
