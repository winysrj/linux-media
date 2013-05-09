Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57658 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3EIQMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 12:12:24 -0400
Received: by mail-ee0-f50.google.com with SMTP id c41so1643578eek.23
        for <linux-media@vger.kernel.org>; Thu, 09 May 2013 09:12:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518BBAE4.4010507@libertysurf.fr>
References: <20130509144422.420FC8FF9BB@zimbra65-e11.priv.proxad.net>
	<518BBAE4.4010507@libertysurf.fr>
Date: Thu, 9 May 2013 12:12:23 -0400
Message-ID: <CADnq5_ODkgRUVc72w01L2BHGcp3OKTpENnKaL24PPdg96SYZpQ@mail.gmail.com>
Subject: Re: HD-Audio Generic HDMI/DP on wheezy
From: Alex Deucher <alexdeucher@gmail.com>
To: pdurand13@libertysurf.fr
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 9, 2013 at 11:04 AM, pierre <pdurand13@libertysurf.fr> wrote:
> Hi,
>
> Some difficult on wheezy, on my computer
> product: Inspiron 620
> vendor: Dell Inc.
> version: 00
> serial: D9V135J
> width: 64 bits
>
> My sound card is now defined as Caicos HDMI Audio [Radeon HD 6400 Series]
> Digital Stereo (HDMI) on Squeeze, it was HD-Audio Generic Digital Stereo
> (HDMI).
> It works but i'm not able to get analogic output, only HDMI / display port
> that i can't use.

You need to enable the audio parameter in the radeon driver.  Boot with:
radeon.audio=1
on the kernel command line in grub.

Alex
