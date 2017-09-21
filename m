Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([63.128.21.107]:59503 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750790AbdIUQJc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 12:09:32 -0400
Subject: Re: [PATCH v3 2/2] media: rc: Add driver for tango HW IR decoder
To: Mans Rullgard <mans@mansr.com>
CC: Sean Young <sean@mess.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
References: <0e433f1b-ec16-5fce-ab21-085f69e266ce@free.fr>
 <4fe2e398-ba7d-3670-f29b-fe3c5e079b39@free.fr> <yw1xbmm4xdfr.fsf@mansr.com>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Message-ID: <f510d7a6-0b6a-002b-3aad-7dd634392d07@sigmadesigns.com>
Date: Thu, 21 Sep 2017 18:09:24 +0200
MIME-Version: 1.0
In-Reply-To: <yw1xbmm4xdfr.fsf@mansr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/09/2017 17:46, Måns Rullgård wrote:

> Marc Gonzalez writes:
> 
>> From: Mans Rullgard <mans@mansr.com>
>>
>> The tango HW IR decoder supports NEC, RC-5, RC-6 protocols.
>>
>> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
> 
> Have you been able to test all the protocols?  Universal remotes usually
> support something or other with each of them.

I found the Great Pile of Remotes locked away in a drawer.
Played "What kind of batteries do you eat?" for about an hour.
And found several NEC remotes, one RC-5, and one RC-6.
Repeats seem to be handled differently than for NEC.
I'll take a closer look.

>> +	err = devm_request_irq(dev, irq, tango_ir_irq, IRQF_SHARED, dev_name(dev), ir);
>> +	if (err)
>> +		return err;
> 
> You shouldn't enable the irq until after you've configured the device.
> Otherwise you have no idea what state it's in, and it might start firing
> unexpectedly.
> 
> My original code did this properly.  Why did you move it?

I got caught up in the great devm rewrite.
Will take another swipe at it on Monday.

>> +	writel_relaxed(0x110, ir->rc5_base + IR_CTRL);
> 
> Since you've defined DISABLE_NEC above, I think you should use it here too.

OK.

Regards.
