Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47266 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933701AbeFLKXT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 06:23:19 -0400
Subject: Re: Fwd: Re: [PATCHv5 0/3] drm/i915: add DisplayPort
 CEC-Tunneling-over-AUX support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: ville.syrjala@linux.intel.com
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <b6ac8671-7b66-977e-1322-f31e08d76436@xs4all.nl>
 <7ec14da2-7aed-906e-3d55-8af1907aaf0c@xs4all.nl>
 <20180112163027.GG10981@intel.com>
 <e7c4e82c-e563-834b-8708-42efa222e7d3@xs4all.nl>
 <20180112175218.GJ10981@intel.com>
 <47a32832-4a4e-c66b-2d7f-f8f7a6093ada@xs4all.nl>
 <9e28a8fe-c792-df98-012d-f7d02ad1e9b2@xs4all.nl>
 <89934a2a-1a2f-4ea8-f9b8-16e5c575a8f6@xs4all.nl>
 <23ff8abe-db62-c8e4-ff0a-1bcb9b0b98a8@xs4all.nl>
Message-ID: <0f1e9637-fef6-a3cc-efa8-182f570570e8@xs4all.nl>
Date: Tue, 12 Jun 2018 12:23:15 +0200
MIME-Version: 1.0
In-Reply-To: <23ff8abe-db62-c8e4-ff0a-1bcb9b0b98a8@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/18 14:20, Hans Verkuil wrote:
> Hi Ville,
> 
> I finally found some time to dig deeper into when a CEC device should be registered.
> 
> Since it's been a long while since we discussed this let me just recap the situation
> and then propose three solutions:
> CEC is implemented for DP-to-HDMI branch devices through DPCD CEC registers. When
> HPD is high we can read these registers and check if CEC is supported or not.
> 
> If an external USB-C/DP/mini-DP to HDMI adapter is used, then when the HPD goes low
> you lose access to the DPCD registers since that is (I think) powered by the HPD.
> 
> If an integrated branch device is used (such as for the HDMI connector on the NUC)
> the DPCD registers will remain available even if the display is disconnected.
> 
> The problem is with external adapters since if the HPD goes low you do not know
> if the adapter has been disconnected, or if the display just pulled the HPD low for a
> short time (updating the EDID, HDCP changes). In the latter case you do not want to
> unregister and reregister the cec device.
> 
> I see three options:
> 
> 1) register a cec device when a connector is registered and keep it for the life time
> of the connector. If HPD goes low, or the branch device doesn't support CEC, then just
> set the physical address of the CEC adapter to f.f.f.f.
> 
> This is simple, but the disadvantage is that there is a CEC device around, even if the
> branch device doesn't support CEC.
> 
> 2) register a cec device when HPD goes high and if a branch device that supports CEC is
> detected. Unregister the cec device when the HPD goes low and stays low for more than
> a second. This prevents a cec device from disappearing whenever the display toggles
> the HPD. It does require a delayed workqueue to handle this delay.
> 
> It would be nice if there is a way to avoid a delayed workqueue, but I didn't see
> anything in the i915 code.
> 
> 3) A hybrid option where the cec device is only registered when a CEC capable branch
> device is detected, but then we keep it for the remaining lifetime of the connector.
> This avoids the delayed workqueue, and avoids creating cec devices if the branch
> device doesn't support CEC. But once it is created it won't be removed until the
> connector is also unregistered.
> 
> I'm leaning towards the second or third option.
> 
> Opinions? Other ideas?

A quick update: I've been working on a next version of this patch series that combines
options 2 and 3 and moves the logic out of the i915 driver into the core drm CEC code
since all DP drivers will have the same problem.

I hope to post the new series later today.

Regards,

	Hans
