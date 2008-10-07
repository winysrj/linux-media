Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KnI6L-0002bI-4F
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2008 21:20:10 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8D00J6YV0KGAO0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 07 Oct 2008 15:19:35 -0400 (EDT)
Date: Tue, 07 Oct 2008 15:19:32 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <faf98b150810071202y5b1ea456o2647fe6917de948d@mail.gmail.com>
To: Pieter Van Schaik <vansterpc@gmail.com>
Message-id: <48EBB644.7060007@linuxtv.org>
MIME-version: 1.0
References: <1223358739.7694.0.camel@vanster-laptop>
	<48EB7BC5.30307@linuxtv.org>
	<faf98b150810071202y5b1ea456o2647fe6917de948d@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] cx88 Maintainers
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

Pieter Van Schaik wrote:
> Hi Steve,
> 
> first of all, I cannot begin to thank you enough for replying I am most 
> grateful! Secondly, I apologize if my question seemed idiotic, I have 
> still much to learn regarding the open source community.
> 
> I am extremely glad to hear that you are one of the maintainers and I 
> hope you can provide me with some guidance regarding the following matter:
> 
> I have a winfast tv2000 xp global card installed on a mythbuntu system. 
> I have everything working except for the remote control. I understand 
> that the remote control should be listed in the output of "cat 
> /proc/bus/input/devices" but I do not see it there.  I have looked 
> through the source code of the cx88-input.c file and I noticed that 
> within the cx88-ir-init() function there is no case statement for this 
> particular card, could this be related to my problem? Any guidance would 
> be greatly appreciated.

Please CC the mailing list when it's related to basic kernel issues. 
(I've re-added them).

cx88-input.c contains all of the code to handle IR for the cx88 cards. 
If you don't see a case statement for your card then nobody has 
implemented IR. Look for similar winfast cards and see how they 
implement their IR,

CX88_BOARD_WINFAST_DTV2000H:

or

case CX88_BOARD_WINFAST2000XP_EXPERT:
case CX88_BOARD_WINFAST_DTV1000:

Add your baord definition in one of these points and see of you can 
encourage some IR activity.

Regards,

Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
