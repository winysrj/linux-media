Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.skynet.fr ([91.121.146.144]:58717 "EHLO mail.skynet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab1IXSr0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 14:47:26 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.skynet.fr (Postfix) with ESMTP id 6FA50126003
	for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 18:47:25 +0000 (UTC)
Received: from mail.skynet.fr ([127.0.0.1])
	by localhost (mail.skynet.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id w9CJ7GFl5aUV for <linux-media@vger.kernel.org>;
	Sat, 24 Sep 2011 18:47:25 +0000 (UTC)
Received: from Jin-Kazamas-MacBook-Pro.local (gli74-3-78-241-6-73.fbx.proxad.net [78.241.6.73])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: mathieu@seillon.fr)
	by mail.skynet.fr (Postfix) with ESMTPSA id 080BB126002
	for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 18:47:24 +0000 (UTC)
Message-ID: <4E7E25BC.5090709@skynet.fr>
Date: Sat, 24 Sep 2011 20:47:24 +0200
From: Jin Kazama <jin.ml@skynet.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: af9015/tda18218: Multiples (separates) usb devices errors/conflicts
References: <S1752295Ab1IWUja/20110923203930Z+74@vger.kernel.org> <4E7CF4DA.5020607@skynet.fr> <4E7D02DC.3010201@iki.fi>
In-Reply-To: <4E7D02DC.3010201@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/24/11 12:06 AM, Antti Palosaari wrote:
> On 09/24/2011 12:06 AM, Jin Kazama wrote:
>> Hello,
>> I've been testing af9015/tda18218 based usb DVB-T tuners on a 2.6.39.4
>> kernel with the latest v4l drivers avaiable (from git).
>> When I'm using a single USB module, (listed as /dev/dvb/adapter0),
>> everything works fine.
>> When I'm plugging another module, at first it looks like everything's ok
>> (/dev/dvb/adapter1) and if I try to use this module while the adapter0
>> is not been used, it works - but if try to use both modules at the same
>> time, I get garbage output on both cards (error: warning: discontinuity
>> for PID... with dvblast on both cards.
>> Does anyone have any idea on how to fix this problem?
>
> Feel free to fix it. I am too busy currently.
>
Well, it looks like if I put 2 devices on different USB buses (on the 
same machine), they work fine, but if they're on the same USB bus, I get 
the problem...
I think the driver may get raw data from the USB bus - and the way it 
identifies the device is not the proper way (I have 2 exactly identical 
devices) => when both devices send data, the driver catches all the data 
from the bus, which is a corrupt mix of both streams...)
Unfortunately, I don't think that I'm capable of fixing the problem by 
myself, I don't even know which part of the driver to look for... if 
someone can give me a hint, I might *try* to *attempt* to fix it :)...
