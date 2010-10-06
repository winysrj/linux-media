Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58886 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab0JFFwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 01:52:19 -0400
Received: by ewy23 with SMTP id 23so2732129ewy.19
        for <linux-media@vger.kernel.org>; Tue, 05 Oct 2010 22:52:18 -0700 (PDT)
Date: Wed, 6 Oct 2010 15:52:56 -0400
From: Dmitri Belimov <d.belimov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>
Subject: xc5000 and switch RF input
Message-ID: <20101006155256.11ec6d6d@glory.local>
In-Reply-To: <AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
	<20100525114939.067404eb@glory.loctelecom.ru>
	<4C32044C.3060007@redhat.com>
	<AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

Our TV card Behold X7 has two different RF input. This RF inputs can switch between
different RF sources. 

ANT 1 for analog and digital TV
ANT 2 for FM radio

The switch controlled by zl10353.

How to I can control this switch?

I found 2 way

1. 
Use tuner callback to saa1734. add some params like XC5000_TUNER_SET/XC5000_TUNER_SET_TV to the xc5000.h
call tuner callback from xc5000_set_analog_params with new params about switching.
In this case inside saa7134 need know about zl10353 and configuration. I don't understand how to do.
The structure saa7134_dev hasn't pointer to the structure dvb_frontend. 
Or use hardcoded i2c_addr and params.

2.
Direct call switch the switcher from the tuner code. In this case need know TV card type. I think it is not so good idea.

With my best regards, Dmitry.
