Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38645 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161071AbcFQPSW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 11:18:22 -0400
Received: by mail-wm0-f50.google.com with SMTP id m124so4004245wme.1
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2016 08:18:21 -0700 (PDT)
Date: Fri, 17 Jun 2016 17:18:15 +0200
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [19/38] ARM: dts: imx6-sabrelite: add video capture ports and
 connections
Message-ID: <20160617151814.GA16378@t450s.lan>
References: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
 <20160616083231.GA6548@t450s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160616083231.GA6548@t450s.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve, All,

On Thu, Jun 16, 2016 at 10:32:31AM +0200, Gary Bisson wrote:
> Steve, All,
> 
> On Tue, Jun 14, 2016 at 03:49:15PM -0700, Steve Longerbeam wrote:
> > Defines the host video capture device node and an OV5642 camera sensor
> > node on i2c2. The host capture device connects to the OV5642 via the
> > parallel-bus mux input on the ipu1_csi0_mux.
> > 
> > Note there is a pin conflict with GPIO6. This pin functions as a power
> > input pin to the OV5642, but ENET requires it to wake-up the ARM cores
> > on normal RX and TX packet done events (see 6261c4c8). So by default,
> > capture is disabled, enable by uncommenting __OV5642_CAPTURE__ macro.
> > Ethernet will still work just not quite as well.
> 
> Actually the following patch fixes this issue and has already been
> applied on Shawn's tree:
> https://patchwork.kernel.org/patch/9153523/
> 
> Also, this follow-up patch declared the HW workaround for SabreLite:
> https://patchwork.kernel.org/patch/9153525/
> 
> So ideally, once those two patches land on your base tree, you could get
> rid of the #define and remove the HW workaround declaration.
> 
> Finally, I'll test the series on Sabre-Lite this week.

I've applied this series on top of Shawn tree (for-next branch) in order
not to worry about the GPIO6 workaround.

Although the camera seems to get enumerated properly, I can't seem to
get anything from it. See log:
http://pastebin.com/xnw1ujUq

In your cover letter, you said that you have not run through
v4l2-compliance. How have you tested the capture?

Also, why isn't the OV5640 MIPI camera declared on the SabreLite device
tree?

Let me know if I can help testing/updating things on the SabreLite.

Regards,
Gary
