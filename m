Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58696 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933284Ab2DKV55 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 17:57:57 -0400
Message-ID: <4F85FE63.1030700@iki.fi>
Date: Thu, 12 Apr 2012 00:57:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com> <4F804CDC.3030306@gmail.com> <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com> <4F85D787.2050403@iki.fi> <4F85F89A.80107@schinagl.nl>
In-Reply-To: <4F85F89A.80107@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.04.2012 00:33, Oliver Schinagl wrote:
> On 04/11/12 21:12, Antti Palosaari wrote:
>> I have some old stubbed drivers that just works for one frequency using
>> combination of RTL2832U + FC2580. Also I have rather well commented USB
>> sniff from that device. I can sent those if you wish.
>>
> FC2580? Do you have anything for/from that driver? My USB stick as an
> AFA9035 based one, using that specific tuner.

Nothing but stubbed driver that contains static register values taken 
from the sniff and it just tunes to one channel (IIRC 634 MHz / 8 MHz BW).

Feel free to contribute new tuner driver in order to add support for 
your AF9035 device.

regards
Antti
-- 
http://palosaari.fi/
