Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0GaINH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 04:13:07 -0400
Date: 31 Jul 2010 10:10:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: maximlevitsky@gmail.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: mchehab@redhat.com
Message-ID: <BTtO1S1ZjFB@christoph>
In-Reply-To: <1280527264.3159.10.camel@maxim-laptop>
Subject: Re: [PATCH 10/13] IR: extend interfaces to support more device settings LIRC: add new IOCTL that enables learning mode (wide band receiver)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxim,

on 31 Jul 10 at 01:01, Maxim Levitsky wrote:
> On Fri, 2010-07-30 at 23:22 +0200, Christoph Bartelmus wrote:
[...]
>>> +#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
>>
>> If you really want this new ioctl, then it should be clarified how it
>> behaves in relation to LIRC_SET_MEASURE_CARRIER_MODE.

> In my opinion, I won't need the LIRC_SET_MEASURE_CARRIER_MODE,
> I would just optionally turn that on in learning mode.
> You disagree, and since that is not important (besides TX and learning
> features are present only at fraction of ENE devices. The only user I
> did the debugging with, doesn't seem to want to help debug that code
> anymore...)
>
> But anyway, in current state I want these features to be independent.
> Driver will enable learning mode if it have to.

Please avoid the term "learning mode" as to you it probably means  
something different than to me.

>
> I'll add the documentation.

>>
>> Do you have to enable the wide-band receiver explicitly before you can
>> enable carrier reports or does enabling carrier reports implicitly switch
>> to the wide-band receiver?
> I would implicitly switch the learning mode on, untill user turns off
> the carrier reports.

You mean that you'll implicitly switch on the wide-band receiver. Ok.

>>
>> What happens if carrier mode is enabled and you explicitly turn off the
>> wide-band receiver?
> Wouldn't it be better to have one ioctl for both after all?

There may be hardware that allows carrier measurement but does not have a  
wide-band receiver. And there may be hardware that does have a wide-band  
receiver but does not allow carrier measurement. irrecord needs to be able  
to distinguish these cases, so we need separate ioctls.

I'd say: carrier reports may switch on the wide-band reciever implicitly.  
In that case the wide-band receiver cannot be switched off explicitly  
until carrier reports are disabled again. It just needs to be documented.

>>
>> And while we're at interface stuff:
>> Do we really need LIRC_SETUP_START and LIRC_SETUP_END? It is only used
>> once in lircd during startup.
> I don't think so.
>

Christoph
