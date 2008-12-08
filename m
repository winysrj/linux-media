Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp126.rog.mail.re2.yahoo.com ([206.190.53.31])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1L9VZy-0004HI-8a
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 03:10:35 +0100
Message-ID: <493C81EF.9010706@rogers.com>
Date: Sun, 07 Dec 2008 21:09:51 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Steve <steve@ganymede.demon.co.uk>
References: <493C6C68.2060702@ganymede.demon.co.uk>
In-Reply-To: <493C6C68.2060702@ganymede.demon.co.uk>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend S2-3600
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

Hi Steve,

> referring back to the message at 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029830.html I 
> assume I'm supposed to do something with the attachment 
> my_s2api_pctv452e.patch but what?
>
> If anyone can point out what I'm doing wrong, what I need to do, or if 
> there is anything I can do to help with support for the TechnoTrend 
> S2-3600 then please let me know.
>   
I'm not familiar with the device et al., but what you can attempt to do
is apply the patch to the source code. If its one or two lines you can
do this manually or you could use "patch" . ( Download patch if its not
include in your distro already, then cd into the s2-liplianin source
code's top most directory and run (but obviously correct for the proper
pathway) the command "patch -p1 < path_to_/my_s2api_pctv452e.patch". )
Then rebuild the drivers and give it another shot.

Note: I have no idea if the patch has been already applied to that
branch or not, or whether if it will still apply properly (if in the
case where there may have been heavy development changes since whomever
drew up that patch).


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
