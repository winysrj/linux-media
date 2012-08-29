Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35246 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2H2Vvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Aug 2012 17:51:31 -0400
Received: by wicr5 with SMTP id r5so7015890wic.1
        for <linux-media@vger.kernel.org>; Wed, 29 Aug 2012 14:51:29 -0700 (PDT)
Message-ID: <503E8EDE.5010209@gmail.com>
Date: Wed, 29 Aug 2012 23:51:26 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Nicolas THERY <nicolas.thery@st.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
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
Subject: Re: [PATCH RFC 0/4] V4L2: Vendor specific media bus formats/ frame
 size control
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com> <503B96DB.3070403@st.com>
In-Reply-To: <503B96DB.3070403@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On 08/27/2012 05:48 PM, Nicolas THERY wrote:
> Hello,
> 
> On 2012-08-23 11:51, Sylwester Nawrocki wrote:
>> This patch series introduces new image source class control - V4L2_CID_FRAMESIZE
>> and vendor or device specific media bus format section.
>>
>> There was already a discussion WRT handling interleaved image data [1].
>> I'm not terribly happy with those vendor specific media bus formats but I
>> couldn't find better solution that would comply with the V4L2 API concepts
>> and would work reliably.
> 
> What about Sakari's "Frame format descriptors" RFC[1] that would allow to
> describe arbitrary pixel code combinations and provide required information
> (virtual channel and data type) to the CSI receiver driver for configuring the
> hardware?

Thanks for reminding about this. The "Frame format descriptors" would not
necessarily solve the main problem which I tried to address in this RFC.

The sensor in question uses single MIPI-CSI data type frame as a container
for multiple data planes, e.g. JPEG compressed stream interleaved with YUV
image data, some optional padding and a specific metadata describing the
interleaved image data. There is no MIPI-CSI2 virtual channel or data type 
interleaving. Everything is transferred on single VC and single DT.

Such a frames need sensor specific S/W algorithm do extract each component.

So it didn't look like the frame descriptors would be helpful here, since
all this needs to be mapped to a single fourcc. Not sure if defining a
"binary blob" fourcc and retrieving frame format information by some other
means would have been a way to go.

I also had some patches adopting design from Sakari's RFC, for the case where
in addition to the above frame format there was captured a copy of meta-data,
(as in the frame footer) send on separate DT (Embedded Data). And this was
mapped to 2-planar V4L2 pixel format. Even then I used a sensor specific
media bus code.

In the end of the day I switched to a single-planar format as it had all 
what's needed to decode the data. And the were some H/W limitations on using
additional DT. 

The frame format descriptors might be worth to work on, but this doesn't 
look like a solution to my problem and it is going to take some time to get 
it right, as Sakari pointed out.

--

Regards,
Sylwester
