Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59566 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeIKBQW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 21:16:22 -0400
Message-ID: <85f9305f4a9d50588b8b4d51ef78727cfa89edc7.camel@collabora.com>
Subject: Re: [PATCH 2/2] vicodec: set state->info before calling the
 encode/decode funcs
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 10 Sep 2018 17:20:26 -0300
In-Reply-To: <85a5d85cc6fc6bb21dafc78e744c350db25894d2.camel@ndufresne.ca>
References: <20180910150040.39265-1-hverkuil@xs4all.nl>
         <20180910150040.39265-2-hverkuil@xs4all.nl>
         <d58b839f60c07bef6e08184de243380550e75171.camel@collabora.com>
         <85a5d85cc6fc6bb21dafc78e744c350db25894d2.camel@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-09-10 at 13:16 -0400, Nicolas Dufresne wrote:
> Le lundi 10 septembre 2018 à 12:37 -0300, Ezequiel Garcia a écrit :
> > On Mon, 2018-09-10 at 17:00 +0200, Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > state->info was NULL since I completely forgot to set state->info.
> > > Oops.
> > > 
> > > Reported-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > For both patches:
> > 
> > Tested-by: Ezequiel Garcia <ezequiel@collabora.com>
> > 
> > With these changes, now this gstreamer pipeline no longer
> > crashes:
> > 
> > gst-launch-1.0 -v videotestsrc num-buffers=30 ! video/x-
> > raw,width=1280,height=720 ! v4l2fwhtenc capture-io-mode=mmap output-
> > io-mode=mmap ! v4l2fwhtdec
> > capture-io-mode=mmap output-io-mode=mmap ! fakesink
> > 
> > A few things:
> > 
> >   * You now need to mark "[PATCH] vicodec: fix sparse warning" as
> > invalid.
> >   * v4l2fwhtenc/v4l2fwhtdec elements are not upstream yet.
> >   * Gstreamer doesn't end properly; and it seems to negotiate
> 
> Is the driver missing CMD_STOP implementation ? (draining flow)
> 

I think that's the case.

Gstreamer debug log, right before it stalls:

0:00:16.929785442   180 0x5593bcbd18a0 DEBUG           v4l2videodec gstv4l2videodec.c:375:gst_v4l2_video_dec_finish:<v4l2fwhtdec0> Finishing decoding
0:00:16.931866009   180 0x5593bcbd18a0 DEBUG           v4l2videodec gstv4l2videodec.c:340:gst_v4l2_decoder_cmd:<v4l2fwhtdec0> sending v4l2 decoder
command 1 with flags 0
0:00:16.934260349   180 0x5593bcbd18a0 DEBUG           v4l2videodec gstv4l2videodec.c:384:gst_v4l2_video_dec_finish:<v4l2fwhtdec0> Waiting for decoder
stop
[stalls here]

Regards,
Ezequiel
