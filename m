Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:42551 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0GTPSe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 11:18:34 -0400
Message-ID: <4C45BE3C.8000703@maxwell.research.nokia.com>
Date: Tue, 20 Jul 2010 18:18:20 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH 05/10] media: Reference count and power handling
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com> <cf2ca57033486758e0b039ce4c133a3e.squirrel@webmail.xs4all.nl> <4C443501.4030401@maxwell.research.nokia.com> <201007201647.14002.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007201647.14002.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,

Heippa,

...

> To summarize the discussion, what should I change here ? Just remove the "ret 
> = " in the second set_power call ?

Yes, and also return 0 instead of ret, which is always zero at that point.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
