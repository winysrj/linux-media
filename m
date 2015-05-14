Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35582 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965087AbbENQKF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 12:10:05 -0400
Date: Thu, 14 May 2015 13:09:59 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Benjamin Larsson <benjamin@southpole.se>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH] rtl2832: PID filter support for slave demod
Message-ID: <20150514130959.3772fe0a@recife.lan>
In-Reply-To: <55076436.3000401@southpole.se>
References: <55075559.50100@southpole.se>
	<55075FDC.1030507@iki.fi>
	<55076436.3000401@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Mar 2015 00:16:06 +0100
Benjamin Larsson <benjamin@southpole.se> escreveu:

> On 03/16/2015 11:57 PM, Antti Palosaari wrote:
> > On 03/17/2015 12:12 AM, Benjamin Larsson wrote:
> >> Is this structure ok for the slave pid implementation? Or should there
> >> be only one filters parameter? Will the overlaying pid filter framework
> >> properly "flush" the set pid filters ?
> >>
> >> Note that this code currently is only compile tested.
> >
> > I am fine with it.
> >
> > byw. Have you tested if your QAM256 (DVB-C or DVB-T2) stream is valid
> > even without a PID filtering? IIRC mine stream is correct and PID
> > filtering is not required (but surely it could be implemented if you wish).
> >
> > regards
> > Antti
> >
> 
> DVB-C seems fine and one of my DVB-T2 muxes is fine also. But one other 
> DVB-T2 mux completely fails. It could be the reception but it might be 
> that it needs pid filtering. I do get small disturbances on my DVB-C 
> muxes. Will report back if pid filtering makes things better or not.

What's the status of this patch?

Btw, checkpatch.pl complains about a few things there:

WARNING: 'transfering' may be misspelled - perhaps 'transferring'?
#31: capable of transfering.

ERROR: "foo* bar" should be "foo *bar"
#77: FILE: drivers/media/dvb-frontends/rtl2832.c:1162:
+	unsigned long* filters;

WARNING: braces {} are not necessary for any arm of this statement
#93: FILE: drivers/media/dvb-frontends/rtl2832.c:1176:
+	if (onoff) {
[...]
+	} else {
[...]

total: 1 errors, 2 warnings, 87 lines checked

For now, as it was sent as RFC, I'll tag as such at patchwork.

If this is patch is pertinent, please re-send it (with the coding style
issues pointed by checkpatch.pl fixed).

Regards,
Mauro

> 
> MvH
> Benjamin Larsson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
