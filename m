Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39978 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0LQQRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 11:17:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Reading/writing controls from different classes in a single VIDIOC_[GS]_EXT_CTRLS call
Date: Fri, 17 Dec 2010 17:17:05 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012171717.06765.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

I've recently run into an issue when porting a sensor driver to the control 
framework.

A userspace application using that driver using VIDIOC_G_EXT_CTRLS to retrieve 
the value of a bunch of controls in a single call. Those controls don't belong 
to the same class, and the application started failing.

What's the rationale behind forbidding that ?

-- 
Regards,

Laurent Pinchart
