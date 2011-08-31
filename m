Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2079 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1HaNjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:39:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC PATCH 0/6] Capture menu reorganization
Date: Wed, 31 Aug 2011 15:38:39 +0200
Message-Id: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think this is how I would reorganize the capture menu. IMHO it's much easier
to navigate, and should be even better once the soc-camera sensor drivers can
be moved to the other sensors.

For the radio adapters a similar change would be needed (all the ISA drivers
in particular should be grouped in a submenu).

Regards,

	Hans

