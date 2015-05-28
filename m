Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.melag.de ([217.6.74.107]:41915 "EHLO mail.melag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbbE1RiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 13:38:25 -0400
Message-ID: <5567528C.7010903@melag.de>
Date: Thu, 28 May 2015 19:38:20 +0200
From: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v2 2/5] gpu: ipu-v3: Add mem2mem image conversion support
 to IC
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>		 <1426674173-17088-3-git-send-email-p.zabel@pengutronix.de>		 <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>		 <5566D92F.8090802@melag.de> <1432809845.3228.25.camel@pengutronix.de>	 <5566FC95.3020000@melag.de> <1432814386.3228.51.camel@pengutronix.de>
In-Reply-To: <1432814386.3228.51.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.05.2015 um 13:59 schrieb Philipp Zabel:

>> Where can I get the recent ones ?
>> Could you push it to your public repo ?
>
> I've updated the tmp/imx-ipu-scaler branch.

Thx. already integrated it into my tree - works fine :)

By the way: i still have some your older patches (2012) in my tree,
eg. some mediabus, camara, display timing stuff, etc ... not sure
whether I really need them for my device.

Should I post them to linux-media list for review ?

Oh, and I also still have your famous DRM_IOCTL_MODE_MAP_DUMB hack
(the "Reluctantly-signed-off-by:" one ;-), meanwhile rebased / adapted
into 4.x. Do you have any idea, what the amd-gpu driver/library exactly
does with the retrieved address ? Send it directly to the gpu ?

> That should be capture-io-mode=dmabuf for the decoder and
> output-io-mode=dmabuf-import for the converter element. h264parse
> doesn't provide and fbdevsink can't handle dmabufs, so the decoder's
> output-io-mode and the converter's capture-io-mode should be kept as
> mmio.

I played around a little bit - this command line only takes 55% cpu:

gst-launch-1.0 filesrc location=montage.mp4 \!
qtdemux \! h264parse \! v4l2video4dec output-io-mode=4 capture-io-mode=4
\! v4l2
video0convert capture-io-mode=4 output-io-mode=5 \! fbdevsink

By the way: what's the exact difference between dmabuf and
dmabuf-import ?

 > > By the way: do you have any idea whether the proprietary driver
 > > (or the gpus itself) might talk to ipu and vpu ?
 >
 > Not that I am aware of.

Well, you perhaps can imagine - I dont trust these guys ...



--mtx

ps: greetings from Bene ... you won't guess where I met him
last weekend ;-)
--
Enrico Weigelt, metux IT consult
+49-151-27565287
MELAG Medizintechnik oHG Sitz Berlin Registergericht AG Charlottenburg HRA 21333 B

Wichtiger Hinweis: Diese Nachricht kann vertrauliche oder nur für einen begrenzten Personenkreis bestimmte Informationen enthalten. Sie ist ausschließlich für denjenigen bestimmt, an den sie gerichtet worden ist. Wenn Sie nicht der Adressat dieser E-Mail sind, dürfen Sie diese nicht kopieren, weiterleiten, weitergeben oder sie ganz oder teilweise in irgendeiner Weise nutzen. Sollten Sie diese E-Mail irrtümlich erhalten haben, so benachrichtigen Sie bitte den Absender, indem Sie auf diese Nachricht antworten. Bitte löschen Sie in diesem Fall diese Nachricht und alle Anhänge, ohne eine Kopie zu behalten.
Important Notice: This message may contain confidential or privileged information. It is intended only for the person it was addressed to. If you are not the intended recipient of this email you may not copy, forward, disclose or otherwise use it or any part of it in any form whatsoever. If you received this email in error please notify the sender by replying and delete this message and any attachments without retaining a copy.
