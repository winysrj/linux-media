Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59261 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab2KFOaJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Nov 2012 09:30:09 -0500
Message-ID: <50991ED4.9030108@iki.fi>
Date: Tue, 06 Nov 2012 16:29:40 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: for_v3.8 build is broken
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That build is broken currently.

drivers/built-in.o: In function `sms_ir_event':
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:48: 
undefined reference to `ir_raw_event_store'
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:50: 
undefined reference to `ir_raw_event_handle'
drivers/built-in.o: In function `sms_ir_init':
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:56: 
undefined reference to `smscore_get_board_id'
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:60: 
undefined reference to `rc_allocate_device'
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:72: 
undefined reference to `sms_get_board'
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:92: 
undefined reference to `sms_get_board'
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:97: 
undefined reference to `rc_register_device'
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:100: 
undefined reference to `rc_free_device'
drivers/built-in.o: In function `sms_ir_exit':
/home/crope/linuxtv/code/linux/drivers/media/common/siano/smsir.c:111: 
undefined reference to `rc_unregister_device'
make: *** [vmlinux] Error 1


Antti

-- 
http://palosaari.fi/
