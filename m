Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39798 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2JEHZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 03:25:59 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm2so217978wib.1
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2012 00:25:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <001301cda20c$d7691db0$863b5910$%dae@samsung.com>
References: <8952601.531301349336373038.JavaMail.weblogic@epml07>
	<001301cda20c$d7691db0$863b5910$%dae@samsung.com>
Date: Fri, 5 Oct 2012 16:25:57 +0900
Message-ID: <CAH9JG2V-7H3U35_QNR=MPbNF1Xwqt+3KFKpBcPuexFP84xP7pA@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] media: s5p-hdmi: add HPD GPIO to platform data
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Inki Dae <inki.dae@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: rahul.sharma@samsung.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	SUNIL JOSHI <joshi@samsung.com>, r.sh.open@gmail.com,
	Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

If you don't mind can we merge this patch at drm tree? the remainig
patches will be merged by Tomasz S.

To Marek & Tomasz,

Can you give your acks?

Thank you,
Kyungmin Park

On 10/4/12, Inki Dae <inki.dae@samsung.com> wrote:
> Hello Media guys,
>
> This is dependent of exynos drm patch set to be merged to mainline so if
> there is no problem then please, give me ack so that I can merge this patch
> with exynos drm patch set.
>
> Thanks,
> Inki Dae
>
>> -----Original Message-----
>> From: RAHUL SHARMA [mailto:rahul.sharma@samsung.com]
>> Sent: Thursday, October 04, 2012 4:40 PM
>> To: Tomasz Stanislawski; Kyungmin Park; linux-arm-
>> kernel@lists.infradead.org; linux-media@vger.kernel.org
>> Cc: In-Ki Dae; SUNIL JOSHI; r.sh.open@gmail.com
>> Subject: Re: [PATCH v1 01/14] media: s5p-hdmi: add HPD GPIO to platform
>> data
>>
>> Hi Mr. Tomasz, Mr. Park, list,
>>
>> First patch in the following set belongs to s5p-media, rest to
>> exynos-drm.
>> Please review the media patch so that It can be merged for mainline.
>>
>> regards,
>> Rahul Sharma
>>
>> On Thu, Oct 4, 2012 at 9:12 PM, Rahul Sharma <rahul.sharma@samsung.com>
>> wrote:
>> > From: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> >
>> > This patch extends s5p-hdmi platform data by a GPIO identifier for
>> > Hot-Plug-Detection pin.
>> >
>> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> > ---
>> >  include/media/s5p_hdmi.h |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/include/media/s5p_hdmi.h b/include/media/s5p_hdmi.h
>> > index 361a751..181642b 100644
>> > --- a/include/media/s5p_hdmi.h
>> > +++ b/include/media/s5p_hdmi.h
>> > @@ -20,6 +20,7 @@ struct i2c_board_info;
>> >   * @hdmiphy_info: template for HDMIPHY I2C device
>> >   * @mhl_bus: controller id for MHL control bus
>> >   * @mhl_info: template for MHL I2C device
>> > + * @hpd_gpio: GPIO for Hot-Plug-Detect pin
>> >   *
>> >   * NULL pointer for *_info fields indicates that
>> >   * the corresponding chip is not present
>> > @@ -29,6 +30,7 @@ struct s5p_hdmi_platform_data {
>> >         struct i2c_board_info *hdmiphy_info;
>> >         int mhl_bus;
>> >         struct i2c_board_info *mhl_info;
>> > +       int hpd_gpio;
>> >  };
>> >
>> >  #endif /* S5P_HDMI_H */
>> > --
>> > 1.7.0.4
>> >
>> >
>> > _______________________________________________
>> > linux-arm-kernel mailing list
>> > linux-arm-kernel@lists.infradead.org
>> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
