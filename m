Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56371 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZLZVVZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2009 16:21:25 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NOe4h-0003k1-0K
	for linux-media@vger.kernel.org; Sat, 26 Dec 2009 22:21:23 +0100
Received: from cpc4-dals10-0-0-cust795.hari.cable.virginmedia.com ([92.234.3.28])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 26 Dec 2009 22:21:22 +0100
Received: from mariofutire by cpc4-dals10-0-0-cust795.hari.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 26 Dec 2009 22:21:22 +0100
To: linux-media@vger.kernel.org
From: Andrea <mariofutire@googlemail.com>
Subject: Re: Error using PWC on a PS3
Date: Sat, 26 Dec 2009 21:20:59 +0000
Message-ID: <hh5unq$m02$1@ger.gmane.org>
References: <hh5u7f$km0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <hh5u7f$km0$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/12/09 21:12, Andrea wrote:
> Hi,
> 
> I've tried to attach my Logitech, Inc. QuickCam Pro 4000 to a PS3 running Fedora 12.
> 
> I get this error in dmesg
> 
> pwc: Failed to set video mode QSIF@10 fps; return code = -110
> 
> Everything works well on a standard x86 laptop running Fedora 11.
> 
> Anybody has an idea why a different architecture could affect pwc?
> I don't know, problems with little/big endian?
> 

This is what I see in dmesg

Dec 26 21:14:52 localhost kernel: Linux video capture interface: v2.00
Dec 26 21:14:52 localhost kernel: pwc: Philips webcam module version 10.0.13 loaded.
Dec 26 21:14:52 localhost kernel: pwc: Supports Philips PCA645/646, PCVC675/680/690,
PCVC720[40]/730/740/750 & PCVC830/840.
Dec 26 21:14:52 localhost kernel: pwc: Also supports the Askey VC010, various Logitech Quickcams,
Samsung MPC-C10 and MPC-C30,
Dec 26 21:14:52 localhost kernel: pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite
VCS-UC300 and VCS-UM100.
Dec 26 21:14:52 localhost kernel: pwc: Logitech QuickCam 4000 Pro USB webcam detected.
Dec 26 21:14:52 localhost kernel: pwc: Registered as /dev/video0.
Dec 26 21:14:53 localhost kernel: input: PWC snapshot button as
/devices/ps3_system/sb_05/usb1/1-2/1-2.1/input/input4
Dec 26 21:14:53 localhost kernel: usbcore: registered new interface driver Philips webcam
Dec 26 21:14:54 localhost kernel: pwc: Failed to set video mode QSIF@10 fps; return code = -110
Dec 26 21:14:55 localhost kernel: pwc: Failed to set video mode QSIF@10 fps; return code = -110
Dec 26 21:14:57 localhost kernel: pwc: Failed to set video mode QSIF@10 fps; return code = -110
Dec 26 21:14:58 localhost kernel: pwc: Failed to set video mode QSIF@10 fps; return code = -110


