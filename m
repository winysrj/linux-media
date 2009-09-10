Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35510 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZIJNl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 09:41:27 -0400
Received: by fxm17 with SMTP id 17so94781fxm.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 06:41:30 -0700 (PDT)
Date: Thu, 10 Sep 2009 16:41:39 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
Message-ID: <20090910134139.GA20149@moon>
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com> <829197380909091459x5367e95dnbd15f23e8377cf33@mail.gmail.com> <20090910091400.GA15105@moon> <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com> <20090910124549.GA18426@moon> <20090910124807.GB18426@moon> <4AA8FB2F.2040504@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA8FB2F.2040504@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 04:12:15PM +0300, Antti Palosaari wrote:
> Aleksandr V. Piskunov wrote:
>>> Here is a test case:
>>> Two DVB-T USB adapters, dvb_usb_af9015 and dvb_usb_af9015. Different tuners,
>>
>> Err, make it: dvb_usb_af9015 and dvb_usb_ce6230
>
> Those both uses currently too small bulk urbs, only 512 bytes. I have  
> asked suitable bulk urb size for ~20mbit/sec usb2.0 stream, but no-one  
> have answered yet (search ml back week or two). I think will increase  
> those to the 8k to reduce load.
>

Nice, I'm ready to test if such change helps.

Does USB subsystem provide any way to monitor current raw USB data transfer rate?

