Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:46324 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab0CKQlu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 11:41:50 -0500
Received: from MacBook-Pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KZ400I42MDKSIP0@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 11 Mar 2010 11:41:44 -0500 (EST)
Date: Thu, 11 Mar 2010 11:41:44 -0500
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: DNTV Dual Hybrid (7164) PCIe
In-reply-to: <4B9919AA.9030505@gmail.com>
To: Jed <jedi.theone@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <4B991D48.7000003@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B9919AA.9030505@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/11/10 11:26 AM, Jed wrote:
> Hi Kernellabs,
>
> I'm thinking of getting this:
> http://forums.dvbowners.com/index.php?showtopic=11720
> It seems very similar to the HVR-2200 yet has component-in.
> Do you reckon your module/s might support it?
>
> Thank-you!

Highly likely the drivers will not support it. Each card has unique firmware 
identifiers that need to be added manually to the driver.

If you'd like to provide me a card then I'd consider adding support.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490

