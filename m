Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:60502 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbZCVVWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 17:22:43 -0400
Subject: Re: [linux-dvb] dvb_shutdown_timeout
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <20090322200241.6ad1f734@bk.ru>
References: <20090322200241.6ad1f734@bk.ru>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 22:14:03 +0100
Message-Id: <1237756443.7311.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Goga,

Am Sonntag, den 22.03.2009, 20:02 +0300 schrieb Goga777:
> Hi
> 
> does the option dvb_shutdown_timeout =0 work correctly on current v4l-dvb ?
> Seems to me it was broken early
> 
> Goga
> 

on the saa7134 driver it works correctly with the exception of that one
Medion Quad md8800 DVB-S frontend which is always at 18Volts until the
driver is unloaded.

Timeout = 0 should be the default currently and all other settings like

echo 8 > /sys/module/dvb_core/parameters/dvb_shutdown_timeout

come through. The hg v4l-dvb is a few weeks old on that machine, but I
also can test on latest if you see it there.

Cheers,
Hermann




