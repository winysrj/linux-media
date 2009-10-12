Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50506 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbZJLDzl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 23:55:41 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MxC00-0000Rn-TD
	for linux-media@vger.kernel.org; Mon, 12 Oct 2009 05:55:04 +0200
Received: from 210.187.111.86 ([210.187.111.86])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 05:55:04 +0200
Received: from mctiew by 210.187.111.86 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 05:55:04 +0200
To: linux-media@vger.kernel.org
From: mctiew <mctiew@yahoo.com>
Subject: Gadmei 380 on kernel 2.6.28.4
Date: Mon, 12 Oct 2009 03:32:53 +0000 (UTC)
Message-ID: <loom.20091012T052656-654@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I am trying to use the gadmei 380 which I bought yesterday.

I am using kernel 2.6.28.4, I downloaded the entire ~dougsland/em28xx
and did a make and install. Everything went on smoothly. However,
when I plug in the gadmei 380 usb device, it seems the driver can 
get loaded by the usb pnp, but at the same time, one of my usb 
pendrive will get disconnected. Because that's my boot drive 
( I boot off from the usb drive ), that will cause problem with 
my system.

Anyone has experienced this before ?

Regards.

