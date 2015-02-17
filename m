Return-path: <linux-media-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.155]:29619 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbbBQIGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 03:06:34 -0500
From: "Daniel Merritt" <daniel@merritt.id.au>
To: <linux-media@vger.kernel.org>
Subject: Updated DVB-T scan tables for Adelaide region
Date: Tue, 17 Feb 2015 18:36:29 +1030
Message-ID: <000001d04a88$a4e71640$eeb542c0$@merritt.id.au>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0001_01D04AE0.A775F680"
Content-Language: en-au
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0001_01D04AE0.A775F680
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Greetings,

I have attached a couple of updated scan tables for the two Adelaide
transmission areas:

* au-Adelaide (Australia / Adelaide / Mt Lofty)
* au-AdelaideFoothills (Australia / Adelaide / Grenfell Street)

A number of channels in the area underwent a final "retune" in late 2013 as
per http://myswitch.digitalready.gov.au. I have used these files
successfully with TvHeadend and confirmed the frequencies are correct.

Regards,
Daniel Merritt.

------=_NextPart_000_0001_01D04AE0.A775F680
Content-Type: application/octet-stream;
	name="au-Adelaide"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="au-Adelaide"

# Australia / Adelaide / Mt Lofty=0A=
# ABC=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 226500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 3/4=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/16=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# Seven=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 177500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 3/4=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/16=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# Nine=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 191500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 3/4=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/16=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# Ten=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 219500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 3/4=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/16=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# SBS=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 184500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 2/3=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/8=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# 44 Adelaide=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 564500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 2/3=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QPSK=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/8=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=

------=_NextPart_000_0001_01D04AE0.A775F680
Content-Type: application/octet-stream;
	name="au-AdelaideFoothills"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="au-AdelaideFoothills"

# Australia / Adelaide / Grenfell Street=0A=
# ABC=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 606500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 3/4=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/16=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# Seven=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 578500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 3/4=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/16=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# Nine=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 585500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 3/4=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/16=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# Ten=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 592500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 3/4=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/16=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=
# SBS=0A=
[CHANNEL]=0A=
	DELIVERY_SYSTEM =3D DVBT=0A=
	FREQUENCY =3D 571500000=0A=
	BANDWIDTH_HZ =3D 7000000=0A=
	CODE_RATE_HP =3D 2/3=0A=
	CODE_RATE_LP =3D NONE=0A=
	MODULATION =3D QAM/64=0A=
	TRANSMISSION_MODE =3D 8K=0A=
	GUARD_INTERVAL =3D 1/8=0A=
	HIERARCHY =3D NONE=0A=
	INVERSION =3D AUTO=0A=
=0A=

------=_NextPart_000_0001_01D04AE0.A775F680--


