Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2a.orange.fr ([80.12.242.140]:56265 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZIIO5p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2009 10:57:45 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2a24.orange.fr (SMTP Server) with ESMTP id 634EF80000B8
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 16:57:44 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2a24.orange.fr (SMTP Server) with ESMTP id 56A1980000E3
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 16:57:44 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-42-204.w86-214.abo.wanadoo.fr [86.214.145.204])
	by mwinf2a24.orange.fr (SMTP Server) with ESMTP id CAFB480000B8
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 16:57:43 +0200 (CEST)
Message-ID: <4AA7C266.3000509@gmail.com>
Date: Wed, 09 Sep 2009 16:57:42 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com> <op.uzzfgyvj3xmt7q@crni> <4AA77240.2040504@gmail.com> <4AA77683.7010201@gmail.com>
In-Reply-To: <4AA77683.7010201@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

just out of curiosity, what's the difference between
"case SAA7134_BOARD_ADS_INSTANT_TV:
        dev->has_remote = SAA7134_REMOTE_GPIO;
        break; "
and
"case SAA7134_BOARD_FLYDVBS_LR300:
        saa_writeb(SAA7134_GPIO_GPMODE3, 0x80);
        saa_writeb(SAA7134_GPIO_GPSTATUS2, 0x40);
        dev->has_remote = SAA7134_REMOTE_GPIO;
        break; "
?

could it be that the repeating keys come from not using that saa_writeb 
thing ?

Morvan Le Meut a écrit :
> wait, from that webpage, the gpio would be different for each key, 
> independently from the mask, so my previous attempt with ir_debug=1 
> means that the gpio itself is read incorrectly .. :(
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



