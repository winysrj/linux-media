Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <alain@satfans.be>) id 1KJvAv-00037R-Ri
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 20:59:30 +0200
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Date: Fri, 18 Jul 2008 20:59:27 +0200
From: <alain@satfans.be>
In-Reply-To: <mailman.95.1216393443.829.linux-dvb@linuxtv.org>
References: <mailman.95.1216393443.829.linux-dvb@linuxtv.org>
Message-ID: <1e5614ef18e9000783d66e7bbd9586fd@localhost>
Subject: Re: [linux-dvb]
 =?utf-8?q?Technotrend_TT3650_S2_USB_and_multiproto_?=
 =?utf-8?q?=28Daniel_Hellstr=3Fm=29?=
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


Tjanks Daniel.



So I succeeded with the make and I'm here now:





On Fri, 18 Jul 2008 17:04:03 +0200, linux-dvb-request@linuxtv.org wrote:

> Send linux-dvb mailing list submissions to

> 	linux-dvb@linuxtv.org

> 

> To subscribe or unsubscribe via the World Wide Web, visit

> 	http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

> or, via email, send a message with subject or body 'help' to

> 	linux-dvb-request@linuxtv.org

> 

> You can reach the person managing the list at

> 	linux-dvb-owner@linuxtv.org

> 

> When replying, please edit your Subject line so it is more specific

> than "Re: Contents of linux-dvb digest..."

> 

> 

> ------------------------------

> 

> Message: 8

> Date: Fri, 18 Jul 2008 14:22:39 +0000 (UTC)

> From: Daniel Hellstr?m <dvenion@hotmail.com>

> Subject: Re: [linux-dvb] Technotrend TT3650 S2 USB and multiproto

> To: linux-dvb@linuxtv.org

> Message-ID: <loom.20080718T141911-959@post.gmane.org>

> Content-Type: text/plain; charset=utf-8

> 

>  <alain <at> satfans.be> writes:

> 

>>

>>

>>

>> Hi,

>> I'm trying to use my DVB S2 USB with Ubuntu8.04 and MyTheatre.

>> I found an how to

>

[url]http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI[/url]

>> But I get stuck with the fail of the make.

>> It claims about the audio driver?

>> [QUOTE]make[2]: Entering directory

> `/usr/src/linux-headers-2.6.24-19-generic'

>> ? CC [M]? /home/alain/3650/multiproto/v4l/em28xx-audio.o

> 

> 

> Just add the line "#include <sound/driver.h>" above the line that says

> "#include

> <sound/core.h> in the em28xx-audio.c file and run make again and it

should

> succed. It solved the problem for me on heron.

> 

> 

> 

> 

> 

> 




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
