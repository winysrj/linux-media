Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:45269 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030916Ab2CSSSq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 14:18:46 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: media_build: how can I test older drivers?
Date: Mon, 19 Mar 2012 19:18:42 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203191918.42972.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To find the responsible patch for a regression, I need to test older drivers. 
(1, 3 or 6 months ago)  How can I do this with media_build? 

I don't really understand how the build script works. It seems that it doesn't 
use the current media_tree.git, but loads instead a driver snapshot 
(http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2) which is at 
the moment from March 9.

Can I simply change the name of the link for the bz2-package in 
linux/Makefile?
