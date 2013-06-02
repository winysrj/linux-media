Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2518 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3FBK4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:21 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id r52Au95R048531
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 2 Jun 2013 12:56:12 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 05C4135E004E
	for <linux-media@vger.kernel.org>; Sun,  2 Jun 2013 12:56:08 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 00/16] saa7134: cleanup
Date: Sun,  2 Jun 2013 12:55:51 +0200
Message-Id: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series cleans up saa7134, updating it to the latest frameworks
(except for vb2). Tested with a Beholder BeholdTV M6 empress card.

There is also one small v4l2-ctrls fix in the patch series and the
saa6752hs is moved to media/i2c, since it really has nothing to do with
the saa7134 driver.

This patch series sits on top of the "Control framework conversions"
patch series since it requires the saa6752hs patch from that series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg62772.html

Still to do: test the saa7134+saa6588 combo.

Regards,

	Hans

