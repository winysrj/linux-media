Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2776 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaHNMQy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 08:16:54 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7ECGplW027386
	for <linux-media@vger.kernel.org>; Thu, 14 Aug 2014 14:16:53 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.cisco.com (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id CBCC72A2E57
	for <linux-media@vger.kernel.org>; Thu, 14 Aug 2014 14:16:46 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 0/2] Add driver for tw68xx PCI grabber boards
Date: Thu, 14 Aug 2014 14:16:46 +0200
Message-Id: <1408018608-7858-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:

- Fix warning that Mauro found (and why didn't I get that warning?)
- Replaced dprintk by either dev_dbg or dev_err. But this means I need to
  retest the driver when I'm back from the LinuxCon to be sure I'm not
  getting any spurious DMA errors.

Add support for the tw68 driver. The driver has been out-of-tree for many
years on gitorious: https://gitorious.org/tw68/tw68-v2

I have refactored and ported that driver to the latest V4L2 core frameworks.

Tested with my Techwell tw6805a and tw6816 grabber boards.

Note that there is no audio support. If anyone is interested in adding alsa
support, please contact me. It's definitely doable.

These devices are quite common and people are using the out-of-tree driver,
so it would be nice to have proper support for this in the mainline kernel.

Regards,

	Hans

