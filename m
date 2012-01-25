Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:35375 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2AYMNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 07:13:14 -0500
Received: from [10.10.1.132] (h217-27-188-82.cust.tyfon.se [217.27.188.82])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPSA id 3747174512
	for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 13:06:30 +0100 (CET)
Message-ID: <4F1FF046.9050401@southpole.se>
Date: Wed, 25 Jan 2012 13:06:30 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge HVR-930C
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tried a daily snapshot (2011-01-24) with this stick. And I'm getting 
these kind of errors in the log:

[43665.769571] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[43665.769857] drxk: 02 00 00 00 10 00 07 00 03 02                    
..........
[43686.121576] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[43686.121861] drxk: 02 00 00 00 10 00 05 00 03 02                    
..........
[43706.465578] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[43706.465861] drxk: 02 00 00 00 10 00 05 00 03 02                    
..........
[43709.669571] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[43709.669850] drxk: 02 00 00 00 10 00 05 00 03 02                    
..........

First I tried the driver with the firmware that is downloaded with the 
get_firmware script. The adapter and frontends was registered properly 
but I did not get any TS from the stick. I then renamed the firmware 
file and the driver complained about missing firmware but stick started 
working anyway. So the drxk in my version of the card has a rom with 
microcode in it.

So things that would be nice to have is:

A log output that the drxk actually loaded the firmware file. Right now 
there is only log output when there is no firmware file detected.
Maybe add a log that the card might work without the drxk firmware.
Silence the SCU_RESULT_INVPAR debug output by default or find out what 
is causing the error messages.

MvH
Benjamin Larsson
