Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34099 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752187AbdBNGkJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 01:40:09 -0500
Received: by mail-lf0-f48.google.com with SMTP id v186so61579996lfa.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 22:40:07 -0800 (PST)
Date: Tue, 14 Feb 2017 07:40:04 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 00/11] media: rcar-vin: fix OPS and format/pad index
 issues
Message-ID: <20170214064004.GF12706@bigcity.dyn.berto.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
 <35612ce2-57b1-3059-60c8-18806e3f066a@xs4all.nl>
 <20170213174737.GD12706@bigcity.dyn.berto.se>
 <8894bcf1-e37b-6eff-7711-17fb4647cb09@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8894bcf1-e37b-6eff-7711-17fb4647cb09@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2017-02-13 21:57:48 +0100, Hans Verkuil wrote:
> On 02/13/2017 06:47 PM, Niklas Söderlund wrote:
> > Hi Hans,
> > 
> > Thanks for your feedback.
> > 
> > On 2017-02-13 15:19:13 +0100, Hans Verkuil wrote:
> >> Hi Niklas,
> >>
> >> One general remark: in many commit logs you mistype 'subdeivce'. Can you
> >> fix that for the v2?
> > 
> > Will fix for v2.
> > 
> >>
> >> On 01/31/2017 04:40 PM, Niklas Söderlund wrote:
> >>> Hi,
> >>>
> >>> This series address issues with the R-Car Gen2 VIN driver. The most 
> >>> serious issue is the OPS when unbind and rebinding the i2c driver for 
> >>> the video source subdevice which have popped up as a blocker for other 
> >>> work.
> >>>
> >>> This series is broken out of my much larger R-Car Gen3 enablement series 
> >>> '[PATCHv2 00/32] rcar-vin: Add Gen3 with media controller support'. I 
> >>> plan to remove that series form patchwork and focus on these fixes first 
> >>> as they are blocking other development. Once the blocking issues are 
> >>> removed I will rebase and repost the larger Gen3 series.
> >>>
> >>> Patch 1-4 fix simple problems found while testing
> >>>     1-2 Fix format problems when the format is (re)set.
> >>>     3   Fix media pad errors
> >>>     4   Fix standard enumeration problem
> >>>
> >>> Patch 5 adds a wrapper function to retrieve the active video source 
> >>> subdevice. This is strictly not needed on Gen2 which only have one 
> >>> possible video source per VIN instance (This will change on Gen3). But 
> >>> patch 6-8,11 which fixes real issues on Gen2 make use of this wrapper, as 
> >>> not risk breaking things by removing this wrapper in this series and 
> >>> then readding it in a later Gen3 series I have chosen to keep the patch.  
> >>> Please let me know if I should drop it and rewrite patch 6-11 (if 
> >>> possible I would like to avoid that).
> >>>
> >>> Patch 6-8 deals with video source subdevice pad index handling by moving 
> >>> the information from struct rvin_dev to struct rvin_graph_entity and 
> >>> moving the pad index probing to the struct v4l2_async_notifier complete 
> >>> callback. This is needed to allow the bind/unbind fix in patch 10-11.
> >>>
> >>> Patch 9 use the pad information when calling enum_mbus_code.
> >>>
> >>> Patch 10-11 fix a OPS when unbinding/binding the video source subdevice.
> >>
> >> This will not help: you can unbind a subdev at any time, including when
> >> it is in use.
> > 
> > Yes, this series will not help remedy the problem if a device is in use.  
> > But I still find it useful since it unblocks other work, solves a OPS 
> > and if there are no current users the driver can supports unbind/bind of 
> > its subdevices, it's not perfect but it do make things a little better 
> > IMHO.
> > 
> > If it where not for me wishing to reuse the behavior introduced in patch 
> > 10-11 on R-Car Gen3 when a subdevice could not available for for other 
> > reasons than it's not bound (see bellow) I would be happy to drop the 
> > patches from this series.
> > 
> >>
> >> But why do you need this at all? You can also set suppress_bind_attrs in
> >> the adv7180 driver to prevent the bind/unbind files from appearing.
> > 
> > The primary use-case for this is on R-Car Gen3 where there are a limited 
> > number of possible routing options to connect CSI-2 devices to VIN 
> > devices (set in hardware), see table bellow. The routing possibilities 
> > are set per VIN group (VIN0-3 and VIN4-7) and not individually for each 
> > VIN device. Given this limitation some routing options will result in an 
> > N/A video source for one or more VIN devices in a VIN "group".
> > 
> >    - VIN0-3 controlled by chsel register in VIN0
> >    chsel    VIN0        VIN1        VIN2        VIN3
> >    0        CSI40/VC0   CSI20/VC0   N/A         CSI40/VC1
> >    1        CSI20/VC0   N/A         CSI40/VC0   CSI20/VC1
> >    2        N/A         CSI40/VC0   CSI20/VC0   N/A
> >    3        CSI40/VC0   CSI40/VC1   CSI40/VC2   CSI40/VC3
> >    4        CSI20/VC0   CSI20/VC1   CSI20/VC2   CSI20/VC3
> > 
> >    - VIN4-7 controlled by chsel register in VIN4
> >    chsel    VIN4        VIN5        VIN6        VIN7
> >    0        CSI40/VC0   CSI20/VC0   N/A         CSI40/VC1
> >    1        CSI20/VC0   N/A         CSI40/VC0   CSI20/VC1
> >    2        N/A         CSI40/VC0   CSI20/VC0   N/A
> >    3        CSI40/VC0   CSI40/VC1   CSI40/VC2   CSI40/VC3
> >    4        CSI20/VC0   CSI20/VC1   CSI20/VC2   CSI20/VC3
> > 
> > Example: If a VIN1 device is exposed as /dev/video1 and the current 
> > CSI-2 to VIN routing configuration controlled by the chsel register in 
> > VIN0 is set to 1 the video source routed to VIN1 is N/A. The idea then 
> > is that any open of /dev/video1 should result in -EBUSY until the CSI-2 
> > to VIN routing changes so that VIN1 is connected to a valid subdevice 
> > again. (side note: changing chsel value will not be allowed while any 
> > VIN device is opened and is done using MC)
> > 
> > This series was originally part of my R-Car Gen3 enablement series so I
> > chose to keep this behavior even if the underlying Gen2 OPS could be 
> > fixed in a different way. With this solution a unavailable subdevice 
> > (subdev not bound on Gen2+Gen3 or a N/A subdevice due to routing setup 
> > on Gen3) would be handled the same (-EBUSY) on both Gen2 and Gen3.
> > 
> > All testing I have done on the driver both on Gen2 and Gen3 have been 
> > based on this solution for quiet a while now. And it seemed strange for 
> > me to try and solve the Gen2 issue differently only to rework it again 
> > later in the Gen3 enablement series.
> > 
> > I'm sorry that I did not explain more about this in the original cover 
> > letter. Did this explanation help clear things up? And is the idea of 
> > returning -EBUSY a OK solution in general to the problem that a video 
> > device who once had all its subdevices available no longer do so, but it 
> > might get them back in the future? I'm happy too keep working and 
> > improving this solution, this is only the best one i found so far :-)
> > 
> >>
> >> It really makes no sense for subdevs. In fact, all subdevs should set this
> >> flag since in the current implementation this is completely impossible to
> >> implement safely.
> >>
> >> I suggest you drop the patches relating to this and instead set the suppress
> >> flag.
> > 
> > If possible I would like to explore the possibility to keep it in the 
> > series. I think it would be an advantage to treat on unbound subdevice 
> > on Gen2 in the same way as a VIN instance on Gen3 would treat a CSI-2 to 
> > VIN routing configuration with a N/A route.
> > 
> > I am of course willing to rework the behavior to something else then 
> > returning -EBUSY if a VIN instance currently have all subdevices 
> > available for some reason. I would like input on how such a scheme could 
> > look like since the -EBUSY one is the only solution I have managed to 
> > figure out and implement.
> 
> I think the core problem here is perhaps less the patches but more the commit
> logs you wrote. You say in several places that is it 'To support unbind and
> rebinding of subdevices'. But it doesn't support that, instead it really
> prepares for a specific Gen3 use-case.
> 
> All existing drivers with subdevs can be induced to oops if you unbind/bind
> a subdev. It is broken at the core, and without fixing it at the core first,
> anything you try to do in a driver is just a band-aid.

