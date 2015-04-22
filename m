Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49837 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbbDVSb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 14:31:59 -0400
Date: Wed, 22 Apr 2015 15:31:46 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>,
	media workshop ML <media-workshop@linuxtv.org>
Subject: [DRAFT 1] Linux Media Summit report - March, 26 2015 - San Jose -
 CA - USA
Message-ID: <20150422153146.5dd9fce7@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the first draft for the Linux Media Summit Report.

Please note that the items 3 to 5 are not in good shape. In special,
nobody took Etherpad notes on item 4.

Please review. I'll publish a second (final?) draft after having some
feedback.

Regards,
Mauro

-

Linux Media Summit - March, 26 2015 - San Jose - CA - USA
 
 
Attendees:


    Angelos Manousaridis <amanous@gmail.com>
    Bob Moragues <bob.moragues@lge.com>
    Chris Kohn
    Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Hans Verkuil <hverkuil@xs4all.nl>
    Hyun Kwon
    Karthik Poduval <karthik.poduval@gmail.com>
    Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Mauro Carvalho Chehab <mchehab@osg.samsung.com>
    Michal Lebik
    Mohammed CHERIFI mcherifi@cisco.com
    Rafael Chehab <chehabrafael@gmail.com>
    Ron Birkett
    Schuyler Patton
    Shuah Khan <shuahkh@osg.samsung.com>

1) Media Controller support for DVB
Mauro presented a set of slides (add link) showing how the DVB pipelines look like and underlined that several topics needs to be addressed by the Media controller:

a) dynamic creation/removal of pipelines
b) change media_entity_pipeline_start to also define the final entity
c) how to setup pipelines that also envolve audio and DRM?
d) how to lock the media controller pipeline between enabling a pipeline and starting it, in 

How to do complex pipelines in DVB?
 
- The DVB demux can filter MPEG-TS traffic (either in hardware or in software) and can send multiplexed TS to the dvr node, elementary streams to the demux node and can create network interfaces for elementary streams (ES) via the net node.
- a given set of elementary streams can go to one of those three options only, or it can be sent directly to a GPU and/or an ALSA pipeline.
- there is support for hardware PID filtering at the Kernel, but no support (yet) for a real hw demuxer that splits the MPEG TS into separate DMA MPEG-TS and/or ES streams.
- frontend device node is to be attached to the demod entity and it will control the demod, the tuner and a possible LNA via the active Media Controller links.
- dvr/net/demux device nodes are attached to the demux entity.
- the net interfaces are not (yet) represented via MC: we need the ability to remove entities dynamically for that, and we are not really sure if we want this at all. So, it as agreed to wait for support for removing entities to arrive, then this need can be discussed again.
- For now we can safely assume that there is only one Satellite Equipment Control (SEC) in each active data path that goes through a tuner/demod. So each frontend will control just one SEC.
  Should we encounter really complex scenarios, then we should consider having device nodes for SEC entities.

It was decided that:
- The Satellite Equipment Control (SEC) should be an entity, linking them to the connector
- Deprecated osd, teletext, video and audio device nodes are only used in av7110. The av7110 driver uses lots of deprecated stuff, we should move this to staging and deprecate the whole driver and see who starts yelling.
- Document the high-level overview of DVB (Mauro). Layout needs to be changed to be in line with the other APIs (Hans?).
- Mauro will rename “frontend” entity to “demod” at the Media Controller, as the frontend is actually a set of elements.
- Laurent will prepare a proposal of reporting device nodes via a new entity properties API addition
 
2) Media Tokens

Shuah submitted some RFC Patches: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux.git

- Changes from the previous RFC:
   - simplified after switching au0828 to vb2
   - token created by the bridge driver

It was decided that:
- Preference for using the Media Controller. That requires that MC support for Alsa is added, the usbaudio driver then needs to find and hook into the MC from the bridge driver.
- The RFC patches will help to identify on what places the driver should be touched
- Shuag from Samsung is willing to do the changes at ALSA; Rafael is willing to add MC support at au0828/au8522.
- Media controler dev (mdev) will have to be created as a dev resource on the parent device to the bridge device similar to media tokens
- Need a new media_device_create() interace to allocate it as a device resource. This routine will either return media device if one is created or create it.
- Both au0828 and ALSA will first call media_device_create(). Coordinate register/unregister??
  
3) FPGA/Project ARA: dynamic reconfiguration (http://www.projectara.com/)
- partial pipeline removal: controlled removal in the case of FPGA reconfiguration. subdevs/entities will be removed: unsupported today.
- no notification in MC when things change: we likely need an event mechanism.
- adding entities: doable, might need to add links in a 'pending' state, to be made into a normal link once all streaming is stopped.
- subdevs: add refcounting, remove calls subdev_unregister(). Internal release callback when the refcount goes to 0.
- Removal of subdevs will lead to holes (missing entities) in the MC graph.
- reuse entity IDs? Mauro doesn't like it, Laurent/Hans undecided.
- if one entity has a pointer to another it has to take a refcount. Possible locking issues. Needs analysis.
 
4) Update on ongoing projects

5) Android Camera v3
 
The Khronos OpenKCam API addresses the same needs as the Android Camera HAL v3 API, and is quite similar in concept. We should make sure that our API can support OpenKCam.
The specification isn't public, but it's based on the FCam API (Nokia research project) which should be available publicly.
 
