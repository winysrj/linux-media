Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33736 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbaLEOTa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 09:19:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH for v3.19 0/4] v4l2-mediabus.h & documentation updates
Date: Fri,  5 Dec 2014 15:19:20 +0100
Message-Id: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches change the type of the two new fields in struct v4l2_mbus_framefmt
from __u32 to __u16, as per Sakari's suggestion. We don't need 4 bytes per field
for this, and this way we save one __u32.

It also updates docbook with the new fields (I somehow missed that) and
documents the new vivid controls in vivid.txt.

Regards,

	Hans

