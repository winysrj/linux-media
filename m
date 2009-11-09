Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:40937 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZKIQnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 11:43:47 -0500
Received: by gv-out-0910.google.com with SMTP id r4so253029gve.37
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 08:43:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
Date: Mon, 9 Nov 2009 11:43:51 -0500
Message-ID: <829197380911090843kb4eb80ducb0acbb7886db170@mail.gmail.com>
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Valerio,

On Mon, Nov 9, 2009 at 6:13 AM, Valerio Bontempi
<valerio.bontempi@gmail.com> wrote:
> Hi all,
>
> I have a problem trying to user Terratec Cinergy T XS (usb dvb only
> adapter) with XC3028 tuner:
> v4l dvb driver installed in last kernel versions (actually I am using
> 2.6.31 from ubuntu 9.10) detects this device but then looks for the
> wrong firmware xc3028-v27.fw, and, moreover, seems to not contain
> correct device firmware at all.

xc3028-v27.fw is the correct firmware for that device.  Why do you
think otherwise?

> This makes the device to be detected but dvb device /dev/dvb is not
> created by the kernel.
>
> Is there a way to make this device to work with last kernel versions
> and last v4l-dvb driver versions?

The device is supported in the latest v4l-dvb, although there is an
outstanding bug related to multiple tuning requests made within the
same frontend open() call.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
