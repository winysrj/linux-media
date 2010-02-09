Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12]:57042 "EHLO
	amy.cooptel.qc.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751004Ab0BIScm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 13:32:42 -0500
Message-ID: <4B71AA49.5000708@cooptel.qc.ca>
Date: Tue, 09 Feb 2010 13:32:41 -0500
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800
 (DVB-S) and USB HVR Hauppauge 950q
References: <4B70E7DB.7060101@cooptel.qc.ca>	 <829197381002082118k346437b3y4dc2eb76d017f24f@mail.gmail.com>	 <4B7166A5.8050402@cooptel.qc.ca> <829197381002090742m1975641eta54b9169447b0436@mail.gmail.com>
In-Reply-To: <829197381002090742m1975641eta54b9169447b0436@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I tried something simple with three kernel versions:

2.6.30, 2.6.31, and 2.6.32.7.

But I can't reproduce the problem that way.

Just after booting I run alternatively

/opt/dvb-apps/bin/szap -a 0 -r "CCTV 4"
/opt/dvb-apps/bin/azap -a 1 -r "57.1"

and then I run them concurrently

and finally I disconnect the USB tuner and replug and retry the 'azap'

I did not get any crash yet.

So there is likely some other "environmental" condition that is relevant.

I will continue using 2.6.32.7.  Whenever I meet the problem I will
take note of the environment and try to reproduce the same environment with
other versions of the kernel.

Thanks

> 
> The only "major reorganization" in that time period I can think of is
> a couple of the files related to IR support were moved.
> 
> Further, the problem appears to be in the implementation of
> request_firmware() and doesn't look specific to any changes in the
> v4l-dvb tree.
> 
> All I can suggest at this point is you try to narrow down what release
> the breakage was introduced in, at which point we can take a look at
> what changed.
> 
> Devin
> 
