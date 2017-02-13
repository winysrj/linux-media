Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36285 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdBMRrl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 12:47:41 -0500
Received: by mail-lf0-f49.google.com with SMTP id z134so54258250lff.3
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 09:47:40 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 13 Feb 2017 18:47:37 +0100
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 00/11] media: rcar-vin: fix OPS and format/pad index
 issues
Message-ID: <20170213174737.GD12706@bigcity.dyn.berto.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
 <35612ce2-57b1-3059-60c8-18806e3f066a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35612ce2-57b1-3059-60c8-18806e3f066a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your feedback.

On 2017-02-13 15:19:13 +0100, Hans Verkuil wrote:
> Hi Niklas,
> 
> One general remark: in many commit logs you mistype 'subdeivce'. Can you
> fix that for the v2?

Will fix for v2.

> 
> On 01/31/2017 04:40 PM, Niklas Söderlund wrote:
> > Hi,
> > 
> > This series address issues with the R-Car Gen2 VIN driver. The most 
> > serious issue is the OPS when unbind and rebinding the i2c driver for 
> > the video source subdevice which have popped up as a blocker for other 
> > work.
> > 
> > This series is broken out of my much larger R-Car Gen3 enablement series 
> > '[PATCHv2 00/32] rcar-vin: Add Gen3 with media controller support'. I 
> > plan to remove that series form patchwork and focus on these fixes first 
> > as they are blocking other development. Once the blocking issues are 
> > removed I will rebase and repost the larger Gen3 series.
> > 
> > Patch 1-4 fix simple problems found while testing
> >     1-2 Fix format problems when the format is (re)set.
> >     3   Fix media pad errors
> >     4   Fix standard enumeration problem
> > 
> > Patch 5 adds a wrapper function to retrieve the active video source 
> > subdevice. This is strictly not needed on Gen2 which only have one 
> > possible video source per VIN instance (This will change on Gen3). But 
> > patch 6-8,11 which fixes real issues on Gen2 make use of this wrapper, as 
> > not risk breaking things by removing this wrapper in this series and 
> > then readding it in a later Gen3 series I have chosen to keep the patch.  
> > Please let me know if I should drop it and rewrite patch 6-11 (if 
> > possible I would like to avoid that).
> > 
> > Patch 6-8 deals with video source subdevice pad index handling by moving 
> > the information from struct rvin_dev to struct rvin_graph_entity and 
> > moving the pad index probing to the struct v4l2_async_notifier complete 
> > callback. This is needed to allow the bind/unbind fix in patch 10-11.
> > 
> > Patch 9 use the pad information when calling enum_mbus_code.
> > 
> > Patch 10-11 fix a OPS when unbinding/binding the video source subdevice.
> 
> This will not help: you can unbind a subdev at any time, including when
> it is in use.

Yes, this series will not help remedy the problem if a device is in use.  
But I still find it useful since it unblocks other work, solves a OPS 
and if there are no current users the driver can supports unbind/bind of 
its subdevices, it's not perfect but it do make things a little better 
IMHO.

If it where not for me wishing to reuse the behavior introduced in patch 
10-11 on R-Car Gen3 when a subdevice could not available for for other 
reasons than it's not bound (see bellow) I would be happy to drop the 
patches from this series.

> 
> But why do you need this at all? You can also set suppress_bind_attrs in
> the adv7180 driver to prevent the bind/unbind files from appearing.

The primary use-case for this is on R-Car Gen3 where there are a limited 
number of possible routing options to connect CSI-2 devices to VIN 
devices (set in hardware), see table bellow. The routing possibilities 
are set per VIN group (VIN0-3 and VIN4-7) and not individually for each 
VIN device. Given this limitation some routing options will result in an 
N/A video source for one or more VIN devices in a VIN "group".

   - VIN0-3 controlled by chsel register in VIN0
   chsel    VIN0        VIN1        VIN2        VIN3
   0        CSI40/VC0   CSI20/VC0   N/A         CSI40/VC1
   1        CSI20/VC0   N/A         CSI40/VC0   CSI20/VC1
   2        N/A         CSI40/VC0   CSI20/VC0   N/A
   3        CSI40/VC0   CSI40/VC1   CSI40/VC2   CSI40/VC3
   4        CSI20/VC0   CSI20/VC1   CSI20/VC2   CSI20/VC3

   - VIN4-7 controlled by chsel register in VIN4
   chsel    VIN4        VIN5        VIN6        VIN7
   0        CSI40/VC0   CSI20/VC0   N/A         CSI40/VC1
   1        CSI20/VC0   N/A         CSI40/VC0   CSI20/VC1
   2        N/A         CSI40/VC0   CSI20/VC0   N/A
   3        CSI40/VC0   CSI40/VC1   CSI40/VC2   CSI40/VC3
   4        CSI20/VC0   CSI20/VC1   CSI20/VC2   CSI20/VC3

