Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab1GaEFZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 00:05:25 -0400
Message-ID: <4E34D481.1040302@redhat.com>
Date: Sun, 31 Jul 2011 01:05:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Istvan Varga <istvan_v@mailbox.hu>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.0] media updates for v3.1
References: <4E32EE71.4030908@redhat.com> <4E33C426.50000@mailbox.hu> <4E340F17.7020501@redhat.com> <4E3411D3.90703@mailbox.hu>
In-Reply-To: <4E3411D3.90703@mailbox.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-07-2011 11:14, Istvan Varga escreveu:
> On 07/30/2011 04:03 PM, Mauro Carvalho Chehab wrote:
> 
>> Btw, It may actually make sense to not allow using the PAL filter with a
>> NTSC source and vice-versa, e. g. reducing the notch filter to only 3
>> possible values:
>>
>>     0 - 4xFSC            (00)
>>     1 - square pixel        (01)
>>     2 - std-optimized filter    (10 or 11)
>>
>> Where 2 would man 10 for NTSC standard or 11 for PAL standard. I suspect,
>> however, that the std-optimized filter only works if the sampling frequency
>> is set to 27 MHz. However, at cx88 code, we set the sampling frequency to
>> be 8xFSC, instead of fixing it to 27MHz. Due to that, I doubt that the
>> PAL or NTSC optimized filters will give a good result. So, maybe we can change
>> it to just:
>>
>>     0 - 4xFSC
>>     1 - square pixel
>>
>> In other words, except if you found that the std-optimized filters are giving
>> better results, I would change the control to only select between 00 and 01,
>> and initialize it at device init, with 00.
> 
> OK, I have no problem with removing the standard optimized filters and
> restricting the control to 2 settings; I only used the square pixel one
> anyway, as I found it often looks better than the default filter.

Ok then. Please prepare the patches for that.

Thanks!
Mauro
