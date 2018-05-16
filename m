Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52163 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeEPOx7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 10:53:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLEztRY0xSScE51uvUtS89PqE_bNjkMfzBeTQTPyKd6asfPEQ@mail.gmail.com>
References: <20180308094807.9443-1-jacob-chen@iotwrt.com> <20180308094807.9443-5-jacob-chen@iotwrt.com>
 <18647985.GIavVuIZz4@avalon> <CAFLEztRY0xSScE51uvUtS89PqE_bNjkMfzBeTQTPyKd6asfPEQ@mail.gmail.com>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Wed, 16 May 2018 22:53:57 +0800
Message-ID: <CAFLEztTsPdR9mjj7uu+0dUpUecUx=bLRBRcfue06Gy5YdrgGDA@mail.gmail.com>
Subject: Re: [PATCH v6 04/17] media: rkisp1: add Rockchip MIPI Synopsys DPHY driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Xing Zheng <zhengxing@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-16 22:39 GMT+08:00 Jacob Chen <jacobchen110@gmail.com>:
> Hi Laurent,
>
> 2018-05-16 13:20 GMT+08:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> Hi Jacob,
>>
>> Thank you for the patch.
>>
>> On Thursday, 8 March 2018 11:47:54 EEST Jacob Chen wrote:
>>> From: Jacob Chen <jacob2.chen@rock-chips.com>
>>>
>>> This commit adds a subdev driver for Rockchip MIPI Synopsys DPHY driver
>>
>> Should this really be a subdev driver ? After a quick look at the code, the
>> only parameters you need to configure the PHY is the number of lanes and the
>> data rate. Implementing the whole subdev API seems overcomplicated to me,
>> especially given that the D-PHY doesn't deal with video streams as such, but
>> operates one level down. Shouldn't we model the D-PHY using the Linux PHY
>> framework ? I believe all the features you need are there except for a D-PHY-
>> specific configuration function that should be very easy to add.
>>
>
> It deserves a subdev driver since the ISP is not the only user.
> Other driver, like VIP, use it too.
>
>

For example, if there are two sensors connected to a rk3399 board.

Sensor1 --> DPHY1
Sensor2 --> DPHY2

With a subdev phy driver, i can choose either ISP or VIP for
sensor1/sensor2 by enable/disable media link in the run time.
1.
Sensor1 --> DPHY1 ---> VIP
Sensor2 --> DPHY2 ---> ISP1
2.
Sensor1 --> DPHY1 ---> ISP1
Sensor2 --> DPHY2 ---> VIP



