Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:52228 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965718AbaDJKnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 06:43:53 -0400
Received: from 188.29.164.63.threembb.co.uk ([188.29.164.63] helo=[192.168.43.247])
	by smtp04.mailcore.me with esmtpa (Exim 4.80.1)
	(envelope-from <it@sca-uk.com>)
	id 1WYCSR-0002oO-Sm
	for linux-media@vger.kernel.org; Thu, 10 Apr 2014 11:43:49 +0100
Message-ID: <534675E1.6050408@sca-uk.com>
Date: Thu, 10 Apr 2014 11:43:45 +0100
From: Steve Cookson - IT <it@sca-uk.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge ImpactVCB-e 01385
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guys,

Sorry to go on about the Hauppauge ImpactVCB-e 01385, but it's a couple 
of years and version 12.04, since I last asked.

This page:

http://linuxtv.org/wiki/index.php/Hauppauge

Now shows:

Table of analog-only devices sold by Hauppauge Model Standard Interface 
Supported Comments
ImpactVCB-e Video PCIe ✔ Yes No tuners, only video-in. S-Video Capture 
works with kernel 3.5.0 (Ubuntu 12.10).

As my distribution is 13.10 with kernel 3.11, I believe it should work.

uname -a gives:

3.11.0-19-generic #33-Ubuntu SMP Tue Mar 11 18:48:34 UTC 2014 x86_64 
x86_64 x86_64 GNU/Linux

When I plug in my 01385 I get the same old stuff in dmseg, ie:

cx23885 driver version 0.0.3 loaded
[ 8.921390] cx23885[0]: Your board isn't known (yet) to the driver.
[ 8.921390] cx23885[0]: Try to pick one of the existing card configs via
[ 8.921390] cx23885[0]: card=<n> insmod option. Updating to the latest
[ 8.921390] cx23885[0]: version might help as well.
[ 8.921393] cx23885[0]: Here is a list of valid choices for the card=<n> 
insmod option:

Etc.

Does anyone have any idea of the issue here?

Best regards

Steve
