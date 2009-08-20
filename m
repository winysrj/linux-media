Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:37751 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808AbZHTRJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 13:09:39 -0400
From: Ronny Brendel <ronny.brendel@tu-dresden.de>
To: linux-media@vger.kernel.org
Subject: What is V4L2_CTRL_TYPE_BUTTON?
Date: Thu, 20 Aug 2009 19:09:37 +0200
Cc: Ronny Brendel <ronnybrendel@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908201909.38313.ronny.brendel@tu-dresden.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the spec it is """A control which performs an action when set. 
Drivers must ignore the value passed with VIDIOC_S_CTRL and return an EINVAL 
error code on a VIDIOC_G_CTRL attempt."""

I don't get what this means. It is no boolean. It has no effect, and you cannot 
set it? I am probably missing something. Please help.

(please answer to all (me in the cc) since I am not a member of this 
mailinglist

regards
Ronny
