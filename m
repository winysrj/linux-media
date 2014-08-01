Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:62823 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaHAThO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 15:37:14 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so3559944lbi.1
        for <linux-media@vger.kernel.org>; Fri, 01 Aug 2014 12:37:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406622460.4001.5.camel@paszta.hi.pengutronix.de>
References: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
	<1406622460.4001.5.camel@paszta.hi.pengutronix.de>
Date: Fri, 1 Aug 2014 16:37:12 -0300
Message-ID: <CAOMZO5AgAFtRExeA_acYmuQ0rfgpvunCmHNw7n+_jHSSRv3dDw@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] CODA encoder/decoder device split
From: Fabio Estevam <festevam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Jul 29, 2014 at 5:27 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi,
>
> Am Freitag, den 18.07.2014, 12:22 +0200 schrieb Philipp Zabel:
>> Hi,
>>
>> the following patches add a few fixes and cleanups and split the
>> coda video4linux2 device into encoder and decoder.
>> Following the principle of least surprise, this way the format
>> enumeration on the output and capture sides is fixed and does
>> not change depending on whether the given instance is currently
>> configured as encoder or decoder.
>>
>> Changes since v1:
>>  - Fixed "[media] coda: delay coda_fill_bitstream()", taking into account
>>    "[media] v4l: vb2: Fix stream start and buffer completion race".
>>  - Added Hans' acks.
>
> is there still a chance to still get this series merged for v3.17?
> Most of it got acked by Hans right away, and I have received no other
> feedback.
> The split into separate encoder and decoder devices (patch 08/11) is
> necessary for this driver to work with the GStreamer v4l2videodec
> element.

You said in another email that Kamil is on vacation. Could you please
apply this series if you are happy with it?

Thanks
