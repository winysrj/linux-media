Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:45801 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0FWMnS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jun 2010 08:43:18 -0400
Received: from TheShoveller.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0L4G00B3VWO5MXY0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 23 Jun 2010 08:43:17 -0400 (EDT)
Date: Wed, 23 Jun 2010 08:43:17 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: buffer management
In-reply-to: <AANLkTikuPBKre8wjkGZ-fXhQc5ad_OmNtERvFslpPXvR@mail.gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <4C220165.50809@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <AANLkTikuPBKre8wjkGZ-fXhQc5ad_OmNtERvFslpPXvR@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Now, on each video interrupt, I know which SG list i need to read
> from. At this stage i do need to copy the
> buffers associated with each of the SG lists at once. In this
> scenario, I don't see how videobuf could be used,
> while I keep getting this feeling that a simple copy_to_user of the
> entire buffer could do the whole job in a
> better way, since the buffers themselves are already managed and
> initialized already. Am I correct in thinking
> so, or is it that I am overlooking something ?

Manu,

SAA7164 suffers from this. If you find a solution I'd love to hear it.

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

