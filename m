Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1K6yHA-0000m3-P7
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 03:40:29 +0200
Message-ID: <4851D002.8000801@linuxtv.org>
Date: Thu, 12 Jun 2008 21:40:18 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: William Melgaard <piobair@mindspring.com>
References: <2496078.1213320530377.JavaMail.root@mswamui-chipeau.atl.sa.earthlink.net>
In-Reply-To: <2496078.1213320530377.JavaMail.root@mswamui-chipeau.atl.sa.earthlink.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO FusionHDTV7
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

William Melgaard wrote:
> I see in the "hardware supported" wiki that the FusionHDTV5 is supported. How about the -7?
> 
> From their web page:
> Chipset: Conexant CX 2388X, S5H1411
> Tuner: Xceive XC5000
> Resolution: 1920 x 1080i
> Snapshot types: TP, WMV, AVI
> Source: Free-to-Air, Cable, Video, S-video


I COULD answer your question, but I always liked the Chinese proverb:

Give a man a fish and you feed him for a day. Teach a man to fish and you feed him for a lifetime.

Check it:

The master development repository is hosted at http://linuxtv.org/hg/v4l-dvb

Various lists of supported cards are found under linux/Documentation/video4linux

http://linuxtv.org/hg/v4l-dvb/file/tip/linux/Documentation/video4linux/

You see the chipset, "CX 2388X" -- the name of the linux driver is "cx88"

If you think the wiki is missing entries for specific cards, please feel free to create yourself a user account and fill in the missing info.

Enjoy, and please spread the word.

Regards,

Mike Krufky


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
