Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:60463 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab2CUHwu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 03:52:50 -0400
Message-ID: <4F6988B8.3090002@schinagl.nl>
Date: Wed, 21 Mar 2012 08:52:24 +0100
From: Oliver Schinagl <oliver@schinagl.nl>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] Basic AF9035/AF9033 driver
References: <201202222321.43972.hfvogt@gmx.net> <4F67CF24.8050601@redhat.com> <20120320140411.58b5808b@milhouse> <4F68B001.1050809@gmail.com>
In-Reply-To: <4F68B001.1050809@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 20-03-12 17:27, Gianluca Gennari wrote:
> Hi Michael,
>
> Il 20/03/2012 14:04, Michael Büsch ha scritto:
>> Thank you for working on a af903x driver.
>>
>> I tried to test the driver on a debian 3.2 kernel, after applying a small fix:
>> It should be CONFIG_DVB_USB_AF903X here.
> this issue is fixed in version "1.02" of the driver, posted by Hans a
> few days ago.
>
>> So I'm wondering how big the differences between the fc0011 and fc0012 are.
>> Can the 0011 be implemented in the 0012 driver, or does it require a separate driver?
>> Please give me a few hints, to I can work on implementing support for that tuner.
> I have no idea about the real differences between the two tuner models,
> but here you can find an old "leaked" af9035 driver with support for
> several tuners, including fc0011 and fc0012:
>
> https://bitbucket.org/voltagex/af9035/src
I also have a git repository, http://git.schinagl.nl/AF903x_SRC.git 
which should work with recent kernels. I haven't tested it extensively 
however, seeing what this new AF9035 driver will do for my stick :)
>
> (look under the "api" subdir for the tuners).
> The driver is not working with recent kernels, but probably you can
> extract the information needed to implement a proper kernel driver for
> fc0011, using the fc0012 driver written by Hans as a reference.
>
> Best regards,
> Gianluca
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
