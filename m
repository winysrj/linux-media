Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142Ab0DWQwV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 12:52:21 -0400
Message-ID: <4BD1D03D.6070403@redhat.com>
Date: Fri, 23 Apr 2010 13:52:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Bee Hock Goh <beehock@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Help needed in understanding v4l2_device_call_all
References: <x2m6e8e83e21004062310ia0eef09fgf97bcfafcdf25737@mail.gmail.com>	 <4BD0B32B.8060505@redhat.com>	 <i2k6e8e83e21004221920q3f687324z8d8aba7ca26978ad@mail.gmail.com>	 <4BD1BB75.9020907@arcor.de> <x2p6e8e83e21004230828vac56ac76q613941884944c0f@mail.gmail.com> <4BD1BD78.3050105@arcor.de>
In-Reply-To: <4BD1BD78.3050105@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Am 23.04.2010 17:28, schrieb Bee Hock Goh:
>> So do you mean its required for tm6010 to set the registers?
>>   
> that is not a register, please see you in lastest git, that this request
> a command is (send start and send stop!).

It is hard to know what it really does, but I suspect that it were meant to
implement manual i2c handling, on a similar way to what other drivers do.
On the logs I have here for tm6000 and tm6010, this is not used. So, I suspect
that this is one of the i2c tricks that were used by the vendor of your board.
Other vendors seem to implement different tricks to make i2c work. We need
to figure out what would work better for the devices supported by the driver.

Cheers,
Mauro