Example: If a VIN1 device is exposed as /dev/video1 and the current 
CSI-2 to VIN routing configuration controlled by the chsel register in 
VIN0 is set to 1 the video source routed to VIN1 is N/A. The idea then 
is that any open of /dev/video1 should result in -EBUSY until the CSI-2 
to VIN routing changes so that VIN1 is connected to a valid subdevice 
again. (side note: changing chsel value will not be allowed while any 
VIN device is opened and is done using MC)

This series was originally part of my R-Car Gen3 enablement series so I
chose to keep this behavior even if the underlying Gen2 OPS could be 
fixed in a different way. With this solution a unavailable subdevice 
(subdev not bound on Gen2+Gen3 or a N/A subdevice due to routing setup 
on Gen3) would be handled the same (-EBUSY) on both Gen2 and Gen3.

All testing I have done on the driver both on Gen2 and Gen3 have been 
based on this solution for quiet a while now. And it seemed strange for 
me to try and solve the Gen2 issue differently only to rework it again 
later in the Gen3 enablement series.

I'm sorry that I did not explain more about this in the original cover 
letter. Did this explanation help clear things up? And is the idea of 
returning -EBUSY a OK solution in general to the problem that a video 
device who once had all its subdevices available no longer do so, but it 
might get them back in the future? I'm happy too keep working and 
improving this solution, this is only the best one i found so far :-)

> 
> It really makes no sense for subdevs. In fact, all subdevs should set this
> flag since in the current implementation this is completely impossible to
> implement safely.
> 
> I suggest you drop the patches relating to this and instead set the suppress
> flag.

If possible I would like to explore the possibility to keep it in the 
series. I think it would be an advantage to treat on unbound subdevice 
on Gen2 in the same way as a VIN instance on Gen3 would treat a CSI-2 to 
VIN routing configuration with a N/A route.

I am of course willing to rework the behavior to something else then 
returning -EBUSY if a VIN instance currently have all subdevices 
available for some reason. I would like input on how such a scheme could 
look like since the -EBUSY one is the only solution I have managed to 
figure out and implement.

