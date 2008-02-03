Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from anchor-post-35.mail.demon.net ([194.217.242.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <osl2008@googlemail.com>) id 1JLgRH-0001Hi-4k
	for linux-dvb@linuxtv.org; Sun, 03 Feb 2008 16:07:23 +0100
Received: from rna.demon.co.uk ([83.104.138.66] helo=[192.168.23.253])
	by anchor-post-35.mail.demon.net with esmtp (Exim 4.67)
	id 1JLgRE-000Fqk-IA
	for linux-dvb@linuxtv.org; Sun, 03 Feb 2008 15:07:20 +0000
Message-ID: <47A5D8AF.2090800@googlemail.com>
Date: Sun, 03 Feb 2008 15:07:27 +0000
From: "Richard (MQ)" <osl2008@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Any chance of help with v4l-dvb-experimental /
	Avermedia A16D please?
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

I tried contacting Markus with the following but no response - probably
one of you experienced coders on this list will know what's wrong
though? As I say below, the 'standard' v4l-dvb builds fine but is no use
with this card.

Cheers
Richard (MQ)

> Having another try to get my Avermedia A16D card working with latest hg
> code. I'm also using the very latest OpenSuSE 'factory' platform, with
> kernel 2.6.24-rc8-git2-5-default. gcc is 4.3.0
> 
> I can build the 'standard' v4l-dvb tree OK, though as expected it
> doesn't see my card. However, when I try to build your
> v4l-dvb-experimental tree (in a separate directory) I get
> 
>> > rpm@DevBox2400:~/Progs/v4l-dvb-experimental/v4l> make
> ...
>> > make -C ../../../linux-2.6.24-rc8-git2-5 O=../linux-2.6.24-rc8-git2-5-obj/i386/default modules
>> >   CC [M]  /home/rpm/Progs/v4l-dvb-experimental/v4l/flexcop-pci.o
>> > In file included from /home/rpm/Progs/v4l-dvb-experimental/v4l/flexcop-common.h:23,
>> >                  from /home/rpm/Progs/v4l-dvb-experimental/v4l/flexcop-pci.c:10:
>> > /home/rpm/Progs/v4l-dvb-experimental/v4l/dvb_frontend.h:42:33: error: media/v4l_dvb_tuner.h: No such file or directory
> 
> Indeed there's no directory 'media' at the current level, though there's
> one at ../linux, so I tried
> 
>> > ln -s ../linux/include/media media
> 
> Now make gets a bit further, but dies building bttv-driver
> 
> Please have you any suggestions?
> 
> By the way - is it more appropriate to post this e.g. at linux-dvb?
> 
> Many thanks
> Richard.
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
