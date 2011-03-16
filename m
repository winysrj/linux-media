Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49311 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1CPW0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 18:26:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: mt9p031 support for Beagleboard.
Date: Wed, 16 Mar 2011 23:26:25 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com> <201103101854.33109.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404E1F52AD5@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E1F52AD5@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103162326.26248.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Vaibhav,

On Thursday 10 March 2011 19:20:02 Hiremath, Vaibhav wrote:
> On Thursday, March 10, 2011 11:25 PM Laurent Pinchart wrote: > > On Thursday 
10 March 2011 18:09:42 Hiremath, Vaibhav wrote:
> > > On Thursday, March 10, 2011 10:12 PM Laurent Pinchart wrote:
> > > > On Thursday 10 March 2011 17:23:52 Hiremath, Vaibhav wrote:
> <snip>
> 
> > > > > [By next week I should be able to make all my changes public (into
> > > > > my Arago repo) for reference]
> > > > 
> > > > There are too many repositories with code lying around. We should try
> > > > to coordinate our efforts.
> > > 
> > > I agree with you.
> > 
> > Any suggestion ? Should I create a repository based on mainline (or
> > latest linux-media tree) and maintain sensor drivers there before they
> > get pushed to
> > mainline ?
> 
> I agree, its good idea, I think no need to create separate repository;
> separate branch in your "media" repository should be ok. What do you think?

Sounds good. Now that 2.6.38 is out, I'll reorganize the repository and add 
sensor drivers. I'll send a mail to the list when the tree will be ready.

-- 
Regards,

Laurent Pinchart
