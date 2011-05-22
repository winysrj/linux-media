Return-path: <mchehab@pedra>
Received: from mail.nagios.lastar.com ([64.129.117.10]:44168 "EHLO
	mail.lastar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab1EVCCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 22:02:18 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lastar.com (Postfix) with ESMTP id 4E3EC2A6007
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 22:02:18 -0400 (EDT)
Received: from mail.lastar.com ([127.0.0.1])
	by localhost (mail.lastar.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ih17h6Qi_zRz for <linux-media@vger.kernel.org>;
	Sat, 21 May 2011 22:02:18 -0400 (EDT)
Received: from V-EXMAILBOX.ctg.com (v-exmailbox.ctg.com [192.168.74.76])
	by mail.lastar.com (Postfix) with ESMTP id 2A9582A6004
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 22:02:18 -0400 (EDT)
From: Jason Gauthier <jgauthier@lastar.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: [SOLVED] Enable IR on hdpvr
Date: Sun, 22 May 2011 02:02:14 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A2AB1470A@V-EXMAILBOX.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
	 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
	 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>,<1294875902.2485.19.camel@morgan.silverblock.net>
 <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com>
 <65DE7931C559BF4DBEE42C3F8246249A2AB1230E@V-EXMAILBOX.ctg.com>
 <65DE7931C559BF4DBEE42C3F8246249A2AB13455@V-EXMAILBOX.ctg.com>
In-Reply-To: <65DE7931C559BF4DBEE42C3F8246249A2AB13455@V-EXMAILBOX.ctg.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

All,


>Okay, so I emailed a little too quickly.  The messages above got me thinking.  One of them is successful the other is not.
>I verified with irsend.  So, this may be an issue with multiple hdpvrs.

I believe I've tracked this down.  

In lirc_zilog.c:

 At 1307:
                ret = add_ir_device(ir);
                if (ret)
                        goto out_free_ir;

Looking at add_ir_device:
  It returns:

	 return i == MAX_IRCTL_DEVICES ? -ENOMEM : i;

Meaning, that with a single device, it will generally return 0.  However, if there are multiple devices it will return a positive. This causes the return check to succeeed, and the goto out_free_ir, and basically doesn't continue.

So, simply changing the check to if (ret<0) seems to resolve this.  Then if -ENOMEM is returned it will fail, and otherwise succeed.

Sorry, this is not an official patch.  The maintainer (Jarod?) should be able to see what I am talking about and correct this.

Thanks!

Jasoin
