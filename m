Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab0CXOyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 10:54:36 -0400
Message-ID: <4BAA279F.6050505@redhat.com>
Date: Wed, 24 Mar 2010 11:54:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: "'Aguirre, Sergio'" <saaguirre@ti.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Subject: Re: [PATCH v2] v4l: videobuf: code cleanup.
References: <1268831061-307-1-git-send-email-p.osciak@samsung.com> <1268831061-307-2-git-send-email-p.osciak@samsung.com> <A24693684029E5489D1D202277BE894454137086@dlee02.ent.ti.com> <001001cac5dc$4407f690$cc17e3b0$%osciak@samsung.com> <4BA130A3.6060203@redhat.com>
In-Reply-To: <4BA130A3.6060203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Pawel Osciak wrote:
>>> Aguirre, Sergio wrote:
>>>> Make videobuf pass checkpatch; minor code cleanups.
>>> I thought this kind patches were frowned upon..
>>>
>>> http://www.mjmwired.net/kernel/Documentation/development-process/4.Coding#41
>>>
>>> But maybe it's acceptable in this case... I'm not an expert on community policies :)
>> Hm, right...
>> I'm not an expert either, but it does seem reasonable. It was just a part of the
>> roadmap we agreed on in Norway, so I simply went ahead with it. Merging with other
>> patches would pollute them so I just posted it separately. I will leave the
>> decision up to Mauro then. I have some more "normal" patches lined up,
>> so please let me know. I'm guessing we are cancelling the clean-up then though.
> 
> It is fine for me to send such patch in a series of changes. A pure CodingStyle patch
> is preferred if you're doing lots of changes, since it is very easy to review those
> changes. Yet, I generally hold pure CodingStyle changes to happen at the end of an
> rc cycle, to avoid conflicts with real patches, especially when the change is on a
> code that use to have lots of changes during a kernel cycle.
> 
> In the specific case of videobuf, I prefer to merge any changes functional changes at the
> beginning of a -rc cycle, and after having several tested-by replies with different
> architectures and boards, as a trouble there will affect almost all drivers.

I'm applying this CodingStyle fix to the tree. Better applying it sooner than later.

Cheers,
Mauro