>>> Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
>>> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
>>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>>> ---
>>>  .../media/platform/rockchip/isp1/mipi_dphy_sy.c    | 868 ++++++++++++++++++
>>>  .../media/platform/rockchip/isp1/mipi_dphy_sy.h    |  15 +
>>>  2 files changed, 883 insertions(+)
>>>  create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy.c
>>>  create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy.h
>>>
>>> diff --git a/drivers/media/platform/rockchip/isp1/mipi_dphy_sy.c
>>> b/drivers/media/platform/rockchip/isp1/mipi_dphy_sy.c new file mode 100644
>>> index 000000000000..32140960557a
>>> --- /dev/null
>>> +++ b/drivers/media/platform/rockchip/isp1/mipi_dphy_sy.c
>>> @@ -0,0 +1,868 @@
>>> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
>>> +/*
>>> + * Rockchip MIPI Synopsys DPHY driver
>>> + *
>>> + * Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd.
>>> + */
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_platform.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/pm_runtime.h>
>>> +#include <linux/regmap.h>
>>> +#include <linux/mfd/syscon.h>
>>> +#include <media/media-entity.h>
>>> +#include <media/v4l2-ctrls.h>
>>> +#include <media/v4l2-fwnode.h>
>>> +#include <media/v4l2-subdev.h>
>>> +
>>> +#define RK3288_GRF_SOC_CON6  0x025c
>>> +#define RK3288_GRF_SOC_CON8  0x0264
>>> +#define RK3288_GRF_SOC_CON9  0x0268
>>> +#define RK3288_GRF_SOC_CON10 0x026c
>>> +#define RK3288_GRF_SOC_CON14 0x027c
>>> +#define RK3288_GRF_SOC_STATUS21      0x02d4
>>> +#define RK3288_GRF_IO_VSEL   0x0380
>>> +#define RK3288_GRF_SOC_CON15 0x03a4
>>> +
>>> +#define RK3399_GRF_SOC_CON9  0x6224
>>> +#define RK3399_GRF_SOC_CON21 0x6254
>>> +#define RK3399_GRF_SOC_CON22 0x6258
>>> +#define RK3399_GRF_SOC_CON23 0x625c
>>> +#define RK3399_GRF_SOC_CON24 0x6260
>>> +#define RK3399_GRF_SOC_CON25 0x6264
>>> +#define RK3399_GRF_SOC_STATUS1       0xe2a4
>>> +
>>> +#define CLOCK_LANE_HS_RX_CONTROL             0x34
>>> +#define LANE0_HS_RX_CONTROL                  0x44
>>> +#define LANE1_HS_RX_CONTROL                  0x54
>>> +#define LANE2_HS_RX_CONTROL                  0x84
>>> +#define LANE3_HS_RX_CONTROL                  0x94
>>> +#define HS_RX_DATA_LANES_THS_SETTLE_CONTROL  0x75
>>> +
>>> +/*
>>> + * CSI HOST
>>> + */
>>> +#define CSIHOST_PHY_TEST_CTRL0               0x30
>>> +#define CSIHOST_PHY_TEST_CTRL1               0x34
>>> +#define CSIHOST_PHY_SHUTDOWNZ                0x08
>>> +#define CSIHOST_DPHY_RSTZ            0x0c
>>> +
>>> +#define PHY_TESTEN_ADDR                      (0x1 << 16)
>>> +#define PHY_TESTEN_DATA                      (0x0 << 16)
>>> +#define PHY_TESTCLK                  (0x1 << 1)
>>> +#define PHY_TESTCLR                  (0x1 << 0)
>>> +#define THS_SETTLE_COUNTER_THRESHOLD 0x04
>>> +
>>> +#define HIWORD_UPDATE(val, mask, shift) \
>>> +     ((val) << (shift) | (mask) << ((shift) + 16))
>>> +
>>> +enum mipi_dphy_sy_pads {
>>> +     MIPI_DPHY_SY_PAD_SINK = 0,
>>> +     MIPI_DPHY_SY_PAD_SOURCE,
>>> +     MIPI_DPHY_SY_PADS_NUM,
>>> +};
>>> +
>>> +enum dphy_reg_id {
>>> +     GRF_DPHY_RX0_TURNDISABLE = 0,
>>> +     GRF_DPHY_RX0_FORCERXMODE,
>>> +     GRF_DPHY_RX0_FORCETXSTOPMODE,
>>> +     GRF_DPHY_RX0_ENABLE,
>>> +     GRF_DPHY_RX0_TESTCLR,
>>> +     GRF_DPHY_RX0_TESTCLK,
>>> +     GRF_DPHY_RX0_TESTEN,
>>> +     GRF_DPHY_RX0_TESTDIN,
>>> +     GRF_DPHY_RX0_TURNREQUEST,
>>> +     GRF_DPHY_RX0_TESTDOUT,
>>> +     GRF_DPHY_TX0_TURNDISABLE,
>>> +     GRF_DPHY_TX0_FORCERXMODE,
>>> +     GRF_DPHY_TX0_FORCETXSTOPMODE,
>>> +     GRF_DPHY_TX0_TURNREQUEST,
>>> +     GRF_DPHY_TX1RX1_TURNDISABLE,
>>> +     GRF_DPHY_TX1RX1_FORCERXMODE,
>>> +     GRF_DPHY_TX1RX1_FORCETXSTOPMODE,
>>> +     GRF_DPHY_TX1RX1_ENABLE,
>>> +     GRF_DPHY_TX1RX1_MASTERSLAVEZ,
>>> +     GRF_DPHY_TX1RX1_BASEDIR,
>>> +     GRF_DPHY_TX1RX1_ENABLECLK,
>>> +     GRF_DPHY_TX1RX1_TURNREQUEST,
>>> +     GRF_DPHY_RX1_SRC_SEL,
>>> +     /* rk3288 only */
>>> +     GRF_CON_DISABLE_ISP,
>>> +     GRF_CON_ISP_DPHY_SEL,
>>> +     GRF_DSI_CSI_TESTBUS_SEL,
>>> +     GRF_DVP_V18SEL,
>>> +     /* below is for rk3399 only */
>>> +     GRF_DPHY_RX0_CLK_INV_SEL,
>>> +     GRF_DPHY_RX1_CLK_INV_SEL,
>>> +};
>>> +
>>> +struct dphy_reg {
>>> +     u32 offset;
>>> +     u32 mask;
>>> +     u32 shift;
>>> +};
>>> +
>>> +#define PHY_REG(_offset, _width, _shift) \
>>> +     { .offset = _offset, .mask = BIT(_width) - 1, .shift = _shift, }
>>> +
>>> +static const struct dphy_reg rk3399_grf_dphy_regs[] = {
>>> +     [GRF_DPHY_RX0_TURNREQUEST] = PHY_REG(RK3399_GRF_SOC_CON9, 4, 0),
>>> +     [GRF_DPHY_RX0_CLK_INV_SEL] = PHY_REG(RK3399_GRF_SOC_CON9, 1, 10),
>>> +     [GRF_DPHY_RX1_CLK_INV_SEL] = PHY_REG(RK3399_GRF_SOC_CON9, 1, 11),
>>> +     [GRF_DPHY_RX0_ENABLE] = PHY_REG(RK3399_GRF_SOC_CON21, 4, 0),
>>> +     [GRF_DPHY_RX0_FORCERXMODE] = PHY_REG(RK3399_GRF_SOC_CON21, 4, 4),
>>> +     [GRF_DPHY_RX0_FORCETXSTOPMODE] = PHY_REG(RK3399_GRF_SOC_CON21, 4, 8),
>>> +     [GRF_DPHY_RX0_TURNDISABLE] = PHY_REG(RK3399_GRF_SOC_CON21, 4, 12),
>>> +     [GRF_DPHY_TX0_FORCERXMODE] = PHY_REG(RK3399_GRF_SOC_CON22, 4, 0),
>>> +     [GRF_DPHY_TX0_FORCETXSTOPMODE] = PHY_REG(RK3399_GRF_SOC_CON22, 4, 4),
>>> +     [GRF_DPHY_TX0_TURNDISABLE] = PHY_REG(RK3399_GRF_SOC_CON22, 4, 8),
>>> +     [GRF_DPHY_TX0_TURNREQUEST] = PHY_REG(RK3399_GRF_SOC_CON22, 4, 12),
>>> +     [GRF_DPHY_TX1RX1_ENABLE] = PHY_REG(RK3399_GRF_SOC_CON23, 4, 0),
>>> +     [GRF_DPHY_TX1RX1_FORCERXMODE] = PHY_REG(RK3399_GRF_SOC_CON23, 4, 4),
>>> +     [GRF_DPHY_TX1RX1_FORCETXSTOPMODE] = PHY_REG(RK3399_GRF_SOC_CON23, 4, 8),
>>> +     [GRF_DPHY_TX1RX1_TURNDISABLE] = PHY_REG(RK3399_GRF_SOC_CON23, 4, 12),
>>> +     [GRF_DPHY_TX1RX1_TURNREQUEST] = PHY_REG(RK3399_GRF_SOC_CON24, 4, 0),
>>> +     [GRF_DPHY_RX1_SRC_SEL] = PHY_REG(RK3399_GRF_SOC_CON24, 1, 4),
>>> +     [GRF_DPHY_TX1RX1_BASEDIR] = PHY_REG(RK3399_GRF_SOC_CON24, 1, 5),
>>> +     [GRF_DPHY_TX1RX1_ENABLECLK] = PHY_REG(RK3399_GRF_SOC_CON24, 1, 6),
>>> +     [GRF_DPHY_TX1RX1_MASTERSLAVEZ] = PHY_REG(RK3399_GRF_SOC_CON24, 1, 7),
>>> +     [GRF_DPHY_RX0_TESTDIN] = PHY_REG(RK3399_GRF_SOC_CON25, 8, 0),
>>> +     [GRF_DPHY_RX0_TESTEN] = PHY_REG(RK3399_GRF_SOC_CON25, 1, 8),
>>> +     [GRF_DPHY_RX0_TESTCLK] = PHY_REG(RK3399_GRF_SOC_CON25, 1, 9),
>>> +     [GRF_DPHY_RX0_TESTCLR] = PHY_REG(RK3399_GRF_SOC_CON25, 1, 10),
>>> +     [GRF_DPHY_RX0_TESTDOUT] = PHY_REG(RK3399_GRF_SOC_STATUS1, 8, 0),
>>> +};
>>> +
>>> +static const struct dphy_reg rk3288_grf_dphy_regs[] = {
>>> +     [GRF_CON_DISABLE_ISP] = PHY_REG(RK3288_GRF_SOC_CON6, 1, 0),
>>> +     [GRF_CON_ISP_DPHY_SEL] = PHY_REG(RK3288_GRF_SOC_CON6, 1, 1),
>>> +     [GRF_DSI_CSI_TESTBUS_SEL] = PHY_REG(RK3288_GRF_SOC_CON6, 1, 14),
>>> +     [GRF_DPHY_TX0_TURNDISABLE] = PHY_REG(RK3288_GRF_SOC_CON8, 4, 0),
>>> +     [GRF_DPHY_TX0_FORCERXMODE] = PHY_REG(RK3288_GRF_SOC_CON8, 4, 4),
>>> +     [GRF_DPHY_TX0_FORCETXSTOPMODE] = PHY_REG(RK3288_GRF_SOC_CON8, 4, 8),
>>> +     [GRF_DPHY_TX1RX1_TURNDISABLE] = PHY_REG(RK3288_GRF_SOC_CON9, 4, 0),
>>> +     [GRF_DPHY_TX1RX1_FORCERXMODE] = PHY_REG(RK3288_GRF_SOC_CON9, 4, 4),
>>> +     [GRF_DPHY_TX1RX1_FORCETXSTOPMODE] = PHY_REG(RK3288_GRF_SOC_CON9, 4, 8),
>>> +     [GRF_DPHY_TX1RX1_ENABLE] = PHY_REG(RK3288_GRF_SOC_CON9, 4, 12),
>>> +     [GRF_DPHY_RX0_TURNDISABLE] = PHY_REG(RK3288_GRF_SOC_CON10, 4, 0),
>>> +     [GRF_DPHY_RX0_FORCERXMODE] = PHY_REG(RK3288_GRF_SOC_CON10, 4, 4),
>>> +     [GRF_DPHY_RX0_FORCETXSTOPMODE] = PHY_REG(RK3288_GRF_SOC_CON10, 4, 8),
>>> +     [GRF_DPHY_RX0_ENABLE] = PHY_REG(RK3288_GRF_SOC_CON10, 4, 12),
>>> +     [GRF_DPHY_RX0_TESTCLR] = PHY_REG(RK3288_GRF_SOC_CON14, 1, 0),
>>> +     [GRF_DPHY_RX0_TESTCLK] = PHY_REG(RK3288_GRF_SOC_CON14, 1, 1),
>>> +     [GRF_DPHY_RX0_TESTEN] = PHY_REG(RK3288_GRF_SOC_CON14, 1, 2),
>>> +     [GRF_DPHY_RX0_TESTDIN] = PHY_REG(RK3288_GRF_SOC_CON14, 8, 3),
>>> +     [GRF_DPHY_TX1RX1_ENABLECLK] = PHY_REG(RK3288_GRF_SOC_CON14, 1, 12),
>>> +     [GRF_DPHY_RX1_SRC_SEL] = PHY_REG(RK3288_GRF_SOC_CON14, 1, 13),
>>> +     [GRF_DPHY_TX1RX1_MASTERSLAVEZ] = PHY_REG(RK3288_GRF_SOC_CON14, 1, 14),
>>> +     [GRF_DPHY_TX1RX1_BASEDIR] = PHY_REG(RK3288_GRF_SOC_CON14, 1, 15),
>>> +     [GRF_DPHY_RX0_TURNREQUEST] = PHY_REG(RK3288_GRF_SOC_CON15, 4, 0),
>>> +     [GRF_DPHY_TX1RX1_TURNREQUEST] = PHY_REG(RK3288_GRF_SOC_CON15, 4, 4),
>>> +     [GRF_DPHY_TX0_TURNREQUEST] = PHY_REG(RK3288_GRF_SOC_CON15, 3, 8),
>>> +     [GRF_DVP_V18SEL] = PHY_REG(RK3288_GRF_IO_VSEL, 1, 1),
>>> +     [GRF_DPHY_RX0_TESTDOUT] = PHY_REG(RK3288_GRF_SOC_STATUS21, 8, 0),
>>> +};
>>> +
>>> +struct hsfreq_range {
>>> +     u32 range_h;
>>> +     u8 cfg_bit;
>>> +};
>>> +
>>> +struct mipidphy_priv;
>>> +
>>> +struct dphy_drv_data {
>>> +     const char * const *clks;
>>> +     int num_clks;
>>> +     const struct hsfreq_range *hsfreq_ranges;
>>> +     int num_hsfreq_ranges;
>>> +     const struct dphy_reg *regs;
>>> +};
>>> +
>>> +struct sensor_async_subdev {
>>> +     struct v4l2_async_subdev asd;
>>> +     struct v4l2_mbus_config mbus;
>>> +     int lanes;
>>> +};
>>> +
>>> +#define MAX_DPHY_CLK         8
>>> +#define MAX_DPHY_SENSORS     2
>>> +
>>> +struct mipidphy_sensor {
>>> +     struct v4l2_subdev *sd;
>>> +     struct v4l2_mbus_config mbus;
>>> +     int lanes;
>>> +};
>>> +
>>> +struct mipidphy_priv {
>>> +     struct device *dev;
>>> +     struct regmap *regmap_grf;
>>> +     const struct dphy_reg *grf_regs;
>>> +     struct clk *clks[MAX_DPHY_CLK];
>>> +     const struct dphy_drv_data *drv_data;
>>> +     u64 data_rate_mbps;
>>> +     struct v4l2_async_notifier notifier;
>>> +     struct v4l2_subdev sd;
>>> +     struct media_pad pads[MIPI_DPHY_SY_PADS_NUM];
>>> +     struct mipidphy_sensor sensors[MAX_DPHY_SENSORS];
>>> +     int num_sensors;
>>> +     bool is_streaming;
>>> +     void __iomem *txrx_base_addr;
>>> +     int (*stream_on)(struct mipidphy_priv *priv, struct v4l2_subdev *sd);
>>> +};
>>> +
>>> +static inline struct mipidphy_priv *to_dphy_priv(struct v4l2_subdev
>>> *subdev) +{
>>> +     return container_of(subdev, struct mipidphy_priv, sd);
>>> +}
>>> +
>>> +static inline void write_grf_reg(struct mipidphy_priv *priv,
>>> +                              int index, u8 value)
>>> +{
>>> +     const struct dphy_reg *reg = &priv->grf_regs[index];
>>> +     unsigned int val = HIWORD_UPDATE(value, reg->mask, reg->shift);
>>> +
>>> +     WARN_ON(!reg->offset);
>>> +     regmap_write(priv->regmap_grf, reg->offset, val);
>>> +}
>>> +
>>> +static void mipidphy0_wr_reg(struct mipidphy_priv *priv,
>>> +                          u8 test_code, u8 test_data)
>>> +{
>>> +     /*
>>> +      * With the falling edge on TESTCLK, the TESTDIN[7:0] signal content
>>> +      * is latched internally as the current test code. Test data is
>>> +      * programmed internally by rising edge on TESTCLK.
>>> +      */
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTCLK, 1);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTDIN, test_code);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTEN, 1);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTCLK, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTEN, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTDIN, test_data);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTCLK, 1);
>>> +}
>>> +
>>> +static void mipidphy1_wr_reg(struct mipidphy_priv *priv, unsigned char
>>> addr, +                            unsigned char data)
>>> +{
>>> +     /*
>>> +      * TESTEN =1,TESTDIN=addr
>>> +      * TESTCLK=0
>>> +      * TESTEN =0,TESTDIN=data
>>> +      * TESTCLK=1
>>> +      */
>>> +     writel((PHY_TESTEN_ADDR | addr),
>>> +            priv->txrx_base_addr + CSIHOST_PHY_TEST_CTRL1);
>>> +     writel(0x00, priv->txrx_base_addr + CSIHOST_PHY_TEST_CTRL0);
>>> +     writel((PHY_TESTEN_DATA | data),
>>> +            priv->txrx_base_addr + CSIHOST_PHY_TEST_CTRL1);
>>> +     writel(PHY_TESTCLK, priv->txrx_base_addr + CSIHOST_PHY_TEST_CTRL0);
>>> +}
>>> +
>>> +static struct v4l2_subdev *get_remote_sensor(struct v4l2_subdev *sd)
>>> +{
>>> +     struct media_pad *local, *remote;
>>> +     struct media_entity *sensor_me;
>>> +
>>> +     local = &sd->entity.pads[MIPI_DPHY_SY_PAD_SINK];
>>> +     remote = media_entity_remote_pad(local);
>>> +     if (!remote) {
>>> +             v4l2_warn(sd, "No link between dphy and sensor\n");
>>> +             return NULL;
>>> +     }
>>> +
>>> +     sensor_me = media_entity_remote_pad(local)->entity;
>>> +     return media_entity_to_v4l2_subdev(sensor_me);
>>> +}
>>> +
>>> +static struct mipidphy_sensor *sd_to_sensor(struct mipidphy_priv *priv,
>>> +                                         struct v4l2_subdev *sd)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < priv->num_sensors; ++i)
>>> +             if (priv->sensors[i].sd == sd)
>>> +                     return &priv->sensors[i];
>>> +
>>> +     return NULL;
>>> +}
>>> +
>>> +static int mipidphy_get_sensor_data_rate(struct v4l2_subdev *sd)
>>> +{
>>> +     struct mipidphy_priv *priv = to_dphy_priv(sd);
>>> +     struct v4l2_subdev *sensor_sd = get_remote_sensor(sd);
>>> +     struct v4l2_ctrl *link_freq;
>>> +     struct v4l2_querymenu qm = { .id = V4L2_CID_LINK_FREQ, };
>>> +     int ret;
>>> +
>>> +     link_freq = v4l2_ctrl_find(sensor_sd->ctrl_handler, V4L2_CID_LINK_FREQ);
>>> +     if (!link_freq) {
>>> +             v4l2_warn(sd, "No pixel rate control in subdev\n");
>>> +             return -EPIPE;
>>> +     }
>>> +
>>> +     qm.index = v4l2_ctrl_g_ctrl(link_freq);
>>> +     ret = v4l2_querymenu(sensor_sd->ctrl_handler, &qm);
>>> +     if (ret < 0) {
>>> +             v4l2_err(sd, "Failed to get menu item\n");
>>> +             return ret;
>>> +     }
>>> +
>>> +     if (!qm.value) {
>>> +             v4l2_err(sd, "Invalid link_freq\n");
>>> +             return -EINVAL;
>>> +     }
>>> +     priv->data_rate_mbps = qm.value * 2;
>>> +     do_div(priv->data_rate_mbps, 1000 * 1000);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int mipidphy_s_stream_start(struct v4l2_subdev *sd)
>>> +{
>>> +     struct mipidphy_priv *priv = to_dphy_priv(sd);
>>> +     int  ret = 0;
>>> +
>>> +     if (priv->is_streaming)
>>> +             return 0;
>>> +
>>> +     ret = mipidphy_get_sensor_data_rate(sd);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     priv->stream_on(priv, sd);
>>> +
>>> +     priv->is_streaming = true;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int mipidphy_s_stream_stop(struct v4l2_subdev *sd)
>>> +{
>>> +     struct mipidphy_priv *priv = to_dphy_priv(sd);
>>> +
>>> +     priv->is_streaming = false;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int mipidphy_s_stream(struct v4l2_subdev *sd, int on)
>>> +{
>>> +     if (on)
>>> +             return mipidphy_s_stream_start(sd);
>>> +     else
>>> +             return mipidphy_s_stream_stop(sd);
>>> +}
>>> +
>>> +static int mipidphy_g_mbus_config(struct v4l2_subdev *sd,
>>> +                               struct v4l2_mbus_config *config)
>>> +{
>>> +     struct mipidphy_priv *priv = to_dphy_priv(sd);
>>> +     struct v4l2_subdev *sensor_sd = get_remote_sensor(sd);
>>> +     struct mipidphy_sensor *sensor = sd_to_sensor(priv, sensor_sd);
>>> +
>>> +     *config = sensor->mbus;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int mipidphy_s_power(struct v4l2_subdev *sd, int on)
>>> +{
>>> +     struct mipidphy_priv *priv = to_dphy_priv(sd);
>>> +
>>> +     if (on)
>>> +             return pm_runtime_get_sync(priv->dev);
>>> +     else
>>> +             return pm_runtime_put(priv->dev);
>>> +}
>>> +
>>> +static int mipidphy_runtime_suspend(struct device *dev)
>>> +{
>>> +     struct media_entity *me = dev_get_drvdata(dev);
>>> +     struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(me);
>>> +     struct mipidphy_priv *priv = to_dphy_priv(sd);
>>> +     int i, num_clks;
>>> +
>>> +     num_clks = priv->drv_data->num_clks;
>>> +     for (i = num_clks - 1; i >= 0; i--)
>>> +             clk_disable_unprepare(priv->clks[i]);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int mipidphy_runtime_resume(struct device *dev)
>>> +{
>>> +     struct media_entity *me = dev_get_drvdata(dev);
>>> +     struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(me);
>>> +     struct mipidphy_priv *priv = to_dphy_priv(sd);
>>> +     int i, num_clks, ret;
>>> +
>>> +     num_clks = priv->drv_data->num_clks;
>>> +     for (i = 0; i < num_clks; i++) {
>>> +             ret = clk_prepare_enable(priv->clks[i]);
>>> +             if (ret < 0)
>>> +                     goto err;
>>> +     }
>>> +
>>> +     return 0;
>>> +err:
>>> +     while (--i >= 0)
>>> +             clk_disable_unprepare(priv->clks[i]);
>>> +     return ret;
>>> +}
>>> +
>>> +/* dphy accepts all fmt/size from sensor */
>>> +static int mipidphy_get_set_fmt(struct v4l2_subdev *sd,
>>> +                             struct v4l2_subdev_pad_config *cfg,
>>> +                             struct v4l2_subdev_format *fmt)
>>> +{
>>> +     struct v4l2_subdev *sensor = get_remote_sensor(sd);
>>> +
>>> +     /*
>>> +      * Do not allow format changes and just relay whatever
>>> +      * set currently in the sensor.
>>> +      */
>>> +     return v4l2_subdev_call(sensor, pad, get_fmt, NULL, fmt);
>>> +}
>>> +
>>> +static const struct v4l2_subdev_pad_ops mipidphy_subdev_pad_ops = {
>>> +     .set_fmt = mipidphy_get_set_fmt,
>>> +     .get_fmt = mipidphy_get_set_fmt,
>>> +};
>>> +
>>> +static const struct v4l2_subdev_core_ops mipidphy_core_ops = {
>>> +     .s_power = mipidphy_s_power,
>>> +};
>>> +
>>> +static const struct v4l2_subdev_video_ops mipidphy_video_ops = {
>>> +     .g_mbus_config = mipidphy_g_mbus_config,
>>> +     .s_stream = mipidphy_s_stream,
>>> +};
>>> +
>>> +static const struct v4l2_subdev_ops mipidphy_subdev_ops = {
>>> +     .core = &mipidphy_core_ops,
>>> +     .video = &mipidphy_video_ops,
>>> +     .pad = &mipidphy_subdev_pad_ops,
>>> +};
>>> +
>>> +/* These tables must be sorted by .range_h ascending. */
>>> +static const struct hsfreq_range rk3288_mipidphy_hsfreq_ranges[] = {
>>> +     {  89, 0x00}, {  99, 0x10}, { 109, 0x20}, { 129, 0x01},
>>> +     { 139, 0x11}, { 149, 0x21}, { 169, 0x02}, { 179, 0x12},
>>> +     { 199, 0x22}, { 219, 0x03}, { 239, 0x13}, { 249, 0x23},
>>> +     { 269, 0x04}, { 299, 0x14}, { 329, 0x05}, { 359, 0x15},
>>> +     { 399, 0x25}, { 449, 0x06}, { 499, 0x16}, { 549, 0x07},
>>> +     { 599, 0x17}, { 649, 0x08}, { 699, 0x18}, { 749, 0x09},
>>> +     { 799, 0x19}, { 849, 0x29}, { 899, 0x39}, { 949, 0x0a},
>>> +     { 999, 0x1a}
>>> +};
>>> +
>>> +static const struct hsfreq_range rk3399_mipidphy_hsfreq_ranges[] = {
>>> +     {  89, 0x00}, {  99, 0x10}, { 109, 0x20}, { 129, 0x01},
>>> +     { 139, 0x11}, { 149, 0x21}, { 169, 0x02}, { 179, 0x12},
>>> +     { 199, 0x22}, { 219, 0x03}, { 239, 0x13}, { 249, 0x23},
>>> +     { 269, 0x04}, { 299, 0x14}, { 329, 0x05}, { 359, 0x15},
>>> +     { 399, 0x25}, { 449, 0x06}, { 499, 0x16}, { 549, 0x07},
>>> +     { 599, 0x17}, { 649, 0x08}, { 699, 0x18}, { 749, 0x09},
>>> +     { 799, 0x19}, { 849, 0x29}, { 899, 0x39}, { 949, 0x0a},
>>> +     { 999, 0x1a}, {1049, 0x2a}, {1099, 0x3a}, {1149, 0x0b},
>>> +     {1199, 0x1b}, {1249, 0x2b}, {1299, 0x3b}, {1349, 0x0c},
>>> +     {1399, 0x1c}, {1449, 0x2c}, {1500, 0x3c}
>>> +};
>>> +
>>> +static const char * const rk3399_mipidphy_clks[] = {
>>> +     "dphy-ref",
>>> +     "dphy-cfg",
>>> +     "grf",
>>> +};
>>> +
>>> +static const char * const rk3288_mipidphy_clks[] = {
>>> +     "dphy-ref",
>>> +     "pclk",
>>> +};
>>> +
>>> +static int mipidphy_rx_stream_on(struct mipidphy_priv *priv,
>>> +                              struct v4l2_subdev *sd)
>>> +{
>>> +     struct v4l2_subdev *sensor_sd = get_remote_sensor(sd);
>>> +     struct mipidphy_sensor *sensor = sd_to_sensor(priv, sensor_sd);
>>> +     const struct dphy_drv_data *drv_data = priv->drv_data;
>>> +     const struct hsfreq_range *hsfreq_ranges = drv_data->hsfreq_ranges;
>>> +     int num_hsfreq_ranges = drv_data->num_hsfreq_ranges;
>>> +     int i, hsfreq = 0;
>>> +
>>> +     for (i = 0; i < num_hsfreq_ranges; i++) {
>>> +             if (hsfreq_ranges[i].range_h >= priv->data_rate_mbps) {
>>> +                     hsfreq = hsfreq_ranges[i].cfg_bit;
>>> +                     break;
>>> +             }
>>> +     }
>>> +     write_grf_reg(priv, GRF_CON_ISP_DPHY_SEL, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_FORCERXMODE, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_FORCETXSTOPMODE, 0);
>>> +     /* Disable lan turn around, which is ignored in receive mode */
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TURNREQUEST, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TURNDISABLE, 0xf);
>>> +
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_ENABLE, GENMASK(sensor->lanes - 1, 0));
>>> +
>>> +     /* dphy start */
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTCLK, 1);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTCLR, 1);
>>> +     usleep_range(100, 150);
>>> +     write_grf_reg(priv, GRF_DPHY_RX0_TESTCLR, 0);
>>> +     usleep_range(100, 150);
>>> +
>>> +     /* set clock lane */
>>> +     /* HS hsfreq_range & lane 0  settle bypass */
>>> +     mipidphy0_wr_reg(priv, CLOCK_LANE_HS_RX_CONTROL, 0);
>>> +     /* HS RX Control of lane0 */
>>> +     mipidphy0_wr_reg(priv, LANE0_HS_RX_CONTROL, hsfreq << 1);
>>> +     /* HS RX Control of lane1 */
>>> +     mipidphy0_wr_reg(priv, LANE1_HS_RX_CONTROL, 0);
>>> +     /* HS RX Control of lane2 */
>>> +     mipidphy0_wr_reg(priv, LANE2_HS_RX_CONTROL, 0);
>>> +     /* HS RX Control of lane3 */
>>> +     mipidphy0_wr_reg(priv, LANE3_HS_RX_CONTROL, 0);
>>> +     /* HS RX Data Lanes Settle State Time Control */
>>> +     mipidphy0_wr_reg(priv, HS_RX_DATA_LANES_THS_SETTLE_CONTROL,
>>> +                      THS_SETTLE_COUNTER_THRESHOLD);
>>> +
>>> +     /* Normal operation */
>>> +     mipidphy0_wr_reg(priv, 0x0, 0);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int mipidphy_txrx_stream_on(struct mipidphy_priv *priv,
>>> +                                struct v4l2_subdev *sd)
>>> +{
>>> +     struct v4l2_subdev *sensor_sd = get_remote_sensor(sd);
>>> +     struct mipidphy_sensor *sensor = sd_to_sensor(priv, sensor_sd);
>>> +     const struct dphy_drv_data *drv_data = priv->drv_data;
>>> +     const struct hsfreq_range *hsfreq_ranges = drv_data->hsfreq_ranges;
>>> +     int num_hsfreq_ranges = drv_data->num_hsfreq_ranges;
>>> +     int i, hsfreq = 0;
>>> +
>>> +     for (i = 0; i < num_hsfreq_ranges; i++) {
>>> +             if (hsfreq_ranges[i].range_h >= priv->data_rate_mbps) {
>>> +                     hsfreq = hsfreq_ranges[i].cfg_bit;
>>> +                     break;
>>> +             }
>>> +     }
>>> +     write_grf_reg(priv, GRF_CON_ISP_DPHY_SEL, 1);
>>> +     write_grf_reg(priv, GRF_DSI_CSI_TESTBUS_SEL, 1);
>>> +     write_grf_reg(priv, GRF_DPHY_RX1_SRC_SEL, 1);
>>> +     write_grf_reg(priv, GRF_DPHY_TX1RX1_MASTERSLAVEZ, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_TX1RX1_BASEDIR, 1);
>>> +     /* Disable lan turn around, which is ignored in receive mode */
>>> +     write_grf_reg(priv, GRF_DPHY_TX1RX1_FORCERXMODE, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_TX1RX1_FORCETXSTOPMODE, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_TX1RX1_TURNREQUEST, 0);
>>> +     write_grf_reg(priv, GRF_DPHY_TX1RX1_TURNDISABLE, 0xf);
>>> +     write_grf_reg(priv, GRF_DPHY_TX1RX1_ENABLE,
>>> +                   GENMASK(sensor->lanes - 1, 0));
>>> +     /* dphy start */
>>> +     writel(0, priv->txrx_base_addr + CSIHOST_PHY_SHUTDOWNZ);
>>> +     writel(0, priv->txrx_base_addr + CSIHOST_DPHY_RSTZ);
>>> +     writel(PHY_TESTCLK, priv->txrx_base_addr + CSIHOST_PHY_TEST_CTRL0);
>>> +     writel(PHY_TESTCLR, priv->txrx_base_addr + CSIHOST_PHY_TEST_CTRL0);
>>> +     usleep_range(100, 150);
>>> +     writel(PHY_TESTCLK, priv->txrx_base_addr + CSIHOST_PHY_TEST_CTRL0);
>>> +     usleep_range(100, 150);
>>> +
>>> +     /* set clock lane */
>>> +     mipidphy1_wr_reg(priv, CLOCK_LANE_HS_RX_CONTROL, 0);
>>> +     mipidphy1_wr_reg(priv, LANE0_HS_RX_CONTROL, hsfreq << 1);
>>> +     mipidphy1_wr_reg(priv, LANE1_HS_RX_CONTROL, 0);
>>> +     mipidphy1_wr_reg(priv, LANE2_HS_RX_CONTROL, 0);
>>> +     mipidphy1_wr_reg(priv, LANE3_HS_RX_CONTROL, 0);
>>> +     /* HS RX Data Lanes Settle State Time Control */
>>> +     mipidphy1_wr_reg(priv, HS_RX_DATA_LANES_THS_SETTLE_CONTROL,
>>> +                      THS_SETTLE_COUNTER_THRESHOLD);
>>> +
>>> +     /* Normal operation */
>>> +     mipidphy1_wr_reg(priv, 0x0, 0);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static const struct dphy_drv_data rk3288_mipidphy_drv_data = {
>>> +     .clks = rk3288_mipidphy_clks,
>>> +     .num_clks = ARRAY_SIZE(rk3288_mipidphy_clks),
>>> +     .hsfreq_ranges = rk3288_mipidphy_hsfreq_ranges,
>>> +     .num_hsfreq_ranges = ARRAY_SIZE(rk3288_mipidphy_hsfreq_ranges),
>>> +     .regs = rk3288_grf_dphy_regs,
>>> +};
>>> +
>>> +static const struct dphy_drv_data rk3399_mipidphy_drv_data = {
>>> +     .clks = rk3399_mipidphy_clks,
>>> +     .num_clks = ARRAY_SIZE(rk3399_mipidphy_clks),
>>> +     .hsfreq_ranges = rk3399_mipidphy_hsfreq_ranges,
>>> +     .num_hsfreq_ranges = ARRAY_SIZE(rk3399_mipidphy_hsfreq_ranges),
>>> +     .regs = rk3399_grf_dphy_regs,
>>> +};
>>> +
>>> +static const struct of_device_id rockchip_mipidphy_match_id[] = {
>>> +     {
>>> +             .compatible = "rockchip,rk3399-mipi-dphy",
>>> +             .data = &rk3399_mipidphy_drv_data,
>>> +     },
>>> +     {
>>> +             .compatible = "rockchip,rk3288-mipi-dphy",
>>> +             .data = &rk3288_mipidphy_drv_data,
>>> +     },
>>> +     {}
>>> +};
>>> +MODULE_DEVICE_TABLE(of, rockchip_mipidphy_match_id);
>>> +
>>> +/* The .bound() notifier callback when a match is found */
>>> +static int
>>> +rockchip_mipidphy_notifier_bound(struct v4l2_async_notifier *notifier,
>>> +                              struct v4l2_subdev *sd,
>>> +                              struct v4l2_async_subdev *asd)
>>> +{
>>> +     struct mipidphy_priv *priv = container_of(notifier,
>>> +                                               struct mipidphy_priv,
>>> +                                               notifier);
>>> +     struct sensor_async_subdev *s_asd = container_of(asd,
>>> +                                     struct sensor_async_subdev, asd);
>>> +     struct mipidphy_sensor *sensor;
>>> +     unsigned int pad, ret;
>>> +
>>> +     if (priv->num_sensors == ARRAY_SIZE(priv->sensors))
>>> +             return -EBUSY;
>>> +
>>> +     sensor = &priv->sensors[priv->num_sensors++];
>>> +     sensor->lanes = s_asd->lanes;
>>> +     sensor->mbus = s_asd->mbus;
>>> +     sensor->sd = sd;
>>> +
>>> +     for (pad = 0; pad < sensor->sd->entity.num_pads; pad++)
>>> +             if (sensor->sd->entity.pads[pad].flags
>>> +                                     & MEDIA_PAD_FL_SOURCE)
>>> +                     break;
>>> +
>>> +     if (pad == sensor->sd->entity.num_pads) {
>>> +             dev_err(priv->dev,
>>> +                     "failed to find src pad for %s\n",
>>> +                     sensor->sd->name);
>>> +
>>> +             return -ENXIO;
>>> +     }
>>> +
>>> +     ret = media_create_pad_link(
>>> +                     &sensor->sd->entity, pad,
>>> +                     &priv->sd.entity, MIPI_DPHY_SY_PAD_SINK,
>>> +                     priv->num_sensors != 1 ? 0 : MEDIA_LNK_FL_ENABLED);
>>> +     if (ret) {
>>> +             dev_err(priv->dev,
>>> +                     "failed to create link for %s\n",
>>> +                     sensor->sd->name);
>>> +             return ret;
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +/* The .unbind callback */
>>> +static void
>>> +rockchip_mipidphy_notifier_unbind(struct v4l2_async_notifier *notifier,
>>> +                               struct v4l2_subdev *sd,
>>> +                               struct v4l2_async_subdev *asd)
>>> +{
>>> +     struct mipidphy_priv *priv = container_of(notifier,
>>> +                                               struct mipidphy_priv,
>>> +                                               notifier);
>>> +     struct mipidphy_sensor *sensor = sd_to_sensor(priv, sd);
>>> +
>>> +     sensor->sd = NULL;
>>> +}
>>> +
>>> +static const struct
>>> +v4l2_async_notifier_operations rockchip_mipidphy_async_ops = {
>>> +     .bound = rockchip_mipidphy_notifier_bound,
>>> +     .unbind = rockchip_mipidphy_notifier_unbind,
>>> +};
>>> +
>>> +static int rockchip_mipidphy_fwnode_parse(struct device *dev,
>>> +                                       struct v4l2_fwnode_endpoint *vep,
>>> +                                       struct v4l2_async_subdev *asd)
>>> +{
>>> +     struct sensor_async_subdev *s_asd =
>>> +                     container_of(asd, struct sensor_async_subdev, asd);
>>> +     struct v4l2_mbus_config *config = &s_asd->mbus;
>>> +
>>> +     if (vep->bus_type != V4L2_MBUS_CSI2) {
>>> +             dev_err(dev, "Only CSI2 bus type is currently supported\n");
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     if (vep->base.port != 0) {
>>> +             dev_err(dev, "The PHY has only port 0\n");
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     config->type = V4L2_MBUS_CSI2;
>>> +     config->flags = vep->bus.mipi_csi2.flags;
>>> +     s_asd->lanes = vep->bus.mipi_csi2.num_data_lanes;
>>> +
>>> +     switch (vep->bus.mipi_csi2.num_data_lanes) {
>>> +     case 1:
>>> +             config->flags |= V4L2_MBUS_CSI2_1_LANE;
>>> +             break;
>>> +     case 2:
>>> +             config->flags |= V4L2_MBUS_CSI2_2_LANE;
>>> +             break;
>>> +     case 3:
>>> +             config->flags |= V4L2_MBUS_CSI2_3_LANE;
>>> +             break;
>>> +     case 4:
>>> +             config->flags |= V4L2_MBUS_CSI2_4_LANE;
>>> +             break;
>>> +     default:
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int rockchip_mipidphy_media_init(struct mipidphy_priv *priv)
>>> +{
>>> +     int ret;
>>> +
>>> +     priv->pads[MIPI_DPHY_SY_PAD_SOURCE].flags =
>>> +             MEDIA_PAD_FL_SOURCE | MEDIA_PAD_FL_MUST_CONNECT;
>>> +     priv->pads[MIPI_DPHY_SY_PAD_SINK].flags =
>>> +             MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
>>> +
>>> +     ret = media_entity_pads_init(&priv->sd.entity,
>>> +                             MIPI_DPHY_SY_PADS_NUM, priv->pads);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>>> +             priv->dev, &priv->notifier,
>>> +             sizeof(struct sensor_async_subdev), 0,
>>> +             rockchip_mipidphy_fwnode_parse);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     if (!priv->notifier.num_subdevs)
>>> +             return -ENODEV; /* no endpoint */
>>> +
>>> +     priv->sd.subdev_notifier = &priv->notifier;
>>> +     priv->notifier.ops = &rockchip_mipidphy_async_ops;
>>> +     ret = v4l2_async_subdev_notifier_register(&priv->sd, &priv->notifier);
>>> +     if (ret) {
>>> +             dev_err(priv->dev,
>>> +                     "failed to register async notifier : %d\n", ret);
>>> +             v4l2_async_notifier_cleanup(&priv->notifier);
>>> +             return ret;
>>> +     }
>>> +
>>> +     return v4l2_async_register_subdev(&priv->sd);
>>> +}
>>> +
>>> +static int rockchip_mipidphy_probe(struct platform_device *pdev)
>>> +{
>>> +     struct device *dev = &pdev->dev;
>>> +     struct v4l2_subdev *sd;
>>> +     struct mipidphy_priv *priv;
>>> +     struct regmap *grf;
>>> +     struct resource *res;
>>> +     const struct of_device_id *of_id;
>>> +     const struct dphy_drv_data *drv_data;
>>> +     int i, ret;
>>> +
>>> +     priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>>> +     if (!priv)
>>> +             return -ENOMEM;
>>> +     priv->dev = dev;
>>> +
>>> +     of_id = of_match_device(rockchip_mipidphy_match_id, dev);
>>> +     if (!of_id)
>>> +             return -EINVAL;
>>> +
>>> +     grf = syscon_node_to_regmap(dev->parent->of_node);
>>> +     if (IS_ERR(grf)) {
>>> +             grf = syscon_regmap_lookup_by_phandle(dev->of_node,
>>> +                                                   "rockchip,grf");
>>> +             if (IS_ERR(grf)) {
>>> +                     dev_err(dev, "Can't find GRF syscon\n");
>>> +                     return -ENODEV;
>>> +             }
>>> +     }
>>> +     priv->regmap_grf = grf;
>>> +
>>> +     drv_data = of_id->data;
>>> +     for (i = 0; i < drv_data->num_clks; i++) {
>>> +             priv->clks[i] = devm_clk_get(dev, drv_data->clks[i]);
>>> +
>>> +             if (IS_ERR(priv->clks[i])) {
>>> +                     dev_err(dev, "Failed to get %s\n", drv_data->clks[i]);
>>> +                     return PTR_ERR(priv->clks[i]);
>>> +             }
>>> +     }
>>> +
>>> +     priv->grf_regs = drv_data->regs;
>>> +     priv->drv_data = drv_data;
>>> +     priv->stream_on = mipidphy_txrx_stream_on;
>>> +     priv->txrx_base_addr = NULL;
>>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +     priv->txrx_base_addr = devm_ioremap_resource(dev, res);
>>> +     if (IS_ERR(priv->txrx_base_addr))
>>> +             priv->stream_on = mipidphy_rx_stream_on;
>>> +
>>> +     sd = &priv->sd;
>>> +     v4l2_subdev_init(sd, &mipidphy_subdev_ops);
>>> +     sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>>> +     snprintf(sd->name, sizeof(sd->name), "rockchip-sy-mipi-dphy");
>>> +     sd->dev = dev;
>>> +
>>> +     platform_set_drvdata(pdev, &sd->entity);
>>> +
>>> +     ret = rockchip_mipidphy_media_init(priv);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     pm_runtime_enable(&pdev->dev);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int rockchip_mipidphy_remove(struct platform_device *pdev)
>>> +{
>>> +     struct media_entity *me = platform_get_drvdata(pdev);
>>> +     struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(me);
>>> +
>>> +     media_entity_cleanup(&sd->entity);
>>> +
>>> +     pm_runtime_disable(&pdev->dev);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static const struct dev_pm_ops rockchip_mipidphy_pm_ops = {
>>> +     SET_RUNTIME_PM_OPS(mipidphy_runtime_suspend,
>>> +                        mipidphy_runtime_resume, NULL)
>>> +};
>>> +
>>> +static struct platform_driver rockchip_isp_mipidphy_driver = {
>>> +     .probe = rockchip_mipidphy_probe,
>>> +     .remove = rockchip_mipidphy_remove,
>>> +     .driver = {
>>> +                     .name = "rockchip-sy-mipi-dphy",
>>> +                     .pm = &rockchip_mipidphy_pm_ops,
>>> +                     .of_match_table = rockchip_mipidphy_match_id,
>>> +     },
>>> +};
>>> +
>>> +module_platform_driver(rockchip_isp_mipidphy_driver);
>>> +MODULE_AUTHOR("Rockchip Camera/ISP team");
>>> +MODULE_DESCRIPTION("Rockchip MIPI DPHY driver");
>>> +MODULE_LICENSE("Dual BSD/GPL");
>>> diff --git a/drivers/media/platform/rockchip/isp1/mipi_dphy_sy.h
>>> b/drivers/media/platform/rockchip/isp1/mipi_dphy_sy.h new file mode 100644
>>> index 000000000000..c558791064a2
>>> --- /dev/null
>>> +++ b/drivers/media/platform/rockchip/isp1/mipi_dphy_sy.h
>>> @@ -0,0 +1,15 @@
>>> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
>>> +/*
>>> + * Rockchip MIPI Synopsys DPHY driver
>>> + *
>>> + * Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd.
>>> + */
>>> +
>>> +#ifndef __MIPI_DPHY_SY_H__
>>> +#define __MIPI_DPHY_SY_H__
>>> +
>>> +#include <media/v4l2-subdev.h>
>>> +
>>> +void rkisp1_set_mipi_dphy_sy_lanes(struct v4l2_subdev *dphy, int lanes);
>>> +
>>> +#endif /* __RKISP1_MIPI_DPHY_SY_H__ */
>>
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
>>
>>
