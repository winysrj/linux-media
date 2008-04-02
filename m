Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1Jh62g-00005h-S9
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 18:42:31 +0200
Received: by rv-out-0910.google.com with SMTP id b22so1789423rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 02 Apr 2008 09:42:25 -0700 (PDT)
Message-ID: <c8b4dbe10804020942r6930fd6fu144b1b445534fda8@mail.gmail.com>
Date: Wed, 2 Apr 2008 17:42:25 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Another Sillyname" <anothersname@googlemail.com>
In-Reply-To: <a413d4880804011641v1d20ebabo376d2b41b179b022@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
	<d9def9db0803311559p3b4fe2a7gfb20477a2ac47144@mail.gmail.com>
	<c8b4dbe10804011406i6923397fw84de9393335dfee9@mail.gmail.com>
	<a413d4880804011641v1d20ebabo376d2b41b179b022@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
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

On 4/2/08, Another Sillyname <anothersname@googlemail.com> wrote:
> Aidan
>
> So are you working on integrating the em28xx devices that are working
> in v4l-dvb-kernel version into v4l-dvb (or ever your own version of
> same)?
>
> Or will it require changes to too much code?

Occasionally, yes - I can do, and generally it's fairly trivial, but
since I don't have access to all this hardware myself, unless
someone's willing to test it there's not much I can do. In fact, I
just added untested support for the card to
http://www.makomk.com/hg/v4l-dvb-em28xx. You'll need to "modprobe
em28xx card=17", though, since your device uses a generic USB ID and I
can't add autodetection without a copy of the dmesg output when
loading the driver without card=17. (Also, while my version of the
driver should in theory support DVB-T, the v4l-dvb version doesn't and
probably won't any time soon.)

> I have to say as a user/observer I find it ridiculous that there are
> two branches of working code that are pretty close to the same and
> won't work with each other.  If there's one area that Linux really
> clearly pi**es on Windows it's the handling of media and stuff like
> this just switches people off.
>
> While not looking at the code or drawing any conclusions therein a new
> layer on top of v4l-dvb (whichever version) seems counter productive
> to me.
>
> Ho hum.....can someone please just tell me how to get my kit working
> without having to re-invent the wheel.

Also, you might be able to get it working with v4l-dvb-experimental by
passing "card=94" to saa7134. No guarantees, though.

> Thanks in advance.
>
> J
>
> On 01/04/2008, Aidan Thornton <makosoft@googlemail.com> wrote:

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
