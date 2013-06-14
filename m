Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:39355 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3FNVB6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 17:01:58 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/2] radio-sf16fmi: Fix remaining v4l2-compliance problems
Date: Fri, 14 Jun 2013 23:01:37 +0200
Message-Id: <1371243699-28946-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


These patches fix two remaining v4l2-compliance problems of radio-sf16fmi driver after
control framework conversion:
http://www.mail-archive.com/linux-media%40vger.kernel.org/msg62772.html

Tested with SF16-FMI card.

-- 
Ondrej Zary
