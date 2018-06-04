Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40541 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbeFDIc7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 04:32:59 -0400
Message-ID: <1528101175.5808.4.camel@pengutronix.de>
Subject: Re: [PATCH v2 01/10] media: imx-csi: Pass sink pad field to
 ipu_csi_init_interface
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 04 Jun 2018 10:32:55 +0200
In-Reply-To: <m3o9grnmwy.fsf@t19.piap.pl>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
         <1527813049-3231-2-git-send-email-steve_longerbeam@mentor.com>
         <1527859350.5913.4.camel@pengutronix.de>
         <bbae0a24-7ab6-1361-f15c-068f32482f1f@gmail.com>
         <m3o9grnmwy.fsf@t19.piap.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-06-04 at 07:25 +0200, Krzysztof Hałasa wrote:
> Steve Longerbeam <slongerbeam@gmail.com> writes:
> 
> > I think we should return to enforcing field order to userspace that
> > matches field order from the source, which is what I had implemented
> > previously. I agree with you that we should put off allowing inverting
> > field order.
> 
> There is no any particular field order at the source, most of the time.
> The odd field is followed by the even field, and so on, sure. But there
> is no "first" and "second" field, any field can be the "first".

There is no particular field order in the data itself. But for BT.656
there is a specific field order, defined by the F flag in the SAV/EAV
codes. For PAL usually F=0 is the top field and F=1 is the bottom field.
For NTSC it usually is the other way around.

> The exception to this is a camera with a progressive sensor - both
> "fields" are taken at the same time and transmitted one after the other,
> so in this case the order is defined (by the camera, e.g. B-T on DV even
> with PAL version). But this isn't exactly PAL/NTSC.

That's why I'd like to make it obvious to the user when the field order
is switched. Whoever selects seq-bt -> seq-tb or seq-tb -> seq-bt
transformation for progressive sources can expect combing artifacts.

regards
Philipp
