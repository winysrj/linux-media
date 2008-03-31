Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anothersname@googlemail.com>) id 1JgQbX-0000aY-00
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 22:27:44 +0200
Received: by el-out-1112.google.com with SMTP id o28so557092ele.2
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 13:27:36 -0700 (PDT)
Message-ID: <a413d4880803311327je81ac83ja4fb5da7d6c8821a@mail.gmail.com>
Date: Mon, 31 Mar 2008 21:27:34 +0100
From: "Another Sillyname" <anothersname@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
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

Any idea when the next 'batch' of em28xx cards will be added to
v4l-dvb or would that question be better asked on the dev list?

Thanks

On 31/03/2008, Aidan Thornton <makosoft@googlemail.com> wrote:
> On Mon, Mar 31, 2008 at 12:40 AM, Another Sillyname
>  <anothersname@googlemail.com> wrote:
>  > I have a machine that has an internal card that's a Lifeview DVB and
>  >  works fine using the v4l-dvb mercurial sources.
>  >
>  >  I want to add a Pinnacle USB Hybrid stick (em28xx) that does not work
>  >  using the v4l-dvb sources but does work using the v4l-dvb-kernel
>  >  version.
>  >
>  >  1.  Will the number of em28xx cards supported by v4l-dvb be increased
>  >  shortly?  (My card id was 94 IIRC ).
>
>
> If it's supported by v4l-dvb-kernel, it's entirely possible, yes.
>
>
>  >  2.  Can I mix and match from the sources...i.e. can I graft the em28xx
>  >  stuff from v4l-dvb-kernel into the v4l-dvb source and compile
>  >  successfully or has the underlying code changed at a more strategic
>  >  level?
>
>
> Not trivially, since v4l-dvb-kernel contains changes to the core code
>  that the em28xx driver relies on and that are incompatible with
>  changes in the main v4l-dvb repository since. You can try
>  http://www.makomk.com/hg/v4l-dvb-makomk - it's the em28xx and xc3028
>  drivers grafted onto a version of v4l-dvb that's about 5 months old at
>  this point - though it's really not a great starting point for porting
>  them onto newer versions, since you'd want to drop the xc3028 driver
>  in favour of the newer one
>
>
>  >  3.  Why did the sources branch?  Was there a good technical reason for this?
>
>
> Supporting the xc3028 silicon tuner needed some changes to support
>  hybrid analog/digital tuners better. Unfortunately, Markus couldn't
>  come to an agreement with the rest of the developers on how to do it.
>  (I think the main concern were that the changes he were proposing were
>  rather more invasive than they needed to be and risked breaking
>  existing drivers). In the end, someone else coded the equivalent
>  functionality in a more backwards-compatible way and merged it in
>  stages.
>
>  (It's actually relatively easy to port code from Markus' hybrid tuner
>  framework to the v4l-dvb one, though he will never admit so.)
>
>
>  >  4.  If I can't use the v4l-dvb sources to get my em28xx working what's
>  >  the chances of getting the v4l-dvb-kernel stuff working for the
>  >  lifeview flydvb card?
>
>
> Not good. Its support for other hardware is, if anything, going to be
>  slowly getting worse over time as other drivers have to be modified or
>  disabled to make it compile on newer kernels.
>
>  >  Thanks in advance.
>  >
>  >  _______________________________________________
>  >  linux-dvb mailing list
>  >  linux-dvb@linuxtv.org
>  >  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
