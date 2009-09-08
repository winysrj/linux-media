Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2b.orange.fr ([80.12.242.145]:8258 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZIHSZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2009 14:25:14 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b12.orange.fr (SMTP Server) with ESMTP id D4FB47000088
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 20:25:15 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b12.orange.fr (SMTP Server) with ESMTP id C6B8C700008A
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 20:25:15 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-19-82.w92-135.abo.wanadoo.fr [92.135.50.82])
	by mwinf2b12.orange.fr (SMTP Server) with ESMTP id A08F17000088
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 20:25:15 +0200 (CEST)
Message-ID: <4AA6A18B.6060008@gmail.com>
Date: Tue, 08 Sep 2009 20:25:15 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com> <4AA69874.2080900@gmail.com>
In-Reply-To: <4AA69874.2080900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Morvan Le Meut a écrit :
> new problem, maybe not related but  : i've no sound anymore.
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
eh, for some reason, saa7131_alsa was preventing snd_hda_intel from 
creating a /dev/dsp device ( " hda-intel: Error creating card!" )



