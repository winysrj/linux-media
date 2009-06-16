Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58293 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZFPT6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 15:58:50 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5GJwmmw007015
	for <linux-media@vger.kernel.org>; Tue, 16 Jun 2009 14:58:53 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id n5GJwlQ7016693
	for <linux-media@vger.kernel.org>; Tue, 16 Jun 2009 14:58:47 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n5GJwlpD020190
	for <linux-media@vger.kernel.org>; Tue, 16 Jun 2009 14:58:47 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 16 Jun 2009 14:58:46 -0500
Subject: RE: USERPTR buffer exchange mechanism
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF996A@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40139A09594@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139A09594@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Any suggestion here?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
>Sent: Friday, June 12, 2009 10:57 AM
>To: linux-media@vger.kernel.org
>Subject: USERPTR buffer exchange mechanism
>
>Hi,
>
>I would like to explore what level of support is available in the v4l
>buffer exchange mechanism for USERPTR buffer exchange.
>
>In our internal release, we had a hack to support this feature. We use
>contiguous buffers in our user ptr hack implementation. The buffers are
>allocated in a kernel module that export api to pass the physical address
>of the allocated buffer to the user application. In the v4l2 driver,
>USERPTR IO mechanism will be requested, and in QBUF, the ptr passed to the
>driver is the above physical address. One thing we observed was that even
>in this case, we had to use index in the buffer structure without which it
>doesn't work.
>
>Anyone has any insight into how to port this capability to the open source
>kernel v4l2 driver? In other words, can I use userptr IO mechanism and pass
>contigous buffer address like above? If so, Is there a driver example I can
>refer to port this to my vpfe capture driver?
>
>Thanks in advance.
>
>Murali Karicheri
>Software Design Engineer
>Texas Instruments Inc.
>Germantown, MD 20874
>email: m-karicheri2@ti.com
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

