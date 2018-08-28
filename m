Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:53456 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbeH1Jmj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 05:42:39 -0400
Received: by mail-it0-f66.google.com with SMTP id p79-v6so988313itp.3
        for <linux-media@vger.kernel.org>; Mon, 27 Aug 2018 22:52:38 -0700 (PDT)
Received: from mail-it0-f49.google.com (mail-it0-f49.google.com. [209.85.214.49])
        by smtp.gmail.com with ESMTPSA id n140-v6sm211324itb.37.2018.08.27.22.45.42
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Aug 2018 22:45:42 -0700 (PDT)
Received: by mail-it0-f49.google.com with SMTP id 139-v6so939757itf.0
        for <linux-media@vger.kernel.org>; Mon, 27 Aug 2018 22:45:42 -0700 (PDT)
MIME-Version: 1.0
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-4-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MV1jjksgbSaCuUcY_ZbjfGeK-GaQ_+OZ7LWUv4ehA3dGQ@mail.gmail.com>
 <9e9417cf2fccfed4015f6893045e4f7f@codeaurora.org> <CAPBb6MX7EQvXfq_F+8b2FcqROpGY7ud4M6UyttGzoELsw=NJ=Q@mail.gmail.com>
 <002138192bcb3f7e6bf55e090d1b5328@codeaurora.org>
In-Reply-To: <002138192bcb3f7e6bf55e090d1b5328@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 28 Aug 2018 14:45:30 +0900
Message-ID: <CAPBb6MX_XR=vfjgnSn3eauW3C-yfu7a9JA3Psnk=0Aej3mtNBg@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] venus: firmware: add no TZ boot and shutdown routine
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 27, 2018 at 9:49 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> On 2018-08-27 08:36, Alexandre Courbot wrote:
> > On Fri, Aug 24, 2018 at 9:26 PM Vikash Garodia
> > <vgarodia@codeaurora.org> wrote:
> >>
> >> Hi Alex,
> >>
> >> On 2018-08-24 13:09, Alexandre Courbot wrote:
> >> > On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia
> >> > <vgarodia@codeaurora.org> wrote:
> >>
> >> [snip]
> >>
> >> >> +struct video_firmware {
> >> >> +       struct device *dev;
> >> >> +       struct iommu_domain *iommu_domain;
> >> >> +};
> >> >> +
> >> >>  /**
> >> >>   * struct venus_core - holds core parameters valid for all instances
> >> >>   *
> >> >> @@ -98,6 +103,7 @@ struct venus_caps {
> >> >>   * @dev:               convenience struct device pointer
> >> >>   * @dev_dec:   convenience struct device pointer for decoder device
> >> >>   * @dev_enc:   convenience struct device pointer for encoder device
> >> >> + * @fw:                a struct for venus firmware info
> >> >>   * @no_tz:     a flag that suggests presence of trustzone
> >> >>   * @lock:      a lock for this strucure
> >> >>   * @instances: a list_head of all instances
> >> >> @@ -130,6 +136,7 @@ struct venus_core {
> >> >>         struct device *dev;
> >> >>         struct device *dev_dec;
> >> >>         struct device *dev_enc;
> >> >> +       struct video_firmware fw;
> >> >
> >> > Since struct video_firmware is only used here I think you can declare
> >> > it inline, i.e.
> >> >
> >> >     struct {
> >> >         struct device *dev;
> >> >         struct iommu_domain *iommu_domain;
> >> >     } fw;
> >> >
> >> > This structure is actually a good candidate to hold the firmware
> >> > memory area start address and size.
> >>
> >> I can make it inline.
> >> Memory area and size are common parameters populated
> >> locally while loading the firmware with or without tz. Firmware struct
> >> has
> >> info more specific to firmware device.
> >>
> >> [snip]
> >>
> >> >
> >> >> +{
> >> >> +       struct iommu_domain *iommu_dom;
> >> >> +       struct device *dev;
> >> >> +       int ret;
> >> >> +
> >> >> +       dev = core->fw.dev;
> >> >> +       if (!dev)
> >> >> +               return -EPROBE_DEFER;
> >> >> +
> >> >> +       iommu_dom = iommu_domain_alloc(&platform_bus_type);
> >> >> +       if (!iommu_dom) {
> >> >> +               dev_err(dev, "Failed to allocate iommu domain\n");
> >> >> +               return -ENOMEM;
> >> >> +       }
> >> >> +
> >> >> +       ret = iommu_attach_device(iommu_dom, dev);
> >> >> +       if (ret) {
> >> >> +               dev_err(dev, "could not attach device\n");
> >> >> +               goto err_attach;
> >> >> +       }
> >> >
> >> > I think like the above belongs more in venus_firmware_init()
> >> > (introduced in patch 4/4) than here. There is no reason to
> >> > detach/reattach the iommu if we stop the firmware.
> >>
> >> Consider the case when we want to reload the firmware during error
> >> recovery.
> >> Boot and shutdown will be needed in such case without the need to
> >> populate
> >> the firmware device again.
> >
> > Is there a need to reattach the iommu domain in case of an error?
>
> re-attach is not needed. We can have alloc/attach in init and
> detach/free in deinit.
> map/reset and unmap/reset can continue to remain in boot and shutdown
> calls. Let me
> know if this is good, i can repatch the series.

Yeah, the idea is to avoid repeating operations that do not need to be. Thanks!
