Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:27806 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1BYGVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 01:21:22 -0500
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH500DLDTNL4870@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 15:21:21 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH500MKVTNKA4@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 15:21:20 +0900 (KST)
Date: Fri, 25 Feb 2011 15:21:21 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: [RFC PATCH v2 0/3] v4l2-ctrls: add new focus mode
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D674A61.9030905@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

Agenda
======================================================================
I faced to the absence of the mode of v4l2 focus for a couple of years.
While dealing with some few morebile camera sensors, the focus modes
are needed more than the current v4l2 focus mode, like a Macro &
Continuous mode. The M-5MOLS camera sensor I dealt with, also support
these 2 modes. So, I'm going to suggest supports of more detailed
v4l2 focus mode.

Version
======================================================================
This is second version patch about auto focus mode.
The second version changes are below:
1. switch enumeration value between V4L2_FOCUS_AUTO and V4L2_FOCUS_MACRO,
   for maintaing previous auto focus mode value.
2. add documentations about the changes of auto focus mode.


This RFC series of patch adds new auto focus modes, and documents it.

The first patch the boolean type of V4L2_CID_FOCUS_AUTO to menu type,
and insert menus 4 enumerations: 

V4L2_FOCUS_MANUAL,
V4L2_FOCUS_AUTO, 
V4L2_FOCUS_MACRO,
V4L2_FOCUS_CONTINUOUS

The recent mobile camera sensors with ISP supports Macro & Continuous Auto
Focus aka CAF mode, of course normal AUTO mode, even Continuous mode.
Changing the type of V4L2_CID_FOCUS_MODE, is able to define more exact
focusing mode of camera sensor.

The second patch let the previous drivers using V4L2_CID_FOCUS_AUTO by
boolean type be able to use the type of menu.

The third patch documentation about changes of the auto focus mode.

Thanks for reading this, and I hope any ideas and any comments.

Regards,
Heungjun Kim