And thanks again for your feedback, I really love to see some R-Car VIN 
work move forward. Let me know if I can do anything to ease the process.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > # echo 2-0020 > /sys/bus/i2c/drivers/adv7180/unbind
> > # echo 2-0020 > /sys/bus/i2c/drivers/adv7180/bind
> > 
> >  adv7180 2-0020: chip found @ 0x20 (e6530000.i2c)
> >  kobject (eaaab118): tried to init an initialized object, something is seriously wrong.
> >  CPU: 0 PID: 1640 Comm: bash Not tainted 4.10.0-rc4-00029-g19b80f8913cad837 #1
> >  Hardware name: Generic R8A7791 (Flattened Device Tree)
> >  Backtrace: 
> >  [<c010a858>] (dump_backtrace) from [<c010aaa4>] (show_stack+0x18/0x1c)
> >   r7:00000016 r6:60070013 r5:00000000 r4:c0a14dd8
> >  [<c010aa8c>] (show_stack) from [<c02de09c>] (dump_stack+0x84/0xa0)
> >  [<c02de018>] (dump_stack) from [<c02dfee4>] (kobject_init+0x3c/0x98)
> >   r7:00000016 r6:eaaab2e4 r5:c0a1f4dc r4:eaaab118
> >  [<c02dfea8>] (kobject_init) from [<c03b9244>] (device_initialize+0x28/0xb0)
> >   r5:c0a70be8 r4:eaaab110
> >  [<c03b921c>] (device_initialize) from [<c03baa34>] (device_register+0x14/0x20)
> >   r5:eaaab110 r4:eaaab110
> >  [<c03baa20>] (device_register) from [<c04a02c0>] (__video_register_device+0xb38/0x11cc)
> >   r5:eaaab110 r4:eaaab020
> >  [<c049f788>] (__video_register_device) from [<c04c91a0>] (rvin_v4l2_probe+0x17c/0x1e8)
> >   r10:00000000 r9:eaa3c050 r8:c0a270a8 r7:eaaab3a0 r6:eaaab020 r5:c0790068
> >   r4:eaaab010
> >  [<c04c9024>] (rvin_v4l2_probe) from [<c04c6da0>] (rvin_digital_notify_complete+0x174/0x184)
> >   r7:00002006 r6:eaaab010 r5:00000000 r4:eaaab3e0
> >  [<c04c6c2c>] (rvin_digital_notify_complete) from [<c04af180>] (v4l2_async_test_notify+0xe8/0xf0)
> >   r7:eaaab410 r6:eaa3c050 r5:c04c6c2c r4:eaaab3e0
> >  [<c04af098>] (v4l2_async_test_notify) from [<c04af560>] (v4l2_async_register_subdev+0xa4/0xcc)
> >   r7:eaa3c0fc r6:c0a27094 r5:eaaab3e0 r4:eaa3c050
> >  [<c04af4bc>] (v4l2_async_register_subdev) from [<c0497740>] (adv7180_probe+0x350/0x3e0)
> >   r9:eaa3c050 r8:00000000 r7:00000000 r6:00000000 r5:eb2cbe00 r4:eaa3c010
> >  [<c04973f0>] (adv7180_probe) from [<c048e9f4>] (i2c_device_probe+0x238/0x250)
> >   r9:0000000e r8:c0a264dc r7:eb2cbe20 r6:c0a264dc r5:c04973f0 r4:eb2cbe00
> >  [<c048e7bc>] (i2c_device_probe) from [<c03bd4f4>] (driver_probe_device+0x1f8/0x2c0)
> >   r9:0000000e r8:c0a264dc r7:00000000 r6:c0a70c18 r5:c0a70c0c r4:eb2cbe20
> >  [<c03bd2fc>] (driver_probe_device) from [<c03bbcd0>] (bind_store+0x94/0xe8)
> >   r10:00000000 r9:00000051 r8:00000007 r7:c0a26058 r6:eb2cbe54 r5:c0a264dc
> >   r4:eb2cbe20 r3:ea60b000
> >  [<c03bbc3c>] (bind_store) from [<c03bb710>] (drv_attr_store+0x2c/0x38)
> >   r9:00000051 r8:eb2daa0c r7:ea58ff80 r6:eb2daa00 r5:ea87a4c0 r4:c03bbc3c
> >  [<c03bb6e4>] (drv_attr_store) from [<c023e5e4>] (sysfs_kf_write+0x40/0x4c)
> >   r5:ea87a4c0 r4:c03bb6e4
> >  [<c023e5a4>] (sysfs_kf_write) from [<c023dc50>] (kernfs_fop_write+0x13c/0x1ac)
> >   r5:ea87a4c0 r4:00000007
> >  [<c023db14>] (kernfs_fop_write) from [<c01e0c78>] (__vfs_write+0x34/0x114)
> >   r9:ea58e000 r8:00000000 r7:00000007 r6:ea58ff80 r5:ea52a480 r4:c023db14
> >  [<c01e0c44>] (__vfs_write) from [<c01e0ee4>] (vfs_write+0xc4/0x150)
> >   r7:ea58ff80 r6:00167028 r5:00000007 r4:ea52a480
> >  [<c01e0e20>] (vfs_write) from [<c01e1038>] (SyS_write+0x48/0x80)
> >   r9:ea58e000 r8:c0106ee4 r7:00000007 r6:00167028 r5:ea52a480 r4:ea52a480
> >  [<c01e0ff0>] (SyS_write) from [<c0106d20>] (ret_fast_syscall+0x0/0x3c)
> >   r7:00000004 r6:b6dfed50 r5:00167028 r4:00000007
> > 
> > Niklas Söderlund (11):
> >   media: rcar-vin: reset bytesperline and sizeimage when resetting
> >     format
> >   media: rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
> >   media: rcar-vin: fix how pads are handled for v4l2 subdeivce
> >     operations
> >   media: rcar-vin: fix standard in input enumeration
> >   media: rcar-vin: add wrapper to get rvin_graph_entity
> >   media: rcar-vin: move subdev source and sink pad index to
> >     rvin_graph_entity
> >   media: rcar-vin: move pad index discovery to async complete handler
> >   media: rcar-vin: refactor pad lookup code
> >   media: rcar-vin: use pad information when verifying media bus format
> >   media: rcar-vin: split rvin_s_fmt_vid_cap()
> >   media: rcar-vin: register the video device early
> > 
> >  drivers/media/platform/rcar-vin/rcar-core.c |  40 +++-
> >  drivers/media/platform/rcar-vin/rcar-dma.c  |  15 +-
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 346 +++++++++++++++-------------
> >  drivers/media/platform/rcar-vin/rcar-vin.h  |  20 +-
> >  4 files changed, 244 insertions(+), 177 deletions(-)
> > 
> 

-- 
Regards,
Niklas Söderlund
