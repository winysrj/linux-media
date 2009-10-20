Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:55912
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZJTO7P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 10:59:15 -0400
Received: from mail.wilsonet.com (localhost.localdomain [127.0.0.1])
	by mail.wilsonet.com (Postfix) with ESMTP id 85132944285
	for <linux-media@vger.kernel.org>; Tue, 20 Oct 2009 10:59:18 -0400 (EDT)
Received: from mail.wilsonet.com ([127.0.0.1])
 by mail.wilsonet.com (mail.wilsonet.com [127.0.0.1]) (amavisd-maia, port 10024)
 with ESMTP id 20544-02 for <linux-media@vger.kernel.org>;
 Tue, 20 Oct 2009 10:59:14 -0400 (EDT)
Received: from dhcp47-134.lab.bos.redhat.com (lan-nat-pool-bos.redhat.com [66.187.234.200])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jarod)
	by mail.wilsonet.com (Postfix) with ESMTPSA id E4CEA944283
	for <linux-media@vger.kernel.org>; Tue, 20 Oct 2009 10:59:13 -0400 (EDT)
Message-Id: <9627EF6A-9468-4868-9806-895BBDE736DB@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: cx18 i2c changes for 2.6.31.x?
Date: Tue, 20 Oct 2009 10:58:15 -0400
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey all,

Over on the lirc list, we've seen multiple reports now of lirc_i2c  
failing to work with the HVR-1300 and 1600.

http://www.nabble.com/lirc-i2c-does-no-longer-work-with-Hauppauge-HVR-1300--to25740534.html

At least for the 1600, it seems that at least these changesets might  
be candidates for adding to the 2.6.31.x stable queue:

http://linuxtv.org/hg/v4l-dvb/rev/21b349750a7a
http://linuxtv.org/hg/v4l-dvb/rev/471784201e1b
http://linuxtv.org/hg/v4l-dvb/rev/a9dd959a71a5

Without them, I'm pretty sure ir-kbd-i2c and definitely sure lirc_i2c  
can't bind.

Haven't looked into driver-specifics on the 1300 yet.

-- 
Jarod Wilson
jarod@wilsonet.com



