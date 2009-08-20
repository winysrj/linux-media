Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:48648 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZHTKV5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 06:21:57 -0400
Received: by iwn42 with SMTP id 42so351229iwn.33
        for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 03:21:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250761934.6730.2.camel@McM>
References: <1250679685.14727.14.camel@McM>
	 <829197380908190642sfabee2ahe599dda1df39678c@mail.gmail.com>
	 <1250701340.14727.28.camel@McM>
	 <829197380908191016n8d7f21eq88ebe3a45816275b@mail.gmail.com>
	 <1250761934.6730.2.camel@McM>
Date: Thu, 20 Aug 2009 06:16:12 -0400
Message-ID: <829197380908200316q6fadadbewff2bc3c9a512857b@mail.gmail.com>
Subject: Re: USB Wintv HVR-900 Hauppauge
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Miguel <mcm@moviquity.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 20, 2009 at 5:52 AM, Miguel<mcm@moviquity.com> wrote:
> hi again Devin,
>
> In this case, the guide :
> http://www.linuxtv.org/wiki/index.php/Trident_TM6000#TM6000_based_Devices
> should be work ?
>
> I get some errors applying the patch:
>
> mcm@McM:~/opt/hvr900/v4l-dvb$ patch -p1 < tm6000-makefile-dvb-tree.patch
> patching file linux/drivers/media/video/Kconfig
> Hunk #1 succeeded at 914 with fuzz 2 (offset 218 lines).
> patching file linux/drivers/media/video/Makefile
> Hunk #1 FAILED at 67.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/video/Makefile.rej
>
> could it be my problem here?

No, that guide will not work for your device.  The HVR-900H uses the
TM6010, not the TM6000, and as the Wiki states, the driver is
completely broken:

http://www.linuxtv.org/wiki/index.php/Trident_TM6000#TM6010_based_Devices

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
