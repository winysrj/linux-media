Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:57018 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZJTHmn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 03:42:43 -0400
Date: Tue, 20 Oct 2009 09:42:39 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Matteo Miraz <telegraph.road@gmail.com>
cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: pctv nanoStick Solo not recognized
In-Reply-To: <51bd605b0910191534x48973759g721f4ee79b692059@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0910200938140.3543@pub2.ifh.de>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>  <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>  <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>  <829197380910191341p484e070ftd190143f73b1d10e@mail.gmail.com>
  <51bd605b0910191451x22287c5ai3f829f2af0243879@mail.gmail.com>  <829197380910191456g5c53f37bh82ae6d7359ae5d2e@mail.gmail.com> <51bd605b0910191534x48973759g721f4ee79b692059@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matteo,

Sorry for being quite in the first place.

On Tue, 20 Oct 2009, Matteo Miraz wrote:

> Devin,
>
> it worked.
>
> I added the new vendor, and changed the other entry. I'm wondering if
> exists a "pinnacle" pctv 73e se usb device...
>
> attached to this mail there is the (easy) patch.

This patch is in fact the right way to do things.

Acked-by:  Patrick Boettcher <pboettcher@kernellabs.com>

While you are at it, can you please also changed the vendor ID for 
the PCTV282E-device to PCTVSYSTEMS and file a new patch?

thanks for the help,

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
