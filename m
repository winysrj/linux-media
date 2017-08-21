Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37526 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754464AbdHUQHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 12:07:40 -0400
Received: by mail-wr0-f193.google.com with SMTP id z91so18645306wrc.4
        for <linux-media@vger.kernel.org>; Mon, 21 Aug 2017 09:07:39 -0700 (PDT)
Date: Mon, 21 Aug 2017 18:07:27 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        Carlos Santa <carlos.santa@intel.com>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCHv2 0/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
Message-ID: <20170821160727.6ynp353rctry4gbn@phenom.ffwll.local>
References: <20170812090107.5198-1-hverkuil@xs4all.nl>
 <7ca54ec8-8820-799a-3f8a-cfc9b82ffca0@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ca54ec8-8820-799a-3f8a-cfc9b82ffca0@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 19, 2017 at 02:05:16PM +0200, Hans Verkuil wrote:
> On 08/12/2017 11:01 AM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
> > feature. This patch series is based on 4.13-rc4 which has all the needed cec
> > and drm 4.13 patches merged.
> > 
> > This patch series has been tested with my NUC7i5BNK and a Samsung USB-C to 
> > HDMI adapter.
> > 
> > Please note this comment at the start of drm_dp_cec.c:
> > 
> > ----------------------------------------------------------------------
> > Unfortunately it turns out that we have a chicken-and-egg situation
> > here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
> > have a converter chip that supports CEC-Tunneling-over-AUX (usually the
> > Parade PS176), but they do not wire up the CEC pin, thus making CEC
> > useless.
> > 
> > Sadly there is no way for this driver to know this. What happens is 
> > that a /dev/cecX device is created that is isolated and unable to see
> > any of the other CEC devices. Quite literally the CEC wire is cut
> > (or in this case, never connected in the first place).
> > 
> > I suspect that the reason so few adapters support this is that this
> > tunneling protocol was never supported by any OS. So there was no 
> > easy way of testing it, and no incentive to correctly wire up the
> > CEC pin.
> > 
> > Hopefully by creating this driver it will be easier for vendors to 
> > finally fix their adapters and test the CEC functionality.
> > 
> > I keep a list of known working adapters here:
> > 
> > https://hverkuil.home.xs4all.nl/cec-status.txt
> > 
> > Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
> > and is not yet listed there.
> > ----------------------------------------------------------------------
> > 
> > I really hope that this work will provide an incentive for vendors to
> > finally connect the CEC pin. It's a shame that there are so few adapters
> > that work (I found only two USB-C to HDMI adapters that work, and no
> > (mini-)DP to HDMI adapters at all).
> > 
> > Note that a colleague who actually knows his way around a soldering iron
> > modified an UpTab DisplayPort-to-HDMI adapter for me, hooking up the CEC
> > pin. And after that change it worked. I also received confirmation that
> > this really is a chicken-and-egg situation: it is because there is no CEC
> > support for this feature in any OS that they do not hook up the CEC pin.
> > 
> > So hopefully if this gets merged there will be an incentive for vendors
> > to make adapters where this actually works. It is a very nice feature
> > for HTPC boxes.
> > 
> > Changes since v1:
> > 
> > - Incorporated Sean's review comments in patch 1/3.
> 
> Ping?
> 
> Who is supposed to merge this? Is there anything I should do? I'd love to
> get this in for 4.14...

1) you have commit rights, so only really need to find a reviewer. Not
exactly sure who'd be a good reviewer, maybe Imre or Ville?
2) 4.14 is done, this will go into 4.15.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
