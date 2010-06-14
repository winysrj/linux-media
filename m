Return-path: <linux-media-owner@vger.kernel.org>
Received: from server3.tinynetworks.co.uk ([89.16.176.161]:44128 "EHLO
	mx.tinynetworks.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab0FNIPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 04:15:55 -0400
To: Antti Palosaari <crope@iki.fi>
Subject: Re: Attempting to use 2 KWorld PlusTV Dual DVB-T PCI tuners
MIME-Version: 1.0
Date: Mon, 14 Jun 2010 09:15:52 +0100
From: Martyn Welch <martyn@welchs.me.uk>
Cc: <linux-media@vger.kernel.org>
In-Reply-To: <a30700b0b93938bb318ceba994a51bfe@localhost>
References: <a30700b0b93938bb318ceba994a51bfe@localhost>
Message-ID: <6e20afc15aeeec651a574dba727166b0@localhost>
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Ah, looks like it was a PCI slot thing, moved the second card into a

different slot and all seems to be working well. Sorry for the noise,



Martyn





On Wed, 09 Jun 2010 12:08:25 +0100, Martyn Welch <martyn@welchs.me.uk>

wrote:

> Hi,

> 

> I'm attempting to use 2 (I believe identical) KWorld PlusTV Dual DVB-T

PCI

> tuners in my system. I have downloaded the firmware and at boot can see

the

> cards being (nearly) successfully detected. It seems that both turners

are

> being detected on one card, but only one on the second.

> 

> I haven't had much time to test the cards and I'm afraid I'm not near

the

> box to be able to provide the boot log at the moment. Looking through

the

> code I can see "static struct dvb_usb_device_properties

> af9015_properties[3];" here:

> 

>

http://lxr.linux.no/#linux+v2.6.32/drivers/media/dvb/dvb-usb/af9015.c#L43

> 

> Which suggests to me that it's only going to be able to register 3

tuners

> (or is it 3 cards?), is that the case?

> 

> Martyn
