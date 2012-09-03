Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3670 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab2ICNst (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:48:49 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id q83DmlnV039423
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 3 Sep 2012 15:48:48 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id A726535E0270
	for <linux-media@vger.kernel.org>; Mon,  3 Sep 2012 15:48:45 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 00/10] First series of API fixes from the 2012 Media Workshop
Date: Mon,  3 Sep 2012 15:48:34 +0200
Message-Id: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the first set of patches that fix a number of V4L2 API ambiguities and
related changes.

A note with regards to the bus_info changes: I've enumerated the bus_info format
for a number of busses. I still need to verify the USB prefix and add the prefix
used by the parallel port.

This patch series also includes Sakari's patch that removes the experimental tag
from several API elements.

Regards,

	Hans

