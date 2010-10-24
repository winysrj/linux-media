Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63827 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab0JXSzf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 14:55:35 -0400
Received: by wyf28 with SMTP id 28so2616933wyf.19
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 11:55:34 -0700 (PDT)
From: Albin Kauffmann <albin.kauffmann@gmail.com>
To: Sasha Sirotkin <demiurg@femtolinux.com>
Subject: Re: Wintv-HVR-1120 woes
Date: Sun, 24 Oct 2010 20:55:30 +0200
Cc: linux-media@vger.kernel.org
References: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com>
In-Reply-To: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010242055.30799.albin.kauffmann@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 21 October 2010 23:25:29 Sasha Sirotkin wrote:
> I'm having all sorts of troubles with Wintv-HVR-1120 on Ubuntu 10.10
> (kernel 2.6.35-22). Judging from what I've seen on the net, including
> this mailing list, I'm not the only one not being able to use this
> card and no solution seem to exist.
> 
> Problems:
> 1. The driver yells various cryptic error messages
> ("tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1,
> i2c_transfer returned: -5", "tda18271_set_analog_params: [1-0060|M]
> error -5 on line 1045", etc)

yes, indeed :(
(cf "Hauppauge WinTV-HVR-1120 on Unbuntu 10.04" thread)

> 2. DVB-T scan (using w_scan) produces no results

Is this happening after each reboot? As far as I'm concerned, I've never had 
problems with DVB-T scans.

> 3. Analog seems to work, but with very poor quality

I just tried to use Analog TV in order to confirm the problem but I cannot get 
any picture. Maybe I just don't know how to use it. I'm using commands like 
(I'm located in France):

mplayer tv:// -tv driver=v4l2:norm=SECAM:chanlist=france -tvscan autostart

... and just get some "snow" on scanned channels.
As I might have a problem with my antenna (an interior one), I am going to 
test it under Windows and report back my experience.

Cheers,

-- 
Albin Kauffmann
