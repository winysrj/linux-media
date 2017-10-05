Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:37288 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751299AbdJEHnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 03:43:46 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 91E0920C7F
        for <linux-media@vger.kernel.org>; Thu,  5 Oct 2017 09:43:44 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Date: Thu, 05 Oct 2017 09:43:42 +0200
From: Martin Kepplinger <martink@posteo.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: platform: coda: how to use firmware-imx binary
 =?UTF-8?Q?releases=3F?=
In-Reply-To: <1507108964.11691.6.camel@pengutronix.de>
References: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
 <1507108964.11691.6.camel@pengutronix.de>
Message-ID: <7dd05afd338e81d293d0424e0b8e6b6a@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.10.2017 11:22 schrieb Philipp Zabel:
> Hi Martin,
> 
> On Wed, 2017-10-04 at 10:44 +0200, Martin Kepplinger wrote:
>> Hi,
>> 
>> Commit
>> 
>>      be7f1ab26f42 media: coda: mark CODA960 firmware versions 2.3.10 
>> and 3.1.1 as supported
>> 
>> says firmware version 3.1.1 revision 46072 is contained in 
>> "firmware-imx-5.4.bin", that's probably
>> 
>>      sha1  78a416ae88ff01420260205ce1d567f60af6847e  firmware-imx-5.4.bin
> 
> Yes.
> 
>> How do I use this in order to get a VPU firmware blob that the coda 
>> platform driver can work with?
> 
> These are self-extracting shell scripts with an attached compressed tar
> archive. This particular file can be extracted by skipping the first
> 34087 bytes:
> 
> dd if=firmware-imx-5.4.bin bs=34087 skip=1 | tar xjv
> 

thanks!

>> (Maybe it'd be worth adding some short documentation on this. There 
>> doesn't seem to be a devicetree bindings doc for coda in 
>> Documentation/devicetree/bindings/media which would
>> be a good place for documenting how to use these binaries too)
> 
> Thank you for pointing this out, the device tree binding docs for coda
> are indeed missing.
> I'm not sure the device tree binding docs are the right place to
> document driver and firmware though. For that, adding a coda.rst entry
> to Documentation/media/v4l-drivers would probably be a better place.
> 

True. That'd be great. Some firmware-handling and maybe even firmware
version changelogs would definitely be useful.


I'm running a little off-topic here, but with the newest firmware too, 
my
coda driver says "Video Data Order Adapter: Disabled" when started
by video playback via v4l2.

(imx6, running linux 4.14-rc3, imx-vdoa is probed and never removed,
a dev_info "probed" would maybe be useful for others too?)

It supsequently fails with

cma: cma_alloc: alloc failed, req-size: 178 pages, ret: -12

which may or may not be related to having the vdoa (is it?), but 
shouldn't
the VDOA module be active by default?

# cat /sys/module/coda/parameters/disable_vdoa
0

thanks

                                 martin
