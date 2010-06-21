Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:36520 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab0FUTCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 15:02:11 -0400
Message-ID: <4C1FB725.6070707@kolumbus.fi>
Date: Mon, 21 Jun 2010 22:01:57 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org,
	Manu Abraham <abraham.manu@gmail.com>,
	Ozan ?a?layan <ozan@pardus.org.tr>,
	Manu Abraham <manu@linuxtv.org>, stable@kernel.org
Subject: Re: [PATCH] Mantis, hopper: use MODULE_DEVICE_TABLE use the macro
 to  make modules auto-loadable
References: <1277110376-6993-1-git-send-email-bjorn@mork.no>	<AANLkTilghfY5tsC0V4m6IQ1VIFE-j-rB4i6Xi2mYevwV@mail.gmail.com> <87vd9c72id.fsf@nemi.mork.no>
In-Reply-To: <87vd9c72id.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

21.06.2010 19:51, Bjørn Mork wrote:
> VDR User<user.vdr@gmail.com>  writes:
>
>    
>> Instead of copy&paste patches from Manu's tree, maybe it's better to
>> just wait for him to push all the changes into v4l.
>>      
>    

I'm Manu sorry about trying to put patches directly into v4-dvb, if 
those should go onto your branch first.

So, what Manu do you think about my DMA patch or other patches I sent 
into linux-media mailing list this weekend?
Is it okay to generate one interrupt once per 16k bytes,
or are the interrupts too rare?

At least VDR reads the DVB stream rarely, so I think
that it is enough if the DVB card has always something
to be delivered when VDR or MythTV asks more data,
so if the number of DMA transfer IRQs is twice than the
number of times VDR or MythTV asks more data per second,
then the context switches are in balance.

Understandable DMA RISC programming should be easier to maintain, and it 
removes the initial garbage from the stream too.

How about the tasklet enable/disable patch I wrote?

What needs to be done for these patches to be accepted?

Best regards,
Marko


