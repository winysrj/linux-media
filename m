Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48570 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbZC3XH7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 19:07:59 -0400
Message-ID: <49D150C6.5060207@iki.fi>
Date: Tue, 31 Mar 2009 02:07:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olivier MENUEL <omenuel@laposte.net>
CC: Thomas RENARD <threnard@gmail.com>,
	Laurent Haond <lhaond@bearstech.com>,
	linux-media@vger.kernel.org,
	Karsten Blumenau <info@blume-online.de>,
	pHilipp Zabel <philipp.zabel@gmail.com>,
	=?ISO-8859-1?Q?Martin_M=FCller?= <mueller1977@web.de>
Subject: Re: AverMedia Volar Black HD (A850)
References: <200903291334.00879.olivier.menuel@free.fr> <49D1287C.5010803@iki.fi> <49D13272.7050906@laposte.net> <200903310048.19629.omenuel@laposte.net>
In-Reply-To: <200903310048.19629.omenuel@laposte.net>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Olivier MENUEL wrote:
> Here are my tests :
> 
> http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/ :
> 
> I found why kaffeine was not working : I needed to check all offset checkboxes when scanning.
> Like Thomas, I get these messages in /var/log/messages when scanning or changing channel : af9015_pid_filter_ctrl: onoff:0 (with kaffeine, scan or vlc)

That's normal behaviour. dvb-usb-framework calls .pid_filter_ctrl(0) 
callback to ensure pid-filter is disabled. Those logs will not seen 
normally when debug-logs are disabled.

> I found a weird thing though with kaffeine (that may be a wrong setting somewhere in kaffeine though, it's the first time I use a DVB device on linux). If I stop kaffeine and restart it I can't access the channels I just scanned anymore : I get an error message :
> Tuning to: NRJ12 / autocount: 0
> Using DVB device 0:0 "Afatech AF9013 DVB-T"
> tuning DVB-T to 498167000 Hz
> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
> .....
> Not able to lock to the signal on the given frequency
> Frontend closed
> Tuning delay: 1062 ms
> 
> I need to switch channels several times and eventually it works : I can now change channels without any problems !
> But if I quit and restart kaffeine, I get the same problem again
> No problem with VLC.

hmm, no idea. Sometimes I have also seen rather similar problems when 
switching channels but restarting Totem solves problem.

I did full band w_scan and it founds all muxes I can receive (4xDVB-T + 
1xDVB-H). I haven't tested Kaffeine.

> Except that everything seems to work perfectly fine !
> I'm not sure exactly what you want me to test though.
> 
> 
> GPI01 :
> 
> Seems quite similar to previous one. Everything seems fine too (except the weird kaffeine issue).
> In the logs I get the same message : af9015_pid_filter_ctrl: onoff:0
> 
> 
> 
> Finally, I tested GPI00 :
> 
> Working fine too, seems exactly like previous ones.
> 
> I hope I installed these correctly and did not mess up between the different drivers.
> Let me know if something seems weird or if you want me to test something else.
> 
> I'm really glad it finally works ;) Thanks a lot.

For me it seems like tuner is not connected to GPIO pin at all. I will 
wait someone else, Thomas?, will test. Testing this (af9015_aver_a850_2) 
tree is enough if it works:
http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/

regards
Antti
-- 
http://palosaari.fi/
