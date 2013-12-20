Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1431 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3LTJbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:51 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBK9VkMx012516
	for <linux-media@vger.kernel.org>; Fri, 20 Dec 2013 10:31:49 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.cisco.com (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 78A162A2226
	for <linux-media@vger.kernel.org>; Fri, 20 Dec 2013 10:31:27 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 00/50] adv fixes and feature enhancements
Date: Fri, 20 Dec 2013 10:30:53 +0100
Message-Id: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is hopefully the final patch series for the ad9389b, adv7511, adv7604
and adv7842.

Changes since the last RFCs:

- ad9389b/adv7511: none
- adv7604: 09/50: add a drive strength enum
- adv7842: update arch/blackfin/mach-bf609/boards/ezkit.c whenever the
	adv7842_platform_data changes to prevent breakage.
- adv7842: 31/50: merged the old patches 05/22 and 07/22 into one: those
	two should be done at the same time. Also make sure the RGB
	quantization is	updated whenever the input changes.
- adv7842: 45/50: the free_run platform data was too obscure. Turn into
	separate bits that are ORed together.
- adv7842: 50/50: add drive strength enum and sync up naming convention with
	that used in adv7604.

If there are no more comments, then I'll likely post a pull request for this
right after Chrismas.

Once this is merged I plan to look at refactoring some of the adv common code
early next year. I think we now have enough experience to know which parts
can be made common and which should stay in the separate drivers.

Regards,

	Hans

