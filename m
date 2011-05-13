Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:58124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab1EMH1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 03:27:14 -0400
Message-ID: <4DCCDD51.1030709@infradead.org>
Date: Fri, 13 May 2011 09:27:13 +0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manoel PN <pinusdtv@hotmail.com>
CC: linux-media@vger.kernel.org, lgspn@hotmail.com
Subject: =?windows-1256?Q?Re=3A_=5BPATCH_4/4=5D_Modifications_to_?=
 =?windows-1256?Q?the_driver_mb86a20s=FE=FE?=
References: <BLU157-w51A0D0CDE5F2B0061ACA23D8880@phx.gbl>
In-Reply-To: <BLU157-w51A0D0CDE5F2B0061ACA23D8880@phx.gbl>
Content-Type: text/plain; charset=windows-1256
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-05-2011 04:13, Manoel PN escreveu:
> 
> 
> This patch implement changes to the function mb86a20s_read_signal_strength.
> 
> The original function, binary search, does not work with device dtb08.

Hmm... that's interesting. Maybe due to a different mb86a20s chip stepping?

> 
> I would like to know if this function works.

I'll test it when I return back to Brazil.

Please send this patch in separate, as a RFC, and keep both methods enabled,
printing debug messages. This way, I can test it with the two devices I have,
comparing the SNR relations provided by both ways.

Thanks,
Mauro.
