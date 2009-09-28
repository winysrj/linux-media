Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:56451 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZI1QaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 12:30:17 -0400
Received: by fg-out-1718.google.com with SMTP id 22so801444fge.1
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 09:30:20 -0700 (PDT)
Message-ID: <4AC0E494.1050604@gmail.com>
Date: Tue, 29 Sep 2009 00:30:12 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>
Subject: Re: CX23885 card Analog/Digital Switch
References: <4AC0DC20.2070307@gmail.com> <829197380909280920v2d86d41nb42d4e90b5136215@mail.gmail.com>
In-Reply-To: <829197380909280920v2d86d41nb42d4e90b5136215@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Mon, Sep 28, 2009 at 11:54 AM, David T. L. Wong
> <davidtlwong@gmail.com> wrote:
>> Hello List,
>>
>> cx23885 card Magic-Pro ProHDTV Extreme 2, has a cx23885 GPIO pin to
>> select Analog TV+Radio or Digital TV. How should I add that GPIO setting
>> code into cx23885?
>> The current model that all operations goes to FE instead of card is not very
>> appropriate to model this case.
>> I thought of adding a callback code for the tuner (XC5000), but my case
>>  is that this behavior is card specific, but not XC5000 generic.
>>
>> Is there any "Input Selection" hook / callback mechanism to notify the card,
>> the device.
>>
>> Regards,
>> David T.L. Wong
> 
> You should definitely *not* add a callback to xc5000 (and such a patch
> will not be accepted).  The best approach may be to look at Michael
> Krufky's fe_override tree, which is pending for merge:
> 
> http://www.kernellabs.com/hg/~mkrufky/fe_ioctl_override/
> 
> Devin
> 

Thanks Devin and Steven. I'll will study Michael's tree.

David
