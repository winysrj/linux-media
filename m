Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:51118 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3HVSXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 14:23:38 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRY00GN932402C0@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Aug 2013 14:23:37 -0400 (EDT)
Date: Thu, 22 Aug 2013 15:23:31 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Javier =?UTF-8?B?QsO6Y2Fy?= <jbucar@lifia.info.unlp.edu.ar>
Cc: Luis Polasek <lpolasek@gmail.com>,
	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick BOETTCHER <patrick.boettcher@parrot.com>
Subject: Re: dib8000 scanning not working on 3.10.3
Message-id: <20130822152331.6e186acd@samsung.com>
In-reply-to: <CAJmEX9B=VAEXSto2omRTNcgVdX7akDBUAhJs7nwPUc9xhqFBbg@mail.gmail.com>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
 <20130801163624.GA10498@localhost> <20130801141518.258ff0a3@samsung.com>
 <CAER7dwe9biLNZKtW6xQmD8J0Qmh4dMTi=chpUuQ_Dq5KKxJ5UQ@mail.gmail.com>
 <20130805172605.1ba32958@samsung.com>
 <CAER7dwcDxa4=i453tOU21ZJP9Opd01mZ-QYrLpQTcgB_yU4B+Q@mail.gmail.com>
 <CAJmEX9B=VAEXSto2omRTNcgVdX7akDBUAhJs7nwPUc9xhqFBbg@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 22 Aug 2013 14:47:33 -0300
Javier Búcar <jbucar@lifia.info.unlp.edu.ar> escreveu:

> Hello Mauro, we have the bad commit:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=173a64cb3fcff1993b2aa8113e53fd379f6a968f
> 
> This is a very big commit. I don't known where to fix it. Can you help
> me on fixing it

Hmm.... So, the error is on this patch?

	author	Patrick Boettcher <pboettcher@kernellabs.com>	2013-04-22 15:45:52 (GMT)
	[media] dib8000: enhancement

	The intend of this patch is to improve the support of the dib8000. 

	Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com> 
	Signed-off-by: Patrick Boettcher <patrick.boettcher@parrot.com> 
	Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com> 

If so, then we need either Olivier or Patrick's help, as I don't have any
documentation about the dib8000 chips.

You can still take a look there at the code that checks for the
chipset version, like:
	if (state->revision == 0x8090) {
		<some code for newer version>
	} else {
		<some code for the old version>
	}

If the code for the old version remains the same as before the patch.
Where it doesn't remains the same, then it could be the source of the
troubles.

I suggest you to check what state->revision shows on your specific device,
in order to do such analysis.

I'll try latter to do some tests with the devices I have, but this could
take some time, as I'm really busy those days.

Regards,
Mauro


