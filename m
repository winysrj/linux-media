Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64900 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaDONLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 09:11:36 -0400
Message-id: <534D3001.2030707@samsung.com>
Date: Tue, 15 Apr 2014 15:11:29 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Rahul Sharma <r.sh.open@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>, b.zolnierkie@samsung.com,
	"sw0312.kim" <sw0312.kim@samsung.com>,
	sunil joshi <joshi@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	m.chehab@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Rahul Sharma <rahul.sharma@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 4/4] drm: exynos: hdmi: add support for pixel clock
 limitation
References: <1397554040-4037-1-git-send-email-t.stanislaws@samsung.com>
 <1397554040-4037-5-git-send-email-t.stanislaws@samsung.com>
 <CAPdUM4NysWMpy3PZhJdKXFa96Oy4kG4dKkDdrabbAmM3+f5kag@mail.gmail.com>
In-reply-to: <CAPdUM4NysWMpy3PZhJdKXFa96Oy4kG4dKkDdrabbAmM3+f5kag@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2014 11:42 AM, Rahul Sharma wrote:
> Hi Tomasz,
> 
> On 15 April 2014 14:57, Tomasz Stanislawski <t.stanislaws@samsung.com> wrote:
>> Adds support for limitation of maximal pixel clock of HDMI
>> signal. This feature is needed on boards that contains
>> lines or bridges with frequency limitations.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> ---
>>  .../devicetree/bindings/video/exynos_hdmi.txt      |    4 ++++
>>  drivers/gpu/drm/exynos/exynos_hdmi.c               |   12 ++++++++++++
>>  include/media/s5p_hdmi.h                           |    1 +
>>  3 files changed, 17 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/video/exynos_hdmi.txt b/Documentation/devicetree/bindings/video/exynos_hdmi.txt
>> index f9187a2..8718f8d 100644
>> --- a/Documentation/devicetree/bindings/video/exynos_hdmi.txt
>> +++ b/Documentation/devicetree/bindings/video/exynos_hdmi.txt
>> @@ -28,6 +28,10 @@ Required properties:
>>  - ddc: phandle to the hdmi ddc node
>>  - phy: phandle to the hdmi phy node
>>
>> +Optional properties:
>> +- max-pixel-clock: used to limit the maximal pixel clock if a board has lines,
>> +       connectors or bridges not capable of carring higher frequencies
>> +
>>  Example:
>>
>>         hdmi {
>> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
>> index 2a18f4e..404f1b7 100644
>> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
>> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
>> @@ -195,6 +195,7 @@ struct hdmi_context {
>>         struct hdmi_resources           res;
>>
>>         int                             hpd_gpio;
>> +       u32                             max_pixel_clock;
>>
>>         enum hdmi_type                  type;
>>  };
>> @@ -887,6 +888,9 @@ static int hdmi_mode_valid(struct drm_connector *connector,
>>         if (ret)
>>                 return MODE_BAD;
>>
>> +       if (mode->clock * 1000 > hdata->max_pixel_clock)
>> +               return MODE_BAD;
>> +
>>         ret = hdmi_find_phy_conf(hdata, mode->clock * 1000);
>>         if (ret < 0)
>>                 return MODE_BAD;
>> @@ -2031,6 +2035,8 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
>>                 return NULL;
>>         }
>>
>> +       of_property_read_u32(np, "max-pixel-clock", &pd->max_pixel_clock);
>> +
>>         return pd;
>>  }
>>
>> @@ -2067,6 +2073,11 @@ static int hdmi_probe(struct platform_device *pdev)
>>         if (!pdata)
>>                 return -EINVAL;
>>
>> +       if (!pdata->max_pixel_clock) {
>> +               DRM_INFO("max-pixel-clock is zero, using INF\n");
>> +               pdata->max_pixel_clock = U32_MAX;
>> +       }
>> +
>>         hdata = devm_kzalloc(dev, sizeof(struct hdmi_context), GFP_KERNEL);
>>         if (!hdata)
>>                 return -ENOMEM;
>> @@ -2083,6 +2094,7 @@ static int hdmi_probe(struct platform_device *pdev)
>>         hdata->type = drv_data->type;
>>
>>         hdata->hpd_gpio = pdata->hpd_gpio;
>> +       hdata->max_pixel_clock = pdata->max_pixel_clock;
>>         hdata->dev = dev;
>>
>>         ret = hdmi_resources_init(hdata);
>> diff --git a/include/media/s5p_hdmi.h b/include/media/s5p_hdmi.h
>> index 181642b..7272d65 100644
>> --- a/include/media/s5p_hdmi.h
>> +++ b/include/media/s5p_hdmi.h
>> @@ -31,6 +31,7 @@ struct s5p_hdmi_platform_data {
>>         int mhl_bus;
>>         struct i2c_board_info *mhl_info;
>>         int hpd_gpio;
>> +       u32 max_pixel_clock;
>>  };
> 
> We have already removed Non DT support from the drm hdmi
> driver. IMO we should not be extending the pdata struct.
> 
> Regards,
> Rahul Sharma

Hi Rahul,

This is not a non-DT patch. The s5p_hdmi_platform_data is
generated from DT itself. This structure is just
a parsed version of DT attributes.

It may be a good idea to rename s5p_hdmi_platform_data
to exynos_hdmi_pdata and move it to exynos_hdmi_drm.c file
or parse DT directly in probe function.

I can prepare a patch for that.

Regards,
Tomasz Stanislawski


> 
>>
>>  #endif /* S5P_HDMI_H */
>> --
>> 1.7.9.5
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel

