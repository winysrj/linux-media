Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60611 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbeFDIij (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 04:38:39 -0400
Message-ID: <1528101517.5808.8.camel@pengutronix.de>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <pza@pengutronix.de>
Cc: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Date: Mon, 04 Jun 2018 10:38:37 +0200
In-Reply-To: <3db739a8-8482-688c-e26d-69095087444a@gmail.com>
References: <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
         <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
         <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com>
         <m3lgc2q5vl.fsf@t19.piap.pl>
         <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com>
         <m38t81plry.fsf@t19.piap.pl>
         <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com>
         <m336y9ouc4.fsf@t19.piap.pl>
         <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com>
         <20180531062911.pkl2pracmyvhsldz@pengutronix.de>
         <3db739a8-8482-688c-e26d-69095087444a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2018-06-02 at 10:33 -0700, Steve Longerbeam wrote:
[...]
> As I said in the other thread, I think we should put this off to some
> other time, and remove the code in ipu_csi_init_interface() that
> inverts field order according to frame size. This way, CSI will not
> be lying to userspace when we tell it the order is BT but the CSI
> has actually inverted that to TB.
> 
> Also I have concerns about the CSI capturing field 1 _before_ field
> 0 for NTSC. Doesn't that mean the CSI will drop the B-field in the
> first captured frame on stream on, and thereafter mix fields from
> different adjacent frames?

Yes, that is only a problem for 29.97 Hz progressive source material.
For real 59.94 Hz interlaced source material it does not matter which
two consecutive fields are displayed together as long as we get the
top/bottom ordering right.

regards
Philipp
