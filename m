Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35715 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3EaFyN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 01:54:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1UiIHy-00085v-GQ
	for linux-media@vger.kernel.org; Fri, 31 May 2013 07:54:10 +0200
Received: from 79-134-123-90.cust.suomicom.fi ([79.134.123.90])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 31 May 2013 07:54:10 +0200
Received: from www.linuxtv.org by 79-134-123-90.cust.suomicom.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 31 May 2013 07:54:10 +0200
To: linux-media@vger.kernel.org
From: Jussi =?utf-8?b?SsOkw6Rza2Vsw6RpbmVu?=
	<www.linuxtv.org@jjussi.com>
Subject: Re: All models of Technotrend TT-connect CT-3650 are not supported
Date: Fri, 31 May 2013 05:53:52 +0000 (UTC)
Message-ID: <loom.20130531T075102-721@post.gmane.org>
References: <loom.20130530T123614-761@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jussi Jääskeläinen <www.linuxtv.org <at> jjussi.com> writes:

> Older models have: idVendor=0b48, idProduct=300d
> Model what I just bought was: idVendor=04b4, idProduct=8613 and this is not 
> supported!
> 
> usb 2-1: New USB device found, idVendor=04b4, idProduct=8613
> usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usbtest 2-1:1.0: FX2 device
> usbtest 2-1:1.0: high-speed {control bulk-in bulk-out} tests (+alt)
> 
> Both products looks just same!

Is there some program I could run what would "extract" all needed information 
to developer, so driver could be created or known driver could be connected to 
this ID?

-- JJussi



