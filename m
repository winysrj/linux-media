Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2106 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2JBGsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 02:48:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 0/2] Two v4l2-ioctl.c fixes
Date: Tue,  2 Oct 2012 08:47:57 +0200
Message-Id: <1349160479-5314-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first ensures the memory allocation remains sane, the second fixes a
bunch of warnings.

Regards,

	Hans

