Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbbLRQwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 11:52:43 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <0df11a53b7100d93643483e9fcfaf4eb69b492a5.1450455971.git.mchehab@osg.samsung.com>
References: <0df11a53b7100d93643483e9fcfaf4eb69b492a5.1450455971.git.mchehab@osg.samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: dhowells@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH] [media] cx23885-dvb: move initialization of a8293_pdata
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1699.1450457560.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Dec 2015 16:52:40 +0000
Message-ID: <1700.1450457560@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> Smatch complains about where the au8293_data is placed:
> 
> drivers/media/pci/cx23885/cx23885-dvb.c:2174 dvb_register() info: 'a8293_pdata' is not actually initialized (unreached code).
> 
> It is not actually expected to have such initialization at
> 
> switch {
> 	foo = bar;
> 
> 	case:
> ...
> }
> 
> Not really sure how gcc does that, but this is something that I would
> expect that different compilers would do different things.
> 
> So, move the initialization outside the switch(), making smatch to
> shut up one warning.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Yeah - checked with the compiler people: it's not really expected to
initialise as expected.

Acked-by: David Howells <dhowells@redhat.com>
