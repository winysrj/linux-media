Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:56307 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab1IHNnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 09:43:06 -0400
Message-ID: <4E68C665.8010508@mlbassoc.com>
Date: Thu, 08 Sep 2011 07:43:01 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP and UYVY422
References: <4E679407.1090300@mlbassoc.com> <CA+2YH7tTbPNjK8+Ao-H30huYmdtWRJFvNbkoD=HQXeppMaZ9aw@mail.gmail.com> <4E68C5DF.1040405@mlbassoc.com>
In-Reply-To: <4E68C5DF.1040405@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-09-08 07:40, Gary Thomas wrote:
> On 2011-09-08 07:22, Enrico wrote:
>> On Wed, Sep 7, 2011 at 5:55 PM, Gary Thomas<gary@mlbassoc.com> wrote:
>>> My UYVY422 data looks like this (raw-3.0):
>>> 0000000: 0080 0080 007f 0080 007f 0080 007f 0080 ................
>>> 0000010: 0080 0080 0080 0080 0080 0080 0080 0080 ................
>>> 0000020: 0080 0080 0080 0080 007f 0080 0080 0080 ................
>>> 0000030: 0080 007f 0080 007f 0080 007f 0080 007f ................
>>>
>>> It should look more like this (raw-2.6.32):
>>> 0000000: 8034 8033 8034 8034 8034 8034 8034 8034 .4.3.4.4.4.4.4.4
>>> 0000010: 8034 8033 8034 8034 8034 8034 8034 8033 .4.3.4.4.4.4.4.3
>>> 0000020: 8034 8034 8034 8034 8034 8034 8033 8032 .4.4.4.4.4.4.3.2
>>> 0000030: 8034 8035 8033 8034 8033 8034 8033 8034 .4.5.3.4.3.4.3.4
>>>
>>> n.b. these are grabbed from the same image on the camera, on the same
>>> board - either running the new media controller code (3.0+) or old TI
>>> PSP code (2.6.32)
>>>
>>> I've compared the CCDC registers between the two systems and they look
>>> pretty good to me (none of the differences explain the behaviour above)
>>>
>>> It looks to me like the 8 bit data coming into the CCDC is not being
>>> packed properly, as well as the second byte of each pair is being
>>> dropped.
>>>
>>> Any hints on where to look, what might be mis-configured, etc?
>>
>> Apart from that (i have the same issue) do you get the full 720
>> horizontal pixels?
>>
>> Because this is what i get:
>>
>> http://imageshack.us/f/215/newkernel0.png/
>>
>> It's not simply "stretched", the right part is missing. Did you change
>> some ccdc parameters in the files i sent you?
>
> This is precisely what I see. If you look at the raw UYVY data as
> I did, you'll see that 1/2 of the data is being lost. It looks like
> there is some setup wrong in how the data is being moved from the CCDC
> to memory but I don't know enough about the code to know where that
> might be configured.
>

Note: I just saw a set of patches for exactly this CCDC with BT656
support on the Linux-OMAP mailing list.  I'll look at them to see
if they are anything different from what Laurent provided.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
