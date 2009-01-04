Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.jarosz@gmail.com>) id 1LJSkm-0005hy-Q9
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 14:10:54 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2528701fga.25
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 05:10:49 -0800 (PST)
Date: Sun, 04 Jan 2009 14:11:33 +0100
To: linux-dvb@linuxtv.org
From: "Roman Jarosz" <roman.jarosz@gmail.com>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com> <20090104111429.1f828fc8@bk.ru>
	<Pine.LNX.4.64.0901041435090.1668@shogun.pilppa.org>
Message-ID: <op.um8hljd6rj95b0@localhost>
In-Reply-To: <Pine.LNX.4.64.0901041435090.1668@shogun.pilppa.org>
Subject: Re: [linux-dvb] DVB-S Channel searching problem
Reply-To: kedgedev@centrum.cz
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

On Sun, 04 Jan 2009 13:42:06 +0100, Mika Laitio <lamikr@pilppa.org> wrote:

>> http://mercurial.intuxication.org/hg/s2-liplianin (yesterday Igor  
>> synchronized it with current v4l-dvb)
>> +
>> http://hg.kewl.org/dvb2010/ - new dvb scaner
>>
>> for me everything is working without any problem with my hvr4000. Also  
>> patched vdr 170 works well with s2api
>
> Can you test whether channel switching works for you with
> following
> - vdr-1.7.2
> -  
> vdr-1.7.2-h264-syncearly-framespersec-audioindexer-fielddetection-speedup.diff
> - vdr172_v4ldvb_2g_modulation_support.patch (attached)
> - streamdev plugin
>
> I can only watch those channels that I have previously tuned with szap or
> szap2 or vdr.1.6.0? If it works for you, what other cards than hvr-4000
> you have simultaneously connected and does the hvr-4000 be
> /dev/dvb/adapter0 or 1? (for me it's adapter1)
>

I've tried clean vdr 1.7.2 (without patches) and it doesn't work (works sometimes).
When I try to change channels in vdr 1.7.2 I see in log:
Jan  4 13:57:43 blackbox vdr: [3250] frontend 0 lost lock on channel 437, tp 110743               
Jan  4 13:57:45 blackbox vdr: [3250] frontend 0 timed out while tuning to channel 437, tp 110743

Btw I don't use hvr-4000 I have only one TeVii S460 DVB-S/S2 card.

But vdr 1.6 works

Roman

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
