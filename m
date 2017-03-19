Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:64515 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdCSPAV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 11:00:21 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170318204324.GM21222@n2100.armlinux.org.uk>
 <4e7f91fa-e1c4-1cbc-2542-2aaf19a35329@mentor.com>
 <20170319142110.GT21222@n2100.armlinux.org.uk>
 <20170319142240.GA23922@n2100.armlinux.org.uk>
CC: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <mchehab@kernel.org>, <hverkuil@xs4all.nl>, <nick@shmanahar.org>,
        <markus.heiser@darmarIT.de>, <p.zabel@pengutronix.de>,
        <laurent.pinchart+renesas@ideasonboard.com>, <bparrot@ti.com>,
        <geert@linux-m68k.org>, <arnd@arndb.de>,
        <sudipm.mukherjee@gmail.com>, <minghsiu.tsai@mediatek.com>,
        <tiffany.lin@mediatek.com>, <jean-christophe.trotin@st.com>,
        <horms+renesas@verge.net.au>,
        <niklas.soderlund+renesas@ragnatech.se>, <robert.jarzmik@free.fr>,
        <songjun.wu@microchip.com>, <andrew-ct.chen@mediatek.com>,
        <gregkh@linuxfoundation.org>, <shuah@kernel.org>,
        <sakari.ailus@linux.intel.com>, <pavel@ucw.cz>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <51e2be34-6fa2-9d91-5111-adcd697b3e3f@mentor.com>
Date: Sun, 19 Mar 2017 17:00:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170319142240.GA23922@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2017 04:22 PM, Russell King - ARM Linux wrote:
> On Sun, Mar 19, 2017 at 02:21:10PM +0000, Russell King - ARM Linux wrote:
>> There's a good reason why I dumped a full debug log using GST_DEBUG=*:9,
>> analysed it for the cause of the failure, and tried several different
>> pipelines, including the standard bayer2rgb plugin.
>>
>> Please don't blame this on random stuff after analysis of the logs _and_
>> reading the appropriate plugin code has shown where the problem is.  I
>> know gstreamer can be very complex, but it's very possible to analyse
>> the cause of problems and pin them down with detailed logs in conjunction
>> with the source code.
> 
> Oh, and the proof of correct analysis is that fixing the kernel capture
> driver to enumerate the frame sizes and intervals fixes the issue, even
> with bayer2rgbneon being used.
> 
> Therefore, there is _no way_ what so ever that it could be caused by that
> plugin.
> 

Hey, no blaming of the unknown to me bayer2rgbneon element from my side,
I've just asked an innocent question, thanks for reply. I failed to find
the source code of the plugin, I was interested to compare its performance
and features with mine in-house NEON powered RGGB/BGGR to RGB24 GStreamer
conversion element, which is written years ago. My question was offtopic.

--
With best wishes,
Vladimir
