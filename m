Return-path: <linux-media-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:58491 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZEVHCE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 03:02:04 -0400
Message-ID: <4A164DEB.4050907@bsc-bvba.be>
Date: Fri, 22 May 2009 09:02:03 +0200
From: Luc Brosens <dvb@bsc-bvba.be>
Reply-To: dvb@bsc-bvba.be
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org, tarik.chougua@yahoo.fr
Subject: Re: [linux-dvb] Hauppauge WinTV-CI
References: <965444.24352.qm@web26902.mail.ukl.yahoo.com> <20090515231650.56d6c4f4@bk.ru>
In-Reply-To: <20090515231650.56d6c4f4@bk.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Goga777 wrote:
>> Is Wintv-CI, the Common Interface from Hauppauge, working on linux now ?
> 
> 
> not
> 
> Goga
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


I have been struggling for ages with this device, trying get the firmware to load.

The program I wrote to extract the firmware from the driver now outputs the Intel Hex format too, used by fxload.
No luck : the A3 part does not get loaded, not even using fxloads' A3-loader

Details and downloads of code, logs etc at http://www.bsc-bvba.be/linux/dvb

I could use some help, like :
= traces of the firmware being loaded on XP/Vista (I am using USBspy myself), preferably using a hardware protocol analyser
= recommendations for an affordable hardware USB2 protocol analyser (I'd try to compare the XP-log with the non-working Linux log)
= suggestions on how to proceed ...

Luc

