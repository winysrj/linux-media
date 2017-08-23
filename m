Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38405 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754090AbdHWOx2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 10:53:28 -0400
Message-ID: <1503500007.10112.15.camel@pengutronix.de>
Subject: Re: Support for direct playback of camera input on imx6q
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Stephan Bauroth <stephanbauroth@web.de>,
        linux-media@vger.kernel.org
Date: Wed, 23 Aug 2017 16:53:27 +0200
In-Reply-To: <13b9d535-094d-c63b-54f9-3ea54e2b138e@web.de>
References: <13b9d535-094d-c63b-54f9-3ea54e2b138e@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephan,

On Wed, 2017-08-23 at 13:25 +0200, Stephan Bauroth wrote:
> Dear List,
> 
> I'm trying to directly output a captured video signal to an LVDS
> panel 
> on an imx6q. Capturing frames works fine using the staging imx-media 
> driver. I can grab JPGs using v4l2grab and I can stream the input to
> the 
> display with gstreamer. However, when streaming, one of the cores is 
> utilized by ~66%, and I have to use the videoconvert module of
> gstreamer.
> 
> The IPU in imx6 can directly stream an captured signal back to the 
> display processor (DP) according to [1]. While the capturing paths 
> within the IPU are managed by the staging media-imx driver, its
> output 
> paths are not, so I can not simply set up links using media-ctl.

We do not support the direct CSI -> DP path because that requires
synchronised clocks between sensor and display. But it is possible to
stream buffers through system RAM without much CPU involvement using
the dmabuf mechanism.

> So, my question is whether it is possible to hook up the captured
> signal 
> to the DP using either the ipuv3 driver or the frame buffer driver 
> (mxcfb) or something else, and if yes, how?
> 
> Thanks for any help and/or hints
> Stephan
> 
> [1] http://www.nxp.com/docs/en/reference-manual/IMX6DQRM.pdf, pg.
> 2732 
> or chapter 37.1.2.1.4.1, 'Camera Preview'

To avoid CPU copies, you'd have to transfer dmabufs from the V4L2
capture device to the DRM output. On current GStreamer this can be
achieved with a pipeline like:

    v4l2src io-mode=dmabuf ! kmssink

regards
Philipp
