Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:63122 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3EROgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 May 2013 10:36:23 -0400
Received: by mail-ee0-f54.google.com with SMTP id e50so3221008eek.13
        for <linux-media@vger.kernel.org>; Sat, 18 May 2013 07:36:22 -0700 (PDT)
Message-ID: <519791E2.4080804@googlemail.com>
Date: Sat, 18 May 2013 16:36:18 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com>
In-Reply-To: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.05.2013 15:57, schrieb Chris Rankin:
> I have a PCTV 290e DVB2 adapter (em28xx, em28xx_dvb, em28xx_rc, cxd2820r), and I have just discovered that the IR remote control has stopped working with VDR when using a vanilla 3.9.2 kernel. Downgrading the kernel to 3.8.12 fixes things again. (Switching to my old DVB NOVA-T2 device fixes things too, although it cannot receive HDTV channels, of course).

Great. :( :( :(
There have been several changes in the em28xx and core RC code between 
3.8 and 3.9...
I can't see anything obvious, the RC device seems to be registered 
correctly.
Could you please bisect ?

Regards,
Frank
