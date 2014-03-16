Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61325 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaCPIWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 04:22:03 -0400
Received: by mail-qa0-f47.google.com with SMTP id w5so4210572qac.34
        for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 01:22:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
Date: Sun, 16 Mar 2014 10:22:02 +0200
Message-ID: <CAKv9HNav3DYRcX8B_N5db012-ShoGVc7rbLW1oWV-rgcwDaGmg@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] rc: Add IR encode based wakeup filtering
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 March 2014 01:04, James Hogan <james@albanarts.com> wrote:
> A recent discussion about proposed interfaces for setting up the
> hardware wakeup filter lead to the conclusion that it could help to have
> the generic capability to encode and modulate scancodes into raw IR
> events so that drivers for hardware with a low level wake filter (on the
> level of pulse/space durations) can still easily implement the higher
> level scancode interface that is proposed.
>
> I posted an RFC patchset showing how this could work, and Antti Seppälä
> posted additional patches to support rc5-sz and nuvoton-cir. This
> patchset improves the original RFC patches and combines & updates
> Antti's patches.
>
> I'm happy these patches are a good start at tackling the problem, as
> long as Antti is happy with them and they work for him of course.
>
> Future work could include:
>  - Encoders for more protocols.
>  - Carrier signal events (no use unless a driver makes use of it).
>
> Patch 1 adds the new encode API.
> Patches 2-3 adds some modulation helpers.
> Patches 4-6 adds some raw encode implementations.
> Patch 7 adds some rc-core support for encode based wakeup filtering.
> Patch 8 adds debug loopback of encoded scancode when filter set.
> Patch 9 (untested) adds encode based wakeup filtering to nuvoton-cir.
>

Hi James.

This is looking very good. I've reviewed the series and have only
minor comments to some of the patches which I'll post individually
shortly.

I've also tested the nuvoton with actual hardware with rc-5-sz and nec
encoders and both generate wakeup samples correctly and can wake the
system.

While doing my tests I also noticed that there is a small bug in the
wakeup_protocols handling where one can enable multiple protocols with
the + -notation. E.g. echo "+nec +rc-5" >
/sys/class/rc/rc0/wakeup_protocols shouldn't probably succeed.

-Antti
