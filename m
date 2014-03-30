Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:51530 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaC3Qtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:49:50 -0400
Received: by mail-qc0-f177.google.com with SMTP id w7so7844879qcr.8
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 09:49:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALW6vT5P-Q-GHyRz7YGxyjx-RdVzhNVJA++mG1A1NbV_DGT8Mw@mail.gmail.com>
References: <CALW6vT5P-Q-GHyRz7YGxyjx-RdVzhNVJA++mG1A1NbV_DGT8Mw@mail.gmail.com>
Date: Sun, 30 Mar 2014 12:49:49 -0400
Message-ID: <CAGoCfiz4whMp4hGiFCqE3++Z1Nmj2P=4wywQKQjeL+qgz67nag@mail.gmail.com>
Subject: Re: No channels on Hauppauge 950Q
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Sunset Machine <sunsetmachine7@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 30, 2014 at 12:25 PM, Sunset Machine
<sunsetmachine7@gmail.com> wrote:
> Today is March 30, 2014
>
> The 950Q is a USB TV Stick. The driver loads, the firmware loads.
> Various software sees the device but none of them find any channels. I
> use an antenna for over-the-air HD television in the US. The device
> works on Windows but not Linux (Debian 7.3, Squeeze).

What kernel version are you using?  What applications have you tested
with?  If you have a relatively recent version of the HVR-950q stick
with a kernel older than 3.7, then you are likely to have issues with
not having some required driver updates for the new tuner chip inside
the unit.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
