Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0JLNu3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 09:50:29 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9CDoTLA009682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 12 Oct 2010 09:50:29 -0400
Date: Tue, 12 Oct 2010 09:50:28 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [GIT PULL REQUEST] IR patches for 2.6.37-rc1
Message-ID: <20101012135028.GF4057@redhat.com>
References: <20101008214407.GI5165@redhat.com>
 <AANLkTimezuonksK=wW1PAkW40oo-KPRMrVdoNxymK69f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimezuonksK=wW1PAkW40oo-KPRMrVdoNxymK69f@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Oct 09, 2010 at 02:23:15PM -0400, Jarod Wilson wrote:
> On Fri, Oct 8, 2010 at 5:44 PM, Jarod Wilson <jarod@redhat.com> wrote:
> > Hey Mauro,
> >
> > I've queued up some lirc fixes and a couple of patches that add a new
> > ir-core driver for the Nuvoton w836x7hg Super I/O integrated CIR
> > functionality. All but the Kconfig re-sorting patch have been posted to
> > linux-media for review, but I'm hoping they can all get merged in time for
> > the 2.6.37-rc1 window, and any additional review feedback can be taken
> > care of with follow-up patches.
> >
> > The following changes since commit b9a1211dff08aa73fc26db66980ec0710a6c7134:
> >
> >  V4L/DVB: Staging: cx25821: fix braces and space coding style issues (2010-10-07 15:37:27 -0300)
> 
> Minor update to the pull req to fully wire up compat ioctls and fixup
> some error messages in lirc_dev:
> 
> The following changes since commit 81d64d12e11a3cca995e6c752e4bd2898959ed0a:
> 
>   V4L/DVB: cx231xx: remove some unused functions (2010-10-07 21:05:52 -0300)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-lirc.git staging

Just tacked on two minor streamzap patches, including the one from Dan
Carpenter that fixes an overflow with timeout values. The other streamzap
patch just makes Dan's patch not create a line > 80 chars, more or less
(renames STREAMZAP_FOO defines to SZ_FOO).

Dan Carpenter (1):
      [patch -next] V4L/DVB: IR/streamzap: fix usec to nsec conversion

Jarod Wilson (8):
      IR: add driver for Nuvoton w836x7hg integrated CIR
      nuvoton-cir: add proper rx fifo overrun handling
      IR/Kconfig: sort hardware entries alphabetically
      IR/lirc: further ioctl portability fixups
      staging/lirc: ioctl portability fixups
      lirc: wire up .compat_ioctl to main ioctl handler
      lirc_dev: fixup error messages w/missing newlines
      IR/streamzap: shorten up some define names for readability


-- 
Jarod Wilson
jarod@redhat.com

