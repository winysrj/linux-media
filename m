Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61992 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0JNQRM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 12:17:12 -0400
Received: by qwa26 with SMTP id 26so1709453qwa.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 09:17:11 -0700 (PDT)
Message-ID: <4CB72D01.3060106@gmail.com>
Date: Thu, 14 Oct 2010 13:17:05 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: tvbox <tvboxspy@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Support or LME2510(C) DM04/QQBOX USB DVB-S BOXES.
References: <1283459370.3368.23.camel@canaries-desktop> <4CB60433.2010105@iki.fi>
In-Reply-To: <4CB60433.2010105@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-10-2010 16:10, Antti Palosaari escreveu:
> On 09/02/2010 11:29 PM, tvbox wrote:
>> DM04/QQBOX DVB-S USB BOX with LME2510C+SHARP:BS2F7HZ7395 or LME2510+LGTDQT-P001F tuner.
> 
>> +config DVB_USB_LME2510
>> +    tristate "LME DM04/QQBOX DVB-S USB2.0 support"
>> +    depends on DVB_USB
>> +    select DVB_TDA10086 if !DVB_FE_CUSTOMISE
>> +    select DVB_TDA826X if !DVB_FE_CUSTOMISE
>> +    select DVB_STV0288 if !DVB_FE_CUSTOMISE
>> +    select DVB_IX2505V if !DVB_FE_CUSTOMISE
>> +    select IR_CORE
>> +    help
>> +      Say Y here to support the LME DM04/QQBOX DVB-S USB2.0 .
> 
> Just for curious, is IR_CORE and DVB_USB both needed? DVB_USB also depends on IR_CORE ? This was only DVB-USB driver which does that.

First of all, you shouldn't never use select with IR_CORE. This won't work for menu items. 
It should use only depends on.

With respect to DVB_USB, as we have:

config DVB_USB
	tristate "Support for various USB DVB devices"
	depends on DVB_CORE && USB && I2C && IR_CORE


The IR_CORE dependency is already there, so, DVB_USB_LME2510 shouldn't need do use dependency
related to IR.

Cheers,
Mauro
