Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward2h.mail.yandex.net ([84.201.187.147]:40362 "EHLO
	forward2h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab2HQRwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 13:52:42 -0400
From: CrazyCat <crazycat69@yandex.ru>
To: Antti Palosaari <crope@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <502D37CF.7030608@iki.fi>
References: <53381345139167@web11e.yandex.ru> <502D37CF.7030608@iki.fi>
Subject: Re: [PATCH] dvb_frontend: Multistream support
MIME-Version: 1.0
Message-Id: <791451345225958@web24h.yandex.ru>
Date: Fri, 17 Aug 2012 20:52:38 +0300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

16.08.2012, 21:11, "Antti Palosaari" <crope@iki.fi>:
> @Mauro, should we rename also DTV_ISDBS_TS_ID to DTV_ISDBS_TS_ID_LEGACY
> to remind users ?

Maybe leave DTV_ISDBS_TS_ID and convert DTV_DVBT2_PLP_ID to  DTV_DVB_STREAM_ID ? and dvbt2_plp_id convert to dvb_stream_id.

Because DVB and ISDB different standards and look like stream id for ISDB is 16 bit, for DVB-S2/T2 8 bit.
