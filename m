Return-path: <mchehab@pedra>
Received: from fallback3.mail.ru ([94.100.176.58]:48755 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1A3T0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jan 2011 14:26:35 -0500
Received: from smtp7.mail.ru (smtp7.mail.ru [94.100.176.52])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id 355AF544C657
	for <linux-media@vger.kernel.org>; Sun, 30 Jan 2011 22:21:51 +0300 (MSK)
Date: Sun, 30 Jan 2011 22:31:06 +0300
From: Goga777 <goga777@bk.ru>
To: william <kc@cobradevil.org>
Cc: linux-media@vger.kernel.org
Subject: Re: tevii s660 still not working properly, hardware donation
Message-ID: <20110130223106.492dba42@bk.ru>
In-Reply-To: <4CEFBE03.2090103@cobradevil.org>
References: <4CEFBE03.2090103@cobradevil.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 try please this patch and patched firmware from vip100
http://linuxdvb.org.ru/wbb/index.php?page=Thread&postID=19310#post19310

> I know you are mantaining the drivers for the tevii s660 usb.
> After a few month testing/waiting i still cannot get it to work properly 
> using the repo: http://mercurial.intuxication.org/hg/s2-liplianin.
> 
> My system intel atom 945dgclf and my laptop are hanging when i try to 
> tune to a frequency.
> The system load goes up not because of cpu or disk io and after 
> disabling the dvb-usb-dw2102 driver and restarting vdr the system works 
> fine with the nova hd card.
> 
> Do you have any idea what it could be or would you otherwise receive my 
> device to test it? Remote access can also be arranged.
> 
> I'm out of ideas.
> Any thoughts?
