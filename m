Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:25077 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1FJIrP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:47:15 -0400
Message-ID: <4DF1DA0D.7010000@maxwell.research.nokia.com>
Date: Fri, 10 Jun 2011 11:47:09 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: v4l2_ctrl_new_std_volatile()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

The v4l2_ctrl_new_std() doesn't allow setting the is_volatile bit in the
bit field. The adp1653 driver needs that for the faults control.

Would you prefer just setting the bit in the driver, or, as Laurent
suggested, a new v4l2_ctrl_new_std_volatile() function which would mark
the control as volatile by itself?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
