Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.jarosz@gmail.com>) id 1LJQfr-0002xx-L0
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 11:57:40 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2516998fga.25
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 02:57:36 -0800 (PST)
Date: Sun, 04 Jan 2009 11:58:07 +0100
To: linux-dvb@linuxtv.org
From: "Roman Jarosz" <roman.jarosz@gmail.com>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com> <20090104111429.1f828fc8@bk.ru>
Message-ID: <op.um8be5xvrj95b0@localhost>
In-Reply-To: <20090104111429.1f828fc8@bk.ru>
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

On Sun, 04 Jan 2009 09:14:29 +0100, Goga777 <goga777@bk.ru> wrote:

>> I would suggest not using S2API as it's seems to be broken for our card
>> at this time,
>
> why do you think so ?
>
>> I did test steven s2 repo which is better that all other
>> S2API repo
>
> have you tested http://mercurial.intuxication.org/hg/s2-liplianin ?
>
>> I have tested but still worse than lipliandvb (multiproto
>> hg).
>
> please try
>
> http://mercurial.intuxication.org/hg/s2-liplianin (yesterday Igor  
> synchronized it with current v4l-dvb)
> +
> http://hg.kewl.org/dvb2010/ - new dvb scaner
>
> for me everything is working without any problem with my hvr4000. Also  
> patched vdr 170 works well with s2api

Wow that worked, thanks.
I've installed s2-liplianin and now scan and scan-s2 and http://hg.kewl.org/dvb2010/ works :)
Vdr 1.6.0 works too :)

Thank you all for your help. I hope that it will make it in kernel 2.6.29 :)

Regards,
Roman


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
