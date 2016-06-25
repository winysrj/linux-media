Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45331
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbcFYRvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 13:51:10 -0400
Date: Sat, 25 Jun 2016 14:51:04 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Nick Whitehead <nick@mistoffolees.me.uk>
Cc: linux-media@vger.kernel.org
Subject: Re: libdvbv5 EIT schedule reading
Message-ID: <20160625145104.185bf2d6@recife.lan>
In-Reply-To: <576EB7AE.5070502@mistoffolees.me.uk>
References: <576EB7AE.5070502@mistoffolees.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Jun 2016 17:56:14 +0100
Nick Whitehead <nick@mistoffolees.me.uk> escreveu:

> In using libdvbv5 to read off-air EIT (UK freeview), I find that to read 
> the full schedule one needs to rrad tables with TIDs 0x50 to 
> (potentially) 0x5f. However in descriptors.c only table 0x50 is given an 
> initialiser function, and so 0x51 onwards cannot be read as it stands.
> 
> Therefore I have made a small change to descriptors.c (attached) to to 
> add initialisers for 0x51-0x5f (and actually 0x60-0x6f). I have not used 
> the latter, but the former certainly allows me to read all future 
> events, whereas with 0x50 alone, could only read 3 days.

Good catch! Yeah, several table IDs were missing initialization, including
0x4F.

Added a fix on this patch:
	https://git.linuxtv.org/v4l-utils.git/commit/?id=3740ca0f500b916490b5b7b7f3ee493eb06cd092

Thanks,
Mauro
