Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:60434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab1EMG5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 02:57:49 -0400
Message-ID: <4DCCD66C.5000600@infradead.org>
Date: Fri, 13 May 2011 08:57:48 +0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manoel PN <pinusdtv@hotmail.com>
CC: linux-media@vger.kernel.org, lgspn@hotmail.com
Subject: Re: [PATCH 2/4] Modifications to the driver mb86a20s
References: <BLU157-w550E2F1986AB3A248199C0D8880@phx.gbl>
In-Reply-To: <BLU157-w550E2F1986AB3A248199C0D8880@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-05-2011 04:05, Manoel PN escreveu:
> 
> This patch implements mb86a20s_read_snr and adds mb86a20s_read_ber and mb86a20s_read_ucblocks both without practical utility but that programs as dvbsnoop need.

Please try to align comments into up to 75 columns. It looks nicer
when people look it into git. Also, please avoid using "This patch",
as it provides no information.

I suggest you to take a look at those kernel guides (there are more 
good stuff for developers at the kernel trees, but those are the 
minimal stuff that a developer should know when submitting a patch):

http://git.linuxtv.org/media_tree.git?a=blob;f=Documentation/SubmittingPatches;h=689e2371095cc5dfea9927120009341f369159aa;hb=HEAD
http://git.linuxtv.org/media_tree.git?a=blob_plain;f=Documentation/CodingStyle;hb=HEAD

> 
> 
> Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
> 
> 
>  		 	   		  
You forgot to attach the patch.
