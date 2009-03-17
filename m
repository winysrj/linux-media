Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:49519 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZCQAsP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 20:48:15 -0400
Message-ID: <003a01c9a69a$0de42640$0a00a8c0@vorg>
From: "Timothy D. Lenz" <tlenz@vorgon.com>
To: <linux-media@vger.kernel.org>
References: <000701c9a5de$09033e20$0a00a8c0@vorg> <49BE5B36.1080901@linuxtv.org>
Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
Date: Mon, 16 Mar 2009 17:46:57 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When it panics, there is no log, just a bunch of stuff that that scrolls fast on the main monitor then cold lock. No way to scroll
back. I looked at the logs and the ones that are text had nothing about it.

----- Original Message ----- 
From: "Steven Toth" <stoth@linuxtv.org>
To: <linux-media@vger.kernel.org>
Cc: <linux-dvb@linuxtv.org>
Sent: Monday, March 16, 2009 6:59 AM
Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic


> Timothy D. Lenz wrote:
> > Using kernel 2.6.26.8 and v4l from a few days ago. When I modprobe cx23885 to load the drivers, I get kernel panic
>
> We'll need the oops.
>
> - Steve
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

