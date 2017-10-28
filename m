Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:41245 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750803AbdJ1Iv4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 04:51:56 -0400
Subject: Re: cx231xx IR remote control protocol
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Sean Young <sean@mess.org>
Cc: linux-media <linux-media@vger.kernel.org>
References: <5f441db1-93eb-2a9f-25ce-022cdcfadfc1@kaa.org.ua>
 <20171023093724.4cgcwbjpeygfb4so@gofer.mess.org>
 <CAGoCfix8JxMTuz2ynV=NsHG9jtSqLDr0Wwcchw4Dbd0k5z0p+Q@mail.gmail.com>
From: Oleh Kravchenko <oleg@kaa.org.ua>
Message-ID: <8580123e-191f-b393-2829-47707a5c2233@kaa.org.ua>
Date: Sat, 28 Oct 2017 11:51:49 +0300
MIME-Version: 1.0
In-Reply-To: <CAGoCfix8JxMTuz2ynV=NsHG9jtSqLDr0Wwcchw4Dbd0k5z0p+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin and Sean!

It was very easy, suddenly IR is fully supported by mceusb!
Required only correct USB ID.

Thank you!

On 23.10.17 16:12, Devin Heitmueller wrote:
> Hi Oleh,
> 
> On Mon, Oct 23, 2017 at 5:37 AM, Sean Young <sean@mess.org> wrote:
>> Hi Oleh,
>>
>> On Sun, Oct 22, 2017 at 05:01:05PM +0300, Oleh Kravchenko wrote:
>>> Hi,
>>>
>>> I'm trying add support remote control for tuners:
>>> - EvroMedia Full Hybrid Full HD
>>> - Astrometa T2hybrid
>>>
>>> But I'm stuck. Can anybody recognize this protocol?
>>
> 
> Is there anything to indicate that there actually a separate IR
> receiver on the board?  Most cx231xx devices have an MCEUSB compliant
> IR RX/TX built into the chip, and thus they don't use a separate part.
> 
> Also, IIRC, address 0x30 is the I2C address of the onboard analog
> frontend for the cx23102, and I suspect you're just reading the values
> out of the AFE.  I suspect you've grabbed a dump from the initial
> device plug-in, which would coincide with the initial register
> programming of the AFE.
> 
> I suspect if you connect the device, let it device settle, *then*
> start the I2C capture and hit a key on the remote, you'll see traffic
> on a totally different endpoint which would be the IR traffic being
> sent back over the IR interface/endpoint.
> 
> Devin
> 

-- 
Best regards,
Oleh Kravchenko
