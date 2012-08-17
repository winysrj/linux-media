Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward4.mail.yandex.net ([77.88.46.9]:44387 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2HQRV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 13:21:58 -0400
From: CrazyCat <crazycat69@yandex.ru>
To: Antti Palosaari <crope@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <502D37CF.7030608@iki.fi>
References: <53381345139167@web11e.yandex.ru> <502D37CF.7030608@iki.fi>
Subject: Re: [PATCH] dvb_frontend: Multistream support
MIME-Version: 1.0
Message-Id: <839331345224097@web14d.yandex.ru>
Date: Fri, 17 Aug 2012 20:21:37 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


16.08.2012, 21:11, "Antti Palosaari" <crope@iki.fi>:
>> š- /* ISDB-T specifics */
>> š- u32 isdbs_ts_id;
>> š-
>> š- /* DVB-T2 specifics */
>> š- u32 ššššššššššššššššššššdvbt2_plp_id;
>> š+ /* Multistream specifics */
>> š+ u32 stream_id;
>
> u32 == 32 bit long unsigned number. See next comment.
>>
>> š- c->isdbs_ts_id = 0;
>> š- c->dvbt2_plp_id = 0;
>> š+ c->stream_id = -1;
>
> unsigned number cannot be -1. It can be only 0 or bigger. Due to that
> this is wrong.

so maybe better declare in as int ? depend from standard valid stream id (for DVB is 0-255) and any another value (-1) disable stream filtering in demod.
