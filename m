Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:30140 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbdKTO4C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 09:56:02 -0500
Date: Mon, 20 Nov 2017 16:55:57 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 10/10] video/hdmi: Pass buffer size to infoframe unpack
 functions
Message-ID: <20171120145557.GX10981@intel.com>
References: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
 <20171113170427.4150-11-ville.syrjala@linux.intel.com>
 <7722c9f6-4bad-7698-da5d-41fe50974562@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7722c9f6-4bad-7698-da5d-41fe50974562@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 20, 2017 at 02:36:20PM +0100, Hans Verkuil wrote:
> On 11/13/2017 06:04 PM, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
<snip>
> > @@ -1163,7 +1176,7 @@ static int hdmi_audio_infoframe_unpack(struct hdmi_audio_infoframe *frame,
> >   */
> >  static int
> >  hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
> > -				 const void *buffer)
> > +				 const void *buffer, size_t size)
> >  {
> >  	const u8 *ptr = buffer;
> >  	size_t length;
> > @@ -1171,6 +1184,9 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
> >  	u8 hdmi_video_format;
> >  	struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
> >  
> > +	if (size < HDMI_INFOFRAME_HEADER_SIZE)
> > +		return -EINVAL;
> > +
> 
> This check is not needed since that is already done in hdmi_infoframe_unpack().

Hmm. True. Somehow I was expecting that this function would have been
exported on its own, but it's static so clearly I was mistaken.

The pack functions are individually exported, which is where I got
this idea probably.

> 
> >  	if (ptr[0] != HDMI_INFOFRAME_TYPE_VENDOR ||
> >  	    ptr[1] != 1 ||
> >  	    (ptr[2] != 4 && ptr[2] != 5 && ptr[2] != 6))
> > @@ -1178,6 +1194,9 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
> >  
> >  	length = ptr[2];
> >  
> > +	if (size < HDMI_INFOFRAME_HEADER_SIZE + length)
> > +		return -EINVAL;
> > +
> >  	if (hdmi_infoframe_checksum(buffer,
> >  				    HDMI_INFOFRAME_HEADER_SIZE + length) != 0)
> >  		return -EINVAL;

-- 
Ville Syrjälä
Intel OTC
