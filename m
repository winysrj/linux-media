Return-path: <linux-media-owner@vger.kernel.org>
Received: from beta.phas.ubc.ca ([142.103.236.75]:56765 "EHLO beta.phas.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965140AbaD2UjO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 16:39:14 -0400
Date: Tue, 29 Apr 2014 13:39:12 -0700 (PDT)
From: Carl Michal <michal@physics.ubc.ca>
To: Fabio Estevam <festevam@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: au0828 (950Q) kernel OOPS 3.10.30 imx6
In-Reply-To: <CAOMZO5DUGECOy8KTrrJzv5Aq2HW0LYtwP3VTwTmjQXLi5UXR7Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1404291337050.26512@spider.phas.ubc.ca>
References: <alpine.LNX.2.00.1404291241000.26512@spider.phas.ubc.ca> <CAOMZO5DUGECOy8KTrrJzv5Aq2HW0LYtwP3VTwTmjQXLi5UXR7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 29 Apr 2014, Fabio Estevam wrote:

> On Tue, Apr 29, 2014 at 4:50 PM, Carl Michal <michal@physics.ubc.ca> wrote:
>> Hello,
>>
>> I'm trying to use a Hauppage HVR-950Q ATSC tv stick with a Cubox-i running
>> geexbox.
>>
>> It works great, until it doesn't. After its been up and running for a few
>> hours (sometimes minutes), I start to get kernel OOPs, example pasted in
>> below. The 950Q generally doesn't work afterwards.
>>
>> This is a 3.10.30 kernel, that I believe the Cubox is somewhat tied to for
>> other driver reasons.
>>
>> I haven't seen any such problems if the HVR-950Q is unplugged.
>>
>> Any advice on tracking this down would be appreciated.
>>
>> Carl
>>
>>
>
> This comes from the Vivante GPU driver, which is not in mainline.
>
> Please try a 3.14.2 or 3.15-rc3 kernel instead.
> --

Some possibly stupid questions then:
is there support for the gpu 3.14.2? I haven't been able to find sources 
that obviously have it?

Thanks,

Carl
