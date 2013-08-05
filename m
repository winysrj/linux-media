Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:34023 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3HEU0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 16:26:13 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR2002A3RDLWR90@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Aug 2013 16:26:11 -0400 (EDT)
Date: Mon, 05 Aug 2013 17:26:05 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Luis Polasek <lpolasek@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	linux-media@vger.kernel.org,
	"jbucar@lifia.info.unlp.edu.ar" <jbucar@lifia.info.unlp.edu.ar>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick BOETTCHER <patrick.boettcher@parrot.com>
Subject: Re: dib8000 scanning not working on 3.10.3
Message-id: <20130805172605.1ba32958@samsung.com>
In-reply-to: <CAER7dwe9biLNZKtW6xQmD8J0Qmh4dMTi=chpUuQ_Dq5KKxJ5UQ@mail.gmail.com>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
 <20130801163624.GA10498@localhost> <20130801141518.258ff0a3@samsung.com>
 <CAER7dwe9biLNZKtW6xQmD8J0Qmh4dMTi=chpUuQ_Dq5KKxJ5UQ@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 05 Aug 2013 16:09:56 -0300
Luis Polasek <lpolasek@gmail.com> escreveu:

> Hi Mauro, I have tested using dvb5-scan, and the results are the same (no
> results, and no error logs) :(
> 
>  Do you have any clue why it is not working with this kernel version ?

c/c Oliver and Patrick, who maintains this driver

There were a recent change on this driver, in order to support some newer
versions of this chipset. Perhaps those changes broke it for you.

commit 59501bb792c66b85fb7fdbd740e788e3afc70bbd
Author: Olivier Grenie <olivier.grenie@parrot.com>
Date:   Mon Dec 31 09:51:17 2012 -0300

    [media] dib7090p: improve the support of the dib7090 and dib7790
    
    The intend of this patch is to improve the support of the dib7090 and
    dib7790. The AGC1 min value is set to 32768 by default. The actual AGC1 min
    and the external attenuation are controled depending on the received RF
    level.
    
    Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
    Signed-off-by: Patrick Boettcher <patrick.boettcher@parrot.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit f45f513a9325b52a5f3e26ee8d15471e8b692947
Author: Olivier Grenie <olivier.grenie@parrot.com>
Date:   Mon Dec 31 09:47:10 2012 -0300

    [media] dib7090p: remove the support for the dib7090E
    
    The intend of this patch is to remove the support for the dib7090E. The
    DiB7090E-package has never left prototype state and never made it to
    mass-prod-state.
    
    Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
    Signed-off-by: Patrick Boettcher <patrick.boettcher@parrot.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Could you please revert those patches and see if they fix the issue?
Please try to revert this one first:
	http://git.linuxtv.org/media_tree.git/commitdiff_plain/59501bb792c66b85fb7fdbd740e788e3afc70bbd

If this doesn't solve, try to revert just this one:
	http://git.linuxtv.org/media_tree.git/commitdiff_plain/f45f513a9325b52a5f3e26ee8d15471e8b692947

then, try to revert both.

AFAIKT, those are the only changes that may be affecting isdb-t on dib8000
driver.

Thanks!
Mauro

> 
> Thanks and regards...
> 
> 
> On Thu, Aug 1, 2013 at 2:15 PM, Mauro Carvalho Chehab
> <m.chehab@samsung.com>wrote:
> 
> > Em Thu, 1 Aug 2013 13:36:25 -0300
> > Ezequiel Garcia <ezequiel.garcia@free-electrons.com> escreveu:
> >
> > > Hi Luis,
> > >
> > > (I'm Ccing Mauro, who mantains this driver and might know what's going
> > on).
> > >
> > > On Wed, Jul 31, 2013 at 03:47:10PM -0300, Luis Polasek wrote:
> > > > Hi, I just upgraded my kernel to 3.10.3, and dib8000 scanning does not
> > > > work anymore.
> > > >
> > > > I tested using dvbscan (from dvb-apps/util/) and w_scan on a Prolink
> > > > Pixelview SBTVD (dib8000 module*).This tools worked very well on
> > > > version 3.9.9 , but now it does not produces any result, and also
> > > > there are no error messages in the logs (dmesg).
> > > >
> > >
> > > Please run a git bisect and report your findings.
> > >
> > > Note that dibcom8000 shows just a handful of commit on 2013,
> > > so you could start reverting those and see what happens.
> >
> > Perhaps it is a failure at the DVBv3 emulation.
> >
> > Did it also break using dvbv5-scan (part of v4l-utils)?
> >
> > Regards,
> > Mauro
> > --
> >
> > Cheers,
> > Mauro
> >


-- 

Cheers,
Mauro
