Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37263 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbcB0QK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 11:10:57 -0500
Received: by mail-wm0-f54.google.com with SMTP id g62so104833044wme.0
        for <linux-media@vger.kernel.org>; Sat, 27 Feb 2016 08:10:57 -0800 (PST)
Subject: Re: Problem since commit c73bbaa4ec3e [rc-core: don't lock device at
 rc_register_device()]
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <56D19314.3050409@gmail.com>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <56D1CA81.10802@gmail.com>
Date: Sat, 27 Feb 2016 17:10:41 +0100
MIME-Version: 1.0
In-Reply-To: <56D19314.3050409@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.02.2016 um 13:14 schrieb Heiner Kallweit:
> Since this commit I see the following error when the Nuvoton RC driver is loaded:
> 
> input: failed to attach handler kbd to device input3, error: -22
> 
> Error 22 (EINVAL) comes from the new check in rc_open().
> 

Complete call chain seems to be:
  rc_register_device
  input_register_device
  input_attach_handler
  kbd_connect
  input_open_device
  ir_open
  rc_open

rc_register_device calls input_register_device before dev->initialized = true,
therefore the new check in rc_open fails. At a first glance I'd say that we have
to remove this check from rc_open.

Regards, Heiner

