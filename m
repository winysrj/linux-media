Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60593 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab2KDH7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 02:59:52 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1864015eaa.19
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2012 00:59:49 -0700 (PDT)
From: Oleg Kravchenko <oleg@kaa.org.ua>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: Added support for AVerTV Hybrid Express Slim HC81R (only analog)
Date: Sun, 04 Nov 2012 09:59:41 +0200
Message-ID: <2065193.Q95hUZKIgW@comp>
In-Reply-To: <21a4038a-2fef-4947-ab2a-06873e80b185@email.android.com>
References: <2489713.pAFgSjBqdl@comp> <21a4038a-2fef-4947-ab2a-06873e80b185@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

субота, 03-лис-2012 16:41:10 Andy Walls написано:
> Oleg Kravchenko <oleg@kaa.org.ua> wrote:
> >Hello! Please review my patch.
> >
> >Supported inputs:
> >Television, S-Video, Component.
> >
> >Modules options:
> >options cx25840 firmware=v4l-cx23418-dig.fw
> 
> Hi,
> 
> Please do not use the CX23418 digitizer firmware with the CX2388[578] chips.
>  Use the proper cx23885 digitizer firmware.  You need the proper firmware
> to get the best results in detecting the audio standard in broadcast analog
> video.
> 
> Regards,
> Andy

Windows driver use v4l-cx23418-dig.fw
95bc688d3e7599fd5800161e9971cc55  merlinAVC.rom
95bc688d3e7599fd5800161e9971cc55  /lib/firmware/v4l-cx23418-dig.fw

So, i think this is a proper firmware :)
