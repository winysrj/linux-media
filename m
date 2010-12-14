Return-path: <mchehab@gaivota>
Received: from mailout3.samsung.com ([203.254.224.33]:31314 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab0LNLeA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 06:34:00 -0500
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LDF003PB1GMQB90@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Dec 2010 20:33:58 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LDF00DBE1GMBJ@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Dec 2010 20:33:58 +0900 (KST)
Date: Tue, 14 Dec 2010 20:33:58 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Fwd: What if add enumerations at the V4L2_FOCUS_MODE_AUTO?
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D075626.7060708@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I miss linux-media email addres.
So, I added it.
Thanks.

---------------------------------------------
Hi Laurent and Hans,

I am working on V4L2 subdev for M5MOLS by Fujitsu.
and I wanna listen your comments about Auto Focus mode of my ideas.
the details is in the following link discussed at the past.
Although the situation(adding the more various functions at the M5MOLS
or any other MEGA camera sensor, I worked.)is changed,
so I wanna continue this threads for now. 

http://www.mail-archive.com/linux-media@vger.kernel.org/msg03543.html

First of all, the at least two more mode of auto-focus exists in the
M5MOLS camera sensor. So, considering defined V4L2 controls and the controls
in the M5MOLS, I suggest like this:

+enum  v4l2_focus_auto_type {
+	V4L2_FOCUS_AUTO_NORMAL = 0,
+	V4L2_FOCUS_AUTO_MACRO = 1,
+	V4L2_FOCUS_AUTO_POSITION = 2,
+};
+#define V4L2_CID_FOCUS_POSITION			(V4L2_CID_CAMERA_CLASS_BASE+13)
 
-#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
-#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
+#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+14)
+#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+15)


The M5MOLS(or other recent camera sensor) can have at least 2 mode although in any cases : *MACRO* and *NORMAL* mode. plus, M5MOLS supports positioning focus mode, AKA. POSITION AF mode.

The MACRO mode scan short range, and this mode can be used at the circumstance
in the short distance with object and camera lens. So, It has fast lens movement,
but the command FOCUSING dosen't works well at the long distance object.

On the other hand, NORMAL mode can this. As the words, It's general and normal focus
mode. The M5MOLS scan fully in the mode.

In the Position AF mode, the position(expressed x,y) is given at the M5MOLS, and then the M5MOLS focus this area. But, the time given the position, is normally touch the lcd screen at the mobile device, in my case. If the time is given from button, it's no big problem *when*. But, in touch-lcd screen case, the position is read at the touch screen driver,
before command FOCUS to camera sensor. It's the why I add another CID(V4L2_CID_FOCUS_POSITION).

So, how do you think about this?

Thanks to read my ideas, and I wait for your answer.

Regrads,
HeungJun Kim


PS. can you let me know where the recent v4l2 controls is described or specificated??

I found this - http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#camera-controls, but It seems a little old, I think.





