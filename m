Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58484 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaH2BF4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 21:05:56 -0400
Message-ID: <53FFD1F0.9050306@iki.fi>
Date: Fri, 29 Aug 2014 04:05:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi> <53FEF144.6060106@gmail.com>
In-Reply-To: <53FEF144.6060106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moikka!

On 08/28/2014 12:07 PM, Akihiro TSUKADA wrote:
> moikka,
> thanks for the comment.
>
>> I have feeling DVBv5 API is aimed to transfer data via property cached.
>> I haven't done much driver for DVBv5 statistics, but recently I
>> implemented CNR (DVBv5 stats) to Si2168 driver and it just writes all
>> the values directly to property cache. I expect RF strength (RSSI) is
>> just similar.
>
> Currently, the demod of PT3 card (tc90522) gets RSSI data from
> the connected tuner (mxl301rf) via tuner_ops.get_signal_strength_dbm()
> and sets property cache in fe->ops.get_frontend() (which is called
> before returning property cache value by dvb_frontend_ioctl_properties()).
> If the tuner driver should set property cache directly,
> when is the right timing to do so?
> In fe->ops.tuner_ops.get_status() ?
> or in the old fe->ops.tuner_ops.get_signal_strength()?
> or Should I change get_signal_strength_dbm(fe, s64 *) to
> update_signal_strength(fe) and let the tuner driver set property cache there?

I think tuner driver should set c->strength as own. Look 
drivers/media/dvb-core/dvb_frontend.c
	/* Fill quality measures */
	case DTV_STAT_SIGNAL_STRENGTH:
		tvp->u.st = c->strength;
		break;

So user-space just get info what is set to struct 
dtv_frontend_properties. That is similarly than CNR and all the other 
statistics.

Start polling thread, which polls once per 2 sec or so, which reads RSSI 
and writes value to struct dtv_frontend_properties. That it is, in my 
understanding. Same for all those DVBv5 stats. Mauro knows better as he 
designed that functionality.

regards
Antti

-- 
http://palosaari.fi/
