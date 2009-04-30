Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:57773 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZD3JyP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 05:54:15 -0400
Date: Thu, 30 Apr 2009 11:54:42 +0200
From: Janne Grunau <j@jannau.net>
To: Samuel Rodelius <samuel@rodelius.se>
Cc: devin.heitmueller@gmail.com, linux-media@vger.kernel.org
Subject: Re: Re: Haupauge Nova-T 500 2.6.28 regression dib0700
Message-ID: <20090430095442.GD8112@aniel.lan>
References: <e65ef5fb0904300019q6d13ff58wa8e2ad0cf2c27a98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e65ef5fb0904300019q6d13ff58wa8e2ad0cf2c27a98@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 30, 2009 at 09:19:17AM +0200, Samuel Rodelius wrote:
> 
> I experience the same problem as Janne with the following reported in the
> /var/log/syslog:
> Apr 30 09:07:02 homer kernel: [   86.068011] ehci_hcd 0000:01:06.2: force
> halt; handhake ffffc2000003c014 00004000 00000000 -> -110
> 
> I was wondering if you have found any workaround or if there is any bugfix
> submitted in a later kernel-version (I'am running 2.6.28.11)?
> 
> The problem started when I updated the kernel-version from 2.6.27-11 (Ubuntu
> Intrepid to Jaunty upgrade).

I've not really investigated due to lack of time and another problem in
2.6.29 (The computer doesn't reliable shut down). A possible workaround
is to disable rc polling but since you seems to use the remote you
probably don't like this (disable_rc_polling=1 module option for dvb-usb).

> For me the device is working when I have just booted but after a minute of
> inactivity it seems to receive the above error. The device is a PCI-TV-card
> where the USB-device is internal on the PCI-card so it is a bit hard to
> unplug the device, connecting and unconnecting the cable to the IR-eye or
> the TV-aerial will not make any difference.
> 
> Let me know if I can help in any other ways to resolve this problem

Janne
