Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eamonn.sullivan@gmail.com>) id 1JgQPX-0007wy-1c
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 22:15:19 +0200
Received: by wx-out-0506.google.com with SMTP id s11so1845048wxc.17
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 13:15:13 -0700 (PDT)
Message-ID: <e40e29dd0803311315sec200acm67b179fa511aa75c@mail.gmail.com>
Date: Mon, 31 Mar 2008 21:15:12 +0100
From: "Eamonn Sullivan" <eamonn.sullivan@gmail.com>
To: dvb@ply.me.uk
In-Reply-To: <200803312107.09463.dvb@ply.me.uk>
MIME-Version: 1.0
Content-Disposition: inline
References: <1206139910.12138.34.camel@youkaida>
	<bbf19b3d0803291756q743eca07t4b2f8290dd47c3e4@mail.gmail.com>
	<754a11be0803311244w319537f6s10c4f3028bb8117a@mail.gmail.com>
	<200803312107.09463.dvb@ply.me.uk>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
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

On Mon, Mar 31, 2008 at 9:07 PM, Andy Carter <dvb@ply.me.uk> wrote:
> On Monday 31 March 2008 20:44:50 Antti Luoma wrote:
>  > Hi,
>  >
>  > it's the the kernel version that causes the problem, you should compile it
>  > yourself or get it from gentoo somehow.
>  > I Think issue affects all USB-DVB-T users with kernel 2.6.24
>
>  Not so.
>
>  I've been running Nova T-500 for three weeks with 4 disconnects in the first
>  24 hours but none since on a stock debian 2.6.24 kernel

Has the patch been applied already to the stock debian kernel? The
code was committed early in the month (March 8, IIRC). Ubuntu is in
kernel freeze for the next release, so it's possible it just didn't
make the cutoff.

>
>
>  > see this post:
>  > https://bugs.launchpad.net/ubuntu/+bug/209603
>
>  I hope this solves the problem others seem to be plagued with, but I'm puzzled
>  as to why it's so stable here
>
>  Andy

There seems to be a couple of common factors in the problem reports --
marginal or poor signal and using active EIT to get the programme
guide. My signal hovers around 52-64 percent, with a booster. I think
my antenna need replacing. My disconnects reduced quite a bit when I
turned off the Active EIT setting, although i still get disconnected
frequently.

Then again, maybe it's just the alignment of the planets out your way...

-Eamonn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
