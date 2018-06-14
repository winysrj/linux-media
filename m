Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:41105 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755163AbeFNNA6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 09:00:58 -0400
Received: by mail-yw0-f195.google.com with SMTP id s201-v6so2090689ywg.8
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 06:00:58 -0700 (PDT)
Received: from mail-yw0-f178.google.com (mail-yw0-f178.google.com. [209.85.161.178])
        by smtp.gmail.com with ESMTPSA id a67-v6sm1972929ywa.20.2018.06.14.06.00.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jun 2018 06:00:56 -0700 (PDT)
Received: by mail-yw0-f178.google.com with SMTP id s201-v6so2090652ywg.8
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 06:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
In-Reply-To: <20180613140714.1686-1-maxime.ripard@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 14 Jun 2018 22:00:43 +0900
Message-ID: <CAAFQd5A-GMBnNnRCfm0-51R9rn_pWw+UC3r-JX-_BE3cdznqig@mail.gmail.com>
Subject: Re: [PATCH 0/9] media: cedrus: Add H264 decoding support
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com, thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Wed, Jun 13, 2018 at 11:07 PM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> Hi,
>
> Here is a preliminary version of the H264 decoding support in the
> cedrus driver.

Thanks for the series! Let me reply inline to some of the points raised here.

>
> As you might already know, the cedrus driver relies on the Request
> API, and is a reverse engineered driver for the video decoding engine
> found on the Allwinner SoCs.
>
> This work has been possible thanks to the work done by the people
> behind libvdpau-sunxi found here:
> https://github.com/linux-sunxi/libvdpau-sunxi/
>
> This driver is based on the last version of the cedrus driver sent by
> Paul, based on Request API v13 sent by Hans:
> https://lkml.org/lkml/2018/5/7/316

Just FYI, there is v15 already. :)

>
> This driver has been tested only with baseline profile videos, and is
> missing a few key features to decode videos with higher profiles.
> This has been tested using our cedrus-frame-test tool, which should be
> a quite generic v4l2-to-drm decoder using the request API to
> demonstrate the video decoding:
> https://github.com/free-electrons/cedrus-frame-test/, branch h264
>
> However, sending this preliminary version, I'd really like to start a
> discussion and get some feedback on the user-space API for the H264
> controls exposed through the request API.
>
> I've been using the controls currently integrated into ChromeOS that
> have a working version of this particular setup. However, these
> controls have a number of shortcomings and inconsistencies with other
> decoding API. I've worked with libva so far, but I've noticed already
> that:

Note that these controls are supposed to be defined exactly like the
bitstream headers deserialized into C structs in memory. I believe
Pawel (on CC) defined them based on the actual H264 specification.

>   - The kernel UAPI expects to have the nal_ref_idc variable, while
>     libva only exposes whether that frame is a reference frame or
>     not. I've looked at the rockchip driver in the ChromeOS tree, and
>     our own driver, and they both need only the information about
>     whether the frame is a reference one or not, so maybe we should
>     change this?

The fact that 2 drivers only need partial information doesn't mean
that we should ignore the data being already in the bitstream. IMHO
this API should to provide all the metadata available in the stream to
the kernel driver, as a replacement for bitstream parsing in firmware
(or in kernel... yuck).

>   - The H264 bitstream exposes the picture default reference list (for
>     both list 0 and list 1), the slice reference list and an override
>     flag. The libva will only pass the reference list to be used (so
>     either the picture default's or the slice's) depending on the
>     override flag. The kernel UAPI wants the picture default reference
>     list and the slice reference list, but doesn't expose the override
>     flag, which prevents us from configuring properly the
>     hardware. Our video decoding engine needs the three information,
>     but we can easily adapt to having only one. However, having two
>     doesn't really work for us.

Where does the override flag come from? If it's in the bitstream, then
I guess it was just missed when creating the structures.

Best regards,
Tomasz
