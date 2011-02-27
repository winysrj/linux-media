Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:54307 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1B0TtV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 14:49:21 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by stevekerrison.com (Postfix) with ESMTP id DB460163CF
	for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 19:49:19 +0000 (GMT)
Received: from stevekerrison.com ([127.0.0.1])
	by localhost (stevekez.vm.bytemark.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TTCzVaEPTo0x for <linux-media@vger.kernel.org>;
	Sun, 27 Feb 2011 19:49:17 +0000 (GMT)
Received: from [192.168.1.17] (94-193-106-123.zone7.bethere.co.uk [94.193.106.123])
	(Authenticated sender: steve@stevekerrison.com)
	by stevekerrison.com (Postfix) with ESMTPSA id 70D8B163CD
	for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 19:49:17 +0000 (GMT)
Subject: CXD2820 & PCTV nanoStick T2 290e bringup
From: Steve Kerrison <steve@stevekerrison.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 19:49:16 +0000
Message-ID: <1298836156.2362.7.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello everyone,

I've done some work on bringup of this device in Linux, and now have a
stub for the CXD2820 demod that includes the capability to pass I2C
commands through to the tuner that sits behind it.

The focus was on bringup, not compatibility with linux-media or Linus'
coding guidelines, but hopefully it's not so horrendous that it makes
you want to cry. This isn't a formal patch submission, but anyone with
an interest is welcome to read more and grab the patch here:
http://stevekerrison.com/290e/index.html#20110227 taking heed of the
warnings and advice where necessary :)

Only I2C passthrough is supported - none of the other demodulator or
frontend functions work, and it doesn't detach properly.

I'd like to know what the best approach would be for me to allow others
to contribute to this if they so wish?

Many thanks,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 


