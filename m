Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.melag.de ([217.6.74.107]:27705 "EHLO mail.melag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbbE1Lbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 07:31:42 -0400
Message-ID: <5566FC95.3020000@melag.de>
Date: Thu, 28 May 2015 13:31:33 +0200
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
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>	 <1426674173-17088-3-git-send-email-p.zabel@pengutronix.de>	 <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>	 <5566D92F.8090802@melag.de> <1432809845.3228.25.camel@pengutronix.de>
In-Reply-To: <1432809845.3228.25.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.05.2015 um 12:44 schrieb Philipp Zabel:

Hi,

 >> Are these patches same as in your git branch tmp/imx-ipu-scaler ?
>
> No, that is an older version.

Where can I get the recent ones ?
Could you push it to your public repo ?

>> when using it w/ gst for video playback, can be directly pass buffers
>> between VPU, IPU and FB (or let them directly write into shared
>> buffers), so CPU doesn't need to act on each frame for each step
>> in the decoding pipeline ?
>
> Check out the (capture/output-)io-mode parameters, that's what the
> dmabuf/dmabuf-import option pairs are for.

Tried dmabuf, but load stays at the same (77..80% CPU, 1.2 loadavg).
dmabuf-import doesnt run at all:

root@KoMo:/usr/share/videos/komo gst-launch-1.0 filesrc
location=montage.mp4 \! qtdemux \! h264parse \! v4l2video4dec
output-io-mode=5 \! v4l2video0convert capture-io-mode=5 output-io-mode=4
\! fbdevsink

Setting pipeline to PAUSED ...
Pipeline is PREROLLING ...
ERROR: from element
/GstPipeline:pipeline0/v4l2video0convert:v4l2video0convert0: No
downstream pool to import from.
Additional debug info:
gstv4l2object.c(3441): gst_v4l2_object_decide_allocation ():
/GstPipeline:pipeline0/v4l2video0convert:v4l2video0convert0:
When importing DMABUF or USERPTR, we need a pool to import from
ERROR: pipeline doesn't want to preroll.
Setting pipeline to NULL ...
Freeing pipeline ...


Perhaps not implemented yet in the old version of the patches ?

By the way: do you have any idea whether the proprietary driver
(or the gpus itself) might talk to ipu and vpu ?


cu
--
Enrico Weigelt, metux IT consult
+49-151-27565287
MELAG Medizintechnik oHG Sitz Berlin Registergericht AG Charlottenburg HRA 21333 B

Wichtiger Hinweis: Diese Nachricht kann vertrauliche oder nur für einen begrenzten Personenkreis bestimmte Informationen enthalten. Sie ist ausschließlich für denjenigen bestimmt, an den sie gerichtet worden ist. Wenn Sie nicht der Adressat dieser E-Mail sind, dürfen Sie diese nicht kopieren, weiterleiten, weitergeben oder sie ganz oder teilweise in irgendeiner Weise nutzen. Sollten Sie diese E-Mail irrtümlich erhalten haben, so benachrichtigen Sie bitte den Absender, indem Sie auf diese Nachricht antworten. Bitte löschen Sie in diesem Fall diese Nachricht und alle Anhänge, ohne eine Kopie zu behalten.
Important Notice: This message may contain confidential or privileged information. It is intended only for the person it was addressed to. If you are not the intended recipient of this email you may not copy, forward, disclose or otherwise use it or any part of it in any form whatsoever. If you received this email in error please notify the sender by replying and delete this message and any attachments without retaining a copy.
