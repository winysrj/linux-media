Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35806 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbcFPIcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 04:32:39 -0400
Received: by mail-wm0-f53.google.com with SMTP id v199so182072194wmv.0
        for <linux-media@vger.kernel.org>; Thu, 16 Jun 2016 01:32:38 -0700 (PDT)
Date: Thu, 16 Jun 2016 10:32:31 +0200
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [19/38] ARM: dts: imx6-sabrelite: add video capture ports and
 connections
Message-ID: <20160616083231.GA6548@t450s.lan>
References: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve, All,

On Tue, Jun 14, 2016 at 03:49:15PM -0700, Steve Longerbeam wrote:
> Defines the host video capture device node and an OV5642 camera sensor
> node on i2c2. The host capture device connects to the OV5642 via the
> parallel-bus mux input on the ipu1_csi0_mux.
> 
> Note there is a pin conflict with GPIO6. This pin functions as a power
> input pin to the OV5642, but ENET requires it to wake-up the ARM cores
> on normal RX and TX packet done events (see 6261c4c8). So by default,
> capture is disabled, enable by uncommenting __OV5642_CAPTURE__ macro.
> Ethernet will still work just not quite as well.

Actually the following patch fixes this issue and has already been
applied on Shawn's tree:
https://patchwork.kernel.org/patch/9153523/

Also, this follow-up patch declared the HW workaround for SabreLite:
https://patchwork.kernel.org/patch/9153525/

So ideally, once those two patches land on your base tree, you could get
rid of the #define and remove the HW workaround declaration.

Finally, I'll test the series on Sabre-Lite this week.

Regards,
Gary
