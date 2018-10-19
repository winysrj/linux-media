Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59804 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbeJSVUs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 17:20:48 -0400
Message-ID: <5b3353eda91dcf2e4a11030913f2726ca4bf0357.camel@collabora.com>
Subject: Re: [PATCH 2/2] vicodec: Implement spec-compliant stop command
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
Date: Fri, 19 Oct 2018 10:14:35 -0300
In-Reply-To: <6c07bc835803dd052ed5d6571fd6d4c56bb84512.camel@collabora.com>
References: <20181018160841.17674-1-ezequiel@collabora.com>
         <20181018160841.17674-3-ezequiel@collabora.com>
         <b75076e1-075b-50eb-96ff-f7115168d2bd@xs4all.nl>
         <16ce7d348d553a91d8e52976c434952b4db0192c.camel@collabora.com>
         <6c07bc835803dd052ed5d6571fd6d4c56bb84512.camel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Fri, 2018-10-19 at 07:41 -0400, Nicolas Dufresne wrote:
> Le vendredi 19 octobre 2018 à 07:35 -0400, Nicolas Dufresne a écrit :
> > Le vendredi 19 octobre 2018 à 09:28 +0200, Hans Verkuil a écrit :
> > > On 10/18/2018 06:08 PM, Ezequiel Garcia wrote:
> > > > Set up a statically-allocated, dummy buffer to
> > > > be used as flush buffer, which signals
> > > > a encoding (or decoding) stop.
> > > > 
> > > > When the flush buffer is queued to the OUTPUT queue,
> > > > the driver will send an V4L2_EVENT_EOS event, and
> > > > mark the CAPTURE buffer with V4L2_BUF_FLAG_LAST.
> > > 
> > > I'm confused. What is the current driver doing wrong? It is already
> > > setting the LAST flag AFAIK. I don't see why a dummy buffer is
> > > needed.
> > 
> > I'm not sure of this patch either. It seems to trigger the legacy
> > "empty payload" buffer case. Driver should mark the last buffer, and
> > then following poll should return EPIPE. Maybe it's the later that
> > isn't respected ?
> 
> Sorry, I've send this too fast. The following poll should not block,
> and DQBUF should retunr EPIPE.
> 
> In GStreamer we currently ignore the LAST flag and wait for EPIPE. The
> reason is that not all driver can set the LAST flag. Exynos firmware
> tells you it's done later and we don't want to introduce any latency in
> the driver. The last flag isn't that useful in fact, but it can be use
> with RTP to set the marker bit.
> 

Yeah, I know that gstreamer ignores the LAST flag.

> In previous discussion, using a buffer with payload 0 was not liked.
> There might be codec where an empty buffer is valid, who knows ?
> 

The goal of this patch is for the driver to mark the dst buf
as V4L2_BUF_FLAG_DONE and V4L2_BUF_FLAG_LAST, so videobuf2
core returns EPIPE on a DQBUF.

Sorry for not being clear in the commit log.

Thanks,
Ezequiel
