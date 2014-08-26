Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3343 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaHZGdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 02:33:17 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7Q6XEhs087669
	for <linux-media@vger.kernel.org>; Tue, 26 Aug 2014 08:33:16 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from telek.fritz.box (telek [192.168.1.29])
	by tschai.lan (Postfix) with ESMTPSA id BFC332A2E5A
	for <linux-media@vger.kernel.org>; Tue, 26 Aug 2014 08:33:01 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv3 0/2] Add driver for tw68xx PCI grabber boards
Date: Tue, 26 Aug 2014 08:33:11 +0200
Message-Id: <1409034793-9465-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v2:

- Drop William Brack's email address since that's no longer valid. I have
  not been able to contact him.
- A few dev_err calls in the interrupt handler were replaced by dev_dbg since
  those interrupts occur during normal operation, either when starting streaming
  or when switching inputs.

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

