Return-path: <linux-media-owner@vger.kernel.org>
Received: from isp-bos-01.edutel.nl ([88.159.1.182]:46420 "EHLO
	isp-bos-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab2BXRod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 12:44:33 -0500
From: linux@eikelenboom.it
To: linux-media@vger.kernel.org
Cc: shu.lin@conexant.com, hiep.huynh@conexant.com, stoth@linuxtv.org,
	hans.verkuil@cisco.com, mchehab@infradead.org
Subject: [PATCH] media/cx25821: Add a card definition for "No brand" cards
Date: Fri, 24 Feb 2012 18:23:09 +0100
Message-Id: <1330104190-1220-1-git-send-email-linux@eikelenboom.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

My "No Brand" cx25821 based card wasn't recognized by the cx25821 module, because the subvendor and subdevice both are 0x0000.
This patch adds a card definition for these "No Brand" cards.
With this patch the device is confirmed to be working with this module.

--
Sander

