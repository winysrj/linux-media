Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:42513 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbZJLXEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 19:04:51 -0400
Received: by bwz6 with SMTP id 6so3498189bwz.37
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 16:04:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD3AE34.6020305@iki.fi>
References: <829197380910121512y62a90cdcs49a0aa9606e8a588@mail.gmail.com>
	 <4AD3AE34.6020305@iki.fi>
Date: Mon, 12 Oct 2009 19:04:12 -0400
Message-ID: <829197380910121604w6a9c5b22i26a892ff79aaf691@mail.gmail.com>
Subject: Re: em28xx mode switching
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 6:31 PM, Antti Palosaari <crope@iki.fi> wrote:
> I ran this same trap few weeks ago when adding Reddo DVB-C USB Box support
> to em28xx :) Anyhow, since it is dvb only device I decided to switch from
> .dvb_gpio to .tuner_gpio to fix the problem. I haven't pull requested it
> yet.
> http://linuxtv.org/hg/~anttip/reddo-dvb-c/rev/38f946af568f
>
> Antti
> --
> http://palosaari.fi/

You were able to get by with using tuner_gpio instead of dvb_gpio
because the Reddo isn't a hybrid device.

I'm going to propose removing the calls to em28xx_set_mode() in
start_streaming() and stop_streaming().  Given the supported boards
that are there, I can regression test:

EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850
EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950
EM2880_BOARD_PINNACLE_PCTV_HD_PRO
EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600
EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900
EM2880_BOARD_TERRATEC_HYBRID_XS

and I cannot regression test:

EM2880_BOARD_KWORLD_DVB_310U (I have a strong suspicion this board is
currently broken anyway)
EM2882_BOARD_TERRATEC_HYBRID_XS (I worked with the authors of this one
and can probably get them to test)
EM2882_BOARD_EVGA_INDTUBE (I worked with the authors of this one and
can probably get them to test)
EM2880_BOARD_EMPIRE_DUAL_TV (I worked with the authors of this one and
can probably get them to test)
EM2881_BOARD_PINNACLE_HYBRID_PRO (this is the board I noticed the problem under)
EM2883_BOARD_KWORLD_HYBRID_330U
EM2870_BOARD_REDDO_DVB_C_USB_BOX

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
