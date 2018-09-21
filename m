Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5688 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbeIUTuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 15:50:39 -0400
Date: Fri, 21 Sep 2018 17:01:35 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 05/18] video/hdmi: Add an enum for HDMI packet types
Message-ID: <20180921140135.GX5565@intel.com>
References: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
 <20180920185145.1912-6-ville.syrjala@linux.intel.com>
 <cc758a1b-acab-caf1-a374-1f58c48e3e98@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc758a1b-acab-caf1-a374-1f58c48e3e98@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 21, 2018 at 10:41:46AM +0200, Hans Verkuil wrote:
> On 09/20/18 20:51, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > We'll be wanting to send more than just infoframes over HDMI. So add an
> > enum for other packet types.
> > 
> > TODO: Maybe just include the infoframe types in the packet type enum
> >       and get rid of the infoframe type enum?
> 
> I think that's better, IMHO. With a comment that the types starting with
> 0x81 are defined in CTA-861-G.
> 
> It's really the same byte that is being checked, so having two enums is
> a bit misleading. The main difference is really which standard defines
> the packet types.

Right. The only slight annoyance is that we'll get a bunch of warnings
from the compiler if we don't handle all the enum valus in the switch
statements. If we want to avoid that I guess I could limit this
to just the null, gcp and gamut metadata packets initially and try to
write some actual code for them. Those three are the only ones we
care about in i915 at the moment.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Cc: Thierry Reding <thierry.reding@gmail.com>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  include/linux/hdmi.h | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
> > index c76b50a48e48..80521d9591a1 100644
> > --- a/include/linux/hdmi.h
> > +++ b/include/linux/hdmi.h
> > @@ -27,6 +27,21 @@
> >  #include <linux/types.h>
> >  #include <linux/device.h>
> >  
> > +enum hdmi_packet_type {
> > +	HDMI_PACKET_TYPE_NULL = 0x00,
> > +	HDMI_PACKET_TYPE_AUDIO_CLOCK_REGEN = 0x01,
> > +	HDMI_PACKET_TYPE_AUDIO_SAMPLE = 0x02,
> > +	HDMI_PACKET_TYPE_GENERAL_CONTROL = 0x03,
> > +	HDMI_PACKET_TYPE_AUDIO_CP = 0x04,
> > +	HDMI_PACKET_TYPE_ISRC1 = 0x05,
> > +	HDMI_PACKET_TYPE_ISRC2 = 0x06,
> > +	HDMI_PACKET_TYPE_ONE_BIT_AUDIO_SAMPLE = 0x07,
> > +	HDMI_PACKET_TYPE_DST_AUDIO = 0x08,
> > +	HDMI_PACKET_TYPE_HBR_AUDIO_STREAM = 0x09,
> > +	HDMI_PACKET_TYPE_GAMUT_METADATA = 0x0a,
> > +	/* + enum hdmi_infoframe_type */
> > +};
> > +
> >  enum hdmi_infoframe_type {
> >  	HDMI_INFOFRAME_TYPE_VENDOR = 0x81,
> >  	HDMI_INFOFRAME_TYPE_AVI = 0x82,
> > 

-- 
Ville Syrjälä
Intel
