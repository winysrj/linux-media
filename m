Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:48774 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751977Ab2HRNAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 09:00:01 -0400
Message-ID: <502F91CD.4070507@gmx.de>
Date: Sat, 18 Aug 2012 14:59:57 +0200
From: Reinhard Nissl <rnissl@gmx.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>, linux-media@vger.kernel.org
Subject: Re: STV0299: reading property DTV_FREQUENCY -- what am I expected
 to get?
References: <502A1221.8020804@gmx.de> <CAHFNz9KnwKuATLKwhH22znmWa8QP5tZN0KJHFu4fuf7RGES1Gw@mail.gmail.com> <502AB1D2.3070209@gmx.de> <502C1E53.4090103@redhat.com>
In-Reply-To: <502C1E53.4090103@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080604050603090206010500"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080604050603090206010500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Am 16.08.2012 00:10, schrieb Mauro Carvalho Chehab:
> The patch seems to be working. Anyway, for it to be merged, you'll
> need to be sending it together with your SOB (Signed-off-by),
> and using the -p1 format e. g. something like:
>
> --- a/drivers/media/dvb/frontends/stb0899_drv.c	2012-08-14 21:59:59.000000000 +0200
> +++ b/drivers/media/dvb/frontends/stb0899_drv.c	2012-08-14 21:29:17.000000000 +0200
>
> as otherwise developer's scripts won't get it right.

I hope I got it right this time ;-)

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de

--------------080604050603090206010500
Content-Type: text/x-patch;
 name="stb0899_drv-report-internal-freq-via-get_frontend-git.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="stb0899_drv-report-internal-freq-via-get_frontend-git.diff"

stb0899: return internally tuned frequency via get_frontend.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>

diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 5d7f8a9..79e29de 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -1563,6 +1563,7 @@ static int stb0899_get_frontend(struct dvb_frontend *fe)
 
 	dprintk(state->verbose, FE_DEBUG, 1, "Get params");
 	p->symbol_rate = internal->srate;
+	p->frequency = internal->freq;
 
 	return 0;
 }

--------------080604050603090206010500--
