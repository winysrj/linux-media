Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37033 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751204AbaISIWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 04:22:01 -0400
Date: Fri, 19 Sep 2014 11:21:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/3] vb2: Buffers returned to videobuf2 from
 start_streaming in QUEUED state
Message-ID: <20140919082122.GK2939@valkosipuli.retiisi.org.uk>
References: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi>
 <1411077469-29178-2-git-send-email-sakari.ailus@iki.fi>
 <541BE5C5.5040205@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541BE5C5.5040205@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Sep 19, 2014 at 10:13:57AM +0200, Hans Verkuil wrote:
> On 09/18/2014 11:57 PM, Sakari Ailus wrote:
> > Patch "[media] v4l: vb2: Fix stream start and buffer completion race" has a
> > sets q->start_streaming_called before calling queue op start_streaming() in
> > order to fix a bug. This has the side effect that buffers returned to
> > videobuf2 in VB2_BUF_STATE_QUEUED will cause a WARN_ON() to be called.
> > 
> > Add a new field called done_buffers_queued_state to struct vb2_queue, which
> > must be set if the new state of buffers returned to videobuf2 must be
> > VB2_BUF_STATE_QUEUED, i.e. buffers returned in start_streaming op.
> 
> I posted a fix for this over a month ago:
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg77871.html
> 
> Unfortunately, the pull request with that patch (https://patchwork.linuxtv.org/patch/25162/)
> fell through the cracks as I discovered yesterday. Hopefully Mauro will pick
> up that pull request quickly.
> 
> I prefer my patch since that avoids introducing yet another state variable.

Using less state variables is good, but with your patch returning buffers
back to videobuf2 to state VB2_BUF_STATE_QUEUED is possible also after
start_stream() has finished. That's probably a lesser problem, though.

I'm fine with your patch as well.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
