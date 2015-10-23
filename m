Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33806 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbbJWJhz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2015 05:37:55 -0400
Date: Fri, 23 Oct 2015 07:37:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Antonio Ospite <ao2@ao2.it>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	moinejf@free.fr, Anders Blomdell <anders.blomdell@control.lth.se>,
	Thomas Champagne <lafeuil@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] [media] gspca: ov534/topro: prevent a division by 0
Message-ID: <20151023073748.34cdf937@recife.lan>
In-Reply-To: <20151023111356.f76b8ec65a91baa2df8a9d36@ao2.it>
References: <1443817993-32406-1-git-send-email-ao2@ao2.it>
	<560F8E59.4090104@redhat.com>
	<20151023111356.f76b8ec65a91baa2df8a9d36@ao2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 23 Oct 2015 11:13:56 +0200
Antonio Ospite <ao2@ao2.it> escreveu:

> On Sat, 3 Oct 2015 10:14:17 +0200
> Hans de Goede <hdegoede@redhat.com> wrote:
> 
> > Hi,
> >
> 
> Hi HdG,
> 
> > On 02-10-15 22:33, Antonio Ospite wrote:
> [...]
> > > Signed-off-by: Antonio Ospite <ao2@ao2.it>
> > > Cc: stable@vger.kernel.org
> > 
> > Good catch:
> > 
> > Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> > 
> > Mauro can you pick this one up directly, and include it in your
> > next pull-req for 4.3 please ?

Hans, I'm removing the delegation at patchwork. Next time, please don't
forget to remove the delegation there, as I generally don't bother
about delegated patches, as my scripts just ignore them.

I'm afraid that it is too late for 4.3, though, as we'll all be
next week at KS.

Regards,
Mauro
