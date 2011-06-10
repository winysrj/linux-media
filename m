Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1464 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1FJIzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:55:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: v4l2_ctrl_new_std_volatile()?
Date: Fri, 10 Jun 2011 10:55:35 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <4DF1DA0D.7010000@maxwell.research.nokia.com>
In-Reply-To: <4DF1DA0D.7010000@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106101055.35163.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, June 10, 2011 10:47:09 Sakari Ailus wrote:
> Hi Hans,
> 
> The v4l2_ctrl_new_std() doesn't allow setting the is_volatile bit in the
> bit field. The adp1653 driver needs that for the faults control.
> 
> Would you prefer just setting the bit in the driver, or, as Laurent
> suggested, a new v4l2_ctrl_new_std_volatile() function which would mark
> the control as volatile by itself?

Just set the bit in the driver.

If this will start happening a lot, then we can consider adding a special
function for this, but volatile controls are still pretty rare and I do
not think it warrants a special function just for that.

Regards,

         Hans
