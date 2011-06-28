Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37062 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab1F1Tt6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 15:49:58 -0400
Received: by wwg11 with SMTP id 11so3309715wwg.1
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 12:49:57 -0700 (PDT)
From: Bogdan Cristea <cristeab@gmail.com>
To: linux-media@vger.kernel.org
Subject: Patch proposition for DVB-T configuration file for Paris area
Date: Tue, 28 Jun 2011 21:47:03 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3+iCOXgIulcX5Ur"
Message-Id: <201106282147.03423.cristeab@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_3+iCOXgIulcX5Ur
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I would like to propose the attached patch for de DVB-T configuration file for 
Paris area (found in openSUSE 11.4 in this location)
/usr/share/dvb/dvb-t/fr-Paris

With the current configuration file only 5 channels are found, while in 
reality there are almost 35 channels.

regards
-- 
Bogdan Cristea
Embedded Software Engineer
Philog
46 rue d'Amsterdam
75009 Paris, France
tel: +33 (0)6 21 64 15 81
web: http://sites.google.com/site/cristeab/

--Boundary-00=_3+iCOXgIulcX5Ur
Content-Type: text/x-patch;
  charset="UTF-8";
  name="fr-Paris.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="fr-Paris.patch"

8,23c8,19
< #R1: France 3, France 2, France 5, LCP, France =C3=B4
< #R2: Direct 8, BFM TV, i>TELE, DirectStar, Gulli, France 4
< #R3: CANAL+, CANAL+ CINEMA, CANAL+ SPORT, PLANETE, TPS STAR
< #R4: ARTE HD, PARIS PREMIERE, M6, W9, NT1
< #R5: TF1 HD, France 2 HD, M6HD
< #R6: TF1, NRJ12, Eurosport, LCI, TMC, TF6, ARTE
< #Local: Canal 21, IDF1, NRJ Paris, BFM Business Paris
<=20
< T 585834000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
< T 505834000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
< T 481834000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
< T 545834000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
< T 529834000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
< T 561834000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
< T 569834000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
<=20
=2D--
> T 474166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 538166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
> T 714166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
> T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 754166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 762166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 786166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 810166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

--Boundary-00=_3+iCOXgIulcX5Ur--
