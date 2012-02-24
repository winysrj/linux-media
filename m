Return-path: <linux-media-owner@vger.kernel.org>
Received: from isp-bos-02.edutel.nl ([88.159.1.183]:54338 "EHLO
	isp-bos-01.edutel.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695Ab2BXSzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 13:55:15 -0500
From: linux@eikelenboom.it
To: linux-media@vger.kernel.org
Cc: shu.lin@conexant.com, hiep.huynh@conexant.com, stoth@linuxtv.org,
	hans.verkuil@cisco.com, mchehab@infradead.org
Subject: [PATCH} corrected cx25821: Add a card definition for "No brand" cards
Date: Fri, 24 Feb 2012 19:49:41 +0100
Message-Id: <1330109382-16505-1-git-send-email-linux@eikelenboom.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for mistake with the previous patch that incorrectly removed the subvendor and subdevice fot the athena.
Here the revised patch:

cx25821: Add a card definition for "No brand" cards that have:
   subvendor = 0x0000
   subdevice = 0x0000
   
   

