Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbZLHLX2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 06:23:28 -0500
Message-ID: <4B1E3727.9090106@redhat.com>
Date: Tue, 08 Dec 2009 09:23:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>	 <1260070593.3236.6.camel@pc07.localdom.local>	 <20091206065512.GA14651@core.coreip.homeip.net>	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>	 <m3skbn6dv1.fsf@intrepid.localdomain>	 <20091207184153.GD998@core.coreip.homeip.net> <9e4733910912071644y234beebepd426f9f5760507ce@mail.gmail.com>
In-Reply-To: <9e4733910912071644y234beebepd426f9f5760507ce@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Mon, Dec 7, 2009 at 1:41 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> That is why I think we should go the other way around - introduce the
>> core which receivers could plug into and decoder framework and once it
>> is ready register lirc-dev as one of the available decoders.
> 
> The core needs to allow for RF remotes too.
> 
> -Bluetooth remotes are already in kernel somehow, I don't know how they work,
> -RF4CE, the 802.15.4 stack has been recently merged, the remotes use a
> protocol on top of that. These remotes will hit the consumer market
> next year. Sony, Panasonic and other big names are behind this.
> -Zwave, the Harmony remotes use Zwave. There is no Zwave support in
> the kernel that I am aware of. Zwave is proprietary.
> 
> After these protocols are decoded you end up with scancodes. The
> scancodes need to get injected into input somehow and then flow
> through the mapping process. Decoding down to the scancodes probably
> happens over in the networking code.
> 
> After an in-kernel IR decoder runs it needs to hand off the scancodes
> into the input subsystem. This same API can be used by the networking
> code to hand off RF scancodes.
> 

Yes, the same core should be able to work with non infra red remotes, but, depending
on how the device is implemented.

Cheers,
Mauro.
