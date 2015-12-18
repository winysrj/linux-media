Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59422 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287AbbLRRXe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 12:23:34 -0500
Date: Fri, 18 Dec 2015 15:23:26 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David Howells <dhowells@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH] [media] cx23885-dvb: move initialization of a8293_pdata
Message-ID: <20151218152326.5ff27a98@recife.lan>
In-Reply-To: <1700.1450457560@warthog.procyon.org.uk>
References: <0df11a53b7100d93643483e9fcfaf4eb69b492a5.1450455971.git.mchehab@osg.samsung.com>
	<1700.1450457560@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Dec 2015 16:52:40 +0000
David Howells <dhowells@redhat.com> escreveu:

> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > Smatch complains about where the au8293_data is placed:
> > 
> > drivers/media/pci/cx23885/cx23885-dvb.c:2174 dvb_register() info: 'a8293_pdata' is not actually initialized (unreached code).
> > 
> > It is not actually expected to have such initialization at
> > 
> > switch {
> > 	foo = bar;
> > 
> > 	case:
> > ...
> > }
> > 
> > Not really sure how gcc does that, but this is something that I would
> > expect that different compilers would do different things.
> > 
> > So, move the initialization outside the switch(), making smatch to
> > shut up one warning.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Yeah - checked with the compiler people: it's not really expected to
> initialise as expected.

Thank you for checking it! Yeah, the above code weren't smelling
well ;) Good to know for sure that such constructions may not be
doing what humans would expect...
 
> Acked-by: David Howells <dhowells@redhat.com>
