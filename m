Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38482 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbbCNLrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 07:47:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCHv3 00/22] marvell-ccic: drop and fix formats
Date: Sat, 14 Mar 2015 12:46:56 +0100
Message-Id: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This v3 patch series replaces patch 18 from the first series.

Patch 18 and 19 are unchanged from patches 18 and 21 from the
second series.

Patches 20-21 replace the RGB444 format by the newly defined XBGR444
format (X means that the 'alpha' channel should be ignored and is not
filled in). The actual layout in memory remains unchanged.

Patch 22 fixes the Bayer format.

All tested on my OLPC XO-1 laptop.

Regards,

	Hans

