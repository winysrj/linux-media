Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34677 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbbJUPei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 11:34:38 -0400
Received: by lbbwb3 with SMTP id wb3so41355406lbb.1
        for <linux-media@vger.kernel.org>; Wed, 21 Oct 2015 08:34:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.20.1510220119590.6421@namei.org>
References: <1445419340-11471-1-git-send-email-benjamin.gaignard@linaro.org>
	<1445419340-11471-2-git-send-email-benjamin.gaignard@linaro.org>
	<alpine.LRH.2.20.1510220119590.6421@namei.org>
Date: Wed, 21 Oct 2015 17:34:36 +0200
Message-ID: <CA+M3ks7xTRHFa30jT3180D1_EV=bEmb1Pk8d_A8PJbXnD0ddxg@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] create SMAF module
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: James Morris <jmorris@namei.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Cooksey <tom.cooksey@arm.com>,
	Daniel Stone <daniel.stone@collabora.com>,
	linux-security-module@vger.kernel.org,
	Xiaoquan Li <xiaoquan.li@vivantecorp.com>,
	Laura Abbott <labbott@redhat.com>,
	Tom Gall <tom.gall@linaro.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-10-21 16:32 GMT+02:00 James Morris <jmorris@namei.org>:
> On Wed, 21 Oct 2015, Benjamin Gaignard wrote:
>
>> Secure Memory Allocation Framework goal is to be able
>> to allocate memory that can be securing.
>> There is so much ways to allocate and securing memory that SMAF
>> doesn't do it by itself but need help of additional modules.
>> To be sure to use the correct allocation method SMAF implement
>> deferred allocation (i.e. allocate memory when only really needed)
>>
>> Allocation modules (smaf-alloctor.h):
>> SMAF could manage with multiple allocation modules at same time.
>> To select the good one SMAF call match() to be sure that a module
>> can allocate memory for a given list of devices. It is to the module
>> to check if the devices are compatible or not with it allocation
>> method.
>>
>> Securing module (smaf-secure.h):
>> The way of how securing memory it is done is platform specific.
>> Secure module is responsible of grant/revoke memory access.
>>
>
> This documentation is highly inadequate.

If you give hints I will try to complete it and make it acceptable.

>
> What does "allocate memory that can be securing" mean?

Maybe I could re-phrase it like that:
"Secure Memory Allocation Framework goal is to be able to allocate
memory that the platform can secure."

I'm trying to be generic here because each could have it own method to
secure buffers.

>
>
> --
> James Morris
> <jmorris@namei.org>
>



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
