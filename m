Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51587 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbaLBPk4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 10:40:56 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 1F9EE2A0092
	for <linux-media@vger.kernel.org>; Tue,  2 Dec 2014 16:40:36 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] Deprecate drivers
Date: Tue,  2 Dec 2014 16:40:30 +0100
Message-Id: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series deprecates the vino/saa7191 video driver (ancient SGI Indy
computer), the parallel port webcams bw-qcam, c-qcam and w9966, the ISA
video capture driver pms and the USB video capture tlg2300 driver.

Hardware for these devices is next to impossible to obtain, these drivers
haven't seen any development in ages, they often use deprecated APIs and
without hardware that's very difficult to port. And cheap alternative
products are easily available today.

So move these drivers to staging for 3.19 and plan on removing them in 3.20.

Regards,

	Hans

