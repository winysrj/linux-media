Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:53934 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdJEQAd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 12:00:33 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id C5D3F20C05
        for <linux-media@vger.kernel.org>; Thu,  5 Oct 2017 18:00:31 +0200 (CEST)
Subject: Re: platform: coda: how to use firmware-imx binary releases?
To: Philipp Zabel <p.zabel@pengutronix.de>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org
References: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
 <1507218340.8473.19.camel@pengutronix.de>
From: Martin Kepplinger <martink@posteo.de>
Message-ID: <72c1247a-63db-3b69-7b46-ca424377b1c1@posteo.de>
Date: Thu, 5 Oct 2017 18:00:28 +0200
MIME-Version: 1.0
In-Reply-To: <1507218340.8473.19.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-05 17:45, Philipp Zabel wrote:
> On Wed, 2017-10-04 at 10:44 +0200, Martin Kepplinger wrote:
>> Hi,
>>
>> Commit
>>
>>      be7f1ab26f42 media: coda: mark CODA960 firmware versions 2.3.10
>> and 
>> 3.1.1 as supported
>>
>> says firmware version 3.1.1 revision 46072 is contained in 
>> "firmware-imx-5.4.bin", that's probably
>>
>>      sha1  78a416ae88ff01420260205ce1d567f60af6847e  firmware-imx-
>> 5.4.bin
>>
>> How do I use this in order to get a VPU firmware blob that the coda 
>> platform driver can work with?
>>
>>
>>
>> (Maybe it'd be worth adding some short documentation on this. There 
>> doesn't seem to be a devicetree bindings doc for coda in 
>> Documentation/devicetree/bindings/media 
> 
> I was mistaken, Documentation/devicetree/bindings/media/coda.txt exists.
> It was added in commit 657eee7d25fb ("media: coda: use genalloc API").

Right. Not greppable with "coda". If you've also missed it because of
that, it might likely help others when "coda" is mendtioned in it :)
