Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51567 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbZCYAuQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 20:50:16 -0400
Subject: Re: [question] atsc and api v5
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: wk <handygewinnspiel@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <412bdbff0903241013r479fbaabo8d7f45a7153aebb9@mail.gmail.com>
References: <49C90BCC.1080401@gmx.de>
	 <412bdbff0903241013r479fbaabo8d7f45a7153aebb9@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 20:51:33 -0400
Message-Id: <1237942293.4448.84.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-24 at 13:13 -0400, Devin Heitmueller wrote:
> On Tue, Mar 24, 2009 at 12:35 PM, wk <handygewinnspiel@gmx.de> wrote:
> > While trying to update an application to API v5 some question arised.
> >
> > Which type of "delivery_system" should be set for ATSC?
> > <frontend.h> says...
> >
> > SYS_DVBC_ANNEX_AC,   <- european DVB-C
> > SYS_DVBC_ANNEX_B,      <- american ATSC QAM
> > ..
> > SYS_ATSC,   <- oops, here we have ATSC again, cable and terrestrial not
> > named? Is this VSB *only*?
> >
> >
> >
> > Which one should i choose, "SYS_ATSC" for both (VSB and QAM),
> > or should i choose SYS_DVBC_ANNEX_B for ATSC cable and SYS_ATSC for VSB?
> >
> > thanks,
> > Winfried
> 
> I'm pretty sure it's SYS_ATSC for both VSB and QAM.
> 
> Devin

Hmmm...

The compatability code between the API v5 property cache and the API v3
frontend parameters use...


a.  This code for translating v3 parameters into the v5 cache:

static void dtv_property_cache_sync(struct dvb_frontend *fe,
                                    struct dvb_frontend_parameters *p)
{
        struct dtv_frontend_properties *c = &fe->dtv_property_cache;

        c->frequency = p->frequency;
        c->inversion = p->inversion;

        switch (fe->ops.info.type) {
...
        case FE_ATSC:
                c->modulation = p->u.vsb.modulation;
                if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
                        c->delivery_system = SYS_ATSC;
                else
                        c->delivery_system = SYS_DVBC_ANNEX_B;
                break;
        }
}


b. This code for translating v5 cache into the v3 parameters:

static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
{
        struct dtv_frontend_properties *c = &fe->dtv_property_cache;
        struct dvb_frontend_private *fepriv = fe->frontend_priv;
        struct dvb_frontend_parameters *p = &fepriv->parameters;

        p->frequency = c->frequency;
        p->inversion = c->inversion;

        switch (fe->ops.info.type) {
...
        case FE_ATSC:
                dprintk("%s() Preparing VSB req\n", __func__);
                p->u.vsb.modulation = c->modulation;
                if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
                        c->delivery_system = SYS_ATSC;
                else
                        c->delivery_system = SYS_DVBC_ANNEX_B;
                break;
        }
}


So it would seem the code to fill out v3 parameter structures uses
SYS_DVBC_ANNEX_B as the "delivery system" for ATSC FE's that aren't
using VSB modulation.

Not that SYS_ATSC nor SYS_DVBC_ANNEX_B are used/checked as a delivery
system by any driver (yet.)

I've checked DVB-C (ETSI EN 300 429 v1.2.1) Annex B and it really
doesn't mention or reference ATSC QAM explicitly, but it does have a
table of QAM modulations useful in 8 MHz BWs down to a 2 MHz BW.

I've also looked at A/53 Part 2 which only talks about VSB modulations.

I couldn't find any free NCTA documents on QAM for American cable
systems.

I did find that ITU-T J.83 Annex B describes the framing structure,
channel coding, and modulation schemes for digital cable service in
North America. And that J.83 Annex A and J.83 Annex C defines the cable
modulation schemes for Japanese and European regions, respectively.
I'm trying to dig up a free copy if I can.

I suspect SYS_DVBC_ANNEX_B and SYS_DVB_ANNEX_AC in the Linux enumeration
don't refer to the DVB C standard Annexes, but refer to ITU-T J.83
Annexes.


So I'm assumming SYS_DVBC_ANNEX_B *is* the Linux delivery system
enumaeration value you want for North American Cable QAM modulations
with FE_ATSC.

Anyone got the ITU-T J.83 document to confirm or refute?



BTW, I plan on starting to documenting the API v5 changes in the Linux
DVB spec within the next week or so.


Regards,
Andy