I see your point, the patches where extracted from my Gen3 enablement 
series to solve the OPS reported by Wolfram when unbinding/binding on 
Gen2. But yes they try to solve the issue by preparing for the wanted 
Gen3 behavior where this particular OPS do not happen (if the device is 
unused).

I do now understand that trying to fix OPS related to unbind/bind is 
futile without core support.

> 
> Take patch 07/11, the commit log says:
> 
> "To fix support for unbind and rebinding of subdevices the
> rvin_v4l2_probe() needs to be called before there might be any subdevice
> bound. Move pad index discovery to when we know the subdevice is
> present."
> 
> This commit log is very misleading. It suggests that this patch fixes
> unbind/rebind support, which it doesn't. Instead, it just prepares for
> patch 11/11 where you want to (partially?) re-initialize the subdevs at
> first open. And that in turn is for future Gen3 support.
> 
> None of this has anything to do with unbind/rebind. The fact that you
> can now do this if there are no filehandles open is a side-effect, and not
> the main reason for the patches.
> 
> I recommend that you take another look and rewrite the commit logs so they
> reflect the real reason you do this.

I will do so and post a new version, thanks for your feedback.

> 
> > And thanks again for your feedback, I really love to see some R-Car VIN 
> > work move forward. Let me know if I can do anything to ease the process.
> 
> Sure, no problem. I've not been a good reviewer recently, but it's getting
> better as I have more time now.
> 
> Regards,
> 
> 	Hans

-- 
Regards,
Niklas Söderlund
