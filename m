Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:48125 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465AbbHNPAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 11:00:33 -0400
Message-ID: <55CE0268.9050400@xs4all.nl>
Date: Fri, 14 Aug 2015 16:59:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Harry Wei <harryxiyou@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
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
	=?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Axel Lin <axel.lin@ingics.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Bryan Wu <cooloney@gmail.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	anuvazhayil <anuv.1994@gmail.com>,
	Mahati Chamarthy <mahati.chamarthy@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	linux-doc@vger.kernel.org, linux-kernel@zh-kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH v4 1/6] media: get rid of unused "extra_links" param on
 media_entity_init()
References: <cover.1439563682.git.mchehab@osg.samsung.com> <b0b576e0bfcc043b4fdab3a57665b525fc054add.1439563682.git.mchehab@osg.samsung.com>
In-Reply-To: <b0b576e0bfcc043b4fdab3a57665b525fc054add.1439563682.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2015 04:56 PM, Mauro Carvalho Chehab wrote:
> Currently, media_entity_init() creates an array with the links,
> allocated at init time. It provides a parameter (extra_links)
> that would allocate more links than the current needs, but this
> is not used by any driver.
> 
> As we want to be able to do dynamic link allocation/removal,
> we'll need to change the implementation of the links. So,
> before doing that, let's first remove that extra unused
> parameter, in order to cleanup the interface first.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans
