Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57008 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbeIYEOK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 00:14:10 -0400
Date: Mon, 24 Sep 2018 15:09:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH] am335x-boneblack-common.dtsi: add cec support
Message-ID: <20180924220947.GJ5662@atomide.com>
References: <c1a57790-ec91-103a-818a-40d7284cc502@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1a57790-ec91-103a-818a-40d7284cc502@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Hans Verkuil <hverkuil@xs4all.nl> [180924 04:06]:
> Add CEC support to the tda998x.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Note: this relies on this gpio patch series:
> 
> https://www.spinics.net/lists/linux-gpio/msg32401.html
> 
> and this follow-up gpio patch:
> 
> https://www.spinics.net/lists/linux-gpio/msg32551.html
> 
> that will appear in 4.20.
> 
> Tested with my BeagleBone Black board.

OK great applying into omap-for-v4.20/dt thanks.

Tony
