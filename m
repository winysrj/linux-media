Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab0G2RSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 13:18:06 -0400
Date: 29 Jul 2010 19:05:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: maximlevitsky@gmail.com
Cc: jarod@wilsonet.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: mchehab@redhat.com
Message-ID: <BTlN2YnZjFB@christoph>
In-Reply-To: <1280417227.29938.60.camel@maxim-laptop>
Subject: Re: [PATCH 5/9] IR: extend interfaces to support more device settings
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxim,

on 29 Jul 10 at 18:27, Maxim Levitsky wrote:
> On Thu, 2010-07-29 at 09:25 +0200, Christoph Bartelmus wrote:
>> Hi!
>>
>> Maxim Levitsky "maximlevitsky@gmail.com" wrote:
>>
>>> Also reuse LIRC_SET_MEASURE_CARRIER_MODE as LIRC_SET_LEARN_MODE
>>> (LIRC_SET_LEARN_MODE will start carrier reports if possible, and
>>> tune receiver to wide band mode)
>>
>> I don't like the rename of the ioctl. The ioctl should enable carrier
>> reports. Anything else is hardware specific. Learn mode gives a somewhat
>> wrong association to me. irrecord always has been using "learn mode"
>> without ever using this ioctl.

> Why?

If an ioctl enables/disables measuring of the carrier, then call it  
LIRC_SET_MEASURE_CARRIER_MODE and not LIRC_SET_LEARN_MODE.

Whether we need a LIRC_ENABLE_WIDE_BAND_RECEIVER ioctl is another  
question.

> Carrier measure (if supported by hardware I think should always be
> enabled, because it can help in-kernel decoders).

That does not work in the real-world scenario. All receivers with a high  
range demodulate the signal and you won't get the carrier.

[...]
> Another thing is reporting these results to lirc.
> By default lirc shouldn't get carrier reports, but as soon as irrecord
> starts, it can place device in special mode that allows it to capture
> input better, and optionally do carrier reports.

And that's what LIRC_SET_MEASURE_CARRIER_MODE is made for.

> Do you think carrier reports are needed by lircd?

No.

Christoph
