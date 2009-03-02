Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:33746 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbZCBIJ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 03:09:56 -0500
MIME-Version: 1.0
In-Reply-To: <A24693684029E5489D1D202277BE894416429F9F@dlee02.ent.ti.com>
References: <Acl1IyATAKAzUiSPQiOOAI2yzi0iWQ==>
	 <A24693684029E5489D1D202277BE894416429F9F@dlee02.ent.ti.com>
Date: Mon, 2 Mar 2009 17:09:54 +0900
Message-ID: <5e9665e10903020009y7fe7d0d0j356708e1c3149cac@mail.gmail.com>
Subject: Re: [REVIEW PATCH 09/14] OMAP: CAM: Add ISP Core
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

reviewing ISP driver, I found that we've got no querymenu support in
ISP and also omap3 camera interface driver.

+/**
+ * struct vcontrol - Video control structure.
+ * @qc: V4L2 Query control structure.
+ * @current_value: Current value of the control.
+ */
+static struct vcontrol {
+       struct v4l2_queryctrl qc;
+       int current_value;
+} video_control[] = {

<snip>

+       {
+               {
+                       .id = V4L2_CID_PRIVATE_ISP_COLOR_FX,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Color Effects",
+                       .minimum = PREV_DEFAULT_COLOR,
+                       .maximum = PREV_BW_COLOR,
+                       .step = 1,
+                       .default_value = PREV_DEFAULT_COLOR,
+               },
+               .current_value = PREV_DEFAULT_COLOR,
+       }
+};

I think we should make it menu type for this color FX control.
If that kind of control has no menu information, user has no way to
figure out what kind of FX supported by device.
BTW if we make querymenu support in omap3 camera subsystem, we should
make querymenu support for v4l2 int device also.
I think I've seen before a patch which intent to use querymenu in v4l2
int device, but no patch for omap3 ISP and camera interface.
Can I make a patch and post on linux-omap, linux-media list? of course
if you don't mind.
Or...am I digging wrong way? I mean.. querymenu for omap3 camera subsystem.
Please let me know :)

Cheers,

Nate

-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab.
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
