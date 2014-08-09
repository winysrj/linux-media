Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59297 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaHIUrJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:47:09 -0400
Message-ID: <53E688CA.1080203@iki.fi>
Date: Sat, 09 Aug 2014 23:47:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bimow Chen <Bimow.Chen@ite.com.tw>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] V4L/DVB: Update tuner initialization sequence
References: <1407217613.2988.7.camel@ite-desktop>
In-Reply-To: <1407217613.2988.7.camel@ite-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I applied that patch too, but reverted register writes you removed / 
moved to af9033 demod driver. Also, register write added for attach() 
happens too late leaving tuner ops populated even it fails. That causes 
surely kernel crash when tuner attach fails and DVB-core sees tuner 
callbacks are populated. So I moved it happen few lines earlier. Also 
removed sleep as I didn't see any need for it.

There should be commit description on each patch saying what it does and 
why. I did a lot of reverse-engineering to understand these patches.


regards
Antti

-- 
http://palosaari.fi/
