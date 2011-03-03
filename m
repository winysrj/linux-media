Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34237 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab1CCQHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 11:07:38 -0500
Received: by eyx24 with SMTP id 24so399970eyx.19
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2011 08:07:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299168093.2864.14.camel@ares>
References: <1299168093.2864.14.camel@ares>
Date: Thu, 3 Mar 2011 11:07:35 -0500
Message-ID: <AANLkTikkz74O96-CPZXOGiXFhcck6dXge8NRknxXTfQy@mail.gmail.com>
Subject: Re: em28xx: dvb lock bug on re-plug of device?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Kerrison <steve@stevekerrison.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 3, 2011 at 11:01 AM, Steve Kerrison <steve@stevekerrison.com> wrote:
> Hi all,
>
> I wonder if Devin/Mauro could help me with something as I've run into a
> problem developing a driver for the PCTV 290e?
>
> First plug of the device works fine, em28xx and em28xx_dvb are loaded.
> However, if I disconnect and then re-plug the device, the em28xx_dvb
> module will hang in dvb_init() where it performs mutex_lock(&dev->lock);

Hi Steve,

I saw this too and brought it to Mauro's attention some months ago
(because I believed strongly it was related to locking changes).  It
looks like he never did anything to address it though (and I've been
working on other bridges so haven't had any time to dig into it).

So, for what it's worth, I can confirm the problem that you are experiencing.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
