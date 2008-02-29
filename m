Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JV8bw-0001tq-FA
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 18:01:28 +0100
Received: by wr-out-0506.google.com with SMTP id 68so6218549wra.13
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 09:01:24 -0800 (PST)
Message-ID: <d9def9db0802290901v74aa7889oab2b6e4c22057f@mail.gmail.com>
Date: Fri, 29 Feb 2008 18:01:23 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <47C83919.4010102@powercraft.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C83611.1040805@powercraft.nl>
	<d9def9db0802290848v100ca9dcm22292e368bec4ad5@mail.gmail.com>
	<47C83919.4010102@powercraft.nl>
Cc: linux-dvb <linux-dvb@linuxtv.org>, em28xx@mcentral.de
Subject: Re: [linux-dvb] Pinnacle PCTV Hybrid Pro Stick 330e - Installation
	Guide - v0.1.2j
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

On 2/29/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> Markus Rechberger wrote:
> > Hi Jelle,
> >
> > On 2/29/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> >> This message contains the following attachment(s):
> >> Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
> >>
> >
> > the correct mailinglist for those devices is em28xx at mcentral dot de
> >
> > I added some comments below and prefixed them with /////////
> >
> > This message contains the following attachment(s):
> > Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
> >
>
> We will get it working in the next few days, i am already working on a
> user guide. I will add the comments to the new version, i just thought
> release as soon as possible, dont want somebody else to spent hours and
> hours of his day installing your nice driver.
>
> Nice, I was working on building tvtime but it gave me errors,
>

libasound2-dev and the linux kernel headers or at least a symlink from
/usr/include/linux -> kernelroot/include/linux is missing.

It would be nice if you can create a howto on mcentral.de! I'm sure it
might help some people. My guide only explains how to compile it on a
already set up system (and this can differ with every distribution).

I will release precompiled packages for the eeePC within the next few
days. I just need to package the binaries for it.
I added tvtime, gqradio and kaffeine buttons to my eeePC and
everything works really well.
I'll focus on ATSC devices next week (after the cebit)

thanks for the howto so far!

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
