Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41669 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaG1VQF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 17:16:05 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so5075880wiv.13
        for <linux-media@vger.kernel.org>; Mon, 28 Jul 2014 14:16:03 -0700 (PDT)
Message-ID: <53D6BD8E.7000903@gmail.com>
Date: Mon, 28 Jul 2014 14:15:58 -0700
From: Steve Longerbeam <slongerbeam@gmail.com>
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: i.MX6 status for IPU/VPU/GPU
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com> <20140728185949.GS13730@pengutronix.de>
In-Reply-To: <20140728185949.GS13730@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2014 11:59 AM, Robert Schwebel wrote:
> Hi,
>
> On Mon, Jul 28, 2014 at 06:24:45PM +0200, Jean-Michel Hautbois wrote:
>> We have a custom board, based on i.MX6 SoC.
>> We are currently using Freescale's release of Linux, but this is a
>> 3.10.17 kernel, and several drivers are lacking (adv7611 for instance)
>> or badly written (all the MXC part).
>> As we want to have nice things :) we would like to use a mainline
>> kernel, or at least a tree which can be mainlined.
>>
>> It seems (#v4l told me so) that some people (Steeve :) ?) are working
>> on a rewriting of the IPU and all DRM part for i.MX6.
>> What is the current status (compared to Freescale's release maybe) ?
>> And what can we expect in a near future? Maybe, how can we help too ?

Hi Jean-Michel,

I did post a v4l2 video capture driver for i.MX6 to linux-media.
The main complaint from Philip at Pengutronix is that it does not
support the media device framework.

The customer I am currently working for has no real interest in the
media controller API, and the driver I posted has all the features they
require, so any work I do to add that support to the driver would have
to be in my spare time, and I don't have much. If our customer were to
request and fund media control support, that would be ideal, but as it is
I can only spend limited time on it. So if you are interested in helping
out in the media device effort I can send what I have so far.

I have not provided any patches to i.MX6 DRM/KMS drivers. We have
developed new features (overlay plane global/local alpha, hardware gamma
correction, color-keying, and others) for for that component but haven't
posted them yet.

Steve

> Pengutronix is continuously working on mainlining more parts of the
> i.MX6 video and graphics subsystem, including the components you have
> mentioned. We are posting patches here when they are ready for mainline
> review.
>
> Regards,
> Robert (for commercial help, please contact me by email)

