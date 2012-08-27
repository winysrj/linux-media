Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:58415 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab2H0PtW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 11:49:22 -0400
From: Nicolas THERY <nicolas.thery@st.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"riverful.kim@samsung.com" <riverful.kim@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>,
	Willy POISSON <willy.poisson@st.com>,
	Benjamin GAIGNARD <benjamin.gaignard@st.com>
Date: Mon, 27 Aug 2012 17:48:43 +0200
Subject: Re: [PATCH RFC 0/4] V4L2: Vendor specific media bus formats/ frame
 size control
Message-ID: <503B96DB.3070403@st.com>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2012-08-23 11:51, Sylwester Nawrocki wrote:
> This patch series introduces new image source class control - V4L2_CID_FRAMESIZE
> and vendor or device specific media bus format section.
> 
> There was already a discussion WRT handling interleaved image data [1].
> I'm not terribly happy with those vendor specific media bus formats but I
> couldn't find better solution that would comply with the V4L2 API concepts
> and would work reliably.

What about Sakari's "Frame format descriptors" RFC[1] that would allow to
describe arbitrary pixel code combinations and provide required information
(virtual channel and data type) to the CSI receiver driver for configuring the
hardware?

Thanks in advance.

Best regards,
Nicolas

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg43530.html