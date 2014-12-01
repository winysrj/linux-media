Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38520 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbaLAJc3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 04:32:29 -0500
Date: Mon, 1 Dec 2014 07:32:23 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Kyle McMartin <kyle@infradead.org>
Cc: Linux Firmware Mailing List <linux-firmware@kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rainer Miethling <RMiethling@pctvsystems.com>
Subject: Re: [PATCH] linux-firmware: Add firmware files for Siano DTV
 devices
Message-ID: <20141201073223.7bf73418@recife.lan>
In-Reply-To: <20141201022132.GF2930@merlin.infradead.org>
References: <1415577499-30850-1-git-send-email-mchehab@osg.samsung.com>
	<20141201022132.GF2930@merlin.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 30 Nov 2014 21:21:32 -0500
Kyle McMartin <kyle@infradead.org> escreveu:

> On Sun, Nov 09, 2014 at 09:58:19PM -0200, Mauro Carvalho Chehab wrote:
> > From: Mauro Carvalho Chehab <mchehab@infradead.org>
> > 
> > Acked-by: Rainer Miethling <RMiethling@pctvsystems.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> > ---
> >  LICENCE.siano                 |  31 +++++++++++++++++++++++++++++++
> >  WHENCE                        |  18 ++++++++++++++++++
> >  cmmb_vega_12mhz.inp           | Bin 0 -> 62780 bytes
> >  cmmb_venice_12mhz.inp         | Bin 0 -> 97016 bytes
> >  dvb_nova_12mhz.inp            | Bin 0 -> 93516 bytes
> >  dvb_nova_12mhz_b0.inp         | Bin 0 -> 101888 bytes
> >  isdbt_nova_12mhz.inp          | Bin 0 -> 75876 bytes
> >  isdbt_nova_12mhz_b0.inp       | Bin 0 -> 98384 bytes
> >  isdbt_rio.inp                 | Bin 0 -> 85840 bytes
> >  sms1xxx-hcw-55xxx-dvbt-02.fw  | Bin 0 -> 85656 bytes
> >  sms1xxx-hcw-55xxx-isdbt-02.fw | Bin 0 -> 70472 bytes
> >  sms1xxx-nova-a-dvbt-01.fw     | Bin 0 -> 85656 bytes
> >  sms1xxx-nova-b-dvbt-01.fw     | Bin 0 -> 76364 bytes
> >  sms1xxx-stellar-dvbt-01.fw    | Bin 0 -> 39900 bytes
> >  tdmb_nova_12mhz.inp           | Bin 0 -> 40096 bytes
> >  15 files changed, 49 insertions(+)
> 
> bleh, it would have been nice to have made a dvb/ namespace for some of
> these to group them all...

Yeah, I agree. The thing is that those drivers are at the Kernel
for a long time, a way before we start to use namespaces for 
firmwares. Changing the namespace could cause regressions.

In the specific case of Siano, the *.inp files are the files that
are provided together with the original driver's CD. When this
driver got merged at the Kernel, back on 2.6.27, we opted to
preserve the same name as the one found there, as we were unable
to get distribution rights for the firmware. Only now, 6 years after
the driver merge, we finally were able to get manufacturer's license 
to redistribute them.

> in any event, i've applied this patch (After a slight fixup to WHENCE.)

Thank you!

Regards,
Mauro
