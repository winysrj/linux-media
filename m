Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:54123 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0AUPQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 10:16:13 -0500
Received: by fxm20 with SMTP id 20so86981fxm.1
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 07:16:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B583459.3030909@csldevices.co.uk>
References: <1264012191.4038.60.camel@urkkimylly>
	 <4B583459.3030909@csldevices.co.uk>
Date: Thu, 21 Jan 2010 10:16:10 -0500
Message-ID: <829197381001210716u654f5d8boa1e13932cdd1eba6@mail.gmail.com>
Subject: Re: Conexant Systems, Inc. Hauppauge Inc. HDPVR-1250 model 1196 (rev
	04) [How to make it work?]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Philip Downer <phil@csldevices.co.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 21, 2010 at 6:02 AM, Philip Downer <phil@csldevices.co.uk> wrote:
> Ukko Happonen wrote:
>>
>> How do I make the TV tuner work?
>>
>> lspci -d 14f1:8880 -v says
>>        Kernel driver in use: cx23885
>>        Kernel modules: cx23885
>>
>
> Looks to me like it's already working.
>
> Do you have a /dev/dvb/adapter0 dir with anything in it? if so see
> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device

Hey Phil,

I worked to him a bit on IRC yesterday.  The only reason that the
cx23885 was loaded was because he forced a modprobe with a card number
(with an arbitrary card, btw).

This looks like an Avermedia OEM version of the HVR-1200, but I would
not be able to say for certain without taking a good look at the card.

In order to get this working, a developer would probably have to work
through the driver to build a card profile.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
