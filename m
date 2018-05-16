Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:12966 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751510AbeEPOH0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 10:07:26 -0400
Date: Wed, 16 May 2018 17:07:20 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com, sadolfsson@google.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, fparent@baylibre.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        linux-media@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v2 2/5] drm/i915: hdmi: add CEC notifier to
 intel_hdmi
Message-ID: <20180516140720.GD23723@intel.com>
References: <1526395342-15481-1-git-send-email-narmstrong@baylibre.com>
 <1526395342-15481-3-git-send-email-narmstrong@baylibre.com>
 <20180515153521.GB23723@intel.com>
 <aff8c86f-b282-c901-5ef5-c5ee334aeedc@baylibre.com>
 <e0f99123-1463-c082-122e-67cf0d106e25@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0f99123-1463-c082-122e-67cf0d106e25@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 16, 2018 at 09:40:17AM +0200, Neil Armstrong wrote:
> On 16/05/2018 09:31, Neil Armstrong wrote:
> > Hi Ville,
> > 
> > On 15/05/2018 17:35, Ville Syrjälä wrote:
> >> On Tue, May 15, 2018 at 04:42:19PM +0200, Neil Armstrong wrote:
> >>> This patchs adds the cec_notifier feature to the intel_hdmi part
> >>> of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
> >>> between each HDMI ports.
> >>> The changes will allow the i915 HDMI code to notify EDID and HPD changes
> >>> to an eventual CEC adapter.
> >>>
> >>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> >>> ---
> >>>  drivers/gpu/drm/i915/Kconfig      |  1 +
> >>>  drivers/gpu/drm/i915/intel_drv.h  |  2 ++
> >>>  drivers/gpu/drm/i915/intel_hdmi.c | 12 ++++++++++++
> >>>  3 files changed, 15 insertions(+)
> >>>
> > 
> > [..]
> > 
> >>>  }
> >>>  
> >>> @@ -2031,6 +2037,8 @@ static void chv_hdmi_pre_enable(struct intel_encoder *encoder,
> >>>  
> >>>  static void intel_hdmi_destroy(struct drm_connector *connector)
> >>>  {
> >>> +	if (intel_attached_hdmi(connector)->notifier)
> >>> +		cec_notifier_put(intel_attached_hdmi(connector)->notifier);
> >>>  	kfree(to_intel_connector(connector)->detect_edid);
> >>>  	drm_connector_cleanup(connector);
> >>>  	kfree(connector);
> >>> @@ -2358,6 +2366,10 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
> >>>  		u32 temp = I915_READ(PEG_BAND_GAP_DATA);
> >>>  		I915_WRITE(PEG_BAND_GAP_DATA, (temp & ~0xf) | 0xd);
> >>>  	}
> >>> +
> >>> +	intel_hdmi->notifier = cec_notifier_get_conn(dev->dev, connector->name);
> >>
> >> What are we doing with the connector name here? Those are not actually
> >> guaranteed to be stable, and any change in the connector probe order
> >> may cause the name to change.
> > 
> > The i915 driver can expose multiple HDMI connectors, but each connected will
> > have a different EDID and CEC physical address, so we will need a different notifier
> > for each connector.
> > 
> > The connector name is DRM dependent, but user-space actually uses this name for
> > operations, so I supposed it was kind of stable.
> > 
> > Anyway, is there another stable id/name/whatever that can be used to make a name to
> > distinguish the HDMI connectors ?
> 
> Would "HDMI %c", port_name(port) be OK to use ?

Yeah, something like seems like a reasonable approach. That does mean
we have to be a little careful with changing enum port or port_name()
in the future, but I guess we could just add a small function to
generated the name/id specifically for this thing.

We're also going to have to think what to do with enum port and
port_name() on ICL+ though. There we won't just have A-F but also
TC1-TC<n>. Hmm. Looks like what we have for those ports in our
codebase ATM is a bit wonky since we haven't even changed
port_name() to give us the TC<n> type names.

Also we might not want "HDMI" in the identifier since the physical
port is not HDMI specific. There are different things we could call
these but I think we could just go with a generic "Port A-F" and
"Port TC1-TC<n>" approach. I think something like that should work
fine for current and upcoming hardware. And in theory that could
then be used for other things as well which need a stable
identifier.

Oh, and now I recall that input subsystem at least has some kind
of "physical path" property on devices. So I guess what we're
dicussing is a somewhat similar idea. I think input drivers
generally include the pci/usb/etc. device in the path as well.
Even though we currently only ever have the one pci device it
would seem like decent idea to include that information in our
identifiers as well. Or what do you think?

-- 
Ville Syrjälä
Intel
