Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36269 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754495Ab2H2Sla (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Aug 2012 14:41:30 -0400
Date: Wed, 29 Aug 2012 21:41:25 +0300
From: "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
To: Nicolas THERY <nicolas.thery@st.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"riverful.kim@samsung.com" <riverful.kim@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>,
	Willy POISSON <willy.poisson@st.com>,
	Benjamin GAIGNARD <benjamin.gaignard@st.com>
Subject: Re: [PATCH RFC 0/4] V4L2: Vendor specific media bus formats/ frame
 size control
Message-ID: <20120829184125.GC5261@valkosipuli.retiisi.org.uk>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
 <503B96DB.3070403@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503B96DB.3070403@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Mon, Aug 27, 2012 at 05:48:43PM +0200, Nicolas THERY wrote:
> Hello,
> 
> On 2012-08-23 11:51, Sylwester Nawrocki wrote:
> > This patch series introduces new image source class control - V4L2_CID_FRAMESIZE
> > and vendor or device specific media bus format section.
> > 
> > There was already a discussion WRT handling interleaved image data [1].
> > I'm not terribly happy with those vendor specific media bus formats but I
> > couldn't find better solution that would comply with the V4L2 API concepts
> > and would work reliably.
> 
> What about Sakari's "Frame format descriptors" RFC[1] that would allow to
> describe arbitrary pixel code combinations and provide required information
> (virtual channel and data type) to the CSI receiver driver for configuring the
> hardware?

I we'll need to continue that work as well, unfortunately I've had higher
priority things to do. Still, getting that right is complex and will take
time. The V4L2 pixel format for this sensor will likely be a
hardware-specific one for quite a while: this sensor in question sends
several frames in different formats of a single image at once which doesn't
match to V4L2's pixel format configuration that assumes a single format.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