> Thanks in advance
> Javier
> 
> On Wed, Aug 7, 2013 at 3:48 PM, Luis Polasek <lpolasek@gmail.com> wrote:
> > Hi again Mauro, reverting both commits:
> >
> > *  59501bb792c66b85fb7fdbd740e788e3afc70bbd
> > *  f45f513a9325b52a5f3e26ee8d15471e8b692947
> >
> > The problem still exists, I am unable to get any result, and also no
> > error logs) :(
> >
> > What shall I do to try to fix this ? Do you need more info on my current setup.
> >
> > Thanks in advance and best regards...
> >
> > On Mon, Aug 5, 2013 at 5:26 PM, Mauro Carvalho Chehab
> > <m.chehab@samsung.com> wrote:
> >> Em Mon, 05 Aug 2013 16:09:56 -0300
> >> Luis Polasek <lpolasek@gmail.com> escreveu:
> >>
> >>> Hi Mauro, I have tested using dvb5-scan, and the results are the same (no
> >>> results, and no error logs) :(
> >>>
> >>>  Do you have any clue why it is not working with this kernel version ?
> >>
> >> c/c Oliver and Patrick, who maintains this driver
> >>
> >> There were a recent change on this driver, in order to support some newer
> >> versions of this chipset. Perhaps those changes broke it for you.
> >>
> >> commit 59501bb792c66b85fb7fdbd740e788e3afc70bbd
> >> Author: Olivier Grenie <olivier.grenie@parrot.com>
> >> Date:   Mon Dec 31 09:51:17 2012 -0300
> >>
> >>     [media] dib7090p: improve the support of the dib7090 and dib7790
> >>
> >>     The intend of this patch is to improve the support of the dib7090 and
> >>     dib7790. The AGC1 min value is set to 32768 by default. The actual AGC1 min
> >>     and the external attenuation are controled depending on the received RF
> >>     level.
> >>
> >>     Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
> >>     Signed-off-by: Patrick Boettcher <patrick.boettcher@parrot.com>
> >>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >> commit f45f513a9325b52a5f3e26ee8d15471e8b692947
> >> Author: Olivier Grenie <olivier.grenie@parrot.com>
> >> Date:   Mon Dec 31 09:47:10 2012 -0300
> >>
> >>     [media] dib7090p: remove the support for the dib7090E
> >>
> >>     The intend of this patch is to remove the support for the dib7090E. The
> >>     DiB7090E-package has never left prototype state and never made it to
> >>     mass-prod-state.
> >>
> >>     Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
> >>     Signed-off-by: Patrick Boettcher <patrick.boettcher@parrot.com>
> >>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >> Could you please revert those patches and see if they fix the issue?
> >> Please try to revert this one first:
> >>         http://git.linuxtv.org/media_tree.git/commitdiff_plain/59501bb792c66b85fb7fdbd740e788e3afc70bbd
> >>
> >> If this doesn't solve, try to revert just this one:
> >>         http://git.linuxtv.org/media_tree.git/commitdiff_plain/f45f513a9325b52a5f3e26ee8d15471e8b692947
> >>
> >> then, try to revert both.
> >>
> >> AFAIKT, those are the only changes that may be affecting isdb-t on dib8000
> >> driver.
> >>
> >> Thanks!
> >> Mauro
> >>
> >>>
> >>> Thanks and regards...
> >>>
> >>>
> >>> On Thu, Aug 1, 2013 at 2:15 PM, Mauro Carvalho Chehab
> >>> <m.chehab@samsung.com>wrote:
> >>>
> >>> > Em Thu, 1 Aug 2013 13:36:25 -0300
> >>> > Ezequiel Garcia <ezequiel.garcia@free-electrons.com> escreveu:
> >>> >
> >>> > > Hi Luis,
> >>> > >
> >>> > > (I'm Ccing Mauro, who mantains this driver and might know what's going
> >>> > on).
> >>> > >
> >>> > > On Wed, Jul 31, 2013 at 03:47:10PM -0300, Luis Polasek wrote:
> >>> > > > Hi, I just upgraded my kernel to 3.10.3, and dib8000 scanning does not
> >>> > > > work anymore.
> >>> > > >
> >>> > > > I tested using dvbscan (from dvb-apps/util/) and w_scan on a Prolink
> >>> > > > Pixelview SBTVD (dib8000 module*).This tools worked very well on
> >>> > > > version 3.9.9 , but now it does not produces any result, and also
> >>> > > > there are no error messages in the logs (dmesg).
> >>> > > >
> >>> > >
> >>> > > Please run a git bisect and report your findings.
> >>> > >
> >>> > > Note that dibcom8000 shows just a handful of commit on 2013,
> >>> > > so you could start reverting those and see what happens.
> >>> >
> >>> > Perhaps it is a failure at the DVBv3 emulation.
> >>> >
> >>> > Did it also break using dvbv5-scan (part of v4l-utils)?
> >>> >
> >>> > Regards,
> >>> > Mauro
> >>> > --
> >>> >
> >>> > Cheers,
> >>> > Mauro
> >>> >
> >>
> >>
> >> --
> >>
> >> Cheers,
> >> Mauro


-- 

Cheers,
Mauro
