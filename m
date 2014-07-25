Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:62484 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaGYMZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 08:25:11 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so5417000oag.35
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 05:25:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D24A74.5060001@xs4all.nl>
References: <53999849.1090105@xs4all.nl> <CAPybu_2R9oj7aF1dUOjdGfHfV=LHaTWDp=CGXAZq76qcvJoAvQ@mail.gmail.com>
 <CAPybu_2fPc5z2KyiMzX-=VNQHavyR5WQHX2JcyPYMbUKmLMYYQ@mail.gmail.com>
 <53D245EA.4070803@xs4all.nl> <CAPybu_2jZ8qCpoJAe9aaBtnr=r8wzgkMn9onEE1L5C=qybQ4dQ@mail.gmail.com>
 <53D24A74.5060001@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 25 Jul 2014 14:24:50 +0200
Message-ID: <CAPybu_1-YVmrSyR4q5JHUj44OgGQK8aWkg3qmn64vYBon_vHwA@mail.gmail.com>
Subject: Re: [ATTN] Please review/check the REVIEWv4 compound control patch series
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans!

> I was thinking of just the sensor driver, not the other components.
> That would provide a proper use-case for both the dead pixel array
> and multi-selection.
>
> I assume that the sensor driver is a lot smaller? Does it need fw as well?
>

We support multiple sensors. The one that requires dead-pixel
correction is: FPA-320x256-C

Unfortunately, the chip only outputs the data as an analog output. The
data is processed by an FPGA. The FPGA requires firmware (the
bitstream).

I guess most of the code is useless for anybody else, if they don't
have access to the proper hw.

Thanks

Ricardo
