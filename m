Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49090 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZFLO4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 10:56:37 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5CEuYr8004581
	for <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 09:56:39 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id n5CEuY6P011121
	for <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 09:56:34 -0500 (CDT)
Received: from dsbe71.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n5CEuYMh021220
	for <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 09:56:34 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 12 Jun 2009 09:56:33 -0500
Subject: USERPTR buffer exchange mechanism
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A09594@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I would like to explore what level of support is available in the v4l buffer exchange mechanism for USERPTR buffer exchange.

In our internal release, we had a hack to support this feature. We use contiguous buffers in our user ptr hack implementation. The buffers are allocated in a kernel module that export api to pass the physical address of the allocated buffer to the user application. In the v4l2 driver, USERPTR IO mechanism will be requested, and in QBUF, the ptr passed to the driver is the above physical address. One thing we observed was that even in this case, we had to use index in the buffer structure without which it doesn't work.

Anyone has any insight into how to port this capability to the open source kernel v4l2 driver? In other words, can I use userptr IO mechanism and pass contigous buffer address like above? If so, Is there a driver example I can refer to port this to my vpfe capture driver?  

Thanks in advance.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

