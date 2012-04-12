Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:42318 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab2DLMoC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 08:44:02 -0400
Message-ID: <4F86CE09.3080601@schinagl.nl>
Date: Thu, 12 Apr 2012 14:43:53 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com> <4F804CDC.3030306@gmail.com> <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com> <4F85D787.2050403@iki.fi> <4F85F89A.80107@schinagl.nl> <4F85FE63.1030700@iki.fi> <4F86C66A.4010404@schinagl.nl> <CAKZ=SG8gHbnRGFrajp2=Op7x52UcMT_5CFM5wzgajKCXkggFtA@mail.gmail.com>
In-Reply-To: <CAKZ=SG8gHbnRGFrajp2=Op7x52UcMT_5CFM5wzgajKCXkggFtA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I accept the challenge :p but where is your fc2580 driver? And in that 
thought, where is antti's stub driver :)

That might help me get started :)

On 12-04-12 14:18, Thomas Mair wrote:
> Hi Oliver,
>
> the Realtek driver sources I have also contain a fc2580 driver. Maybe
> the source code will help you together with the usb sniff.
>
> 2012/4/12 Oliver Schinagl<oliver+list@schinagl.nl>:
>> Would love to,  even tried a bit, but don't really know how to start, what
>> to use as a template. I think I can extract the i2c messages from the
>> dreaded ugly af903 driver however, using src or usbsniff.
>>
>> On 11-04-12 23:57, Antti Palosaari wrote:
>>> On 12.04.2012 00:33, Oliver Schinagl wrote:
>>>> On 04/11/12 21:12, Antti Palosaari wrote:
>>>>> I have some old stubbed drivers that just works for one frequency using
>>>>> combination of RTL2832U + FC2580. Also I have rather well commented USB
>>>>> sniff from that device. I can sent those if you wish.
>>>>>
>>>> FC2580? Do you have anything for/from that driver? My USB stick as an
>>>> AFA9035 based one, using that specific tuner.
>>>
>>> Nothing but stubbed driver that contains static register values taken from
>>> the sniff and it just tunes to one channel (IIRC 634 MHz / 8 MHz BW).
>>>
>>> Feel free to contribute new tuner driver in order to add support for your
>>> AF9035 device.
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

