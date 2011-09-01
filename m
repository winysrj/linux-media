Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588Ab1IAOb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Sep 2011 10:31:27 -0400
Message-ID: <4E5F9738.3080604@redhat.com>
Date: Thu, 01 Sep 2011 11:31:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: goffa72@gmail.com
CC: Thierry Reding <thierry.reding@avionic-design.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 02/21] [media] tuner/xc2028: Fix frequency offset for
 radio mode.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-3-git-send-email-thierry.reding@avionic-design.de> <4E5E7E2B.90603@redhat.com> <20110901051037.GB18473@avionic-0098.mockup.avionic-design.de> <4E5F7E71.5010209@aapt.net.au>
In-Reply-To: <4E5F7E71.5010209@aapt.net.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-09-2011 09:45, Andrew Goff escreveu:
> Hi Thierry,
> 
> I have been having problems with the radio tuner in my leadtek 1800h card. This card has the xc2028 tuner. Using fmtools i would get an error message similar to - frequency out of range 0.0 - 0.0.

This is due to a bug at the tuner core.

> After seeing you patches at the beginning of last month I installed the recent drivers at the time and applied your patches. The frequency out of range error went away but the only sound I got was static. I then discovered the frequency is out by 2.7MHz, so if I want to listen to 104.9 I need to tune the radio to 107.6.

Try to remove Thierry xc3028 patch. His patches were applied already at the main tree
(I applied them very early today).

> 
> On Ubuntu 10.04 the card works fine, the errors started when applying the recent V4L drivers that I require for another card.
> 
> Are you able to help resolve this problem and get this card working properly again.
> 
> Thanks
> 
> Andrew
> 
> 
> 
> On 1/09/2011 3:10 PM, Thierry Reding wrote:
>> * Mauro Carvalho Chehab wrote:
>>> Em 04-08-2011 04:14, Thierry Reding escreveu:
>>>> In radio mode, no frequency offset is needed. While at it, split off the
>>>> frequency offset computation for digital TV into a separate function.
>>>
>>> Nah, it is better to keep the offset calculation there. there is already
>>> a set_freq for DVB. breaking the frequency logic even further seems to
>>> increase the driver's logic. Also, patch is simpler and easier to review.
>>
>> Okay, no problem. Feel free to replace the patch with yours.
>>
>>> The patch bellow seems to be better. On a quick review, I think that the
>>>     send_seq(priv, {0x00, 0x00})
>>> sequence may be wrong. I suspect that the device is just discarding that,
>>> but changing it needs more testing.
>>
>> I ran across that as well, but I didn't dare touch it because I wasn't sure
>> what the broader impact would be.
>>
>> Thierry

