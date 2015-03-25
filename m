Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37893 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbCYEms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 00:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <20150324091540.GU8656@n2100.arm.linux.org.uk>
References: <1425369592.3146.14.camel@pengutronix.de> <CAL_Jsq+s5RN+7z8Q5N1VghxaQ_ajQmBddtWOTovLoVJjb_6uDw@mail.gmail.com>
 <1426063881.3101.33.camel@pengutronix.de> <2376013.jScnaqPlDa@phil> <20150324091540.GU8656@n2100.arm.linux.org.uk>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 24 Mar 2015 23:42:26 -0500
Message-ID: <CAL_JsqJCRQx9=pnvxvKP+Ruek1F-0TRJ2rDDHCcVYZ8y=hE=Xg@mail.gmail.com>
Subject: Re: [GIT PULL v2] of: Add of-graph helpers to loop over endpoints and
 find ports by id
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Benoit Parrot <bparrot@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Darren Etheridge <detheridge@ti.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 24, 2015 at 4:15 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Mar 23, 2015 at 05:29:02PM +0100, Heiko Stuebner wrote:
>> Hi Rob, Philipp,
>>
>> Am Mittwoch, 11. März 2015, 09:51:21 schrieb Philipp Zabel:
>> > Am Dienstag, den 10.03.2015, 14:05 -0500 schrieb Rob Herring:
>> > > I've only been copied on this latest pull request and a version from
>> > > March of last year which Grant nak'ed. This series did not go to
>> > > devicetree list either. I'll take a look at the series.
>> >
>> > My bad, I should have copied you, too. Thanks for having a look now.
>>
>> any news on this?
>>
>> Because it looks like I'll need the of_graph_get_port_by_id functionality in
>> the short term, it'll be nice to not having to opencode this :-)
>
> Oh hell, you mean this still hasn't been merged for the next merge window?
>
> What's going on, Grant?
>
> Andrew, can you please take this if we send you the individual patches?
> If not, I'll merge it into my tree, and send it to Linus myself.  If
> Grant wakes up, we can address any comments he has at that time by
> additional patches.  (I'll give Grant an extra few days to reply to
> this mail...)

I've merged this for 4.1. It is in my for-next branch[1].

Rob

[1] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
