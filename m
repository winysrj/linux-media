Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37687 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaHDGUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 02:20:00 -0400
Received: by mail-oa0-f47.google.com with SMTP id g18so4642689oah.34
        for <linux-media@vger.kernel.org>; Sun, 03 Aug 2014 23:20:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D6BD8E.7000903@gmail.com>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
	<20140728185949.GS13730@pengutronix.de>
	<53D6BD8E.7000903@gmail.com>
Date: Sun, 3 Aug 2014 23:14:22 -0700
Message-ID: <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com>
Subject: Re: i.MX6 status for IPU/VPU/GPU
From: Tim Harvey <tharvey@gateworks.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Steve Longerbeam <slongerbeam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 28, 2014 at 2:15 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> On 07/28/2014 11:59 AM, Robert Schwebel wrote:
>> Hi,
>>
>> On Mon, Jul 28, 2014 at 06:24:45PM +0200, Jean-Michel Hautbois wrote:
>>> We have a custom board, based on i.MX6 SoC.
>>> We are currently using Freescale's release of Linux, but this is a
>>> 3.10.17 kernel, and several drivers are lacking (adv7611 for instance)
>>> or badly written (all the MXC part).
>>> As we want to have nice things :) we would like to use a mainline
>>> kernel, or at least a tree which can be mainlined.
>>>
>>> It seems (#v4l told me so) that some people (Steeve :) ?) are working
>>> on a rewriting of the IPU and all DRM part for i.MX6.
>>> What is the current status (compared to Freescale's release maybe) ?
>>> And what can we expect in a near future? Maybe, how can we help too ?
>
> Hi Jean-Michel,
>
> I did post a v4l2 video capture driver for i.MX6 to linux-media.
> The main complaint from Philip at Pengutronix is that it does not
> support the media device framework.

Philipp,

It is unfortunate that the lack of the media device framework is
holding back acceptance of Steve's patches. Is this something that can
be added later? Does your patchset which you posted for reference
resolve this issue and perhaps is something that everyone could agree
on for a starting point?

Regards,

Tim

>
> The customer I am currently working for has no real interest in the
> media controller API, and the driver I posted has all the features they
> require, so any work I do to add that support to the driver would have
> to be in my spare time, and I don't have much. If our customer were to
> request and fund media control support, that would be ideal, but as it is
> I can only spend limited time on it. So if you are interested in helping
> out in the media device effort I can send what I have so far.
>
> I have not provided any patches to i.MX6 DRM/KMS drivers. We have
> developed new features (overlay plane global/local alpha, hardware gamma
> correction, color-keying, and others) for for that component but haven't
> posted them yet.
>
> Steve
>
>> Pengutronix is continuously working on mainlining more parts of the
>> i.MX6 video and graphics subsystem, including the components you have
>> mentioned. We are posting patches here when they are ready for mainline
>> review.
>>
>> Regards,
>> Robert (for commercial help, please contact me by email)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
