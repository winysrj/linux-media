Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp27.orange.fr ([80.12.242.96]:27381 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbZIIVAw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2009 17:00:52 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2726.orange.fr (SMTP Server) with ESMTP id 81E201C00097
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 23:00:54 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2726.orange.fr (SMTP Server) with ESMTP id 716B81C00092
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 23:00:54 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-42-204.w86-214.abo.wanadoo.fr [86.214.145.204])
	by mwinf2726.orange.fr (SMTP Server) with ESMTP id F1E6D1C00097
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 23:00:53 +0200 (CEST)
Message-ID: <4AA81785.5000806@gmail.com>
Date: Wed, 09 Sep 2009 23:00:53 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com> <op.uzzfgyvj3xmt7q@crni> <4AA77240.2040504@gmail.com> <4AA77683.7010201@gmail.com> <4AA7C266.3000509@gmail.com> <op.uzzz96se6dn9rq@crni> <4AA7E166.7030906@gmail.com>
In-Reply-To: <4AA7E166.7030906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't know if i mentioned it before but something i find strange is " 
saa7134 IR (ADS Tech Instant TV: unknown key: key=0x00 raw=0x00 down=1" 
as soon as the module is loaded.


Morvan Le Meut a écrit :
> i did try it ( well, i left the keyup and keydown part and i also 
> tried it by setting it to 0 ) but the gpio still repeat 
> ("saa7133[0]/ir: build_key gpio=0x1b mask=0x0 data=0" for Power and 
> Record, each followed by gpio=7f ).
> Which is why i believe i am missing part of that code ( got the dvb-t 
> version too on another computer, and given the software used, there 
> should be no duplicate keys ).
> I guess i will have to wait for someone to solve the problem. I can at 
> least use the remote in a "broken" way.
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>




