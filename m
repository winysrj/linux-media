Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32863 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbZFEPVn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 11:21:43 -0400
Message-ID: <4A293802.8070404@iki.fi>
Date: Fri, 05 Jun 2009 18:21:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>, jhoogenraad@linuxtv.org
CC: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: [not working] Conceptronic USB 2.0 Digital TV Receiver - CTVDIGRCU
 - Device Information
References: <49F189BC.5090606@powercraft.nl> <49F1ADF3.2030901@iki.fi>	<49F1AFC9.2040405@powercraft.nl> <49F1BA30.6060702@iki.fi>
In-Reply-To: <49F1BA30.6060702@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve Jelle,

On 04/24/2009 04:10 PM, Antti Palosaari wrote:
> On 04/24/2009 03:25 PM, Jelle de Jong wrote:
>> I got an USB ID 14aa:0160 Conceptronic USB2.0 DVB-T CTVDIGRCU V2.0 but I
>> have no idea what chipsets it contains. Could somebody extract the
>> drivers to be sure? (see my first mail for driver web pages)
>> http://www.conceptronic.net/site/desktopdefault.aspx?tabindex=0&tabid=420&pc=CTVDIGRCU
>>
>
> There is no drivers for device USB-ID 14aa:0160.
>
> ; Copyright (C) Wideviewer Corporation, 2005 All Rights Reserved.
> ;
> ; USB DVB-T Adapter
> ; WideViewer DVB-T WT-225U
>
> ; The Vendor ID =14AA, and the Product ID =0226
> %DevModel.DeviceDesc%=DevModel.Dev,USB\VID_14AA&PID_0226&MI_00
>
> According to google search it could be Realtek.
> http://ubuntuforums.org/showthread.php?t=822291&page=2

I just got that device from post. I installed driver from:
http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2
and it is working :(

Driver identifies this device as "Freecom USB 2.0 DVB-T Device".

I have don't know exactly what's driver status currently - is is only in 
development tree currently. Could Jan Hoogenraad comment what should do 
before driver is ready to the master release?

regards
Antti
-- 
http://palosaari.fi/
