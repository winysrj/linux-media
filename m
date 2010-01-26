Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:49076 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab0AZGT6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 01:19:58 -0500
Message-ID: <4B5E8987.4080407@free.fr>
Date: Tue, 26 Jan 2010 07:19:51 +0100
From: Chris Moore <moore@free.fr>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Looking for original source of an old DVB tree
References: <4B5BFFE3.30003@free.fr> <4B5C3ABF.4000807@iki.fi>
In-Reply-To: <4B5C3ABF.4000807@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Thanks for your reply, Antti.

Le 24/01/2010 13:19, Antti Palosaari a écrit :
> On 01/24/2010 10:08 AM, Chris Moore wrote:
>> Hello,
>>
>> Short version:
>> I am looking for the original source code of a Linux DVB tree containing
>> in particular
>> drivers/media/dvb/dibusb/microtune_mt2060.c
>> and the directory
>> drivers/media/dvb/dibusb/mt2060_api
>>
>> Googling for microtune_mt2060.c and mt2060_api is no help.
>> Could anyone kindly point me in the right direction, please?
>
> It is mt2060.c, mt2060_priv.h (IIRC) and mt2060.h.
>

Sorry, I did not explain my problem clearly enough.
The DVB subtree in the Realtek 2.6.12.6-VENUS kernel used on the 
Xtreamer is *very* different from that in mainline 2.6.12.6.
It is also different from anything I have found anywhere else.
Judging from the code it looks as though Realtek got the source code 
from elsewhere and hacked it dirtily for their own chips.
I was trying to find the original unhacked source code.
I *do* have the (hacked) files.
The file and directory I cited seem to be specific to this version.
I gave them to see if they ring a bell with anyone.
(A thought: maybe they could have come directly from a DiBcom SDK?)

>> Longer version:
>> I am trying to get my USB DVB-T stick running on my Xtreamer.
>> Xtreamer uses an old 2.6.12.6 kernel heavily modified by Realtek and
>> possibly also modified by MIPS.
>> I have the source code but it would be a tremendous effort to change to
>> a recent kernel.
>> The DVB subtree seems to have been dirtily hacked by Realtek to support
>> their frontends.
>> In the process they seem to have lost support for other frontends.
>> I have been trying to find the source code for the original version.
>> I have found nothing resembling it in kernel.org, linux-mips.org and
>> linuxtv.org.
>
> I am not sure what kind of device Xtreamer is, but try this:
> http://linuxtv.org/hg/~anttip/rtl2831u/
>
> It is for Realtek RTL2831U + MT2060 based USB sticks.
>

The Xtreamer is a cheap network media player based on the Realtek 
RTD1283 SoC.

I am not looking for support for Realtek DVB chips.
I was trying to get an Artec T14 USB DVB-T stick running on the Xtreamer.
(This looked the most promising of the sticks I have.)

In the end I bit the bullet and backported the current tip of v4l-dvb to 
2.6.12.6.
This was not trivial as many modifications were needed :(

I now have modules that load and which *nearly* work.
Scan outputs ">>> tuning status == 0x02" then  ">>> tuning status == 
0x1a" and sticks there with no further output (for hours; probably 
indefinitely).
This status seems to indicate a problem with FEC.
I guess there are uncorrectable Reed-Solomon errors.

I live in a low signal area and this could be normal.
Is there a LNA on this stick?
I couldn't find a module parameter to activate one.

Anyway I now think the best idea would be to for me to get the stick 
running on x86 first.

Thanks again for your help.

Cheers,
Chris


