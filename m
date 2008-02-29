Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <johnfdonaghy@gmail.com>) id 1JVC3U-0000r6-CT
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 21:42:08 +0100
Received: by mu-out-0910.google.com with SMTP id w9so5836467mue.6
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 12:42:01 -0800 (PST)
Message-ID: <a6e3d9900802291242y14e025cbt31159c6dd54d0ae0@mail.gmail.com>
Date: Sat, 1 Mar 2008 14:42:01 +1800
From: "John Donaghy" <johnfdonaghy@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <47C865AB.3070101@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <a6e3d9900802291150l33e8dc7fu39ccbef9310d706c@mail.gmail.com>
	<47C865AB.3070101@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] xc3028 tuner development status?
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

On Sat, Mar 1, 2008 at 2:06 PM, Steven Toth <stoth@linuxtv.org> wrote:
>
>  Correct, it's a rebranded Haupauge HVR1500.
>
>
>  > Unlike the previous poster I'm not getting "frontend initialization
>  > failed" which is promising, but when I run:
>  >
>  > /usr/bin/scan /usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB
>  >
>  > I get a bunch of "tuning failed" messages like this:
>  >
>  > scanning /usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB
>  > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  >>>> tune to: 57028615:8VSB
>  > WARNING: >>> tuning failed!!!
>  >>>> tune to: 57028615:8VSB (tuning failed)
>  > WARNING: >>> tuning failed!!!
>  >
>  > Am I missing something (like firmware perhaps) or does it not work
>  > yet? Let me know if there's anything I can do to help get it working.
>
>  Do you have the xc3028 firmware on your system?
>
>  - Steve
>

Thanks for the quick reply. I mast have done something wrong before,
because after I reinstalled the firmware, it worked!

(For the firmware I followed the instructions I found at
http://www.linuxtv.org/pipermail/linux-dvb/2008-January/022621.html)

Thanks,

John

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
