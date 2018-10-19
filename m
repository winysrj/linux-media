Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59784 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbeJSVRW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 17:17:22 -0400
Message-ID: <724c838390056f9acd75900f03b099e8899c5a78.camel@collabora.com>
Subject: Re: [PATCH 2/2] vicodec: Implement spec-compliant stop command
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Date: Fri, 19 Oct 2018 10:11:10 -0300
In-Reply-To: <b75076e1-075b-50eb-96ff-f7115168d2bd@xs4all.nl>
References: <20181018160841.17674-1-ezequiel@collabora.com>
         <20181018160841.17674-3-ezequiel@collabora.com>
         <b75076e1-075b-50eb-96ff-f7115168d2bd@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-10-19 at 09:28 +0200, Hans Verkuil wrote:
> On 10/18/2018 06:08 PM, Ezequiel Garcia wrote:
> > Set up a statically-allocated, dummy buffer to
> > be used as flush buffer, which signals
> > a encoding (or decoding) stop.
> > 
> > When the flush buffer is queued to the OUTPUT queue,
> > the driver will send an V4L2_EVENT_EOS event, and
> > mark the CAPTURE buffer with V4L2_BUF_FLAG_LAST.
> 
> I'm confused. What is the current driver doing wrong? It is already
> setting the LAST flag AFAIK.

The driver seems to be setting V4L2_BUF_FLAG_LAST to the dst
buf, if there's no src buf.

IIRC, that alone is has no effects, because .device_run never
gets to run (after all, there is no src buf), and the dst
buf is never marked as done and dequeued...
 
> I don't see why a dummy buffer is needed.
> 

... and that is why I took the dummy buffer idea (from some other driver),
which seemed an easy way to artificially run device_run
to dequeue the dst buf.

What do you think?

Thanks,
Ezequiel
