Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41289 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2GWQNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 12:13:02 -0400
Received: by yenl2 with SMTP id l2so5620543yen.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 09:13:01 -0700 (PDT)
Message-ID: <500D7846.7010802@gmail.com>
Date: Mon, 23 Jul 2012 12:13:58 -0400
From: Joshua Roys <roysjosh@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: ATI theatre 750 HD tuner USB stick
In-Reply-To: <CAD4Xxq8c_SBbJsZc764oFwNjRDeGKuVEX_042ry=xeZBY_ZH-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fisher Grubb <fisher.grubb <at> gmail.com> writes:
>
> Hi all,
>
> My name is Fisher Grubb, I have an ATI (now AMD) theatre 750 HD based
> TV tuner USB stick.  I don't think this ATI chipset is supported by
> linuxTV and have had no joy search google as others also hit a dead
> end.
>

Hello,

I'm working on writing a partial userspace driver for this device from
traffic dumps presently. I believe that it supports / performs similar
functions to the rtl-sdr project, but with better specifications (minus
the great tuner range of the E4000). See
https://github.com/roysjosh/tvw-sdr for current progress. I suspect it
can send 8MHz at 12 bits resolution (it sends roughly 125Mbps through
the USB interface when listening to an FM station).

Currently, my code initializes the T507 and uploads the firmware blob(s)
and all register readouts match. Also, my code does it in under 2
seconds (including a 1 second sleep after the 2nd blob upload) compared
to the over 45 seconds the closed driver needs. I can reach the TDA18271
through an I2C bridge, but I don't configure it yet. I'm considering how
to use existing code rather than write my own from scratch, as much code
already exists (as was mentioned already).

I would love some help, especially from people who are able to safely RE
without legal issues.

Thanks,

Josh
