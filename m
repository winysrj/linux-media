Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:59507 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753125AbdLELAq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 06:00:46 -0500
Date: Tue, 5 Dec 2017 11:00:05 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Mark Brown <broonie@kernel.org>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH v6 0/9] i2c: document DMA handling and add helpers for
 it
Message-ID: <20171205110005.00004d66@huawei.com>
In-Reply-To: <20171204220541.GA11658@finisterre>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
        <20171108225037.i4dx5iu5zxc542oq@sirena.co.uk>
        <20171127185116.j2vmkhbik33vk4f7@ninjato>
        <20171128153446.6pyqtkcvuepil5gi@sirena.org.uk>
        <20171203194347.bbds47a72xbc4nvl@ninjato>
        <20171204220541.GA11658@finisterre>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 Dec 2017 22:05:41 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Sun, Dec 03, 2017 at 08:43:47PM +0100, Wolfram Sang wrote:
> 
> > > It's a bit different in that it's much more likely that a SPI controller
> > > will actually do DMA than an I2C one since the speeds are higher and
> > > there's frequent applications that do large transfers so it's more
> > > likely that people will do the right thing as issues would tend to come
> > > up if they don't.  
> 
> > Yes, for SPI this is true. I was thinking more of regmap with its
> > usage of different transport mechanisms. But I guess they should all be
> > DMA safe because some of them need to be DMA safe?  
> 
> Possibly.  Hopefully.  I guess we'll find out.
> 

Yeah, optimistic assumption. Plenty of drivers use regmap for the
convenience of it's caching and field access etc rather than
because they support multiple buses.

I'll audit the IIO drivers and see where we have issues if we
start assuming DMA safe for regmap (which makes sense to me).

Probably worth fixing them all up anyway and tends to be straightforward.

Jonathan
