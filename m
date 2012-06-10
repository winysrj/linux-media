Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:30592 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2FJTeX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 15:34:23 -0400
Message-ID: <4FD4F6B6.1070605@iki.fi>
Date: Sun, 10 Jun 2012 22:34:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 0/4] Selection target rename
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patchset contains two patches already sent to the list ages ago,
and two new patches to unify the selections documentation as well.

The selection target documentation is moved to a new section whereas the
true meaning of the targets is documented as part of the interface they
are relevant to. I think this is how it must be since there are
differences between the two interfaces.

I'd consider this safe even for 3.5 as this is only about definitions
and documentation: there are no functional changes.

Comments, questions and acks are all very welcome. ;-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi

