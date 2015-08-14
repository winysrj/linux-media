Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57747 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbbHNLIH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 07:08:07 -0400
Date: Fri, 14 Aug 2015 08:07:52 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Harry Wei <harryxiyou@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Axel Lin <axel.lin@ingics.com>, Bryan Wu <cooloney@gmail.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	anuvazhayil <anuv.1994@gmail.com>,
	Mahati Chamarthy <mahati.chamarthy@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	linux-doc@vger.kernel.org, linux-kernel@zh-kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH RFC v3 07/16] media: get rid of unused "extra_links"
 param on media_entity_init()
Message-ID: <20150814080752.1e2d1311@recife.lan>
In-Reply-To: <20150814103348.GC19840@valkosipuli.retiisi.org.uk>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
	<7b9f2654888f0fd54c290c50f50248a367768da7.1439410053.git.mchehab@osg.samsung.com>
	<20150814103348.GC19840@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Aug 2015 13:33:48 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Wed, Aug 12, 2015 at 05:14:51PM -0300, Mauro Carvalho Chehab wrote:
> > Currently, media_entity_init() creates an array with the links,
> > allocated at init time. It provides a parameter (extra_links)
> > that would allocate more links than the current needs, but this
> > is not used by any driver.
> > 
> > As we want to be able to do dynamic link allocation/removal,
> > we'll need to change the implementation of the links. So,
> > before doing that, let's first remove that extra unused
> > parameter, in order to cleanup the interface first.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> ...
> 
> 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 738e1d5d25dc..be6885e7c8ed 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -177,7 +177,7 @@ void graph_obj_init(struct media_device *mdev,
> >  void graph_obj_remove(struct media_graph_obj *gobj);
> >  
> >  int media_entity_init(struct media_entity *entity, u16 num_pads,
> > -		struct media_pad *pads, u16 extra_links);
> > +		struct media_pad *pads);
> >  void media_entity_cleanup(struct media_entity *entity);
> >  
> >  int media_entity_create_link(struct media_entity *source, u16 source_pad,
> 
> How about putting this in front of the set? It has no dependencies to the
> other patches, does it?

Yeah this patch can be the first one ;) It just cleans up something
that we never used. It just needs to be before patch 8.

> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
