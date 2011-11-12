Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45432 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1KLS6p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 13:58:45 -0500
Message-ID: <4EBEC1E3.2020500@iki.fi>
Date: Sat, 12 Nov 2011 20:58:43 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/7] af9015/af9013 full pid filtering
References: <4ebe96f4.6359b40a.5cac.3970@mx.google.com>	 <4EBE9E0F.3060707@iki.fi> <4ebebfba.5b6be30a.26ea.ffffaa15@mx.google.com>
In-Reply-To: <4ebebfba.5b6be30a.26ea.ffffaa15@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 08:49 PM, Malcolm Priestley wrote:
> On Sat, 2011-11-12 at 18:25 +0200, Antti Palosaari wrote:

>> Does that patch force PID filter always on or what?
>
> Yes, and why not?
>
> Pid filtering has it uses in usb 2.0 and works very well. Low power and
> low bus usage.

Actually, I do not know the exact reason. That is how it was defaulted 
by DVB USB framework.

Sending whole TS to Kernel demux still sounds good idea for my ears.

Is there anyone who can say why we send whole TS to Kernel demux in case 
of USB2.0 ?

Antti


-- 
http://palosaari.fi/
