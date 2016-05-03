Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:40736 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbcECVij (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 17:38:39 -0400
Date: Tue, 3 May 2016 23:38:08 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v7 16/24] i2c: allow adapter drivers to override the
 adapter locking
Message-ID: <20160503213807.GA2018@tetsubishi>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-17-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461165484-2314-17-git-send-email-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 20, 2016 at 05:17:56PM +0200, Peter Rosin wrote:
> Add i2c_lock_bus() and i2c_unlock_bus(), which call the new lock_bus and
> unlock_bus ops in the adapter. These funcs/ops take an additional flags
> argument that indicates for what purpose the adapter is locked.
> 
> There are two flags, I2C_LOCK_ADAPTER and I2C_LOCK_SEGMENT, but they are
> both implemented the same. For now. Locking the adapter means that the
> whole bus is locked, locking the segment means that only the current bus
> segment is locked (i.e. i2c traffic on the parent side of mux is still
> allowed even if the child side of the mux is locked.
> 
> Also support a trylock_bus op (but no function to call it, as it is not
> expected to be needed outside of the i2c core).
> 
> Implement i2c_lock_adapter/i2c_unlock_adapter in terms of the new locking
> scheme (i.e. lock with the I2C_LOCK_ADAPTER flag).
> 
> Annotate some of the locking with explicit I2C_LOCK_SEGMENT flags.

Can you explain a little why it is SEGMENT and not ADAPTER here? That
probably makes it easier to get into this patch.

And to double check my understanding: I was surprised to not see any
i2c_lock_adapter() or I2C_LOCK_ADAPTER in action. This is because muxes
call I2C_LOCK_SEGMENT on their parent which in case of the parent being
the root adapter is essentially the same as I2C_LOCK_ADAPTER. Correct?

> 
> Signed-off-by: Peter Rosin <peda@axentia.se>
> ---
>  drivers/i2c/i2c-core.c | 46 ++++++++++++++++++++++++++++------------------
>  include/linux/i2c.h    | 28 ++++++++++++++++++++++++++--
>  2 files changed, 54 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 0f2f8484e8ec..21f46d011c33 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -960,10 +960,12 @@ static int i2c_check_addr_busy(struct i2c_adapter *adapter, int addr)
>  }
>  
>  /**
> - * i2c_lock_adapter - Get exclusive access to an I2C bus segment
> + * i2c_adapter_lock_bus - Get exclusive access to an I2C bus segment
>   * @adapter: Target I2C bus segment
> + * @flags: I2C_LOCK_ADAPTER locks the root i2c adapter, I2C_LOCK_SEGMENT
> + *	locks only this branch in the adapter tree
>   */

I think this kerneldoc should be moved to i2c_lock_adapter and/or
i2c_lock_bus() which are now in i2c.h. This is what users will use, not
this static, adapter-specific implementation. I think it is enough to
have a comment here explaining what is special in handling adapters.

Thanks,

   Wolfram
