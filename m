Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3CRXfk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 19:35:40 -0400
Date: Mon, 18 Mar 2013 20:35:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] dvb_frontend: Simplify the emulation logic
Message-ID: <20130318203536.6dbe7772@redhat.com>
In-Reply-To: <CAOMZO5DD-J3Uf9mSxvyLNz2X5-G3nkamfZ6+Zo0uYqgineHfEg@mail.gmail.com>
References: <1363634737-22550-1-git-send-email-mchehab@redhat.com>
	<1363634737-22550-2-git-send-email-mchehab@redhat.com>
	<CAOMZO5DD-J3Uf9mSxvyLNz2X5-G3nkamfZ6+Zo0uYqgineHfEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 18 Mar 2013 17:05:12 -0300
Fabio Estevam <festevam@gmail.com> escreveu:

> Hi Mauro,
> 
> On Mon, Mar 18, 2013 at 4:25 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> 
> > -static int emulate_delivery_system(struct dvb_frontend *fe,
> > -                                  enum dvbv3_emulation_type type,
> > -                                  u32 delsys, u32 desired_system)
> > +/**
> > + * emulate_delivery_system - emulate a DVBv5 delivery system with a DVBv3 type
> > + * @fe:                        struct frontend;
> > + * @desired_system:    DVBv5 type that will be used for emulation
> 
> 'desired_system' parameter has been removed in this patch. 'delsys'
> should be put in the description instead.

Thanks for reviewing it!

Yeah, internally I made several versions of this patch, in order to make
each routine clear. On the very last minute, I ended by just removing
desired_system, keeping just one parameter there after fe.

I'm changing it at the version I'm committing.

Thanks!
Mauro
