Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JV9JE-0005Nr-WF
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 18:46:14 +0100
Received: by rv-out-0910.google.com with SMTP id b22so3289094rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 09:46:08 -0800 (PST)
Message-ID: <d9def9db0802290946x4e92c810l4ad2ad605aa29b00@mail.gmail.com>
Date: Fri, 29 Feb 2008 18:46:08 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <47C84079.6060203@powercraft.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C83611.1040805@powercraft.nl>
	<d9def9db0802290848v100ca9dcm22292e368bec4ad5@mail.gmail.com>
	<47C83919.4010102@powercraft.nl>
	<d9def9db0802290901v74aa7889oab2b6e4c22057f@mail.gmail.com>
	<47C84079.6060203@powercraft.nl>
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
> > On 2/29/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> >> Markus Rechberger wrote:
> >>> Hi Jelle,
> >>>
> >>> On 2/29/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> >>>> This message contains the following attachment(s):
> >>>> Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
> >>>>
> >>> the correct mailinglist for those devices is em28xx at mcentral dot de
> >>>
> >>> I added some comments below and prefixed them with /////////
> >>>
> >>> This message contains the following attachment(s):
> >>> Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
> >>>
> >> We will get it working in the next few days, i am already working on a
> >> user guide. I will add the comments to the new version, i just thought
> >> release as soon as possible, dont want somebody else to spent hours and
> >> hours of his day installing your nice driver.
> >>
> >> Nice, I was working on building tvtime but it gave me errors,
> >>
> >
> > libasound2-dev and the linux kernel headers or at least a symlink from
> > /usr/include/linux -> kernelroot/include/linux is missing.
> >
> > It would be nice if you can create a howto on mcentral.de! I'm sure it
> > might help some people. My guide only explains how to compile it on a
> > already set up system (and this can differ with every distribution).
> >
> > I will release precompiled packages for the eeePC within the next few
> > days. I just need to package the binaries for it.
> > I added tvtime, gqradio and kaffeine buttons to my eeePC and
> > everything works really well.
> > I'll focus on ATSC devices next week (after the cebit)
> >
> > thanks for the howto so far!
> >
> > Markus
>
> I will work on the docu you on the nice code :-p
>
> Just one thing how to fix the below? Than we can release a first draft.
> We need a group that is compatiable with udev and the driver, so that we
> can do adduser $USER $GROUP to give premissions to use the devices
>

feel free to work on it, if you have some patches to apply for the
build.sh scripts just submit them :)

> # to-do:
> # howto add group for created devices so that all users in that group
> can use the devices?
>
> oja also i cant get /dev/vdi0 working
>

the vbi interface was only tested with osc which is part of the
libzvbi package. There's currently no application available which
works with the vbi interface, it needs some more fiddling around with
the libzvbi library.
This is a topic which has a lower priority since other parts have to
be improved first..
Patches in that area are welcome of course.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
