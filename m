Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anothersname@googlemail.com>) id 1JhdSa-0004Fy-Rm
	for linux-dvb@linuxtv.org; Fri, 04 Apr 2008 06:23:29 +0200
Received: by wr-out-0506.google.com with SMTP id c30so2691217wra.14
	for <linux-dvb@linuxtv.org>; Thu, 03 Apr 2008 21:23:24 -0700 (PDT)
Message-ID: <a413d4880804032123r55fa7f68we895550dc61a24f4@mail.gmail.com>
Date: Fri, 4 Apr 2008 05:23:23 +0100
From: "Another Sillyname" <anothersname@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <c8b4dbe10804030611p6481043bgc6ed3cc0803fcadf@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
	<d9def9db0803311559p3b4fe2a7gfb20477a2ac47144@mail.gmail.com>
	<c8b4dbe10804011406i6923397fw84de9393335dfee9@mail.gmail.com>
	<a413d4880804011641v1d20ebabo376d2b41b179b022@mail.gmail.com>
	<c8b4dbe10804020942r6930fd6fu144b1b445534fda8@mail.gmail.com>
	<a413d4880804021704g369cef0ak9b0998197ae847a2@mail.gmail.com>
	<c8b4dbe10804030611p6481043bgc6ed3cc0803fcadf@mail.gmail.com>
Subject: Re: [linux-dvb] Lifeview DVB-T from v4l-dvb and Pinnacle Hybrid USb
	from v4l-dvb-kernel......help
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

Aidan

Just to let you know that after tweaking around I've managed to get it
working stable.  I had to add a sleep in modprobe.conf else the
em2880-dvb module was trying to load before em28xx had 'settled'.

Just in case you see the problem in the future I added this to my
modprobe.conf file to fix the problem.....

install em28xx /sbin/modprobe --ignore-install em28xx; /bin/sleep 2;
/sbin/modprobe em2880-dvb

I've been reading that once 2.6.25 kernel is released there will be a
lot more support for the em28 products....hopefully it'll reduce some
of these issues going forward.

Best Regards and once again thanks for your help.

J

On 03/04/2008, Aidan Thornton <makosoft@googlemail.com> wrote:
> On 4/3/08, Another Sillyname <anothersname@googlemail.com> wrote:
>  > Hi Aidan
>  >
>  > I've played around with this for a few hours now and we have moved
>  > forward but not quite working yet.....
>  >
>  > The card is getting loaded properly (when I use the appropriate
>  > card=17 option) however loading the em2880-dvb module then borks.....
>  >
>  > I've attached the edited dmesg file.....any ideas?
>  >
>  > Thanks
>  >
>  > J
>
>
> Hi,
>
>  Sorry about that - I forgot to copy over a couple of extra GPIO writes
>  needed to switch the device to DVB-T mode. (I knew some devices needed
>  them, I'd just forgotten about it and didn't think to check). Try
>  again now.
>
>
>  Aidan
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
