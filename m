Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:55960 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1CJSUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 13:20:23 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 10 Mar 2011 23:50:02 +0530
Subject: RE: mt9p031 support for Beagleboard.
Message-ID: <19F8576C6E063C45BE387C64729E739404E1F52AD5@dbde02.ent.ti.com>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
 <201103101741.41403.laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E739404E1F52AB5@dbde02.ent.ti.com>
 <201103101854.33109.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103101854.33109.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, March 10, 2011 11:25 PM
> To: Hiremath, Vaibhav
> Cc: Guennadi Liakhovetski; javier Martin; Linux Media Mailing List; Mauro
> Carvalho Chehab
> Subject: Re: mt9p031 support for Beagleboard.
> 
> Hi Vaibhav,
> 
> On Thursday 10 March 2011 18:09:42 Hiremath, Vaibhav wrote:
> > On Thursday, March 10, 2011 10:12 PM Laurent Pinchart wrote:
> > > On Thursday 10 March 2011 17:23:52 Hiremath, Vaibhav wrote:
> > > >
<snip>
> > > > [By next week I should be able to make all my changes public (into
> my
> > > > Arago repo) for reference]
> > >
> > > There are too many repositories with code lying around. We should try
> to
> > > coordinate our efforts.
> >
> > I agree with you.
> 
> Any suggestion ? Should I create a repository based on mainline (or latest
> linux-media tree) and maintain sensor drivers there before they get pushed
> to
> mainline ?
> 
[Hiremath, Vaibhav] I agree, its good idea, I think no need to create separate repository; separate branch in your "media" repository should be ok. What do you think? 

Thanks,
Vaibhav

> --
> Regards,
> 
> Laurent Pinchart
