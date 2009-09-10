Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55721 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZIJRQd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 13:16:33 -0400
Received: by bwz19 with SMTP id 19so251515bwz.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 10:16:35 -0700 (PDT)
Date: Thu, 10 Sep 2009 20:16:31 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
Message-ID: <20090910171631.GA4423@moon>
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com> <829197380909091459x5367e95dnbd15f23e8377cf33@mail.gmail.com> <20090910091400.GA15105@moon> <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com> <20090910124549.GA18426@moon> <20090910124807.GB18426@moon> <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon> <4AA9038B.8090404@iki.fi> <4AA911B6.2040301@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA911B6.2040301@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 05:48:22PM +0300, Antti Palosaari wrote:
> On 09/10/2009 04:47 PM, Antti Palosaari wrote:
>> Aleksandr V. Piskunov wrote:
>>> On Thu, Sep 10, 2009 at 04:12:15PM +0300, Antti Palosaari wrote:
>>>> Aleksandr V. Piskunov wrote:
>>>>>> Here is a test case:
>>>>>> Two DVB-T USB adapters, dvb_usb_af9015 and dvb_usb_af9015.
>>>>>> Different tuners,
>>>>> Err, make it: dvb_usb_af9015 and dvb_usb_ce6230
>>>> Those both uses currently too small bulk urbs, only 512 bytes. I have
>>>> asked suitable bulk urb size for ~20mbit/sec usb2.0 stream, but
>>>> no-one have answered yet (search ml back week or two). I think will
>>>> increase those to the 8k to reduce load.
>>>>
>>>
>>> Nice, I'm ready to test if such change helps.
>>
>> OK, I will make test version in couple of hours.
>
> Here it is, USB2.0 URB is now about 16k both af9015 and ce6230 devices.
> Now powertop shows only about 220 wakeups on my computer for the both  
> sticks.
> Please test and tell what powertop says:
> http://linuxtv.org/hg/~anttip/urb_size/
>
> I wonder if we can decide what URB size DVB USB drivers should follow  
> and even add new module param for overriding driver default.

Thanks, Antti!

Tested your branch on affected system.

Load definitely went down, from ~7000 wakeups to ~250 for each tuner
according to powertop.
Both tuners still working ok if not used simultaneously or if used the
same time on different USB controllers.

Bad news are that original problem still persists: putting both tuners
on same USB controller and zapping simultaneously corrupts stream.
Interesting observation: no matter in what sequence tuners are connected
(i.e. become adapter0 or adapter1), af9015 stream always gets heavily
distorted, visually mplayer picture becomes like 80% corrupted with
random color blocks and pixels, sound becomes a mess. At the same time
ce6230 gets slight corruption, a few discolored blocks at the time and
sound hickups.

Anyway, will try to do a few more tests:
1) Two usb flash drives on same controller calculating md5sum of 
big .iso file, to check if it is/isn't dvb-usb problem.
2) Will see if same issue persists on another PC with same motherboard
(slightly different revision) to rule out hardware issues. If I manage
to wire antenna there, that is...
