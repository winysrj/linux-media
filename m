Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:45653 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2C1RT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 13:19:29 -0400
From: "EricJCh.Aubert" <ericjch.aubert@orange.fr>
To: linux-media@vger.kernel.org
Subject: update to file fr-Paris for DVB-T corrected
Date: Wed, 28 Mar 2012 19:18:58 +0200
Message-ID: <1706979.NJtO1a2JFt@linux>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1621382.tLakN1j2ix"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1621382.tLakN1j2ix
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi
I've made a mistake in my previous file fr-Paris for R8 due to a bad compute
it's not 700   but 770!
here is the file with the correct values

Rgds
-- 
Eric Aubert

ericjch.aubert@orange.fr
--nextPart1621382.tLakN1j2ix
Content-Disposition: attachment; filename="fr-Paris"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="fr-Paris"

# Paris - France - various DVB-T transmitters
# contributed by Alexis de Lattre <alexis@via.ecp.fr>
#
# update by Eric Aubert <ericjch.aubert@orange.fr>
# date march 2012
#
# City                       R1 R2 R3 R4 R5 R6 L8 R7* R8*
# Paris - Tour Eiffel      : 35 25 22 30 28 32 33 42  58
# Paris Est - Chennevi=C3=A8res : 35 25 22 30 28 32    42  58=20
# Paris Nord - Sannois     : 35 25 22 30 28 32    42  58=20
# Paris Sud - Villebon     : 35 25 22 30 28 32    42  58=20
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarch=
y
#R3 (Canal+ HD,Canal+ Cin=C3=A9ma,Canal+ Sport,Plan=C3=A8te,TPS Star)
T 482166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
#R2 (I-T=C3=A9l=C3=A9,BFM TV,Direct 8,Gulli,Virgin 17,France 4)
T 506166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
#R3 (Canal+ HD,Canal+ Cin=C3=A9ma,Canal+ Sport,Plan=C3=A8te,TPS Star)
T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
#R5 (TF1 HD,France 2 HD,M6 HD)
T 530166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
#R4 (M6,W9,NT1,Paris Premi=C3=A8re,ARTE HD)
T 546166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
#R6 (TF1,LCI,Eurosport,TF6,NRJ 12,TMC)
T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
### Paris - Tour Eiffel      : 33
#L8 (cha=C3=AEnes locales)
T 570166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
#R1 (France 2,France 3,France 5,Arte,LCP/Public S=C3=A9nat,France =C3=94=
)
T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
#R7*
T 642166000 8MHz 3/4 NONE QAM64 8k 1/32 NONE
#R8*
T 770166000 8MHz 3/4 NONE QAM64 8k 1/32 NONE

--nextPart1621382.tLakN1j2ix--

