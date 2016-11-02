Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:55243 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756212AbcKBR3O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 13:29:14 -0400
Date: Wed, 2 Nov 2016 17:29:11 +0000
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v3 0/6] Add support for IR transmitters
Message-ID: <20161102172910.GA11817@gofer.mess.org>
References: <20161102104010.26959-1-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161102104010.26959-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 02, 2016 at 07:40:04PM +0900, Andi Shyti wrote:
> The main goal is to add support in the rc framework for IR
> transmitters, which currently is only supported by lirc but that
> is not the preferred way.
> 
> The last patch adds support for an IR transmitter driven by
> the MOSI line of an SPI controller, it's the case of the Samsung
> TM2(e) board which support is currently ongoing.
> 
> The last patch adds support for an IR transmitter driven by
> the MOSI line of an SPI controller, it's the case of the Samsung
> TM2(e) board which support is currently ongoing.

Looks great! For the whole series:

Reviewed-by: Sean Young <sean@mess.org>

Thanks,
Sean
