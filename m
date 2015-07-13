Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33129 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbbGMM5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 08:57:32 -0400
Received: by lbbyj8 with SMTP id yj8so39374421lbb.0
        for <linux-media@vger.kernel.org>; Mon, 13 Jul 2015 05:57:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <03c101d0739c$71eeeb40$55ccc1c0$%debski@samsung.com>
References: <1426607290-13380-1-git-send-email-p.zabel@pengutronix.de>
	<03c101d0739c$71eeeb40$55ccc1c0$%debski@samsung.com>
Date: Mon, 13 Jul 2015 09:57:31 -0300
Message-ID: <CAOMZO5Do770FtGTTh-hwvpy4qCJAem21yzw+X0x++WsZVBq_=g@mail.gmail.com>
Subject: Re: [PATCH 0/5] i.MX5/6 mem2mem scaler
From: Fabio Estevam <festevam@gmail.com>
To: Kamil Debski <k.debski@samsung.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Fri, Apr 10, 2015 at 11:41 AM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi,
>
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Philipp Zabel
> Sent: Tuesday, March 17, 2015 4:48 PM
>>
>> Hi,
>>
>> this series uses the IPU IC post-processing task, to implement a
>> mem2mem device for scaling and colorspace conversion.
>
> This patchset makes changes in two subsystems - media and gpu.
> It would be good to merge these patchset through a single subsystem.
>
> The media part of this patchset is good, are there any comments to
> the gpu part of this patchset?
>
> I talked with Mauro on the IRC and he acked that this patchset could be
> merged via the gpu subsystem.

Do you plan to resend this series?

It is still not applied.

Regards,

Fabio Estevam
