Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-gw1.li-life.net ([195.225.200.26]:51460 "EHLO
	SMTP-GW1.li-life.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab2L3Qpi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Dec 2012 11:45:38 -0500
Message-ID: <50E06E6C.80400@kaiser-linux.li>
Date: Sun, 30 Dec 2012 17:40:12 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Retrieving the Source Code & Building/Compiling the Modules
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I followed the instructions on:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

"Developer's Approach"

When I edit drivers/media/dvb/ddbridge/ddbridge-core.c and do "make -C 
../v4l", my changes are not compiled.

What I am doing wrong?

Thomas


