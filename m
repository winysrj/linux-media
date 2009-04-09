Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:38771 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764625AbZDIOEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 10:04:05 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHU0068M72DSG70@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 09 Apr 2009 10:03:52 -0400 (EDT)
Date: Thu, 09 Apr 2009 10:03:48 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [linux-dvb] HVR-1700 - can't open or scan
In-reply-to: <8de7a23f0904090007x3905ee7dp817efe67044b8223@mail.gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Message-id: <49DE0044.10700@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <8de7a23f0904090007x3905ee7dp817efe67044b8223@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alastair Bain wrote:
> I'm trying to get the Hauppauge HVR-1700 working on a Mythbuntu 9.04 b 
> install. Looks like the modules are all loading, firmware is being 
> loaded, device appears in /dev etc, but I can't seem to do anything with 
> it. dvbscan fails around ln 315,
> 
> dvbfe_get_info(fe, DVBFE_INFO_LOCKSTATUS, &feinfo,
>                                 DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0)
> returns DVBFE_INFO_QUERYTYPE_LOCKCHANGE
> 
> Anyone have any clues as to what I can do to fix this? Kernel trace is 
> at http://pastebin.com/m7671e816.

trace looks fine.

Try tzap then report back.

- Steve
