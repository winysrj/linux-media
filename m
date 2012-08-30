Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:55843 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab2H3IEX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 04:04:23 -0400
From: Nicolas THERY <nicolas.thery@st.com>
To: "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
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
Date: Thu, 30 Aug 2012 10:03:55 +0200
Subject: Re: [PATCH RFC 0/4] V4L2: Vendor specific media bus formats/ frame
 size control
Message-ID: <503F1E6B.1000006@st.com>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
 <503B96DB.3070403@st.com> <20120829184125.GC5261@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120829184125.GC5261@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Thanks for your reply.  It's good to know your proposal is simply on the
back-burner.

Best regards,
Nicolas

On 2012-08-29 20:41, sakari.ailus@iki.fi wrote:
> Hi Nicolas,
>
> On Mon, Aug 27, 2012 at 05:48:43PM +0200, Nicolas THERY wrote:
>> Hello,
>>
>> On 2012-08-23 11:51, Sylwester Nawrocki wrote:
>>> This patch series introduces new image source class control - V4L2_CID_FRAMESIZE
>>> and vendor or device specific media bus format section.
>>>
>>> There was already a discussion WRT handling interleaved image data [1].
>>> I'm not terribly happy with those vendor specific media bus formats but I
>>> couldn't find better solution that would comply with the V4L2 API concepts
>>> and would work reliably.
>> What about Sakari's "Frame format descriptors" RFC[1] that would allow to
>> describe arbitrary pixel code combinations and provide required information
>> (virtual channel and data type) to the CSI receiver driver for configuring the
>> hardware?
> I we'll need to continue that work as well, unfortunately I've had higher
> priority things to do. Still, getting that right is complex and will take
> time. The V4L2 pixel format for this sensor will likely be a
> hardware-specific one for quite a while: this sensor in question sends
> several frames in different formats of a single image at once which doesn't
> match to V4L2's pixel format configuration that assumes a single format.
>
> Kind regards,
>
