Return-path: <mchehab@pedra>
Received: from mail2.cablestogo.co.uk ([64.129.117.9]:58062 "EHLO
	mail.lastar.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752676Ab1EVCN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 22:13:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lastar.com (Postfix) with ESMTP id 553752A6005
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 22:13:56 -0400 (EDT)
Received: from mail.lastar.com ([127.0.0.1])
	by localhost (mail.lastar.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2ZzLIZKlkWQS for <linux-media@vger.kernel.org>;
	Sat, 21 May 2011 22:13:56 -0400 (EDT)
Received: from V-EXMAILBOX.ctg.com (v-exmailbox.ctg.com [192.168.74.76])
	by mail.lastar.com (Postfix) with ESMTP id 14CD82A6004
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 22:13:56 -0400 (EDT)
From: Jason Gauthier <jgauthier@lastar.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: [SOLVED (not really)] Enable IR on hdpvr
Date: Sun, 22 May 2011 02:13:55 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A2AB14746@V-EXMAILBOX.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
	 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
	 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>,<1294875902.2485.19.camel@morgan.silverblock.net>
 <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com>
 <65DE7931C559BF4DBEE42C3F8246249A2AB1230E@V-EXMAILBOX.ctg.com>
 <65DE7931C559BF4DBEE42C3F8246249A2AB13455@V-EXMAILBOX.ctg.com>
 <65DE7931C559BF4DBEE42C3F8246249A2AB1470A@V-EXMAILBOX.ctg.com>
In-Reply-To: <65DE7931C559BF4DBEE42C3F8246249A2AB1470A@V-EXMAILBOX.ctg.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>So, simply changing the check to if (ret<0) seems to resolve this.  Then if -ENOMEM is returned it will fail, and otherwise succeed.

>Sorry, this is not an official patch.  The maintainer (Jarod?) should be able to see what I am talking about and correct this.

>Thanks!

Last email on this topic for awhile.

The module loads, but there is definitely an issue beyond me at this point.
The second zilog device detected not sending, even though it looks good:

[ 3247.366917] lirc_zilog: Zilog/Hauppauge IR driver initializing
[ 3247.369339] lirc_zilog: probing IR Rx on Hauppage HD PVR I2C (i2c-1)
[ 3247.369346] lirc_zilog: probe of IR Rx on Hauppage HD PVR I2C (i2c-1) done. Waiting on IR Tx.
[ 3247.369352] lirc_zilog: probing IR Tx on Hauppage HD PVR I2C (i2c-1)
[ 3247.369477] i2c i2c-1: lirc_dev: driver lirc_zilog registered at minor = 1
[ 3247.622652] lirc_zilog: Zilog/Hauppauge IR blaster firmware version 2.1.0 loaded
[ 3247.622657] lirc_zilog: probe of IR Tx on Hauppage HD PVR I2C (i2c-1) done. IR unit ready.
[ 3247.622671] lirc_zilog: probing IR Rx on Hauppage HD PVR I2C (i2c-2)
[ 3247.622675] lirc_zilog: probe of IR Rx on Hauppage HD PVR I2C (i2c-2) done. Waiting on IR Tx.
[ 3247.622680] lirc_zilog: probing IR Tx on Hauppage HD PVR I2C (i2c-2)
[ 3247.622835] i2c i2c-2: lirc_dev: driver lirc_zilog registered at minor = 2
[ 3247.869401] lirc_zilog: Zilog/Hauppauge IR blaster firmware version 2.1.0 loaded
[ 3247.869406] lirc_zilog: probe of IR Tx on Hauppage HD PVR I2C (i2c-2) done. IR unit ready.
[ 3247.869446] lirc_zilog: initialization complete


However:
root@jgauthier-mythtv:# irsend -d/var/run/lirc/hdpvr0 SEND_ONCE blaster 0_74_KEY_2
root@jgauthier-mythtv:# irsend -d/var/run/lirc/hdpvr1 SEND_ONCE blaster 0_74_KEY_2
irsend: command failed: SEND_ONCE blaster 0_74_KEY_2
irsend: hardware does not support sending


First one worked. Second does not.  

Thanks,

Jason
