Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50612 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751003AbdHSMFZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 08:05:25 -0400
Subject: Re: [PATCHv2 0/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: dri-devel <dri-devel@lists.freedesktop.org>
Cc: linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        Carlos Santa <carlos.santa@intel.com>,
        David Airlie <airlied@linux.ie>
References: <20170812090107.5198-1-hverkuil@xs4all.nl>
Message-ID: <7ca54ec8-8820-799a-3f8a-cfc9b82ffca0@xs4all.nl>
Date: Sat, 19 Aug 2017 14:05:16 +0200
MIME-Version: 1.0
In-Reply-To: <20170812090107.5198-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2017 11:01 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
> feature. This patch series is based on 4.13-rc4 which has all the needed cec
> and drm 4.13 patches merged.
> 
> This patch series has been tested with my NUC7i5BNK and a Samsung USB-C to 
> HDMI adapter.
> 
> Please note this comment at the start of drm_dp_cec.c:
> 
> ----------------------------------------------------------------------
> Unfortunately it turns out that we have a chicken-and-egg situation
> here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
> have a converter chip that supports CEC-Tunneling-over-AUX (usually the
> Parade PS176), but they do not wire up the CEC pin, thus making CEC
> useless.
> 
> Sadly there is no way for this driver to know this. What happens is 
> that a /dev/cecX device is created that is isolated and unable to see
> any of the other CEC devices. Quite literally the CEC wire is cut
> (or in this case, never connected in the first place).
> 
> I suspect that the reason so few adapters support this is that this
> tunneling protocol was never supported by any OS. So there was no 
> easy way of testing it, and no incentive to correctly wire up the
> CEC pin.
> 
> Hopefully by creating this driver it will be easier for vendors to 
> finally fix their adapters and test the CEC functionality.
> 
> I keep a list of known working adapters here:
> 
> https://hverkuil.home.xs4all.nl/cec-status.txt
> 
> Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
> and is not yet listed there.
> ----------------------------------------------------------------------
> 
> I really hope that this work will provide an incentive for vendors to
> finally connect the CEC pin. It's a shame that there are so few adapters
> that work (I found only two USB-C to HDMI adapters that work, and no
> (mini-)DP to HDMI adapters at all).
> 
> Note that a colleague who actually knows his way around a soldering iron
> modified an UpTab DisplayPort-to-HDMI adapter for me, hooking up the CEC
> pin. And after that change it worked. I also received confirmation that
> this really is a chicken-and-egg situation: it is because there is no CEC
> support for this feature in any OS that they do not hook up the CEC pin.
> 
> So hopefully if this gets merged there will be an incentive for vendors
> to make adapters where this actually works. It is a very nice feature
> for HTPC boxes.
> 
> Changes since v1:
> 
> - Incorporated Sean's review comments in patch 1/3.

Ping?

Who is supposed to merge this? Is there anything I should do? I'd love to
get this in for 4.14...

Regards,

	Hans
