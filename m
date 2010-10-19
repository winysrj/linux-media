Return-path: <mchehab@pedra>
Received: from ns2011.yellis.net ([79.170.233.11]:47060 "EHLO
	vds2011.yellis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab0JSNCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 09:02:30 -0400
Message-ID: <4CBD9543.2050107@anevia.com>
Date: Tue, 19 Oct 2010 14:55:31 +0200
From: Florent AUDEBERT <florent.audebert@anevia.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: abraham.manu@gmail.com, Florent Audebert <faudebert@anevia.com>
Subject: Re: [PATCH] stb0899: Removed an extra byte sent at init on DiSEqC
 bus
References: <4C125DD5.6060604@anevia.com>
In-Reply-To: <4C125DD5.6060604@anevia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/11/2010 06:01 PM, Florent AUDEBERT wrote:
> I noticed a stray 0x00 at init on DiSEqC bus (KNC1 DVB-S2) with a DiSEqC
> tool analyzer.
> 
> I removed the register from initialization table and all seem to go well
> (at least for my KNC board).

Hi,

This old small patch had been marked superseded on patchwork[1].

Is there an non-obvious case when patches go superseded ? Perhaps I missed
something but it seems to me no other patch replaced it.


Regards,


[1] https://patchwork.kernel.org/patch/105621/

-- 
Florent AUDEBERT
