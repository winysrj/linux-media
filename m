Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:42506 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab0FWQJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jun 2010 12:09:24 -0400
Message-ID: <4C2231A1.9020104@kolumbus.fi>
Date: Wed, 23 Jun 2010 19:09:05 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: buffer management
References: <AANLkTikuPBKre8wjkGZ-fXhQc5ad_OmNtERvFslpPXvR@mail.gmail.com> <4C220165.50809@kernellabs.com>
In-Reply-To: <4C220165.50809@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

23.06.2010 15:43, Steven Toth kirjoitti:
>> Now, on each video interrupt, I know which SG list i need to read
>> from. At this stage i do need to copy the
>> buffers associated with each of the SG lists at once. In this
>> scenario, I don't see how videobuf could be used,
>> while I keep getting this feeling that a simple copy_to_user of the
>> entire buffer could do the whole job in a
>> better way, since the buffers themselves are already managed and
>> initialized already. Am I correct in thinking
>> so, or is it that I am overlooking something ?

How to activate DMA transfers only if there is empty space for the DMA 
transfer?

Regards,
Marko

>
> Manu,
>
> SAA7164 suffers from this. If you find a solution I'd love to hear it.
>
> Regards,
>
> - Steve
>

