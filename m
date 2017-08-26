Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53437
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752129AbdHZKHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:07:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 5/6] media: dvbproperty.rst: improve notes about legacy frontend calls
Date: Sat, 26 Aug 2017 07:07:13 -0300
Message-Id: <b91d0e4c931674cf173dfcdad342a1756d7e6a46.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description of the DVBv5 API was written a long time ago,
where the API was still new, and there were not apps using it.

Now that the API is stable and used by new applications, clarify
that DVBv3 calls should not be used and why.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dvbproperty.rst | 39 ++++++++++++++++++----------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index dd2d71ce43fa..1e8fc75e469d 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -12,23 +12,34 @@ antenna subsystem via Satellite Equipment Control (SEC), on satellite
 systems. The actual parameters are specific to each particular digital
 TV standards, and may change as the digital TV specs evolves.
 
-In the past, the strategy used was to have a union with the parameters
-needed to tune for DVB-S, DVB-C, DVB-T and ATSC delivery systems grouped
-there. The problem is that, as the second generation standards appeared,
-those structs were not big enough to contain the additional parameters.
-Also, the union didn't have any space left to be expanded without
-breaking userspace. So, the decision was to deprecate the legacy
-union/struct based approach, in favor of a properties set approach.
+In the past (up to DVB API version 3), the strategy used was to have a
+union with the parameters needed to tune for DVB-S, DVB-C, DVB-T and
+ATSC delivery systems grouped there. The problem is that, as the second
+generation standards appeared, the size of such union was not big
+enough to group the structs that would be required for those new
+standards. Also, extending it would break userspace.
+
+So, the legacy union/struct based approach was deprecated, in favor
+of a properties set approach.
+
+This section describes the new and recommended way to set the frontend,
+with suppports all digital TV delivery systems.
 
 .. note::
 
-   On Linux DVB API version 3, setting a frontend were done via
-   struct :c:type:`dvb_frontend_parameters`.
-   This got replaced on version 5 (also called "S2API", as this API were
-   added originally_enabled to provide support for DVB-S2), because the
-   old API has a very limited support to new standards and new hardware.
-   This section describes the new and recommended way to set the frontend,
-   with suppports all digital TV delivery systems.
+   1. On Linux DVB API version 3, setting a frontend was done via
+      struct :c:type:`dvb_frontend_parameters`.
+
+   2. Don't use DVB API version 3 calls on hardware with supports
+      newer standards. Such API provides no suport or a very limited
+      support to new standards and/or new hardware.
+
+   3. Nowadays, most frontends support multiple delivery systems.
+      Only with DVB v5 calls it is possible to switch between
+      the multiple delivery systems supported by a frontend.
+
+   4. DVB API version 5 is also called *S2API*, as the first
+      new standard added to it was DVB-S2.
 
 Example: with the properties based approach, in order to set the tuner
 to a DVB-C channel at 651 kHz, modulated with 256-QAM, FEC 3/4 and
-- 
2.13.3
