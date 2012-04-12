Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:41985 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab2DLMLe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 08:11:34 -0400
Message-ID: <4F86C66A.4010404@schinagl.nl>
Date: Thu, 12 Apr 2012 14:11:22 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com> <4F804CDC.3030306@gmail.com> <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com> <4F85D787.2050403@iki.fi> <4F85F89A.80107@schinagl.nl> <4F85FE63.1030700@iki.fi>
In-Reply-To: <4F85FE63.1030700@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Would love to,  even tried a bit, but don't really know how to start, 
what to use as a template. I think I can extract the i2c messages from 
the dreaded ugly af903 driver however, using src or usbsniff.

On 11-04-12 23:57, Antti Palosaari wrote:
> On 12.04.2012 00:33, Oliver Schinagl wrote:
>> On 04/11/12 21:12, Antti Palosaari wrote:
>>> I have some old stubbed drivers that just works for one frequency using
>>> combination of RTL2832U + FC2580. Also I have rather well commented USB
>>> sniff from that device. I can sent those if you wish.
>>>
>> FC2580? Do you have anything for/from that driver? My USB stick as an
>> AFA9035 based one, using that specific tuner.
>
> Nothing but stubbed driver that contains static register values taken 
> from the sniff and it just tunes to one channel (IIRC 634 MHz / 8 MHz 
> BW).
>
> Feel free to contribute new tuner driver in order to add support for 
> your AF9035 device.
>
> regards
> Antti

