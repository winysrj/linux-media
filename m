Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:33764 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0EGNky (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 09:40:54 -0400
Received: from MacBook-Pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0L21006PQXZXWYS0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Fri, 07 May 2010 09:40:48 -0400 (EDT)
Date: Fri, 07 May 2010 09:40:45 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Time to merge support for new HVR-2200?
In-reply-to: <4BE407F9.8040409@barber-family.id.au>
To: Francis Barber <fedora@barber-family.id.au>
Cc: linux-media@vger.kernel.org
Message-id: <4BE4185D.3010902@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4BE407F9.8040409@barber-family.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5/7/10 8:30 AM, Francis Barber wrote:
> Hello Steven,
>
> I was just what your plans are to submit the latest patches from
> http://www.kernellabs.com/hg/saa7164-stable to the main linuxtv
> repository?  It would be great to have these in the main kernel.

Hi Frank.

Yeah, I actually have a large number of patches for the HVR22xx and the CX2388x 
sitting up on kernellabs.com

I'm hoping to get these out for pull this weekend. Another dev is also working 
on the TDA10048 fixes so the plan is to pull these into saa7164-dev, test using 
a generator and (all being well) promote these into a unified tree.

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

