Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29748 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933658AbeFZMIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 08:08:21 -0400
Message-ID: <6131ffd5cd7455426ea5f68633d5a8c8dd8457bb.camel@linux.intel.com>
Subject: Re: [PATCH v2 01/10] tpm/tpm_i2c_infineon: switch to
 i2c_lock_bus(..., I2C_LOCK_SEGMENT)
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Alexander Steffen <Alexander.Steffen@infineon.com>,
        Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Guenter Roeck <linux@roeck-us.net>, Crt Mori <cmo@melexis.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Lee Jones <lee.jones@linaro.org>,
        linux-integrity@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Date: Tue, 26 Jun 2018 15:07:59 +0300
In-Reply-To: <6169da633eab7e68d645e6b933b605dcc9ae09f1.camel@linux.intel.com>
References: <20180620051803.12206-1-peda@axentia.se>
         <20180620051803.12206-2-peda@axentia.se>
         <20180625102454.GA3845@linux.intel.com>
         <7703d6a2-b22c-104c-7390-b5143a504725@infineon.com>
         <6169da633eab7e68d645e6b933b605dcc9ae09f1.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-06-26 at 15:05 +0300, Jarkko Sakkinen wrote:
> On Tue, 2018-06-26 at 12:07 +0200, Alexander Steffen wrote:
> > On 25.06.2018 12:24, Jarkko Sakkinen wrote:
> > > On Wed, Jun 20, 2018 at 07:17:54AM +0200, Peter Rosin wrote:
> > > > Locking the root adapter for __i2c_transfer will deadlock if the
> > > > device sits behind a mux-locked I2C mux. Switch to the finer-grained
> > > > i2c_lock_bus with the I2C_LOCK_SEGMENT flag. If the device does not
> > > > sit behind a mux-locked mux, the two locking variants are equivalent.
> > > > 
> > > > Signed-off-by: Peter Rosin <peda@axentia.se>
> > > 
> > > Studied enough so that I can give
> > > 
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > 
> > > Do not have hardware to test this, however.
> > 
> > I don't have a mux-locked I2C mux either, but at least I can confirm 
> > that this change did not break my existing test setup (SLB9635/SLB9645 
> > on Raspberry Pi 2B).
> > 
> > Tested-by: Alexander Steffen <Alexander.Steffen@infineon.com>
> > 
> > Alexander
> 
> Given the scope of the change and since analogous change works for
> every other subsystem, this should be enough! Thank you.

It is now applied to my tree (master). I will move it to the
next branch once James has updated security/next-general.

/Jarkko
