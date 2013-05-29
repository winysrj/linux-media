Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4473 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542Ab3E2LA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:27 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4TB0Fus071064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 29 May 2013 13:00:17 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 913AB35E019E
	for <linux-media@vger.kernel.org>; Wed, 29 May 2013 13:00:14 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv1 00/38] Remove VIDIOC_DBG_G_CHIP_IDENT
Date: Wed, 29 May 2013 12:59:33 +0200
Message-Id: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the introduction in 3.10 of the new superior VIDIOC_DBG_G_CHIP_INFO
ioctl there is no longer any need for the DBG_G_CHIP_IDENT ioctl or the
v4l2-chip-ident.h header. The V4L2 core is now responsible for handling
the G_CHIP_INFO ioctl. Only if a bridge driver has multiple address ranges
represented as different 'chips' does a bridge driver have to implement the
g_chip_info handler.

This patch series removes all code related to the old CHIP_IDENT ioctl and
the v4l2-chip-ident.h header.

See the documentation of the new VIDIOC_DBG_G_CHIP_INFO ioctl:

http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-dbg-g-chip-info.html

It also fixes a number of bugs relating to the VIDIOC_DBG_G/S_REGISTER
ioctls: adding/fixing register address checks where appropriate, and
set the size field correctly (not all drivers set that field).

This patch series simplifies drivers substantially and deletes almost
2900 lines in total.

Regards,

        Hans

