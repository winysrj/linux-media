Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.melag.de ([217.6.74.107]:34790 "EHLO mail.melag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbbE1JBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 05:01:16 -0400
Message-ID: <5566D92F.8090802@melag.de>
Date: Thu, 28 May 2015 11:00:31 +0200
From: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
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
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de> <1426674173-17088-3-git-send-email-p.zabel@pengutronix.de> <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>
In-Reply-To: <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.05.2015 um 20:42 schrieb Jean-Michel Hautbois:

<snip>

@Phillip,

I've missed the previous mails (just subscribed here yesterday) ...

Are these patches same as in your git branch tmp/imx-ipu-scaler ?
I've got them running on 4.0.4 and currently trying on 4.1-rc*

Yet another question:

when using it w/ gst for video playback, can be directly pass buffers
between VPU, IPU and FB (or let them directly write into shared
buffers), so CPU doesn't need to act on each frame for each step
in the decoding pipeline ?
Playing an 800x400 mp4 still produces about 70..75%.


cu
--
Enrico Weigelt, metux IT consult
+49-151-27565287
MELAG Medizintechnik oHG Sitz Berlin Registergericht AG Charlottenburg HRA 21333 B

Wichtiger Hinweis: Diese Nachricht kann vertrauliche oder nur für einen begrenzten Personenkreis bestimmte Informationen enthalten. Sie ist ausschließlich für denjenigen bestimmt, an den sie gerichtet worden ist. Wenn Sie nicht der Adressat dieser E-Mail sind, dürfen Sie diese nicht kopieren, weiterleiten, weitergeben oder sie ganz oder teilweise in irgendeiner Weise nutzen. Sollten Sie diese E-Mail irrtümlich erhalten haben, so benachrichtigen Sie bitte den Absender, indem Sie auf diese Nachricht antworten. Bitte löschen Sie in diesem Fall diese Nachricht und alle Anhänge, ohne eine Kopie zu behalten.
Important Notice: This message may contain confidential or privileged information. It is intended only for the person it was addressed to. If you are not the intended recipient of this email you may not copy, forward, disclose or otherwise use it or any part of it in any form whatsoever. If you received this email in error please notify the sender by replying and delete this message and any attachments without retaining a copy.
