Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KVYMd-0003F7-GJ
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 23:03:40 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5V00ILD953D1N0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 19 Aug 2008 17:03:04 -0400 (EDT)
Date: Tue, 19 Aug 2008 17:03:03 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <6664ae760808191345y3a0c5bd8odd4f5f7ca969b3b@mail.gmail.com>
To: Jay Modi <jaymode@gmail.com>
Message-id: <48AB3507.8030302@linuxtv.org>
MIME-version: 1.0
References: <6664ae760808181614g47d65c7atf71d564d815934a8@mail.gmail.com>
	<48AAF9FB.6010108@ecst.csuchico.edu>
	<6664ae760808191345y3a0c5bd8odd4f5f7ca969b3b@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
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

Jay Modi wrote:
> On Tue, Aug 19, 2008 at 12:51 PM, Barry Quiel <quielb@ecst.csuchico.edu 
> <mailto:quielb@ecst.csuchico.edu>> wrote:
> 
> 
>     I've got the same problem.  I'm running on a fedora 9 box, so at
>     least that tells you its not OS related.
> 
>     I posted this problem on the list a while back and didn't get any
>     response.  Here is my post out of the archives:
> 
>     http://linuxtv.org/pipermail/linux-dvb/2008-July/027367.html
>     http://linuxtv.org/pipermail/linux-dvb/2008-August/027670.html
> 
>     It makes me feel a little bit better that its not just me.
> 
> 
> 
> I am glad to know someone else has this error too.
> 
> For the devs, is there anything Barry and I can do to help 
> diagnose/test/fix this problem?

# make unload
# modprobe cx25840 debug=1
# modprobe cx23885 debug=1

Then cat /dev/video1 >test.mpg

Better?

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
