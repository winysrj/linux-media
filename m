Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:62932 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZERWFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 18:05:13 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe1a4.dyn.optonline.net [24.191.225.164]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KJU00EASZYISZM0@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 18 May 2009 17:35:07 -0400 (EDT)
Date: Mon, 18 May 2009 17:35:06 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: no tuning with an hvr-1700
In-reply-to: <C9D3D945-05BF-48DA-9CEF-CF7D4DFE8053@lauresconseil.fr>
To: =?ISO-8859-1?Q?Guillaume_Laur=E8s?= <glaures@lauresconseil.fr>
Cc: linux-media@vger.kernel.org
Message-id: <4A11D48A.1030209@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <C9D3D945-05BF-48DA-9CEF-CF7D4DFE8053@lauresconseil.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guillaume Laurès wrote:
> Hello all,
> 
> I can't find digital channels with an hvr-1700.
> "dvb-scan -a2  /usr/share/dvb/dvb-t/fr-Tours" outputs no channel info, 
> only some "tuning failed" messages. Two hvr-3000 in the same box work 
> flawlessly (both dvb-t and dvb-s).
> 
> I run v4l-sources (last saturday's snapshot), on a 2.6.28-gentoo-r5 x64 
> host.
> The card is recognized as /dev/dvb/adapter2 and firmwares are loaded. I 
> also tried with the hvr-1700 alone and got the same result.
> Here is some dmesg output with debugging enabled, this shows activity 
> from modprobe and dvb-scan.
> 
...


> 
> Any hints ?

Clone this tree and try again:

http://kernellabs.com/hg/~stoth/tda10048-merge

Better, or not?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
