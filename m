Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:38315 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZDUBvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 21:51:32 -0400
Received: from mbp.kernelscience.com
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KIF002LOH5RZW41@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 20 Apr 2009 21:51:28 -0400 (EDT)
Date: Mon, 20 Apr 2009 21:51:27 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
In-reply-to: <1240265172.5388.184.camel@mountainboyzlinux0>
To: pghben@yahoo.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Message-id: <49ED269F.9030603@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
 <loom.20090420T150829-849@post.gmane.org> <49EC9A08.50603@linuxtv.org>
 <1240245715.5388.126.camel@mountainboyzlinux0> <49ECA8DD.9090708@linuxtv.org>
 <1240249684.5388.146.camel@mountainboyzlinux0> <49ECBCF0.3060806@linuxtv.org>
 <1240255677.5388.153.camel@mountainboyzlinux0> <49ECD553.9090707@linuxtv.org>
 <1240259904.5388.178.camel@mountainboyzlinux0> <49ECEEA3.6010203@linuxtv.org>
 <1240265172.5388.184.camel@mountainboyzlinux0>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> 
> If there is anything I can do that will help you find the bug, please 
> let me know..

The issue is fixed.

http://linuxtv.org/hg/~stoth/cx23885-hvr1500/rev/7853c00870e1

It's locking OK for me now. If you can clone, built and test - thus confirm the 
fix - that would be great.

Build instructions on the wiki:

http://linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-DVB_Device_Drivers

Thanks,

- Steve


