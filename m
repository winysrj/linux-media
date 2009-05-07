Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wow.synacor.com ([64.8.70.55]:56552 "EHLO
	smtp.mail.wowway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZEGAJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 20:09:28 -0400
Received: from aqui.slotcar.prv ([172.16.1.3])
	by sordid.slotcar.chicago.il.us with esmtp (Exim 4.67)
	(envelope-from <johnr@wowway.com>)
	id 1M1rB2-0006Tv-5P
	for linux-media@vger.kernel.org; Wed, 06 May 2009 19:09:28 -0500
Message-ID: <4A0226B3.3010804@wowway.com>
Date: Wed, 06 May 2009 19:09:23 -0500
From: "John R." <johnr@wowway.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: XC5000 improvements: call for testers!
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
In-Reply-To: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:

[snip]

> Unfortunately, current users are going to have to upgrade to the new
> firmware.  However, this is a one time cost and I will work with the
> distros to get it bundled so that users won't have to do this in the
> future:
> 
> http://www.devinheitmueller.com/xc5000/dvb-fe-xc5000-1.6.114.fw
> http://www.devinheitmueller.com/xc5000/README.xc5000

I downloaded the tip archive for xc5000-improvements-beta, compiled and 
installed it.  I copied the firmware above into /lib/firmware (where the 
old one was).  However, when the driver loads it still loads the old 
firmware.  If this is a non-linux-media question then feel free to 
direct me where to look.  My searching hasn't yet yielded anything yet.

Thanks,

John
