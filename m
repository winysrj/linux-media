Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:30645 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab0FBL2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jun 2010 07:28:18 -0400
Received: by fg-out-1718.google.com with SMTP id l26so1602605fgb.1
        for <linux-media@vger.kernel.org>; Wed, 02 Jun 2010 04:28:17 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: "Davor Emard" <davoremard@gmail.com>
Cc: semiRocket <semirocket@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
References: <op.vceiu5q13xmt7q@crni>
 <AANLkTinMYcgG6Ac73Vgdx8NMYocW8Net6_-dMC3yEflQ@mail.gmail.com>
 <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni> <20100509173243.GA8227@z60m> <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m> <op.vcsntos43xmt7q@crni> <op.vc551isrndeod6@crni>
 <20100530234817.GA17135@emard.lan> <20100531075214.GA17456@lipa.lan>
Date: Wed, 02 Jun 2010 13:28:11 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: semiRocket <semirocket@gmail.com>
Message-ID: <op.vdn7g9nj3xmt7q@crni>
In-Reply-To: <20100531075214.GA17456@lipa.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 May 2010 09:52:14 +0200, Davor Emard <davoremard@gmail.com>  
wrote:

> HI!
>
> I just went to compro website and have seen that *f cards
> have some identical MCE-alike but also slightly different remotes,
> so we have to invent some better names to distinguish between
> them (compro itself might have some names for them)
>
> d.

Hi,


Tested your new patch with Gerd's input-events utility. input-events is  
reporting wrong key (KEY_MIN_INTERESTING) for KEY_MUTE, not sure why.

input-events is reporting ??? for all KEY_NUMERIC_*.


Perhaps you could use KEY_PREVIOUS and KEY_NEXT instead of  
KEY_PREVIOUSSONG and KEY_NEXTSONG.

For the naming you could use K100

     http://www.comprousa.com/en/pctv_remote.php

Lirc has definitions for K300 and it seems that it's using totally  
different codes:
     http://lirc.sourceforge.net/remotes/compro/VideoMate-K300

So I think too this would be a better naming sheme.


Regards,
Samuel
