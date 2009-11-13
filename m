Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:49466 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbZKMQpC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 11:45:02 -0500
Received: by yxe17 with SMTP id 17so3072710yxe.33
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 08:45:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AFD8B9A.7000309@hoogenraad.net>
References: <20091112173130.GV31295@www.viadmin.org>
	 <20091113160850.GY31295@www.viadmin.org>
	 <4AFD8B9A.7000309@hoogenraad.net>
Date: Fri, 13 Nov 2009 11:45:07 -0500
Message-ID: <829197380911130845y7a18ca25k266159c3af031a3e@mail.gmail.com>
Subject: Re: [linux-dvb] Organizing ALL device data in linuxtv wiki
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 13, 2009 at 11:38 AM, Jan Hoogenraad
<jan-conceptronic@hoogenraad.net> wrote:
> Would it be possible to store this information in the CODE archives, and
> extract it from there ?
> Right now, I end up putting essentially the same information into structures
> in the driver and into documentation.
> This is hard to keep synchronised.
>
> Basic information like device IDs, vendors, demod types, tuners, etc is
> already in place in the driver codes.
>
> Getting data from the hg archives (including development branches) sounds
> like a cleaner solution.

The challenge you run into there is that every driver organizes its
table of products differently, and the driver source code does not
expose what features the device supports in any easily easily parsed
manner.  Also, it does not indicate what the hardware supports which
is not supported by the Linux driver.

So for example, you can have a hybrid USB device that supports
ATSC/QAM and analog NTSC.  The driver won't really tell you these
things, nor will it tell you that the hardware also supports IR but
the Linux driver does not.

It's one of those ideas that sounds reasonable until you look at how
the actual code defines devices.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
