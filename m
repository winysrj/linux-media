Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63818 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab0FELJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jun 2010 07:09:12 -0400
Received: by fxm8 with SMTP id 8so1253215fxm.19
        for <linux-media@vger.kernel.org>; Sat, 05 Jun 2010 04:09:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C07C851.2090107@orange.fr>
References: <4C07C851.2090107@orange.fr>
Date: Sat, 5 Jun 2010 13:09:11 +0200
Message-ID: <AANLkTilmj7sF7ERCORrnUs8vwVOMv0mc-byIYXTq6DjB@mail.gmail.com>
Subject: Re: New multiplex list for Boulogne sur mer / France
From: Christoph Pfister <christophpfister@gmail.com>
To: =?UTF-8?Q?Jean=2Dmichel_D=C3=A9champs?= <jean-michel-62@orange.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/6/3 Jean-michel Déchamps <jean-michel-62@orange.fr>:
> Hi,
>
> Since very first times of DVB-T at Boulogne sur mer / France, I tried to
> use fr-Boulogne regular lists for my scans (I'm a vdr user) but it
> worked very badly; as there was only one frequency correct.
> (DVB-T began in 2007 december here in Boulogne sur mer).
>     So i managed to create my own list, from the official channel
> numbers. So here following is the list i use since then; that works
> perfectly for me. I want to share this little thing with others ...

Updated, thanks!

Christoph


> Cheers
> Jean-michel Déchamps / Boulogne sur mer / France
>
>
> # Boulogne - France (DVB-T transmitter of Boulogne ( MontLambert ) )
> # Boulogne - France (signal DVB-T transmis depuis l'émetteur de MontLambert
> )
> #
> # Si vous constatez des problemes et voulez apporter des
> # modifications au fichier, envoyez le fichier modifie a
> # l'adresse linux-media@vger.kernel.org (depot des fichiers d'init dvb)
> #
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> #### Boulogne - MontLambert ####
> # (Boulogne sur mer)
> #R1
> T 530000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R2
> T 586000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R3
> T 634000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R4
> T 658000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R5
> T 698000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R6
> T 714000000 8MHz AUTO NONE QAM64 8k AUTO NONE
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
