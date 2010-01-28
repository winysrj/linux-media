Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41264 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab0A1OT7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 09:19:59 -0500
Received: by bwz27 with SMTP id 27so501333bwz.21
        for <linux-media@vger.kernel.org>; Thu, 28 Jan 2010 06:19:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B61990E.5010604@epfl.ch>
References: <4B60CB5A.7000109@epfl.ch> <ac3eb2511001280118s4e00dca3l905a8ed7d532bde2@mail.gmail.com>
	<4B61990E.5010604@epfl.ch>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 28 Jan 2010 15:13:50 +0100
Message-ID: <ac3eb2511001280613p698ad22fmb436650122f3a2eb@mail.gmail.com>
Subject: Re: [Q] udev and soc-camera
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 28, 2010 at 15:02, Valentin Longchamp
<valentin.longchamp@epfl.ch> wrote:
> Kay Sievers wrote:
> Thanks a lot Kay, you pointed me exactly where I needed to watch.
> OpenEmbedded adds udevadm trigger a big list of --susbsystem-nomatch options
> as soon as you are not doing your first boot anymore and video4linux is
> among them.
>
> I either have to remove this option in the script or understand why my other
> /dev nodes are kept (ttys are doing fine with the same treatment for
> instance) and not video4linux ones (it looks like they are using DEVCACHE or
> something like this). But I would prefer the first alternative since cameras
> may be unplugged on some robots.

Really, that logic sounds awfully wrong. Any /dev-caching and games
with skipping selected subsystems at coldplug can never reliably work
as you have found out. :) You should definitely go for devtmpfs
instead of such needless and misguided hacks, if a plain "udevadm
trigger" does not work for some reason.

Good luck.
Kay
