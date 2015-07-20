Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35272 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbbGTQzA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 12:55:00 -0400
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
To: Devin Heitmueller <dheitmueller@kernellabs.com>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
 <55AD0617.7060007@iki.fi>
 <CALzAhNVFBgEBJ8448h1WL3iDZ4zkR_k5And0-mtJ6vu97RZLTQ@mail.gmail.com>
 <55AD234E.5010904@iki.fi>
 <CAGoCfiy5Fy26EJzRPYEk_kgH0YESTXiR-E=83Rur6PWZjyi8jQ@mail.gmail.com>
Cc: Steven Toth <stoth@kernellabs.com>, tonyc@wincomm.com.tw,
	Linux-Media <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55AD27E0.6080102@iki.fi>
Date: Mon, 20 Jul 2015 19:54:56 +0300
MIME-Version: 1.0
In-Reply-To: <CAGoCfiy5Fy26EJzRPYEk_kgH0YESTXiR-E=83Rur6PWZjyi8jQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2015 07:45 PM, Devin Heitmueller wrote:
>> Look at the em28xx driver and you will probably see why it does not work as
>> expected. For my eyes, according to em28xx driver, it looks like that bus
>> control is aimed for bridge driver. You or em28xx is wrong.
>
> Neither are wrong.  In some cases the call needs to be intercepted by
> the frontend in order to disable its TS output.  In other cases it
> needs to be intercepted by the bridge to control a MUX chip which
> dictates which demodulator's TS output to route from (typically by
> toggling a GPIO).

Quickly looking the existing use cases and I found only lgdt3306a demod 
which uses that callback to control its TS interface. All the rest seems 
to be somehow more related to bridge driver, mostly changing bridge TS 
IF or leds etc.

I don't simply see that correct solution for disabling demod TS IF - 
there is sleep() for this kind of things - and as I pointed out it does 
not even work for me em28xx based device because em28xx uses that 
routine to switch own TS mode.

regards
Antti

-- 
http://palosaari.fi/
