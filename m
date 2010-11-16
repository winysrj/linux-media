Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47407 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab0KPJhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 04:37:40 -0500
Received: by fxm6 with SMTP id 6so287835fxm.19
        for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 01:37:39 -0800 (PST)
Date: Tue, 16 Nov 2010 10:37:31 +0100
From: Davor Emard <davoremard@gmail.com>
To: Okkel Klaver <vbroek@iae.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: af9015 and nxp tda182128 support
Message-ID: <20101116093731.GA21367@lipa.lan>
References: <4CE16387.3040103@iae.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE16387.3040103@iae.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Nov 15, 2010 at 05:44:55PM +0100, Okkel Klaver wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> Hello everybody,
> 
> 
> I own a brandless hdtv usb dvb-t stick.
> 
> lsusb identifies it as:
> Bus 001 Device 005: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T
> USB2.0 stick

few days ago I submeitted
[PATCH] terratec cinergy t-stick RC (with TDA18218)
that applies to latest normal (not new) v4l tree
Just add your usb id as terratec cinergy t-stick RC,
make install and try it. it might work

best regards, Emard
