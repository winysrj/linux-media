Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1JP0EN-0006dG-HG
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 19:51:47 +0100
Date: Tue, 12 Feb 2008 19:51:47 +0100
From: Artem Makhutov <artem@makhutov.org>
To: David BERCOT <david.bercot@wanadoo.fr>
Message-ID: <20080212185147.GB4971@moelleritberatung.de>
References: <A33C77E06C9E924F8E6D796CA3D635D102396F@w2k3sbs.glcdomain.local>
	<20080212135037.2dde5349@wanadoo.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080212135037.2dde5349@wanadoo.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Has anyone got multiproto and TT3200 to work
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

On Tue, Feb 12, 2008 at 01:50:37PM +0100, David BERCOT wrote:
> [...]
> DMESG
> # dmesg
> [...]
> stb6100_attach: Attaching STB6100 DVB: registering frontend 0 (STB0899
> Multistandard)... dvb_ca adaptor 0: PC card did not respond :(
> 
> As you can see, I have one error left, and it seems to come from my CI
> module. If you have a different method, may be we can exchange ;-)))

Have you tried to load the drivers without the CI module attached to the
card?

Regards, Artem

-- 
Artem Makhutov
Unterort Str. 36
D-65760 Eschborn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
