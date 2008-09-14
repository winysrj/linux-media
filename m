Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KexdE-0001Ss-FV
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 21:51:41 +0200
Received: by wx-out-0506.google.com with SMTP id t16so702823wxc.17
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 12:51:36 -0700 (PDT)
Message-ID: <d9def9db0809141251r1edece84r96c8becd5a2d4ee3@mail.gmail.com>
Date: Sun, 14 Sep 2008 21:51:36 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48CD41BD.8040508@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <564277.58085.qm@web46102.mail.sp1.yahoo.com>
	<48CD41BD.8040508@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On Sun, Sep 14, 2008 at 6:54 PM, Steven Toth <stoth@linuxtv.org> wrote:
> barry bouwsma wrote:
>> --- On Sun, 9/14/08, Steven Toth <stoth@linuxtv.org> wrote:
>>
>>> is that the BSD folks can't port the GPL license into BSD because it's
>>> not compatible.
>>
>> I don't want to see any religious war here (trimmed to dvb
>> list), but...
>>
>> There is GPL code distributed as part of *BSD sources,
>> as you can see by reading the licensing in, for example,
>> $ ls /lost+found/CVSUP/BSD/FreeBSD.cvs/src/sys/gnu/dev/sound/pci/
>> Attic       emu10k1-alsa.h,v  maestro3_reg.h,v  p17v-alsa.h,v
>> csaimg.h,v  maestro3_dsp.h,v  p16v-alsa.h,v
>
> Interesting.
>
>>
>>
>>> I owe it to myself to spend somehime reading the BSD licencing. Maybe
>>> the GPL is compatible with BSD.
>>
>> It all depends on the intended use -- whether for optional
>> kernel components as above.  In the distributions, though,
>> it's kept separated.
>>
>> It's also possible to dual-licence source, and I see a good
>> number of such files in NetBSD under, as an example,
>> /lost+found/CVSUP/BSD/NetBSD.cvs/src/sys/dev/ic/
>
> I'm be quite happy to grant a second license on my work the the BSD
> guys, as the copyright owner I can do that. The legal stuff gets messy
> quickly and I don't claim to understand all of it.
>

Great move Steven! Can we move the TDA10048 code over, maybe adding
a note that it's dual licensed would be nice?

thanks,
Markus

> I'm an opensource developer, I chose to work on Linux because it's the
> biggest movement. I have no objections to any other projects, in fact I
> welcome them.
>
>
>>
>>
>> There will be plenty of misinformation and FUD about which
>> licensing is better, and I don't want to hear any more such.
>> Or debates.  Or evangelism.  Or anything.
>
> Agreed.
>
>>
>> The different BSDen will handle GPLed code differently.
>>
>> (By the way, it is possible to completely build NetBSD from
>> within Linux, though the DVB code hasn't been merged as of
>> this morning my time, if someone with *BSD familiarity here
>> wants to think about considering maybe playing with it later
>> sometime, perhaps, maybe)
>
> The issue would be your support community. If you're working on linux
> then people here will help, if our working on something else and asking
> for help here - then people will probably be trying to fix linux first,
> so responses to questions may not arrive, or be slow coming.
>
> Still, better TV support in BSD is good news.
>
> - Steve
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
