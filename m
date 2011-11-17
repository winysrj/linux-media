Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55631 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab1KQOCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 09:02:00 -0500
Received: by ywt32 with SMTP id 32so1056471ywt.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 06:01:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC4FDB4.2050104@mitlab.de>
References: <4EC4FDB4.2050104@mitlab.de>
Date: Thu, 17 Nov 2011 14:01:59 +0000
Message-ID: <CAB33W8f+sabd6H+wYtrp-3KbG8wD1e-TEhrWc5vYEA8SQpc5BA@mail.gmail.com>
Subject: Re: problems getting v4l to start
From: Tim Draper <veehexx@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 November 2011 12:27, Ralf Moeller <ralf.moeller@mitlab.de> wrote:
> Hi,
>
> I tried to compile v4l media_build in case of getting a dvb-t card to run.
> (it uses saa7134)
>
> when i made "make install" and reboot, it says the module saa7134 have
> unknown symbols.
>
> then I tried it by removing older dvb/v4l support from my customkernel
> (2.6.37.2)
> rebuild media_build again, but same problem. modprobe says error about
> unknown
> symbols and with dmesg there is written "saa7134: unknown parameter index"
>
> what went wrong ?
> is there help available ?
>
> kind regards,
> ralf moeller




have you tried following this link:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
