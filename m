Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp13.wxs.nl ([195.121.247.25]:34130 "EHLO psmtp13.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0AGWgg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2010 17:36:36 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp13.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KVW00BV0ESYQD@psmtp13.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 07 Jan 2010 23:36:35 +0100 (MET)
Date: Thu, 07 Jan 2010 23:36:29 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Compro VideoMate U80 DVB-T USB 2.0 High Definition Digital TV Stick
In-reply-to: <4B3ABD9D.6040207@iinet.net.au>
To: drappa <drappa@iinet.net.au>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Message-id: <4B4661ED.3070606@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B3ABD9D.6040207@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can you give us the USB ID
(type on the command line: lsusb, and report the output)

The U90 has a RTL2831 in it. More info on the driver on:
http://www.linuxtv.org/wiki/index.php/Rtl2831_devices

drappa wrote:
> Hi All
> 
> http://www.comprousa.com/en/product/u80/u80.html
> 
> I'd be grateful if anyone can tell me if this device is supported yet, 
> and if so, any pointers to getting it working.
> 
> Thanks
> Drappa
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
