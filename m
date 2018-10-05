Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbeJER3i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:29:38 -0400
Date: Fri, 5 Oct 2018 07:31:23 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH 3/3] media: v4l2-fwnode: simplify
 v4l2_fwnode_reference_parse_int_props() call
Message-ID: <20181005073123.28e40cea@coco.lan>
In-Reply-To: <20181005100604.pfslnij52rfjgwvj@paasikivi.fi.intel.com>
References: <cover.1538690587.git.mchehab+samsung@kernel.org>
        <463ae4be895e592aa575d55530a615e22a1934b3.1538690587.git.mchehab+samsung@kernel.org>
        <20181005080310.74skdxkbvt37yd2j@paasikivi.fi.intel.com>
        <20181005065449.0a1ab62f@coco.lan>
        <20181005100604.pfslnij52rfjgwvj@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 5 Oct 2018 13:06:04 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> > > > -	unsigned int i;    
> > > 
> > > I'd like to keep this here.  
> > 
> > Why? IMHO, it makes harder to read (yet, if you insist, I'm ok with 
> > both ways).  
> 
> Generally loop, temporary, return etc. variables are nice to declare as
> last. That is the practice in this file and generally in kernel code,
> albeit with variable degree of application.

I've seen more than one practice of ordering arguments at the Kernel :-)

Anyway, I kept it there on the version I just sent.


Thanks,
Mauro
