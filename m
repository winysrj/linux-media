Return-path: <linux-media-owner@vger.kernel.org>
Received: from web57003.mail.re3.yahoo.com ([66.196.97.107]:29099 "HELO
	web57003.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752816Ab0BXQ33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 11:29:29 -0500
Message-ID: <302486.84780.qm@web57003.mail.re3.yahoo.com>
Date: Wed, 24 Feb 2010 08:22:49 -0800 (PST)
From: ozgur cagdas <ocagdas@yahoo.com>
Subject: Re: [linux-dvb] soft demux device
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lovely! It worked straight away, at least happily created the nodes :) I'm hoping to give an update after I manage to find sometime to play with it.

On the other hand, as a small note, I've applied your patch ( http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/16540 ) on top of the latest hg clone but linux/drivers/media/dvb/Makefile patch failed. It's a very simple patch to apply manually though.

Cheers,

Ozgur.



----- Original Message ----
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Sent: Wed, February 24, 2010 1:22:32 PM
Subject: Re: [linux-dvb] soft demux device

On Wed, 2010-02-24 at 03:57 -0800, ozgur cagdas wrote:
> Hi,
> 
> Thanks very much for the previous information. To give it a go just as
> it is, I've loaded dvb_dummy_fe module manually and many other modules
> including dvb_core as well, but no hope, don't have /dev/dvb folder
> yet. As I've mentioned earlier, I do not have a hardware at the
> moment, so I should trigger loading of proper modules manually. In my
> scenario, which modules should I load? Any simple set of modules
> that'd create necessary /dev/dvb/ and subsequent would do for me. If
> it matters, I am using 2.6.31 kernel and ubuntu 9.10 distribution.

See my dvb_dummy_adapter patch I just posted to the list.

Regards,
Andy

> Cheers,
> 
> Ozgur.
> 
> 
>      
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



      
