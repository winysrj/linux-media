Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:45487 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751163AbeC3SAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 14:00:08 -0400
Subject: Re: [PATCH v4] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and
 merge with gl861
To: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180327174730.1887-1-tskd08@gmail.com>
 <f1ce1268-e918-a12f-959e-98644cafb2fe@iki.fi>
 <e861a533-5517-2089-52af-ce720174e3ae@gmail.com>
 <db8f370c-20f5-e9fe-9d2e-d12c1475dc33@iki.fi>
 <30d0270b-852a-39df-14e5-4c12d59aeac7@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <25d4e91f-454f-bac7-125b-dd1ae5c77d9e@iki.fi>
Date: Fri, 30 Mar 2018 20:59:44 +0300
MIME-Version: 1.0
In-Reply-To: <30d0270b-852a-39df-14e5-4c12d59aeac7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/30/2018 04:21 PM, Akihiro TSUKADA wrote:
>> I simply cannot see why it cannot work. Just add i2c adapter and
>> suitable logic there. Transaction on your example is simply and there is
>> no problem to implement that kind of logic to demod i2c adapter.
> 
> I might be totally wrong, but...
> 
> i2c transactions to a tuner must use:
> 1. usb_control_msg(request:3) for the first half (write) of reads
> 2. usb_control_msg(request:1) for the other writes
> 3. usb_control_msg(request:2) for (all) reads
> 
> How can the demod driver control the 'request' argument of USB messages
> that are sent to its parent (not to the demod itself),
> when the bridge of tc90522 cannot be limited to gl861 (or even to USB) ?

I don't understand those control message parts and it is bit too hard to 
read i2c adapter implementation to get understanding. Could you offer 
simple 2 sniff examples, register write to demod and register write to 
tuner.

Anyhow, demod i2c adapter gets request from tuner and then does some 
demod specific i2c algo stuff and then pass proper request to usb-bridge 
i2c adapter.

IIR it was somehing like

write_tuner_reg(0xaa, 0xbb);
  ==> demod i2c algo:
  * write_demod_reg(0xfe, 0x60) // set tuner i2c addr + start i2c write
  * write_demod_reg(0xaa, 0xbb)

so those command now goes to i2c-bridge i2c algo which uses gl861 i2c algo


regards
Antti

-- 
http://palosaari.fi/
