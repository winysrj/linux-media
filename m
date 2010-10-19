Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37998 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0JSQFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 12:05:41 -0400
Received: by pwj4 with SMTP id 4so569373pwj.19
        for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 09:05:41 -0700 (PDT)
Message-ID: <4CBDC1CC.6030704@gmail.com>
Date: Tue, 19 Oct 2010 14:05:32 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Florent AUDEBERT <florent.audebert@anevia.com>,
	abraham.manu@gmail.com
CC: linux-media@vger.kernel.org,
	Florent Audebert <faudebert@anevia.com>
Subject: Re: [PATCH] stb0899: Removed an extra byte sent at init on DiSEqC
 bus
References: <4C125DD5.6060604@anevia.com> <4CBD9543.2050107@anevia.com>
In-Reply-To: <4CBD9543.2050107@anevia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-10-2010 10:55, Florent AUDEBERT escreveu:
> On 06/11/2010 06:01 PM, Florent AUDEBERT wrote:
>> I noticed a stray 0x00 at init on DiSEqC bus (KNC1 DVB-S2) with a DiSEqC
>> tool analyzer.
>>
>> I removed the register from initialization table and all seem to go well
>> (at least for my KNC board).
> 
> Hi,
> 
> This old small patch had been marked superseded on patchwork[1].
> 
> Is there an non-obvious case when patches go superseded ? Perhaps I missed
> something but it seems to me no other patch replaced it.

This is one of the bad things with patchwork: there's no "reason" field associated
to a status change, nor it marks when the status were changed.

A search on my linux-media box, showed that this patch were there, waiting for
Manu review, at the email I sent on Jul, 6 2010. The patch still applies, and
I didn't find any reply from Manu giving any feedback about it.

So, I'm re-tagging it as under review.

Manu, any comments about this patch (and the other remaining patches that we're
waiting fro your review) ?

> 
> 
> Regards,
> 
> 
> [1] https://patchwork.kernel.org/patch/105621/
> 

Cheers,
Mauro
