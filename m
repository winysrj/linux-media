Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34088 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZIKTr3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 15:47:29 -0400
Message-ID: <4AAAA94D.1040609@iki.fi>
Date: Fri, 11 Sep 2009 22:47:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
CC: Markus Rechberger <mrechberger@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
References: <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com> <20090910124549.GA18426@moon> <20090910124807.GB18426@moon> <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon> <4AA9038B.8090404@iki.fi> <4AA911B6.2040301@iki.fi> <20090910171631.GA4423@moon> <20090910193916.GA4923@moon> <4AAA60D0.50706@iki.fi> <20090911175030.GA10479@moon>
In-Reply-To: <20090911175030.GA10479@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2009 08:50 PM, Aleksandr V. Piskunov wrote:
> Ok, I did read basics of USB 2.0 protocol, gotta love these 600 page specs..
> So using my fresh knowledge I went away and hacked ce6230 to use Isochronous
> transfer endpoint instead of Bulk one. And it helped, tuner works, no
> corruption with af9015 running on same controller at the same time.

Looks like chipset driver issue as you said.

> Of course it isn't a fix per se, af9015 still corrupts if I start bulk
> reading from a flash drive, etc. And there are no Isochronous endpoints on
> af9015, so no alternative to bulk transfers :)

y, correct. Welcome to hacking DVB drivers.

> But at least I'm getting closer to pinpointing the real problem and so far
> everything points to AMD SB700 chipset driver. Google says it has quite
> some hardware bugs and several workarounds in linux drivers...
>
> P.S. Rather unrelated question, what type of USB transfer is generally
> preferred for USB media stream devices, BULK or ISOC? Antti, why did you
> choose BULK for ce6230?

Because chipset Windows driver was using BULK. Very many, I think even 
most, DVB chipset offers both ISOC and BULK. BULK is still used 
commonly, only few drivers are using ISOC. Devin answered already why 
BULK is used generally for DVB streams. :)

I read also USB "bible" book yesterday and it says it is better to use 
biggest BULK urb supported. I want to change it biggest possible one, 
but there is other side that limits it - memory needed for buffers. 
That's why I am thinking twice whether to increase it 8k or 16k or even 
more. I currently think 16k will be good compromise for most 
configurations / devices.

Antti
-- 
http://palosaari.fi/
