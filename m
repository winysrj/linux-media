Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wow.synacor.com ([64.8.70.55]:35451 "EHLO
	smtp.mail.wowway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbZEGLVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2009 07:21:17 -0400
Received: from aqui.slotcar.prv ([172.16.1.3])
	by sordid.slotcar.chicago.il.us with esmtp (Exim 4.67)
	(envelope-from <johnr@wowway.com>)
	id 1M21f9-00006f-Vd
	for linux-media@vger.kernel.org; Thu, 07 May 2009 06:21:16 -0500
Message-ID: <4A02C426.2030703@wowway.com>
Date: Thu, 07 May 2009 06:21:10 -0500
From: "John R." <johnr@wowway.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: XC5000 improvements: call for testers!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


-------- Original Message --------
Subject: Re: XC5000 improvements: call for testers!
Date: Wed, 06 May 2009 19:09:23 -0500
From: John R. <johnr@wowway.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>

John R. wrote:
> Devin Heitmueller wrote:
> 
> [snip]
> 
>> Unfortunately, current users are going to have to upgrade to the new
>> firmware.  However, this is a one time cost and I will work with the
>> distros to get it bundled so that users won't have to do this in the
>> future:
>>
>> http://www.devinheitmueller.com/xc5000/dvb-fe-xc5000-1.6.114.fw
>> http://www.devinheitmueller.com/xc5000/README.xc5000
> 
> I downloaded the tip archive for xc5000-improvements-beta, compiled and 
> installed it.  I copied the firmware above into /lib/firmware (where the 
> old one was).  However, when the driver loads it still loads the old 
> firmware.  If this is a non-linux-media question then feel free to 
> direct me where to look.  My searching hasn't yet yielded anything yet.
> 
> Thanks,
> 
> John

After some off-list pointers by Devin, I tracked this down to user 
error.  I thought I was compiling tip for xc5000-improvements-beta but 
was not.  This is now working and composite input video works well on my 
950Q.  I notice no difference from previous version (wouldn't really 
expect to based on changes).

Thanks,

John
