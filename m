Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56501 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2HUWpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 18:45:34 -0400
Received: by wgbdr13 with SMTP id dr13so272668wgb.1
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 15:45:33 -0700 (PDT)
Message-ID: <50340F89.4090903@gmail.com>
Date: Wed, 22 Aug 2012 00:45:29 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: "M. Fletcher" <mpf30@cam.ac.uk>
CC: linux-media@vger.kernel.org
Subject: Re: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
References: <00f301cd7fb1$b596f2c0$20c4d840$@cam.ac.uk> <5033A9C3.7090501@iki.fi> <00f401cd7fb2$d402c530$7c084f90$@cam.ac.uk> <5033AC22.608@iki.fi> <00f501cd7fb7$f93fc0a0$ebbf41e0$@cam.ac.uk> <5033B459.1020401@iki.fi> <00ff01cd7fc6$0487c030$0d974090$@cam.ac.uk>
In-Reply-To: <00ff01cd7fc6$0487c030$0d974090$@cam.ac.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2012 07:54 PM, M. Fletcher wrote:
> I appreciate all of your help. 
> 
> I found the following http://sdr.osmocom.org/trac/wiki/rtl-sdr which seems
> to support the E4000 on the Compro U680F. Could that driver be incorporated
> with the RTL83xxu from V4L-DVB?
> 
> Regards,
> Marc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Fletcher, 'dvb_usb_rtl2832[u]' is original(patched) Realtek "Out Of
Tree" driver.
https://github.com/tmair/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0#readme
Although this one have tuner issue(irregularly), too ;)
WARNING: filter timeout pid 0x00…
…
'dvb-usb-rtl28xxu' and 'rtl2832' are "In House" drivers/modules.
http://git.linuxtv.org/media_build.git

FMTTM,
poma

