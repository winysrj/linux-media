Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1LEOq9-0001gQ-V7
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 14:59:32 +0100
Date: Sun, 21 Dec 2008 14:59:26 +0100
From: Artem Makhutov <artem@makhutov.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20081221135926.GI12059@titan.makhutov-it.de>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<alpine.DEB.2.00.0812210301090.22383@ybpnyubfg.ybpnyqbznva>
	<1229827473.2557.11.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1229827473.2557.11.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to stream DVB-S2 channels over network?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

On Sun, Dec 21, 2008 at 03:44:33AM +0100, hermann pitton wrote:
> I must admit that I did not read it all yet this time.
> 
> But a good probe might be to save the HD S2 stuff to a file and then try
> to get it over a nfs mount with xine for example on other PCs.
> 
> On consumer level it only has advantages, skip the commercials ...
> 
> This works since stoneage within local networks.
> 
> If you are trying to get it out over the internet, it might cause some
> more questions of course.

The STB can only playpack UDP Streams, so NFS will not help me much.

I have recorded the stream to a file and will try to playback it under windows.
My CPU is too slow to playback the stream without GPU acceleration under linux.

Regards, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
