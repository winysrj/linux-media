Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41107 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab2EGSxZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 14:53:25 -0400
Message-ID: <4FA81A23.4000102@iki.fi>
Date: Mon, 07 May 2012 21:53:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: Reduce number of retries
References: <20120403110503.392c8432@milhouse> <4F7B1624.8020401@iki.fi> <20120403173320.2d3df3f8@milhouse>
In-Reply-To: <20120403173320.2d3df3f8@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.04.2012 18:33, Michael Büsch wrote:
> On another thing:
> The af9035 driver doesn't look multi-device safe. There are lots of static
> variables around that keep device state. So it looks like this will
> blow up if multiple devices are present in the system. Unlikely, but still... .
> Are there any plans to fix this up?
> If not, I'll probably take a look at this. But don't hold your breath.

I fixed what was possible by moving af9033 and af9035 configurations for 
the state. That at least resolves most significant issues - like your 
fc0011 tuner callback.

But there is still some stuff in "static struct 
dvb_usb_device_properties" which cannot be fixed. Like dynamic remote 
configuration, dual mode, etc. I am going to make RFC for those maybe 
even this week after some analysis is done.

regards
Antti
-- 
http://palosaari.fi/
