Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm20-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.180]:38748 "HELO
	nm20-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751066Ab1HNX43 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 19:56:29 -0400
Message-ID: <1313366188.5010.YahooMailClassic@web121715.mail.ne1.yahoo.com>
Date: Sun, 14 Aug 2011 16:56:28 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: PCTV 290e - assorted problems
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4E485C0C.8040600@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Mon, 15/8/11, Antti Palosaari <crope@iki.fi> wrote:
> T 554000000 8MHz + auto auto auto etc.
> is enough.

Hmm, not here it isn't:

$ scandvb -u -vvv uk-CrystalPalace 
scanning uk-CrystalPalace
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 554000000 0 9 9 6 2 4 4
>>> tune to: 554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
WARNING: >>> tuning failed!!!
>>> tune to: 554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
>>> tuning status == 0x0f
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

Although it was working (briefly) on Saturday morning.

> Have you tried it on Windows?

No, because I don't own a Windows machine.

Cheers,
Chris

