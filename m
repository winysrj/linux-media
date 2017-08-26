Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53429
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751918AbdHZKHb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:07:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/6] media: dvb/intro.rst: Use verbatim font where needed
Date: Sat, 26 Aug 2017 07:07:09 -0300
Message-Id: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device numbering for DVB uses "M" and "N" as vars for the
number of the device, but sometimes this is printed using normal
font instead of verbatim.

While here, remove an extra space after quotation marks.

This is a minor cleanup with no changes at the text.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/intro.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index 652c4aacd2c6..20bd7aec2665 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -137,9 +137,9 @@ individual devices are called:
 
 -  ``/dev/dvb/adapterN/caM``,
 
-where N enumerates the DVB PCI cards in a system starting from 0, and M
+where ``N`` enumerates the DVB PCI cards in a system starting from 0, and ``M``
 enumerates the devices of each type within each adapter, starting
-from 0, too. We will omit the “ ``/dev/dvb/adapterN/``\ ” in the further
+from 0, too. We will omit the “``/dev/dvb/adapterN/``\ ” in the further
 discussion of these devices.
 
 More details about the data structures and function calls of all the
-- 
2.13.3
