Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:30273 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZCORa3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 13:30:29 -0400
Message-ID: <49BD3B31.8030308@iki.fi>
Date: Sun, 15 Mar 2009 19:30:25 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, pureherz@gmail.com
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] EC168 and MT2060
References: <1237129041.7993.38.camel@0ri0n>
In-Reply-To: <1237129041.7993.38.camel@0ri0n>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moi,

t.Hgch wrote:
> I also followed this post to get streams from the EC168:
> https://www.dealextreme.com/forums/Default.dx/sku.8325~threadid.278942
> However my card is a MinTv usb 2.0 dvb-t DUTV002, which seems to be
> using a MT2060 tuner. Some channels where partially received. Let me

Partially received? If there is really MT2060 tuner then channels should 
  not be received at all.

> know if you have any idea of how i could solve this.

I can look usb-sniffs if you will take.
http://www.pcausa.com/Utilities/UsbSnoop/default.htm

One sec sniff to channel where it lock is enough, log size will increase 
very rapidly when streaming picture...

One big problem to make this device really working is lack of specs... I 
am very interested if someone could help getting specs.

regards
Antti
-- 
http://palosaari.fi/
