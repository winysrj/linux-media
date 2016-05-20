Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:64535 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETWrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2016 18:47:40 -0400
Date: Sat, 21 May 2016 00:47:28 +0200 (CEST)
From: Rolf Evers-Fischer <embedded24@evers-fischer.de>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org, olli.salonen@iki.fi
Message-ID: <1677993131.49456.01924d52-f180-4aca-bc23-42b237aaedb7.open-xchange@email.1und1.de>
Subject: Re: DVBSky T330 DVB-C regression Linux 4.1.12 to 4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Antti,
I apologize for tackling this old problem, but I just ran into the same
situation with my "DVBSky T330 DVB-C" and found that I'm not the only one.

Antti Palosaari <crope  iki.fi> writes:

> 
> Moikka!
> 
> On 11/19/2015 01:36 AM, Stephan Eisvogel wrote:
> > Hey Olli, Antti,
> 
> > culprit is:
> >
> > http://git.linuxtv.org/cgit.cgi/linux.git/commit/drivers/media/dvb-frontends/si2168.c?id=7adf99d20ce0e96a70755f452e3a63824b14060f

Reverting this commit helps, but is not very convenient.

> To see that, debug messages should be enabled:
> modprobe si2168 dyndbg==pmftl
> or
> modprobe si2168; echo -n 'module si2168 =pft' > 
> /sys/kernel/debug/dynamic_debug/control
> 
> You could also replace all dev_dbg with dev_info if you don't care 
> compile kernel with dynamic debugs enabled needed for normal debug logging.
> 

Dynamic debug didn't work properly on my system. I'll replace all dev_dbg with
dev_info and provide you the output as soon as possible, if you are still
interested.

> Also, you used 4.0.19 firmware. Could you test that old one:
> http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/4.0.11/
> 

I've just tried the old 4.0.11 firmware - and the error is gone. Now the tuning
works perfectly!

Best regards,
 Rolf
