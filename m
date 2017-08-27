Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55312
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751124AbdH0Lh4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 07:37:56 -0400
Date: Sun, 27 Aug 2017 08:37:48 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v4 3/6] i2c: add docs to clarify DMA handling
Message-ID: <20170827083748.248e2430@vento.lan>
In-Reply-To: <20170817141449.23958-4-wsa+renesas@sang-engineering.com>
References: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
        <20170817141449.23958-4-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Aug 2017 16:14:46 +0200
Wolfram Sang <wsa+renesas@sang-engineering.com> escreveu:

> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>  Documentation/i2c/DMA-considerations | 50 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/i2c/DMA-considerations
> 
> diff --git a/Documentation/i2c/DMA-considerations b/Documentation/i2c/DMA-considerations
> new file mode 100644
> index 00000000000000..a4b4a107102452
> --- /dev/null
> +++ b/Documentation/i2c/DMA-considerations
> @@ -0,0 +1,50 @@
> +Linux I2C and DMA
> +-----------------

I would use, instead:

=================
Linux I2C and DMA
=================

As this is the way we're starting document titles, after converted to
ReST. So, better to have it already using the right format, as one day
someone will convert i2c documentation to ReST. So, it would be
really cool if this document could be just renamed without needing
to patch it during such conversion :-)

There are also a couple of things here that Sphinx would complain.
So, it could be worth to rename it to *.rst, while you're writing
it, and see what:
	make htmldocs
will complain and how it will look in html.

> +
> +Given that I2C is a low-speed bus where largely small messages are transferred,
> +it is not considered a prime user of DMA access. At this time of writing, only
> +10% of I2C bus master drivers have DMA support implemented.

Are you sure about that? I'd say that, on media, at least half of the
drivers use DMA for I2C bus access, as the I2C bus is on a remote
board that talks with CPU via USB, using DMA, and all communication
with USB should be DMA-safe.

I guess what you really wanted to say on most of this section is
about SoC (and other CPUs) where the I2C bus master is is at the
mainboard, and not on some peripheral.

> And the vast
> +majority of transactions are so small that setting up DMA for it will likely
> +add more overhead than a plain PIO transfer.
> +
> +Therefore, it is *not* mandatory that the buffer of an I2C message is DMA safe.

Again, that may not be true on media boards. The code that implements the
I2C transfers there, on most boards, have to be DMA safe, as it won't
otherwise send/receive commands from the chips that are after the USB
bridge.

> +It does not seem reasonable to apply additional burdens when the feature is so
> +rarely used. However, it is recommended to use a DMA-safe buffer if your
> +message size is likely applicable for DMA. Most drivers have this threshold
> +around 8 bytes (as of today, this is mostly an educated guess, however). For
> +any message of 16 byte or larger, it is probably a really good idea.
> +
> +If you use such a buffer in a i2c_msg, set the I2C_M_DMA_SAFE flag with it.
> +Then, the I2C core and drivers know they can safely operate DMA on it. Note
> +that setting this flag makes only sense in kernel space. User space data is
> +copied into kernel space anyhow. The I2C core makes sure the destination
> +buffers in kernel space are always DMA capable.
> +
> +FIXME: Need to implement i2c_master_{send|receive}_dma and proper buffers for i2c_smbus_xfer_emulated.
> +
> +Drivers wishing to implement DMA can use helper functions from the I2C core.
> +One gives you a DMA-safe buffer for a given i2c_msg as long as a certain
> +threshold is met.
> +
> +	dma_buf = i2c_get_dma_safe_msg_buf(msg, threshold_in_byte);

I'm concerned about the new bits added by this call. Right now,
USB drivers just use kalloc() for transfer buffers used to send and
receive URB control messages for both setting the main device and
for I2C messages. Before this changeset, buffers allocated this
way are DMA save and have been working for years.

When you add some flags that would make the I2C subsystem aware
that a buffer is now DMA safe, I guess you could be breaking
those drivers, as a DMA safe buffer will now be considered as
DMA-unsafe.

So, you'll likely need to patch all media USB drivers to fix it,
or come up with some other solution.

> +
> +If a buffer is returned, it either msg->buf for the I2C_M_DMA_SAFE case or a
> +bounce buffer. But you don't need to care about that detail. If NULL is
> +returned, the threshold was not met or a bounce buffer could not be allocated.
> +Fall back to PIO in that case.
> +
> +In any case, a buffer obtained from above needs to be released. It ensures data
> +is copied back to the message and a potentially used bounce buffer is freed.
> +
> +	i2c_release_dma_safe_msg_buf(msg, dma_buf);
> +
> +The bounce buffer handling from the core is generic and simple. It will always
> +allocate a new bounce buffer. If you want a more sophisticated handling (e.g.
> +reusing pre-allocated buffers), you are free to implement your own.
> +
> +Please also check the in-kernel documentation for details. The i2c-sh_mobile
> +driver can be used as a reference example how to use the above helpers.
> +
> +Final note: If you plan to use DMA with I2C (or with anything else, actually)
> +make sure you have CONFIG_DMA_API_DEBUG enabled during development. It can help
> +you find various issues which can be complex to debug otherwise.



Thanks,
Mauro
