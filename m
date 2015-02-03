Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:53627 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966332AbbBCTxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 14:53:22 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so47054021wev.12
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 11:53:21 -0800 (PST)
Message-ID: <54D12722.5080507@gmail.com>
Date: Tue, 03 Feb 2015 19:53:06 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] lmedm04: add read snr, signal strength and ber call
 backs
References: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>	<1420206991-3939-5-git-send-email-tvboxspy@gmail.com>	<20150203171921.2afa629c@recife.lan>	<54D12204.4030403@gmail.com> <20150203174438.3832d42d@recife.lan>
In-Reply-To: <20150203174438.3832d42d@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/02/15 19:44, Mauro Carvalho Chehab wrote:
> Em Tue, 03 Feb 2015 19:31:16 +0000
> Malcolm Priestley <tvboxspy@gmail.com> escreveu:
>
>>
>>
>> On 03/02/15 19:19, Mauro Carvalho Chehab wrote:
>>> Em Fri,  2 Jan 2015 13:56:31 +0000
>>> Malcolm Priestley <tvboxspy@gmail.com> escreveu:
>>>
>>>> This allows calling the original functions providing the streaming is off.
>>>
>>> Malcolm,
>>>
>>> I'm applying this patch series, as the driver has already some support for
>>> the legacy DVBv3 stats, but please port it to use DVBv5.
>> Hi Mauro,
>>
>> I am not sure what you mean by this?
>
> The DVB API version 3 has some issues with stats. The main one is that
> they don't provide any glue to userspace about what scale they use.
> Due to that, we've added a new API at DVB. We're gradually adding
> support for that on the already existing drivers.
>
>> Are there any examples?
>
> Yes. You can see, for example:

Thanks

Malcolm
>
> $ git lg drivers/media/dvb-frontends/ |grep stats
> 906aaf5a195b [media] dvb:tc90522: fix stats report
> 1d0ceae4a19d [media] af9033: wrap DVBv3 UCB to DVBv5 UCB stats
> 041ad449683b [media] dib7000p: Add DVBv5 stats support
> d591590e1b5b [media] drx-j: enable DVBv5 stats
> 6983257813dc [media] drx-j: properly handle bit counts on stats
> 03fdfbfd3b59 [media] drx-j: Prepare to use DVBv5 stats
> 704f01bbc7e4 [media] dib8000: be sure that stats are available before reading them
> 7a9d85d5559f [media] dib8000: Fix UCB measure with DVBv5 stats
> 6ef06e78c74c [media] dib8000: add DVBv5 stats
> 8f3741e02831 [media] drxk: Add pre/post BER and PER/UCB stats
> 8b8e444a2711 [media] mb86a20s: Don't reset strength with the other stats
> 15b1c5a068e7 [media] mb86a20s: provide CNR stats before FE_HAS_SYNC
