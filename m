Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Ls4Rg-0007Fh-IA
	for linux-dvb@linuxtv.org; Fri, 10 Apr 2009 02:18:13 +0200
Received: from steven-toths-macbook-pro.local
	(ool-45721e5a.dyn.optonline.net [69.114.30.90]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0KHU00FCZZH2Y2W0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 09 Apr 2009 20:17:27 -0400 (EDT)
Date: Thu, 09 Apr 2009 20:17:26 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <8de7a23f0904091518t72643426ub77855d43bab9631@mail.gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Message-id: <49DE9016.3090306@linuxtv.org>
MIME-version: 1.0
References: <8de7a23f0904090007x3905ee7dp817efe67044b8223@mail.gmail.com>
	<49DE0044.10700@linuxtv.org>
	<8de7a23f0904091518t72643426ub77855d43bab9631@mail.gmail.com>
Cc: Alastair Bain <bainorama@gmail.com>
Subject: Re: [linux-dvb] HVR-1700 - can't open or scan
Reply-To: linux-media@vger.kernel.org
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

Alastair Bain wrote:
> 
> 
> 2009/4/10 Steven Toth <stoth@linuxtv.org <mailto:stoth@linuxtv.org>>
> 
>     Alastair Bain wrote:
> 
>         I'm trying to get the Hauppauge HVR-1700 working on a Mythbuntu
>         9.04 b install. Looks like the modules are all loading, firmware
>         is being loaded, device appears in /dev etc, but I can't seem to
>         do anything with it. dvbscan fails around ln 315,
> 
>         dvbfe_get_info(fe, DVBFE_INFO_LOCKSTATUS, &feinfo,
>                                        DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0)
>         returns DVBFE_INFO_QUERYTYPE_LOCKCHANGE
> 
>         Anyone have any clues as to what I can do to fix this? Kernel
>         trace is at http://pastebin.com/m7671e816.
> 
> 
>     trace looks fine.
> 
>     Try tzap then report back.
> 
>     - Steve
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-media" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> I don't think I can use tzap until I have the results from dvbscan can I?
> 

Do not drop the CC for the mailing list, I was replying to the list - not 
directly to you.

Find a channels.conf for your local transmitter, I used to use Crystal Palace 
for London. We have all of them already for the UK.

- Steve


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
