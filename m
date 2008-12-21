Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1LEOKX-0007UE-A1
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 14:26:50 +0100
Date: Sun, 21 Dec 2008 14:26:37 +0100
From: Artem Makhutov <artem@makhutov.org>
To: Michel Verbraak <michel@verbraak.org>
Message-ID: <20081221132637.GG12059@titan.makhutov-it.de>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<494E4176.2000003@verbraak.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <494E4176.2000003@verbraak.org>
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

On Sun, Dec 21, 2008 at 02:15:34PM +0100, Michel Verbraak wrote:
> Have a look at my tvpump program which is part of my set of programs I  
> use to view livetv (http://www.verbraak.org/wiki/index.php/TVSuite).
> I use ffplay to view HD content but I currently also have problems  
> viewing HD content because my computer for viewing is a bit to slow.

I just checked it out. It looks interesing, but I need UDP streaming,
as the STB can only receive UDP-Streams.

Maybe I can stream to UDP  by connecting to it using nc and the pipe the
output an other nc, which will output to UDP.

Regards, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
