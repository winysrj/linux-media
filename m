Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53460 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaHEIH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 04:07:27 -0400
Received: by mail-ob0-f172.google.com with SMTP id wn1so410111obc.17
        for <linux-media@vger.kernel.org>; Tue, 05 Aug 2014 01:07:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407153257.3979.30.camel@paszta.hi.pengutronix.de>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
 <20140728185949.GS13730@pengutronix.de> <53D6BD8E.7000903@gmail.com>
 <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com> <1407153257.3979.30.camel@paszta.hi.pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 5 Aug 2014 10:07:11 +0200
Message-ID: <CAL8zT=i1KSUKWnsbC2iero8Y8e8iDH+chhVA_KvnRKNHg==zKw@mail.gmail.com>
Subject: Re: i.MX6 status for IPU/VPU/GPU
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Tim Harvey <tharvey@gateworks.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Steve Longerbeam <slongerbeam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-08-04 13:54 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi Tim,
>
> Am Sonntag, den 03.08.2014, 23:14 -0700 schrieb Tim Harvey:
>> Philipp,
>>
>> It is unfortunate that the lack of the media device framework is
>> holding back acceptance of Steve's patches. Is this something that can
>> be added later? Does your patchset which you posted for reference
>> resolve this issue and perhaps is something that everyone could agree
>> on for a starting point?
>
> We should take this step by step. First I'd like to get Steve's ipu-v3
> series in, those don't have any major issues and are a prerequisite for
> the media patches anyway.
>
> The capture patches had a few more issues than just missing media device
> support. But this is indeed the biggest one, especially where it
> involves a userspace interface that we don't want to have to support in
> the future.
> My RFC series wasn't without problems either. I'll work on the IPU this
> week and then post another RFC.

Are the capture patches using v4l2_async_notifier_register() ?
I can help integrating/testing all these patches, if you want...

JM
