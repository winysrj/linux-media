Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:64045 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0CCRCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 12:02:54 -0500
Received: by fxm19 with SMTP id 19so1754383fxm.21
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 09:02:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8E959E.6010400@gmail.com>
References: <4B8E959E.6010400@gmail.com>
Date: Wed, 3 Mar 2010 12:02:53 -0500
Message-ID: <829197381003030902xe91cc66r64246a9bb2d3ffd5@mail.gmail.com>
Subject: Re: GIGABYTE U8000-RH Analog source support ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: RoboSK <ucet.na.diskusie@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/3/3 RoboSK <ucet.na.diskusie@gmail.com>:
> Hi, i find this page *1 with last change from "3 May 2009" with text "no
> driver written for the CX25843-24Z" and then this *2 from "27 September
> 2009" with text "CX2584x chips are fully supported by Linux..." = have linux
> (now/future) support for Analog source with this USB stick ?
>
> thanks
>
> Robo

The wiki page is just wrong.  The reason that board is not supported
is not because of the cx25843.  It's because the dib0700 bridge falls
under the dvb-usb framework, and the framework doesn't have analog
support at all.

Adding such support would be a huge undertaking, but if it were done a
whole bunch of products would start getting analog support (all of the
dib0700 products which also have analog onboard).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
