Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52349 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZLEFvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 00:51:25 -0500
Received: by fxm5 with SMTP id 5so3205024fxm.28
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 21:51:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091129153148.GA20727@localhost>
References: <20091129153148.GA20727@localhost>
Date: Sat, 5 Dec 2009 09:51:30 +0400
Message-ID: <1a297b360912042151n24d8deadwfb1b3fd6dd671ba7@mail.gmail.com>
Subject: Re: [linux-dvb] Skystar HD2 and s2-liplianin/mantis driver
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 7:31 PM, Albert Gall <ss3vdr@gmail.com> wrote:
> Hello list
>
> I try to build latest s2-liplianin drivers but make shows severals
> warnings and module not load after build driver:
>
> WARNING: "ir_input_keydown" [s2-liplianin/v4l/mantis.ko] undefined!
> WARNING: "ir_codes_mantis_vp1041_table" [s2-liplianin/v4l/mantis.ko] undefined!
> WARNING: "ir_input_nokey" [s2-liplianin/v4l/mantis.ko] undefined!
> WARNING: "ir_input_init" [s2-liplianin/v4l/mantis.ko] undefined!
> WARNING: "ir_codes_mantis_vp2040_table" [s2-liplianin/v4l/mantis.ko] undefined!
> WARNING: "ir_codes_mantis_vp2033_table" [s2-liplianin/v4l/mantis.ko] undefined!
>
> My kernel is 2.6.31.4.
> The attached is full driver build log.
>
> Any idea to fix this problem ?

Please try it from here: http://jusst.de/hg/v4l-dvb

Regards,
Manu
