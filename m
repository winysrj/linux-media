Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:56202 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbZKBNhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 08:37:17 -0500
Received: by ewy28 with SMTP id 28so4821707ewy.18
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2009 05:37:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b3a495710911020528oe1df259yad30f3fb5f7868b4@mail.gmail.com>
References: <b3a495710911020528oe1df259yad30f3fb5f7868b4@mail.gmail.com>
Date: Mon, 2 Nov 2009 08:37:20 -0500
Message-ID: <829197380911020537jd400aacme8d649ddc8dd2e34@mail.gmail.com>
Subject: Re: 1164:1f08 YUAN High-Tech STK7700PH kernel crash in Ubuntu 9.10
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Patrick Byrne <pjlbyrne@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 2, 2009 at 8:28 AM, Patrick Byrne <pjlbyrne@gmail.com> wrote:
> Hi,
>
> I have an Aopen MP45-DR mini-pc. I am trying to get a DVB-T card
> working in it. The DVB card is a Mini-PCI express card. It fits on a
> minicard slot inside the pc.
>
> I can activate the 'Firmware for DVB cards' in the Hardware Drivers applet:
<snip>

This was fixed quite some time ago in the v4l-dvb trunk and the Ubuntu
maintainers just haven't backported the fix into their tree.  It's
being tracked here:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/429662

So you can install the latest v4l-dvb tree via the instructions at
http://linuxtv.org/repo or you can complain to your distribution
maintainers to backport the fix.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
