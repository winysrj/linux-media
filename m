Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56934 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaICC05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Sep 2014 22:26:57 -0400
Message-ID: <54067C6D.8090804@iki.fi>
Date: Wed, 03 Sep 2014 05:26:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>
Subject: Re: [GIT PULL FINAL 16/21] m88ts2022: rename device state (priv =>
 s)
References: <1408705093-5167-1-git-send-email-crope@iki.fi> <1408705093-5167-17-git-send-email-crope@iki.fi> <20140902155104.4b4e04dc.m.chehab@samsung.com>
In-Reply-To: <20140902155104.4b4e04dc.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/2014 09:51 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 22 Aug 2014 13:58:08 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> I like short names for things which are used everywhere overall the
>> driver. Due to that rename device state pointer from 'priv' to 's'.
>
> Please, don't do that. "s" is generally used on several places for string.
> If you want a shorter name, call it "st" for example.

huoh :/
st is not even much better. 'dev' seems to be the 'official' term. I 
will start using it. There is one caveat when 'dev' is used as kernel 
dev_foo() logging requires pointer to device, which is also called dev.

for USB it is: intf->dev
for PCI it is: pci->dev
for I2C it is: client->dev

And you have to store that also your state in order to use logging (and 
usually needed other things too). So for example I2C driver it goes:

struct driver_dev *dev = i2c_get_clientdata(client);
dev_info(&dev->client->dev, "Hello World\n");

Maybe macro needed to shorten that dev_ logging, which takes as a first 
parameter pointer to your own driver state.

I have used that 's' for many of my drivers already and there is likely 
over 50 patches on my queue which needs to be rebased. And rebasing that 
kind of thing for 50 patches is *really* painful, ugh.

Antti

-- 
http://palosaari.fi/
