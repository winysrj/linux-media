Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40417 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1ISIsR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 04:48:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRR008Z1HSF7D00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 09:48:15 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRR00MTKHSE7E@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 09:48:15 +0100 (BST)
Date: Mon, 19 Sep 2011 10:48:14 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l2: Add the parallel bus HREF signal polarity
 flags
In-reply-to: <201109190105.29383.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <4E7701CE.6050201@samsung.com>
References: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com>
 <alpine.DEB.2.00.1109171423460.28766@axis700.grange>
 <4E74C57C.8030801@gmail.com>
 <201109190105.29383.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/19/2011 01:05 AM, Laurent Pinchart wrote:
> On Saturday 17 September 2011 18:06:20 Sylwester Nawrocki wrote:
>> On 09/17/2011 02:34 PM, Guennadi Liakhovetski wrote:
>>> On Sat, 17 Sep 2011, Sylwester Nawrocki wrote:
>>>> On 09/17/2011 12:54 PM, Laurent Pinchart wrote:
>>>>> On Friday 16 September 2011 19:28:42 Sylwester Nawrocki wrote:
>>>>>> HREF is a signal indicating valid data during single line
>>>>>> transmission. Add corresponding flags for this signal to the set of
>>>>>> mediabus signal polarity flags.
>>>>>
>>>>> So that's a data valid signal that gates the pixel data ? The OMAP3 ISP
>>>>> has a
>>>>
>>>> Yes, it's "horizontal window reference" signal, it's well described in
>>>> this datasheet: http://www.morninghan.com/pdf/OV2640FSL_DS_(1_3).pdf
>>>>
>>>> AFAICS there can be also its vertical counterpart - VREF.
>>>>
>>>> Many devices seem to use this terminology. However, I realize, not all,
>>>> as you're pointing out. So perhaps it's time for some naming contest
>>>> now.. :-)
>>>
>>> No objections in principle, just one question though: can these signals
>>> actually be used simultaneously with respective *SYNC signals or only as
>>> an alternative? If the latter, maybe we could reuse same names by just
>>> making them more generic?
>>
>> That's actually a good question. In my use cases only HREF is used as
>> horizontal synchronization signal, i.e. physical bus interface has this
>> signals:
>>
>> ->| PCLK
>> ->| VSYNC
>> ->| HREF
>> ->| DATA[0:7]
>> ->| FIELD
>>
>> For interlaced mode FIELD can be connected to the horizontal
>> synchronization signal. For this case there is InvPolHSYNC bit in the host
>> interface registers to indicate the polarity. There are 5 bits actually:
>>
>> InvPolPCLK
>> InvPolVSYNC (vertical sychronization)
>> InvPolHREF  (horizontal synchronization)
>> InvPolHSYNC (for interlaced mode only, FIELD port = horizontal sync.
>> signal) InvPolFIELD (interlaced mode,  FIELD port = FIELD signal)
> 
> Shouldn't this be handled through platform data only ?

Indeed, this is how it's done now and I didn't intend to change that.
I just wanted to replace driver's private signal polarity flag definitions
with the standard ones. Do you think I should rather keep these things in
driver's public header? It's of course a way of less resistance :)


To make things complete I thought about adding the FIELD flags, i.e.

>From 9bd11f9b14dffe877f9c546e068b4b4027c9472a Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Sun, 18 Sep 2011 11:28:58 +0200
Subject: [PATCH 1/2] v4l2: Add the parallel bus HREF and FIELD signal polarity
flags

HREF is a signal gating valid data during single line transmission.
FIELD is an Even/Odd field selection signal, as specified in ITU-R BT.601
standard.
Add corresponding flags for these signals to the set of media bus signal
polarity flags.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-mediabus.h |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 6114007..1952d9f 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -23,15 +23,21 @@
 #define V4L2_MBUS_MASTER			(1 << 0)
 #define V4L2_MBUS_SLAVE				(1 << 1)
 /* Which signal polarities it supports */
-/* Note: in BT.656 mode HSYNC and VSYNC are unused */
+/* Note: in BT.656 mode HSYNC, HREF, FIELD, and VSYNC are unused */
 #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
 #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
-#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
-#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
-#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
-#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
-#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
-#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
+/* HREF is a horizontal window reference signal gating valid pixel data */
+#define V4L2_MBUS_HREF_ACTIVE_HIGH		(1 << 4)
+#define V4L2_MBUS_HREF_ACTIVE_LOW		(1 << 5)
+#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 6)
+#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 7)
+#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 8)
+#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 9)
+#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 10)
+#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 11)
+/* Field selection signal for interlaced scan mode */
+#define V4L2_MBUS_FIELD_ACTIVE_HIGH		(1 << 12)
+#define V4L2_MBUS_FIELD_ACTIVE_LOW		(1 << 13)

 /* Serial flags */
 /* How many lanes the client can use */
-- 1.7.4.1

If there is more objection to the above changes then I'll drop the patch
and stay with driver's private definitions.


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
