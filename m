Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1112 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3LFKSd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:18:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dinesh.Ram@cern.ch, edubezval@gmail.com
Subject: [PATCHv2 00/11] si4713: add si4713 usb driver
Date: Fri,  6 Dec 2013 11:17:03 +0100
Message-Id: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second version of this patch series from Dinesh:

http://www.spinics.net/lists/linux-media/msg68927.html

It's identical to the first version except for two new patches: patch 10/11
prints the product number of the chip on the board and patch 11/11 fixes
checkpatch warnings/errors in si4713.c and radio-usb-si4713.c.

