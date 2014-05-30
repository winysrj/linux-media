Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47892 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbaE3PI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 11:08:59 -0400
Received: by mail-ie0-f170.google.com with SMTP id to1so631209ieb.15
        for <linux-media@vger.kernel.org>; Fri, 30 May 2014 08:08:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140530134730.GH2073@valkosipuli.retiisi.org.uk>
References: <CAHqFTYrnru=b9MhuzRHbY8hk8Y149N2nb3Oj2e8p3cc9NP9bJw@mail.gmail.com>
	<20140530130446.GG2073@valkosipuli.retiisi.org.uk>
	<CAHqFTYoQ3NuC6T52nGrNqtVsUiSqmM1KCeGAuu4_WhMGCV1joA@mail.gmail.com>
	<20140530134730.GH2073@valkosipuli.retiisi.org.uk>
Date: Fri, 30 May 2014 17:08:59 +0200
Message-ID: <CAHqFTYoypVCGfXLTmf+yZd=2zgGftPS+RU_rfpa3tjsr-TMsNw@mail.gmail.com>
Subject: Re: v4l2_device_register_subdev_nodes() clean_up code
From: Krzysztof Czarnowski <khczarnowski@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> One additional thing: I think sd->devnode should also be set as NULL since
> sub-devices are no longer created by the driver owning the media device.

Yes, I think you're right.

But there are also other issues with
v4l2_device_register_subdev_nodes(). I think after checking
V4L2_SUBDEV_FL_HAS_DEVNODE flag yet another check like so:

if (sd->devnode)
    continue;  /* or perhaps raising error, TBD */

would be reasonable. Maybe this is not necessary, I don't know, but
this is cheap and would prevent bad things when a duplicate
/dev/v4l-subdev node is created for the same subdevice and track is
lost of the old one.

Actually, I'm trying to make use of v4l2_async_register_subdev()
protocol and v4l2_device_register_subdev_nodes() doesn't seem to fit
well. Something like v4l2_device_register_subdev_node() (singular)
would be nice. But this is probably an idea that's been already
raised. Anyway in async scenarios I can imagine that nodes
registration is called twice and it should be made somehow taken care
of. Regardles that a single subdev node registration is probably
required for such use cases and it's quite easy to implement.

Anyway, I'll prepare a bug fix patch and maybe another as an
improvement suggestion.
Any comments welcome,
Krzysztof



On Fri, May 30, 2014 at 3:47 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Fri, May 30, 2014 at 03:27:27PM +0200, Krzysztof Czarnowski wrote:
>> Sure, a moment :-)
>
> One additional thing: I think sd->devnode should also be set as NULL since
> sub-devices are no longer created by the driver owning the media device.
>
> This isn't done in the error path or in v4l2_device_unregister_subdev()
> currently.
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
