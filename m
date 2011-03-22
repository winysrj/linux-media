Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:22826 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab1CVIt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 04:49:27 -0400
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIG00DOOB6CFF10@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2011 17:49:24 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIG00KMCB6DWE@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2011 17:49:25 +0900 (KST)
Date: Tue, 22 Mar 2011 17:49:24 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: [RFC PATCH v3 0/2] v4l2-ctrls: add auto focus mode and controls
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D886294.5060300@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

This is third version of RFC patch series about adding auto focus mode
and controls. The patch of the previous version bring about the issue
to be able to execute only once, not repeatedly. Because the each modes
are defined by menu type. To solve this, we add the new control of
choosing focus mode, and if doing repeatedly, it's alright that you
determine the focus mode and change the value of V4L2_CID_FOCUS_AUTO.

In the case of new added rectangle mode, these each controls belongs to
4 new controls, can make to point by the form of rectangle. These 4 new
each control values mean left x coordinate, top y coordinate,
width x length, height y length. It's similar to structure v4l2_rect.

You can find previous threads about this:
http://www.spinics.net/lists/linux-media/msg29446.html

Thanks and Regards,
Heungjun Kim
