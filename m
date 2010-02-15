Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37290 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab0BOWV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 17:21:56 -0500
Received: by fxm7 with SMTP id 7so6371216fxm.28
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 14:21:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <310bfb251002151257x7121b20cme3cbe5096decea4b@mail.gmail.com>
References: <310bfb251002151257x7121b20cme3cbe5096decea4b@mail.gmail.com>
Date: Mon, 15 Feb 2010 17:21:54 -0500
Message-ID: <a728f9f91002151421y6d2c0d2fgfc715517bf1d56e8@mail.gmail.com>
Subject: Re: ATI TV Wonder 650 PCI development
From: Alex Deucher <alexdeucher@gmail.com>
To: Samuel Cantrell <samuelcantrell@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 15, 2010 at 3:57 PM, Samuel Cantrell
<samuelcantrell@gmail.com> wrote:
> Hello,
>
> I have an ATI TV Wonder 650 PCI card, and have started to work on the
> wiki page on LinuxTV.org regarding it. I want to *attempt* to write a
> driver for it (more like, take a look at the code and run), and have
> printed off some information on the wiki. I need to get pictures up of
> the card and lspci output, etc.
>
> Is there anyone else more experienced at writing drivers that could
> perhaps help?
>
> http: // www.linuxtv.org / pipermail / linux-dvb / 2007-October /
> 021228.html says that three pieces of documentation are missing. I've
> emailed Samsung regarding the tuner module on the card, as I could not
> find it on their website. I checked some of their affiliates as well,
> but still had no luck. I've emailed AMD/ATI regarding the card and
> technical documentation.
>

Who did you contact?   gpudriverdevsupport AT amd DOT com is the devel
address you probably want.  I looked into documentation for the newer
theatre chips when I started at AMD, but unfortunately, I'm not sure
how much we can release since we sold most of our multimedia IP to
Marvell last year.  I'm not sure what the status of the theatre chips
is now.

Documentation for the older theatre and theatre 200 asics was released
under NDA years ago which resulted in the theatre support in the
opensource radeon Xorg driver and gatos projects.  Now that we a
proper KMS driver for radeon, someone could port the old userspace
theatre code to the kernel for proper v4l support on AIW radeon cards.

Alex

> Is it likely that that the tuner module has an XC3028 in it? In the
> same linux-dvb message thread noted above, someone speculated that
> there is a XC3028. As the v4l tree has XC3028 support, if this is
> true, wouldn't that help at least a little bit?
>
> Thanks.
>
> Sam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
