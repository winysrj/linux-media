Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45566 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751189AbdKUP1a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 10:27:30 -0500
Date: Tue, 21 Nov 2017 17:27:26 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH 1/2] drivers/video/hdmi: allow for larger-than-needed
 vendor IF
Message-ID: <20171121152726.GE10981@intel.com>
References: <20171120134129.26161-1-hverkuil@xs4all.nl>
 <20171120134129.26161-2-hverkuil@xs4all.nl>
 <20171120145154.GW10981@intel.com>
 <dea1aedf-80f8-ad6d-2560-eb7a0b1936a3@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dea1aedf-80f8-ad6d-2560-eb7a0b1936a3@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 20, 2017 at 04:02:14PM +0100, Hans Verkuil wrote:
> On 11/20/2017 03:51 PM, Ville Syrjälä wrote:
> > On Mon, Nov 20, 2017 at 02:41:28PM +0100, Hans Verkuil wrote:
> >> From: Hans Verkuil <hansverk@cisco.com>
> >>
> >> Some devices (Windows Intel driver!) send a Vendor InfoFrame that
> >> uses a payload length of 0x1b instead of the length of 5 or 6
> >> that the unpack code expects. The InfoFrame is padded with 0 by
> >> the source.
> > 
> > So it doesn't put any 3D_Metadata stuff in there? We don't see to
> > have code to parse/generate any of that.
> 
> I can't remember if it puts any 3D stuff in there. Let me know if you
> want me to check this later this week.

Would be nice to know.

I guess we should really add code to parse/generate that stuff too,
otherwise we're going to be lying when we unpack an infoframe with that
stuff present.

-- 
Ville Syrjälä
Intel OTC
