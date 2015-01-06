Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42886 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbbAFTKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jan 2015 14:10:48 -0500
Date: Tue, 6 Jan 2015 17:10:15 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some issues with Media controller on DVB
Message-ID: <20150106171015.6186a1e5@concha.lan>
In-Reply-To: <20150106120930.17abd19a@concha.lan>
References: <20150106120930.17abd19a@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Jan 2015 12:09:30 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Hi Laurent,
> 
> Now that we have a patchset enabling the media controller for DVB, I'm facing
> with some issues related to media streaming that are different than what
> happens at the V4L side.
> 
> I took some time to write a small text that describes the DVB from the PoV
> of the media controller, and showing some issues I'm currently facing.
> 
> Please take a look. Perhaps we could discuss it on a next Media Summit,
> as some of the issues there seem to require some changes at the media
> controller side. What do you think?
> 
> PS.: the described scenario on this document is far from being complete.
> This is just a starting point for discussions.
> 
> Regards,
> Mauro
> 
> ---
> 
> DRAFT: DVB and the Media Controller
> 
> 
> DVB DEVNODES
> ============
> 
> At the DVB API, there are multiple DVB devices that are used for different
> purposes. A typical device with just one adapter and just one frontend would
> be mapped as:
> 
> 	/dev/dvb/adapter0/frontend0	- frontend devnode
> 	/dev/dvb/adapter0/demux0	- demux devnode
> 	/dev/dvb/adapter0/dvr0		- DVR devnode
> 
> If such device has a CA module (responsible to decrypt streams), an extra
> devnode appears:
> 
> 	/dev/dvb/adapter0/ca0		- CA devnode
> 
> If the device is hybrid, it will also have a V4L2 device, like:
> 	/dev/video0
> 
> TUNER SUB-DEVICE
> ================
> 
> Just like analog TV devices, DVB devices have a component that tuners
> into a channel. On DVB, the component responsible to tune into a channel
> and decode the physical layer is called frontend.
> 
> However, several non-hybrid DVB devices don't have a tuner subdev, due 
> to two reasons:
> - Sometimes (like Satellite systems), the tuner is integrated with
>   the frontend device;
> - Several devices use a micro controller to setup both tuner and frontend
>   at the same time. So, the tuner is invisible to the Kernel.
> 
> Hybrid Analog/Digital devices always have a tuner, as the same tuner is
> used for both analog TV and as part of the digital TV frontend.
> In this case, the tuner subdev may feed either the DVB frontend or the
> analog demod subdev, but never to both at the same time.
> 
> MEDIA STREAMING
> ===============
> 
> As the DVB devnodes are independent, the concept of "media streaming"
> is actually split into each specific devnode.
> 
> a) frontend streaming
> 
> When the frontend devnode is opened and a FE_SET_PROPERTY ioctl (or the
> legacy DVBv3 ioctl) is called, a thread is started inside the DVB core.
> Both tuner and frontend start streaming at this time. However, the
> MPEG TS is not delivered yet.
> 
> What happens here is that it tries to lock at the TV physical channel.
> Via the frontend interface, it is possible to check the status and the
> QoS parameters related to the tuning and to the DVB error measurements.
> 
> b) MPEG-TS streaming
> 
> The MPEG-TS streaming is commanded via the demod devnode. It happens
> by setting a filter that will be applied to the MPEG-TS. There are
> two types of filters: one for MPEG tables, and another one for MPEG programs.
> 
> When a filter is created, a dynamic stream is created, and will contain
> all the packet IDs (or tables) that match the filter. Both the input and
> the output can be directed to different devnodes, depending on the parameters
> that are given to the ioctl.
> 
> Typically, it uses the frontend devnode as stream input[1], and the dvr
> devnode as output, although it is possible to get the output also at the demod
> devnode[2].
> 
> [1] http://linuxtv.org/downloads/v4l-dvb-apis/dvb_demux.html#dmx-input-t
> [2] http://linuxtv.org/downloads/v4l-dvb-apis/dvb_demux.html#dmx-output-t
> 
> While in general just a few filters are set, the drivers generally allow
> a big number of filters, like 256. Some hardware even allow to dynamically
> allocate and change the max number of filters at runtime, reallocating
> filters from one adapter to another one.
> 
> The CA interface is something that requires change. Originally, it was
> just a control interface to handle CA, but some devices implement it as
> a completely separated independent module that can even decrypt a TS that
> was, for example, stored in the disk. So, from the media pipeline PoV,
> this can be dynamically added in the middle of an streaming pipeline.
> 
> TYPICAL USECASE
> ===============
> 
> As can be seen from the above, the are multiple streams happening at
> the DVB API:
> 
> 1) the frontend streaming;
> 2) the per-filter streaming.
> 
> And they're started/stopped at different times. 
> 
> A typical DVB application will initially create one pipeline:
> 
> tuner --> fe
> 
> Once the FE locks and has an stable connection, the DVB application
> will create other pipelines. For example:
> 
> pipeline 1: Track the MPEG-TS control tables (PAT, PMT, ...)
> pipeline 2: Audio Program Elementary Stream
> pipeline 3: Video Program Elementary Stream
> 
> So, it will have:
> 
> tuner --> fe --> demux --> dvr filter 0
> tuner --> fe --> demux --> dvr filter 1
> tuner --> fe --> demux --> dvr filter 2
> 
> If the user wants, for example to see the closed captions,
> an extra pipeline will be created:
> 
> tuner --> fe --> demux --> dvr filter 3 (for CC)
> 
> Let's now assume that a given program is DRM-protected and needs
> to pass through the CA subdev.
> 
> The pipelines should be dynamically changed to:
> 
> tuner --> fe --> demux --> ca --> dvr filter 0
> tuner --> fe --> demux --> ca --> dvr filter 1
> tuner --> fe --> demux --> ca --> dvr filter 2
> 
> Btw, it is possible to have both encrypted and unencrypted programs
> inside the same MPEG TS. So, we may have things like:
> 
> tuner --> fe --> demux --> dvr filter 0
> tuner --> fe --> demux --> dvr filter 1
> tuner --> fe --> demux --> dvr filter 2
> tuner --> fe --> demux --> ca --> dvr filter 3
> tuner --> fe --> demux --> ca --> dvr filter 4
> tuner --> fe --> demux --> ca --> dvr filter 5
> 
> (in the above example, one program could be recorded while the other
> one could be displayed).
> 
> 
> KNOWN ISSUES WITH MEDIA CONTROLLER API
> ======================================
> 
> 1) dynamic creation/removal of pipelines
> 
> This is needed to allow mapping each DVB filter as a pipeline.
> 
> 
> 2) media_entity_pipeline_start
> 
> It should be possible to pass not only the start entity but also
> the final entity, as it should be possible to control tuner/fe
> pipeline independently of the demux filter pipelines.
> 
> 3) pipelines with audio and DRM
> 
> (I'm adding this one just to make this document complete)
> 
> This was discussed already at last Media Summits, but assuming that both
> audio and DRM will use the media controller, it would be interesting to
> be able to setup a pipeline between the different subsystems.
> 
> This is not an issue for DVB and V4L2, as the bridge driver can easily
> share the media device between the two subsystems, as I did on my
> experimental patches, but for audio this is an issue, as devices that
> implement standard Audio Class don't use the media driver for audio,
> but, instead, snd-usb-audio.
> 
> Perhaps we could add a function that would allow to get the mdev based
> on the parent device struct, in order to allow re-using the mdev on
> different subsystems. This would help with audio, but not with DRM.
> 

One more issue:

4) Race conditions

