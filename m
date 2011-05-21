Return-path: <mchehab@pedra>
Received: from mail.lastar.com ([64.129.117.10]:52238 "EHLO mail.lastar.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab1EUSqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 14:46:06 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lastar.com (Postfix) with ESMTP id 1EBB82A6006
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 14:46:06 -0400 (EDT)
Received: from mail.lastar.com ([127.0.0.1])
	by localhost (mail.lastar.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7kjbCXyjpc5T for <linux-media@vger.kernel.org>;
	Sat, 21 May 2011 14:46:06 -0400 (EDT)
Received: from V-EXMAILBOX.ctg.com (v-exmailbox.ctg.com [192.168.74.76])
	by mail.lastar.com (Postfix) with ESMTP id F08912A6004
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 14:46:05 -0400 (EDT)
From: Jason Gauthier <jgauthier@lastar.com>
To: Jason Gauthier <jgauthier@lastar.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: Enable IR on hdpvr
Date: Sat, 21 May 2011 18:46:03 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A2AB13455@V-EXMAILBOX.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
	 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
	 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>,<1294875902.2485.19.camel@morgan.silverblock.net>
 <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com>
 <65DE7931C559BF4DBEE42C3F8246249A2AB1230E@V-EXMAILBOX.ctg.com>
In-Reply-To: <65DE7931C559BF4DBEE42C3F8246249A2AB1230E@V-EXMAILBOX.ctg.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>Admittedly, I do not understand exactly what I am reading.  It seems to probe the IR Tx (i2c-1) successfully:
>May 21 12:51:06 jgauthier-mythtv kernel: [   43.088265] lirc_zilog: probe of IR Tx on Hauppage HD PVR I2C (i2c-1) done. IR unit ready.

>But, then below on (i2c-2) is failed:
>May 21 12:51:06 jgauthier-mythtv kernel: [   43.088282] lirc_zilog: ir_probe: probing IR Rx on Hauppage HD PVR I2C (i2c-2) failed with 1
>May 21 12:51:06 jgauthier-mythtv kernel: [   43.088288] Zilog/Hauppauge i2c IR: probe of 2-0071 failed with error 1

>Either way irsend doesn't work:

>irsend: command failed: SEND_ONCE blaster 0_74_KEY_2
>irsend: hardware does not support sending

>Are there other pieces I need to glue together?
>I attempted to move to lirc 0.9, and recompiled everything (including zilog) against it, (I read it somewhere) but that did not really make a >difference.

Okay, so I emailed a little too quickly.  The messages above got me thinking.  One of them is successful the other is not.
I verified with irsend.  So, this may be an issue with multiple hdpvrs.

Anything else I can test/verify?

