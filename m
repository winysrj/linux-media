Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp12.wxs.nl ([195.121.247.24]:64189 "EHLO psmtp12.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbZFLTxd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 15:53:33 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp12.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KL500KOT5X5HJ@psmtp12.wxs.nl> for linux-media@vger.kernel.org;
 Fri, 12 Jun 2009 21:53:35 +0200 (MEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by localhost (8.14.3/8.14.3/Debian-4) with ESMTP id n5CJrSEQ003997	for
 <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 21:53:29 +0200
Date: Fri, 12 Jun 2009 21:53:28 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: [linux-dvb] Remote af9015 Conceptronic
In-reply-to: <bc67ac90906090053g31ed44e7q1f6c96d86c9fd6f0@mail.gmail.com>
To: linux-media@vger.kernel.org
Message-id: <4A32B238.9070000@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <bc67ac90906090053g31ed44e7q1f6c96d86c9fd6f0@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IR tables are hardcoded in the driver that can be found at:
http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2

It has 3 sets parameters, and by default is set to tthe NEC one.
ir_protocol
Specify RTL2381 remote: 0=NEC, 1=RC5, 2=Conceptronic (defaults to 0)

   sudo modprobe -r dvb_usb_rtl2831u
   sudo modprobe dvb-usb-rtl2831u ir_protocol=2

to be compliant with the Conceptronic IR

Daniel Sanchez wrote:
> Hi,
> I'm have Conceptronic USB2.0 DVB-T CTVDIGRCU V3.0 and remote not working,
> In method 'af9015_read_config' set IR mode: 4 and set rc_key_map to NULL;
> Why I'm read ir_table to set?
> It's possible follow this instructions? 
> http://linuxtv.org/wiki/index.php/Remote_controllers-V4L#How_to_add_remote_control_support_to_a_card_.28GPIO_remotes.29
> 
> Thanks
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
