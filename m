Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20006 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdCBHyL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 02:54:11 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Subject: Re: [PATCH v6 2/2] [media] s5p-mfc: Handle 'v4l2_pix_format:field' in
 try_fmt and g_fmt
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <54862f6b-290d-7e87-4297-57ffc35d357a@samsung.com>
Date: Thu, 02 Mar 2017 08:42:51 +0100
In-reply-to: <1488381666.14858.5.camel@collabora.com>
Content-transfer-encoding: 8bit
References: <20170301115108.14187-1-thibault.saunier@osg.samsung.com>
 <CGME20170301115141epcas2p37801b1fbe0951cc37a4e01bf2bcae3da@epcas2p3.samsung.com>
 <20170301115108.14187-3-thibault.saunier@osg.samsung.com>
 <33dbd3fa-04b2-3d94-5163-0a10589ff1c7@samsung.com>
 <1488381666.14858.5.camel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.03.2017 16:21, Nicolas Dufresne wrote:
> Le mercredi 01 mars 2017 à 14:12 +0100, Andrzej Hajda a écrit :
>> - on output side you have encoded bytestream - you cannot say about
>> interlacing in such case, so the only valid value is NONE,
>> - on capture side you have decoded frames, and in this case it
>> depends
>> on the device and driver capabilities, if the driver/device does not
>> support (de-)interlacing (I suppose this is MFC case), interlace type
>> field should be filled according to decoded bytestream header (on
>> output
>> side), but no direct copying from output side!!!
> I think we need some nuance here for this to actually be usable. If the
> information is not provided by the driver (yes, hardware is limiting
> sometimes), it would make sense to copy over the information that
> userspace provided. Setting NONE is just the worst approximation in my
> opinion.

The whole point is that s_fmt on output side is to describe format of
the stream passed to the device, and in case of decoder it is just
mpeg/h.26x/... stream. It does not contain frames, fields, width, height
- it is just raw stream of bytes. We cannot say in such case about field
type, there is not such thing as interlaced byte stream.
Using s_fmt on output to describe things on capture side look for me
unnecessary and abuses V4L2 API IMO.

>
> About MFC, it will be worth trying to read the DISPLAY_STATUS after the
> headers has been processed. It's not clearly stated in the spec if this
> will be set or not.
>
Documentation for MFC6.5 states clearly:

> Note: On SEQ_DONE, INTERLACE_PICTURE will return the picture type to
> be decoded based on the
> sequence header information.

In case of MFC5.1 it is unclear, but I hope HW behaves the same way.

Anyway I agree it will be good to fix it at least for MFC6.5+, any
volunteer?


Regards

Andrzej
