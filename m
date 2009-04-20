Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:42209 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbZDTPvz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 11:51:55 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KIE000O5PE1VHD0@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 20 Apr 2009 11:51:38 -0400 (EDT)
Date: Mon, 20 Apr 2009 11:51:36 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
In-reply-to: <loom.20090420T150829-849@post.gmane.org>
To: linux-media@vger.kernel.org
Message-id: <49EC9A08.50603@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
 <loom.20090420T150829-849@post.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ben Heggy wrote:
> I'm having the same issues (recognized - but won't turn on) with the same card
> and would be delighted to join the open discussion and to try to help to provide
> any information necessary to debug this issue. 
> 
> To this point, I have enabled debug options on what I think are the related
> modules and have seen nothing that appears to be an error, but am also noticing
> that there should be some messages about loading firmware for the various chips
> and they don't appear (I did put the firmware files in /lib/firmware but I
> cannot find references to their correct md5sums to verify they are correct)
> 
> I'm a newbie to linux, but was once (20 years ago) a system manager on a
> vax/unix system, so I can find my way around a bit better than average.
> 
> Tell me what info you want to see or what actions to try and I will gladly act
> immediately.

Connect the card.

Cold boot the system, boot linux, use the dmesg command.

Do you see any evidence of the cx23885 driver recognizing your card?

Use the lspci -vn command to display attached PCI(e) devices, is the card present?

- Steve
