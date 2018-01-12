Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:63511 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933994AbeALQab (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 11:30:31 -0500
Date: Fri, 12 Jan 2018 18:30:27 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: Fwd: Re: [PATCHv5 0/3] drm/i915: add DisplayPort
 CEC-Tunneling-over-AUX support
Message-ID: <20180112163027.GG10981@intel.com>
References: <b6ac8671-7b66-977e-1322-f31e08d76436@xs4all.nl>
 <7ec14da2-7aed-906e-3d55-8af1907aaf0c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ec14da2-7aed-906e-3d55-8af1907aaf0c@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 12, 2018 at 05:19:44PM +0100, Hans Verkuil wrote:
> Hi Ville,
> 
> For some strange reason your email disappeared from the Cc list. Perhaps it's the
> ä that confuses something somewhere.
> 
> So I'll just forward this directly to you.
> 
> Can you please take a look? This patch series has been in limbo for too long.

IIRC last I looked we still had some ragistration race to deal with.
Was that fixed?

Also I think we got stuck on leaving the zombie device lingering around
when the display is disconnected. I couldn't understand why that is
at all useful since you anyway remove the device eventually.

Adding the lists back to cc so I don't have to repeat myself there...

> 
> Regards,
> 
> 	Hans
> 
> 
> -------- Forwarded Message --------
> Subject: Re: [PATCHv5 0/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
> Date: Tue, 9 Jan 2018 13:46:44 +0100
> From: Hans Verkuil <hverkuil@xs4all.nl>
> To: linux-media@vger.kernel.org
> CC: Daniel Vetter <daniel.vetter@ffwll.ch>, Carlos Santa <carlos.santa@intel.com>, dri-devel@lists.freedesktop.org
> 
> First of all a Happy New Year for all of you!
> 
> And secondly: can this v5 patch series be reviewed/merged? It's been waiting
> for that for a very long time now...
> 
> Regards,
> 
> 	Hans
> 
> On 12/11/17 09:57, Hans Verkuil wrote:
> > Ping again. Added a CC to Ville whom I inexplicably forgot to add when
> > I sent the v5 patch series.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > On 01/12/17 08:23, Hans Verkuil wrote:
> >> Ping!
> >>
> >> I really like to get this in for 4.16 so I can move forward with hooking
> >> this up for nouveau/amd.
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >> On 11/20/2017 12:42 PM, Hans Verkuil wrote:
> >>> This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
> >>> feature. This patch series is based on the 4.14 mainline release but applies
> >>> as well to drm-next.
> >>>
> >>> This patch series has been tested with my NUC7i5BNK, a Samsung USB-C to 
> >>> HDMI adapter and a Club 3D DisplayPort MST Hub + modified UpTab DP-to-HDMI
> >>> adapter (where the CEC pin is wired up).
> >>>
> >>> Please note this comment at the start of drm_dp_cec.c:
> >>>
> >>> ----------------------------------------------------------------------
> >>> Unfortunately it turns out that we have a chicken-and-egg situation
> >>> here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
> >>> have a converter chip that supports CEC-Tunneling-over-AUX (usually the
> >>> Parade PS176 or MegaChips MCDP2900), but they do not wire up the CEC pin,
> >>> thus making CEC useless.
> >>>
> >>> Sadly there is no way for this driver to know this. What happens is
> >>> that a /dev/cecX device is created that is isolated and unable to see
> >>> any of the other CEC devices. Quite literally the CEC wire is cut
> >>> (or in this case, never connected in the first place).
> >>>
> >>> I suspect that the reason so few adapters support this is that this
> >>> tunneling protocol was never supported by any OS. So there was no
> >>> easy way of testing it, and no incentive to correctly wire up the
> >>> CEC pin.
> >>>
> >>> Hopefully by creating this driver it will be easier for vendors to
> >>> finally fix their adapters and test the CEC functionality.
> >>>
> >>> I keep a list of known working adapters here:
> >>>
> >>> https://hverkuil.home.xs4all.nl/cec-status.txt
> >>>
> >>> Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
> >>> and is not yet listed there.
> >>>
> >>> Note that the current implementation does not support CEC over an MST hub.
> >>> As far as I can see there is no mechanism defined in the DisplayPort
> >>> standard to transport CEC interrupts over an MST device. It might be
> >>> possible to do this through polling, but I have not been able to get that
> >>> to work.
> >>> ----------------------------------------------------------------------
> >>>
> >>> I really hope that this work will provide an incentive for vendors to
> >>> finally connect the CEC pin. It's a shame that there are so few adapters
> >>> that work (I found only two USB-C to HDMI adapters that work, and no
> >>> (mini-)DP to HDMI adapters at all).
> >>>
> >>> Hopefully if this gets merged there will be an incentive for vendors
> >>> to make adapters where this actually works. It is a very nice feature
> >>> for HTPC boxes.
> >>>
> >>> The main reason why this v5 is delayed by 2 months is due to the fact
> >>> that I needed some dedicated time to investigate what happens when an
> >>> MST hub is in use. It turns out that this is not working. There is no
> >>> mechanism defined in the DisplayPort standard to transport the CEC
> >>> interrupt back up the MST chain. I was actually able to send a CEC
> >>> message but the interrupt that tells when the transmit finished is
> >>> unavailable.
> >>>
> >>> I attempted to implement this via polling, but I got weird errors
> >>> and was not able to read the DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1
> >>> register. I decided to give up on this for now and just disable CEC
> >>> for DP-to-HDMI adapters after an MST hub. I plan to revisit this
> >>> later since it would be neat to make this work as well. Although it
> >>> might not be possible at all.
> >>>
> >>> If anyone is interested, work-in-progress for this is here:
> >>>
> >>> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=dp-cec-mst
> >>>
> >>> Note that I removed the Tested-by tag from Carlos Santa due to the
> >>> almost complete rework of the third patch. Carlos, can you test this again?
> >>>
> >>> Regards,
> >>>
> >>>         Hans
> >>>
> >>> Changes since v4:
> >>>
> >>> - Updated comment at the start of drm_dp_cec.c
> >>> - Add edid pointer to drm_dp_cec_configure_adapter
> >>> - Reworked the last patch (adding CEC to i915) based on Ville's comments
> >>>   and my MST testing:
> >>> 	- register/unregister CEC in intel_dp_connector_register/unregister
> >>> 	- add comment and check if connector is registered in long_pulse
> >>> 	- unregister CEC if an MST 'connector' is detected.
> >>>
> >>> _______________________________________________
> >>> dri-devel mailing list
> >>> dri-devel@lists.freedesktop.org
> >>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> >>>
> >>
> >> _______________________________________________
> >> dri-devel mailing list
> >> dri-devel@lists.freedesktop.org
> >> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> >>
> > 
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> > 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel OTC
