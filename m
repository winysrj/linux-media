Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14041 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3JJJ5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 05:57:53 -0400
Message-id: <52567A1C.8060609@samsung.com>
Date: Thu, 10 Oct 2013 11:57:48 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Bert Kenward <bert.kenward@broadcom.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] mipi-dsi-bus: add MIPI DSI bus support
References: <1380032596-18612-1-git-send-email-a.hajda@samsung.com>
 <1380032596-18612-2-git-send-email-a.hajda@samsung.com>
 <F5FE6E5E9429DA44B1C6B8A1A883D135041E001F@SJEXCHMB13.corp.ad.broadcom.com>
In-reply-to: <F5FE6E5E9429DA44B1C6B8A1A883D135041E001F@SJEXCHMB13.corp.ad.broadcom.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2013 12:47 PM, Bert Kenward wrote:
> On Tuesday September 24 2013 at 15:23, Andrzej Hajda wrote:
>> MIPI DSI is a high-speed serial interface to transmit
>> data from/to host to display module.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/video/display/Kconfig        |   4 +
>>  drivers/video/display/Makefile       |   1 +
>>  drivers/video/display/mipi-dsi-bus.c | 332
>> +++++++++++++++++++++++++++++++++++
>>  include/video/display.h              |   3 +
>>  include/video/mipi-dsi-bus.h         | 144 +++++++++++++++
>>  5 files changed, 484 insertions(+)
> <snipped as far as mipi-dsi-bus.h
>
>> diff --git a/include/video/mipi-dsi-bus.h b/include/video/mipi-dsi-bus.h
>> new file mode 100644
>> index 0000000..a78792d
>> --- /dev/null
>> +++ b/include/video/mipi-dsi-bus.h
>> @@ -0,0 +1,144 @@
>> +/*
>> + * MIPI DSI Bus
>> + *
>> + * Copyright (C) 2013, Samsung Electronics, Co., Ltd.
>> + * Andrzej Hajda <a.hajda@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __MIPI_DSI_BUS_H__
>> +#define __MIPI_DSI_BUS_H__
>> +
>> +#include <linux/device.h>
>> +#include <video/videomode.h>
>> +
>> +struct mipi_dsi_bus;
>> +struct mipi_dsi_device;
>> +
>> +struct mipi_dsi_bus_ops {
>> +	int (*set_power)(struct mipi_dsi_bus *bus, struct mipi_dsi_device
>> *dev,
>> +			 bool on);
>> +	int (*set_stream)(struct mipi_dsi_bus *bus, struct mipi_dsi_device
>> *dev,
>> +			  bool on);
>> +	int (*transfer)(struct mipi_dsi_bus *bus, struct mipi_dsi_device
>> *dev,
>> +			u8 type, const u8 *tx_buf, size_t tx_len, u8 *rx_buf,
>> +			size_t rx_len);
>> +};
>> +
>> +#define DSI_MODE_VIDEO			(1 << 0)
>> +#define DSI_MODE_VIDEO_BURST		(1 << 1)
>> +#define DSI_MODE_VIDEO_SYNC_PULSE	(1 << 2)
>> +#define DSI_MODE_VIDEO_AUTO_VERT	(1 << 3)
>> +#define DSI_MODE_VIDEO_HSE		(1 << 4)
>> +#define DSI_MODE_VIDEO_HFP		(1 << 5)
>> +#define DSI_MODE_VIDEO_HBP		(1 << 6)
>> +#define DSI_MODE_VIDEO_HSA		(1 << 7)
>> +#define DSI_MODE_VSYNC_FLUSH		(1 << 8)
>> +#define DSI_MODE_EOT_PACKET		(1 << 9)
>> +
>> +enum mipi_dsi_pixel_format {
>> +	DSI_FMT_RGB888,
>> +	DSI_FMT_RGB666,
>> +	DSI_FMT_RGB666_PACKED,
>> +	DSI_FMT_RGB565,
>> +};
>> +
>> +struct mipi_dsi_interface_params {
>> +	enum mipi_dsi_pixel_format format;
>> +	unsigned long mode;
>> +	unsigned long hs_clk_freq;
>> +	unsigned long esc_clk_freq;
>> +	unsigned char data_lanes;
>> +	unsigned char cmd_allow;
>> +};
>> +
>> +struct mipi_dsi_bus {
>> +	struct device *dev;
>> +	const struct mipi_dsi_bus_ops *ops;
>> +};
>> +
>> +#define MIPI_DSI_MODULE_PREFIX		"mipi-dsi:"
>> +#define MIPI_DSI_NAME_SIZE		32
>> +
>> +struct mipi_dsi_device_id {
>> +	char name[MIPI_DSI_NAME_SIZE];
>> +	__kernel_ulong_t driver_data	/* Data private to the driver */
>> +			__aligned(sizeof(__kernel_ulong_t));
>> +};
>> +
>> +struct mipi_dsi_device {
>> +	char name[MIPI_DSI_NAME_SIZE];
>> +	int id;
>> +	struct device dev;
>> +
>> +	const struct mipi_dsi_device_id *id_entry;
>> +	struct mipi_dsi_bus *bus;
>> +	struct videomode vm;
>> +	struct mipi_dsi_interface_params params;
>> +};
>> +
>> +#define to_mipi_dsi_device(d)	container_of(d, struct
>> mipi_dsi_device, dev)
>> +
>> +int mipi_dsi_device_register(struct mipi_dsi_device *dev,
>> +			     struct mipi_dsi_bus *bus);
>> +void mipi_dsi_device_unregister(struct mipi_dsi_device *dev);
>> +
>> +struct mipi_dsi_driver {
>> +	int(*probe)(struct mipi_dsi_device *);
>> +	int(*remove)(struct mipi_dsi_device *);
>> +	struct device_driver driver;
>> +	const struct mipi_dsi_device_id *id_table;
>> +};
>> +
>> +#define to_mipi_dsi_driver(d)	container_of(d, struct
>> mipi_dsi_driver, driver)
>> +
>> +int mipi_dsi_driver_register(struct mipi_dsi_driver *drv);
>> +void mipi_dsi_driver_unregister(struct mipi_dsi_driver *drv);
>> +
>> +static inline void *mipi_dsi_get_drvdata(const struct mipi_dsi_device
>> *dev)
>> +{
>> +	return dev_get_drvdata(&dev->dev);
>> +}
>> +
>> +static inline void mipi_dsi_set_drvdata(struct mipi_dsi_device *dev,
>> +					void *data)
>> +{
>> +	dev_set_drvdata(&dev->dev, data);
>> +}
>> +
>> +int of_mipi_dsi_register_devices(struct mipi_dsi_bus *bus);
>> +void mipi_dsi_unregister_devices(struct mipi_dsi_bus *bus);
>> +
>> +/* module_mipi_dsi_driver() - Helper macro for drivers that don't do
>> + * anything special in module init/exit.  This eliminates a lot of
>> + * boilerplate.  Each module may only use this macro once, and
>> + * calling it replaces module_init() and module_exit()
>> + */
>> +#define module_mipi_dsi_driver(__mipi_dsi_driver) \
>> +	module_driver(__mipi_dsi_driver, mipi_dsi_driver_register, \
>> +			mipi_dsi_driver_unregister)
>> +
>> +int mipi_dsi_set_power(struct mipi_dsi_device *dev, bool on);
>> +int mipi_dsi_set_stream(struct mipi_dsi_device *dev, bool on);
>> +int mipi_dsi_dcs_write(struct mipi_dsi_device *dev, int channel, const u8
>> *data,
>> +		       size_t len);
>> +int mipi_dsi_dcs_read(struct mipi_dsi_device *dev, int channel, u8 cmd,
>> +		      u8 *data, size_t len);
>> +
>> +#define mipi_dsi_dcs_write_seq(dev, channel, seq...) \
>> +({\
>> +	const u8 d[] = { seq };\
>> +	BUILD_BUG_ON_MSG(ARRAY_SIZE(d) > 64, "DCS sequence too long for
>> stack");\
>> +	mipi_dsi_dcs_write(dev, channel, d, ARRAY_SIZE(d));\
>> +})
>> +
>> +#define mipi_dsi_dcs_write_static_seq(dev, channel, seq...) \
>> +({\
>> +	static const u8 d[] = { seq };\
>> +	mipi_dsi_dcs_write(dev, channel, d, ARRAY_SIZE(d));\
>> +})
>> +
>> +#endif /* __MIPI_DSI_BUS__ */
> I may well have missed something,
>  but I can't see exactly how a command mode
> update would be done with this interface. Would this require repeated calls to
> .transfer? Such transfers would need to be flagged as requiring
> synchronisation with a tearing effect control signal - either the inband
> method or a dedicated line. I suspect many hardware implementations will have
> a specific method for transferring pixel data in a DSI command mode transfer.
>
> The command sending period during video mode should probably be configurable
> on a per-transfer basis. Some commands have to be synchronised with vertical
> blanking, others do not. This could perhaps be combined with a wider
> configuration option for a given panel or interface. Similarly, selection of
> low power (LP) and high speed (HS) mode on a per-transfer basis can be needed
> for some panels.
>
> Is there a mechanism for controlling ultra-low power state (ULPS) entry? Also,
> is there a method for sending arbitrary trigger messages (eg the reset
> trigger)?
Thanks for the feedback.
The current dsi bus implementation was just made to work with the
hw I have. It should be extended to be more generic, but I hope
now it is just matter of adding good opses and parameters.
Feel free to propose new opses.

Andrzej
>
> Thanks,
>
> Bert.

