Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:46138 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965046Ab0BZPdK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 10:33:10 -0500
Date: Fri, 26 Feb 2010 09:33:09 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Dean <red1@linuxstation.net>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: OnAir USB HDTV Creator
In-Reply-To: <4B8781BE.1090601@linuxstation.net>
Message-ID: <alpine.DEB.1.10.1002260925440.12683@cnc.isely.net>
References: <4B8781BE.1090601@linuxstation.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 26 Feb 2010, Dean wrote:

> I am trying to use an 'OnAir USB HDTV Creator' (from autumnwave.com).  According to
> http://www.linuxtv.org/wiki/index.php/OnAir_USB_HDTV_Creator
> This device is supported, however it's not working for me.  Following the instructions at above link, I tried this:
> modprobe pvrusb2 initusbreset=0
> 
> The result:
> FATAL: Error inserting pvrusb2 (/lib/modules/2.6.31.12-desktop586-1mnb/kernel/drivers/media/video/pvrusb2/pvrusb2.ko.gz): Unknown symbol in module, or unknown parameter (see dmesg)

Dean:

The initusbreset module option no longer exists.  That's why your 
modprobe command is failing.  That feature was removed from the driver, 
due to a change in USB stack behavior that started with the 2.6.27 
kernel.  (The resolution hinted at in the wiki page was in fact just 
removal of the feature.)

So you need to not use "initusbreset=0".  The advice in the wiki is over 
a year out of date.

  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
