Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43044 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab0CaFLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 01:11:48 -0400
Received: by bwz1 with SMTP id 1so4897852bwz.21
        for <linux-media@vger.kernel.org>; Tue, 30 Mar 2010 22:11:46 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fernando@develcuy.com
Date: Wed, 31 Mar 2010 01:11:46 -0400
Message-ID: <k2p5ba75e2f1003302211w2a7f4e0cy3fac5da36acc649@mail.gmail.com>
Subject: Re: GIGABYTE U8000-RH Analog source support ?
From: =?UTF-8?Q?Fernando_P=2E_Garc=C3=ADa?=
	<fernandoparedesgarcia@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

May you elaborate about the "huge undertaking"

Fernando.

>
> 2010/3/3 RoboSK <ucet.na.disku...@gmail.com>:
> > Hi, i find this page *1 with last change from "3 May 2009" with text "no
> > driver written for the CX25843-24Z" and then this *2 from "27 September
> > 2009" with text "CX2584x chips are fully supported by Linux..." = have linux
> > (now/future) support for Analog source with this USB stick ?
> >
> > thanks
> >
> > Robo
>
> The wiki page is just wrong.  The reason that board is not supported
> is not because of the cx25843.  It's because the dib0700 bridge falls
> under the dvb-usb framework, and the framework doesn't have analog
> support at all.
>
> Adding such support would be a huge undertaking, but if it were done a
> whole bunch of products would start getting analog support (all of the
> dib0700 products which also have analog onboard).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
