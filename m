Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:29894 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279Ab1CNHRx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 03:17:53 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LI10034JCVDHA10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Mar 2011 16:02:01 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LI1005FGCVDVL@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Mar 2011 16:02:01 +0900 (KST)
Date: Mon, 14 Mar 2011 16:02:01 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: the focus terms or sequences
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D7DBD69.2000507@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

I heard of that there was a chance between you and Sylwester telling about the menu entries focus,
and so after that, probably this menu style of the patch I sent, need to be more upgraded.
So, can you tell me the kind or sequence of the UVC device breifly?

I guess the word *AUTO* at the UVC device means doing focus continuously, not once or one time. 
But, at the sensors I used the *AUTO* focus means doing focus once, on the other hand *CONTINUOUS*
means doing continuously. So, we need to be clear terms about focus.

At the sensor I used, the focus needs 3 kinds of commands:
1) setting mode
  : it makes the lens initial position for each AF(Normal, Continuous, Night mode Focus, etc),
    and set the AF status Idle.
2) execute AF
  : doing the move of the lens
3) read AF status
  : checking the lens status(Focus failed, Focus success, Idle, Busy)
    and do the proper jobs.

I don't know uvc case well, so, If you share about this, it can be help.

Thanks,
Heungjun Kim
