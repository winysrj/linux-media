Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62515 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaCFD2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 22:28:54 -0500
Received: by mail-ob0-f180.google.com with SMTP id wn1so1989036obc.11
        for <linux-media@vger.kernel.org>; Wed, 05 Mar 2014 19:28:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5317D9B4.1080405@samsung.com>
References: <187b01cf385bb9b4510$%debski@samsung.com>
	<1394017710-671-1-git-send-email-sw0312.kim@samsung.com>
	<CAK9yfHx_yx9qvitSGfNZWJfRK1ZtrOu3VdhJh-aEZ4LNv_8Z-A@mail.gmail.com>
	<5317D9B4.1080405@samsung.com>
Date: Thu, 6 Mar 2014 08:58:53 +0530
Message-ID: <CAK9yfHx0o2n7fPvPeMHmMoLrP+ZifkP2uCitpatY8pFG-hDxCA@mail.gmail.com>
Subject: Re: [PATCH] [media] s5-mfc: remove meaningless memory bank assignment
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Seung-Woo,

On 6 March 2014 07:43, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> Hello Sachin,
>
> On 2014년 03월 05일 20:42, Sachin Kamat wrote:
>> On 5 March 2014 16:38, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
>
> (...)
>
>>> -       dev->bank1 = dev->bank1;
>>
>> Are you sure this isn't some kind of typo? If not then your commit
>> description is too verbose
>> to actually say that the code is redundant and could be removed. The
>> code here is something like
>>
>>  a = a;
>>
>> which does not make sense nor add any value and hence redundant and
>> could be removed.
>
> Right, this meaningless code can be simply removed as like the first
> version. Anyway this redundant made from change of address type in
> earlier patch. So I tried to describe that.

What Kamil meant was that it is not a good practice to leave the
commit description
blank however trivial the patch might be. So a single line stating the
obvious should
be sufficient in this case.

-- 
With warm regards,
Sachin
