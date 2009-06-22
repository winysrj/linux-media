Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:57933 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZFVO3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 10:29:42 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KLN00KF19LEPB60@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 22 Jun 2009 10:29:39 -0400 (EDT)
Date: Mon, 22 Jun 2009 10:29:39 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hauppauge HVR-1250 IR Support? (CX23885)
In-reply-to: <24713386.1245628635222.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
To: whelky-82852@mypacks.net
Cc: linux-media@vger.kernel.org
Message-id: <4A3F9553.6050200@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <24713386.1245628635222.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

whelky-82852@mypacks.net wrote:
> I was wondering if anyone is working on IR support for this card? I looked through cx23885-cards.c and its not supported.
> 
> 627         switch (dev->board) {
> 628         case CX23885_BOARD_HAUPPAUGE_HVR1250:
> 629         case CX23885_BOARD_HAUPPAUGE_HVR1500:
> 630         case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
> 631         case CX23885_BOARD_HAUPPAUGE_HVR1800:
> 632         case CX23885_BOARD_HAUPPAUGE_HVR1200:
> 633         case CX23885_BOARD_HAUPPAUGE_HVR1400:
> 634                 /* FIXME: Implement me */
> 635                 break;

Not currently.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