When DVB starts the frontend streaming kthread, it should disable the
	analog TV link and enable the Digital TV one. So, it needs to
do the following status changes:

[ 9727.649847] cx231xx 3-1.2:1.1: link NXP TDA18271HD->cx25840 19-0044 was disabled
[ 9727.649857] cx231xx 3-1.2:1.1: link NXP TDA18271HD->Fujitsu mb86A20s was ENABLED

in the above:
	"NXP TDA18271HD" is the tuner
	"Fujitsu mb86A20s" is the DVB frontend
	"cx25840" is the Analog demodulator

And then call media_entity_pipeline_start() to start streaming at the 
new pipeline. The reverse should happen when analog TV stream on happens,
e. g.:

[10648.573263] cx231xx 3-1.2:1.1: link NXP TDA18271HD->cx25840 19-0044 was ENABLED
[10648.573274] cx231xx 3-1.2:1.1: link NXP TDA18271HD->Fujitsu mb86A20s was disabled

However, something could happen between changing the link state and calling
media_entity_pipeline_start(), e. g. either an ioctl changing the pipeline
via the media controller devnode or an application trying to use analog TV
while digital TV is starting (or vice-versa).

How to properly lock the media controller to avoid those issues?

Probably the best would be to create a variant of media_entity_pipeline_start()
that would not lock the mdev->graph_mutex, but I'm not sure if this is
enough. What do you think?

PS.: the patches I'm using to test are at:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=dvb-media-ctl


-- 

Cheers,
Mauro
