Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35245 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbcGEOWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 10:22:14 -0400
Date: Tue, 5 Jul 2016 09:22:11 -0500
From: Rob Herring <robh@kernel.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mark Rutland <mark.rutland@arm.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] [media] rc: ir-spi: add support for IR LEDs connected
 with SPI
Message-ID: <20160705142211.GA19930@rob-hp-laptop>
References: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 01, 2016 at 05:33:42PM +0900, Andi Shyti wrote:
> The ir-spi is a simple device driver which supports the
> connection between an IR LED and the MOSI line of an SPI device.

Please split the binding from the driver.


> The driver, indeed, uses the SPI framework to stream the raw data
> provided by userspace through a character device. The chardev is
> handled by the LIRC framework and its functionality basically
> provides:
> 
>  - raw write: data to be sent to the SPI and then streamed to the
>    MOSI line;
>  - set frequency: sets the frequency whith which the data should
>    be sent;
>  - set length: sets the data length. This information is
>    optional, if the length is set, then userspace should send raw
>    data only with that length; while if the length is set to '0',
>    then the driver will figure out himself the length of the data
>    based on the length of the data written on the character
>    device.
>    The latter is not recommended, though, as the driver, at
>    any write, allocates and deallocates a buffer where the data
>    from userspace are stored.
> 
> The driver provides three feedback commands:
> 
>  - get length: reads the length set and (as mentioned), if the
>    length is '0' it will be calculated at any write
>  - get frequency: the driver reports the frequency. If userpace
>    doesn't set the frequency, the driver will use a default value
>    of 38000Hz.
> 
> The character device is created under /dev/lircX name, where X is
> and ID assigned by the LIRC framework.
> 
> Example of usage:
> 
>         int fd, ret;
>         ssize_t n;
>         uint32_t val = 0;
> 
>         fd = open("/dev/lirc0", O_RDWR);
>         if (fd < 0) {
>                 fprintf(stderr, "unable to open the device\n");
>                 return -1;
>         }
> 
>         /* ioctl set frequency and length parameters */
>         val = 6430;
>         ret = ioctl(fd, LIRC_SET_LENGTH, &val);
>         if (ret < 0)
>                 fprintf(stderr, "LIRC_SET_LENGTH failed\n");
>         val = 608000;
>         ret = ioctl(fd, LIRC_SET_FREQUENCY, &val);
>         if (ret < 0)
>                 fprintf(stderr, "LIRC_SET_FREQUENCY failed\n");
> 
>         /* read back length and frequency parameters */
>         ret = ioctl(fd, LIRC_GET_LENGTH, &val);
>         if (ret < 0)
>                 fprintf(stderr, "LIRC_GET_LENGTH failed\n");
>         else
>                 fprintf(stdout, "legnth = %u\n", val);
> 
>         ret = ioctl(fd, LIRC_GET_FREQUENCY, &val);
>         if (ret < 0)
>                 fprintf(stderr, "LIRC_GET_FREQUENCY failed\n");
>         else
>                 fprintf(stdout, "frequency = %u\n", val);
> 
>         /* write data to device */
>         n = write(fd, b, 6430);
>         if (n < 0) {
>                 fprintf(stderr, "unable to write to the device\n");
>                 ret = -1;
>         } else if (n != 6430) {
>                 fprintf(stderr, "failed to write everything, wrote %ld instead\n", n);
>                 ret = -1;
>         } else {
>                 fprintf(stdout, "written all the %ld data\n", n);
>         }
> 
>         close(fd);
> 
> The driver supports multi task access, but all the processes
> which hold the driver should use the same length and frequency
> parameters.
> 
> Change-Id: I323d7dd4a56d6dcf48f2c695293822eb04bdb85f
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  Documentation/devicetree/bindings/media/spi-ir.txt |  24 ++
>  drivers/media/rc/Kconfig                           |   9 +
>  drivers/media/rc/Makefile                          |   1 +
>  drivers/media/rc/ir-spi.c                          | 301 +++++++++++++++++++++
>  4 files changed, 335 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/spi-ir.txt
>  create mode 100644 drivers/media/rc/ir-spi.c
> 
> diff --git a/Documentation/devicetree/bindings/media/spi-ir.txt b/Documentation/devicetree/bindings/media/spi-ir.txt
> new file mode 100644
> index 0000000..2232d92
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/spi-ir.txt
> @@ -0,0 +1,24 @@
> +Device tree bindings for IR LED connected through SPI bus which is used as
> +remote controller.

Do said devices have part numbers? Seems kind of generic and I've never 
seen such device.

> +The IR LED switch is connected to the MOSI line of the SPI device and the data
> +are delivered thourgh that.
> +
> +Required properties:
> +	- compatible: should be "ir-spi"
> +
> +Optional properties:
> +	- irled,switch: specifies the gpio switch which enables the irled

Just "switch-gpios"

> +
> +Example:
> +
> +        irled@0 {
> +                compatible = "ir-spi";
> +                reg = <0x0>;
> +                spi-max-frequency = <5000000>;
> +                irled,switch = <&gpr3 3 0>;
> +
> +                controller-data {

This is part of the controller binding? Omit that from the example.

> +                        samsung,spi-feedback-delay = <0>;
> +                };
> +        };
