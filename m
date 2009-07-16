Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40074 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbZGPPcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 11:32:24 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n6GFWJ1b026040
	for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 10:32:24 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id n6GFWI9j014315
	for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 10:32:18 -0500 (CDT)
Received: from dlee75.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n6GFWIoJ006455
	for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 10:32:18 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 16 Jul 2009 10:32:17 -0500
Subject: two instances of tvp514x module required for DM6467. Any suggestion?
Message-ID: <A69FA2915331DC488A831521EAE36FE40144F1E560@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working to add support for DM6467 capture driver. This evm has two tvp5147 chips with different i2c addresses. So will I be able to call v4l2_i2c_new_subdev_board() twice to have two instances of this driver running? 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

