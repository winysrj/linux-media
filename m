Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44443 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab1IAMpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 08:45:51 -0400
Received: by ywf7 with SMTP id 7so1337079ywf.19
        for <linux-media@vger.kernel.org>; Thu, 01 Sep 2011 05:45:51 -0700 (PDT)
Message-ID: <4E5F7E71.5010209@aapt.net.au>
Date: Thu, 01 Sep 2011 22:45:37 +1000
From: Andrew Goff <goffa72@gmail.com>
Reply-To: goffa72@gmail.com
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 02/21] [media] tuner/xc2028: Fix frequency offset for
 radio mode.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-3-git-send-email-thierry.reding@avionic-design.de> <4E5E7E2B.90603@redhat.com> <20110901051037.GB18473@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20110901051037.GB18473@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

I have been having problems with the radio tuner in my leadtek 1800h 
card. This card has the xc2028 tuner. Using fmtools i would get an error 
message similar to - frequency out of range 0.0 - 0.0.

After seeing you patches at the beginning of last month I installed the 
recent drivers at the time and applied your patches. The frequency out 
of range error went away but the only sound I got was static. I then 
discovered the frequency is out by 2.7MHz, so if I want to listen to 
104.9 I need to tune the radio to 107.6.

On Ubuntu 10.04 the card works fine, the errors started when applying 
the recent V4L drivers that I require for another card.

Are you able to help resolve this problem and get this card working 
properly again.

Thanks

Andrew



On 1/09/2011 3:10 PM, Thierry Reding wrote:
> * Mauro Carvalho Chehab wrote:
>> Em 04-08-2011 04:14, Thierry Reding escreveu:
>>> In radio mode, no frequency offset is needed. While at it, split off the
>>> frequency offset computation for digital TV into a separate function.
>>
>> Nah, it is better to keep the offset calculation there. there is already
>> a set_freq for DVB. breaking the frequency logic even further seems to
>> increase the driver's logic. Also, patch is simpler and easier to review.
>
> Okay, no problem. Feel free to replace the patch with yours.
>
>> The patch bellow seems to be better. On a quick review, I think that the
>> 	send_seq(priv, {0x00, 0x00})
>> sequence may be wrong. I suspect that the device is just discarding that,
>> but changing it needs more testing.
>
> I ran across that as well, but I didn't dare touch it because I wasn't sure
> what the broader impact would be.
>
> Thierry
