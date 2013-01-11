Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4979 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3AKN5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:57:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: DocBook: fixes
Date: Fri, 11 Jan 2013 14:56:59 +0100
Message-Id: <1357912622-24736-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Three patches: the first fixes a number of validation errors in the DocBook
code (unchanged from v1), the second clarifies how the error_idx is used
(incorporated the few remaining comments from v2) and the third patch is
new: it clarifies that EINVAL can also be returned when the value of a
control is incorrect, in particularly for menu controls where the given
menu item is not supported by the driver.

Regards,

        Hans

