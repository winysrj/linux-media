Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:47583 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1CVIsN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 04:48:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIG009AEB499I10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2011 17:48:09 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIG001BXB49FF@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2011 17:48:09 +0900 (KST)
Date: Tue, 22 Mar 2011 17:48:09 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH v3 0/2] v4l2-ctrls: add auto focus mode and controls
In-reply-to: <4D885F32.60309@samsung.com>
To: riverful.kim@samsung.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D886249.5020905@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D885F32.60309@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The comments of 2/2 patch are wrong. It's my fault.
Please ignore this. And I'll send again.
Sorry to confuse.

2011-03-22 오후 5:34, Kim, HeungJun 쓴 글:
> Hello,
> 
> This is third version of RFC patch series about adding auto focus mode
> and controls. The patch of the previous version bring about the issue
> to be able to execute only once, not repeatedly. Because the each modes
> are defined by menu type. To solve this, we add the new control of
> choosing focus mode, and if doing repeatedly, it's alright that you
> determine the focus mode and change the value of V4L2_CID_FOCUS_AUTO.
> 
> In the case of new added rectangle mode, these each controls belongs to
> 4 new controls, can make to point by the form of rectangle. These 4 new
> each control values mean left x coordinate, top y coordinate,
> width x length, height y length. It's similar to structure v4l2_rect.
> 
> You can find previous threads about this:
> http://www.spinics.net/lists/linux-media/msg29446.html
> 
> Thanks and Regards,
> Heungjun Kim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

