Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49543 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbbDWHGk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 03:06:40 -0400
Date: Thu, 23 Apr 2015 09:06:35 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	media workshop ML <media-workshop@linuxtv.org>
Subject: Re: [DRAFT 1] Linux Media Summit report - March, 26 2015 - San Jose
 - CA - USA
Message-ID: <20150423090635.67a1656d@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <20150422153146.5dd9fce7@recife.lan>
References: <20150422153146.5dd9fce7@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I could not participate at your Summit, but may have an input to the
media-controller in DVB - see below.


On Wed, 22 Apr 2015 15:31:46 -0300 Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:

> This is the first draft for the Linux Media Summit Report.
> 
> Please note that the items 3 to 5 are not in good shape. In special,
> nobody took Etherpad notes on item 4.
> 
> Please review. I'll publish a second (final?) draft after having some
> feedback.
> 
> Regards,
> Mauro
> 
> -
> 
> Linux Media Summit - March, 26 2015 - San Jose - CA - USA
>  
>  
> Attendees:
> 
> 
>     Angelos Manousaridis <amanous@gmail.com>
>     Bob Moragues <bob.moragues@lge.com>
>     Chris Kohn
>     Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>     Hans Verkuil <hverkuil@xs4all.nl>
>     Hyun Kwon
>     Karthik Poduval <karthik.poduval@gmail.com>
>     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>     Michal Lebik
>     Mohammed CHERIFI mcherifi@cisco.com
>     Rafael Chehab <chehabrafael@gmail.com>
>     Ron Birkett
>     Schuyler Patton
>     Shuah Khan <shuahkh@osg.samsung.com>
> 
> 1) Media Controller support for DVB
> Mauro presented a set of slides (add link) showing how the DVB
> pipelines look like and underlined that several topics needs to be
> addressed by the Media controller:
> 
> a) dynamic creation/removal of pipelines
> b) change media_entity_pipeline_start to also define the final entity
> c) how to setup pipelines that also envolve audio and DRM?
> d) how to lock the media controller pipeline between enabling a
> pipeline and starting it, in 
> 
> How to do complex pipelines in DVB?
>  
> - The DVB demux can filter MPEG-TS traffic (either in hardware or in
> software) and can send multiplexed TS to the dvr node, elementary
> streams to the demux node and can create network interfaces for
> elementary streams (ES) via the net node.
> - a given set of elementary streams can go to one of those three
> options only, or it can be sent directly to a GPU and/or an ALSA
> pipeline.
> - there is support for hardware PID filtering at the Kernel, but no
> support (yet) for a real hw demuxer that splits the MPEG TS into
> separate DMA MPEG-TS and/or ES streams.
> - frontend device node is to be attached to the demod entity and it
> will control the demod, the tuner and a possible LNA via the active
> Media Controller links.
> - dvr/net/demux device nodes are attached to the demux entity.
> - the net interfaces are not (yet) represented via MC: we need the
> ability to remove entities dynamically for that, and we are not
> really sure if we want this at all. So, it as agreed to wait for
> support for removing entities to arrive, then this need can be
> discussed again.
> - For now we can safely assume that there is only one Satellite
> Equipment Control (SEC) in each active data path that goes through a
> tuner/demod. So each frontend will control just one SEC. Should we
> encounter really complex scenarios, then we should consider having
> device nodes for SEC entities.

What about demod-diversity: demods of some manufacturers can be used to
combine their demodulated symbols and, due to their different antennas
and RF-paths, improve the overall reception quality.

If we ever have someone contributing in this area with hardware-drivers,
it would be nice to have the user-space possible to select
demod-combinations. It should be possible to add and remove a demod
to a diversity-chain when and when not being tuned to a channel.

regards,
--
