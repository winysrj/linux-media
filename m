Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.20]:43168 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2I1TAu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:50 -0400
Message-ID: <5065F3E0.1000006@free.fr>
Date: Fri, 28 Sep 2012 21:00:48 +0200
From: Damien Bally <biribi@free.fr>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, tvboxspy@gmail.com
Subject: Re: [PATCH] usb id addition for Terratec Cinergy T Stick Dual rev. 2
References: <5064A3AD.70009@free.fr> <5064ABD2.2060106@iki.fi>
	<5065D1AC.5030800@free.fr> <5065E487.80502@iki.fi>
In-Reply-To: <5065E487.80502@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Le 28/09/2012 19:55, Antti Palosaari a écrit :

> I am not sure what you do here but let it be clear.
> There is same ID used by af9015 and it913x. Both drivers are loaded when
> that ID appears. What I understand *both* drivers, af9015 and it913x
> should detect if device is correct or not. If device is af9015 then
> it913x should reject it with -ENODEV most likely without a I/O. If
> device is it913x then af9015 should reject the device similarly. And you
> must find out how to do that. It is not acceptable both drivers starts
> doing I/O for same device same time.
>

I'd gladly implement this, but I'm not a developper, for the moment ;-)

>>
>> I'm unfortunately not able to rewrite the driver, but I'm willing to
>> provide any information about the device to help its correct
>> identification.
