Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38220 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZCKLfE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 07:35:04 -0400
Message-ID: <49B7A1DF.1080204@iki.fi>
Date: Wed, 11 Mar 2009 13:34:55 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: bloehei <bloehei@yahoo.de>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: EC168 support?!
References: <200903111217.17846.bloehei@yahoo.de>
In-Reply-To: <200903111217.17846.bloehei@yahoo.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moi Jo!
bloehei wrote:
> Hi,
> I'm reading this list because I'm - like many others I guess - waiting for my 
> EC168 based Sinovideo 3420b to be supported under linux. Now I've read this 
> (https://www.dealextreme.com/forums/Default.dx/sku.8325~threadid.278942) post 
> and was supprised that there already is some code that seems to be working 
> for some other EC168 sticks. Sadly, it doesn't work for my device.
> I want to thank Antti Palosaari for the work on the driver and suggest, that 
> it should be communicated more clearly that there already is a code base for 
> a driver.

It is ugly few hour hack driver which I did when I tried to order Intel 
ce6230 based stick but got E3C ec168 one.
Anyhow, it seems to work with 8 MHz bandwidth. I think you have 6 or 7 
MHz? It is rather easy to add 6 and 7 too, just take usb-sniff and look 
registers programmed differently.
Are you using 6 or 7 MHz?

regards
Antti
-- 
http://palosaari.fi/
