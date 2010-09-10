Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab0IJCBv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 22:01:51 -0400
Date: Thu, 9 Sep 2010 22:01:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8 V5] Many fixes for in-kernel decoding and for the ENE
 driver
Message-ID: <20100910020129.GA26845@redhat.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
 <4C8805FA.3060102@infradead.org>
 <20100908224227.GL22323@redhat.com>
 <AANLkTikBVSYpD_+qomCad-OvXg6CRam4b01wSBV-pNw8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikBVSYpD_+qomCad-OvXg6CRam4b01wSBV-pNw8@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, Sep 09, 2010 at 12:34:27AM -0400, Jarod Wilson wrote:
...
> >> For now, I've applied patches 3, 4 and 5, as it is nice to have Jarod's review also.
> >
> > I've finally got them all applied atop current media_tree staging/v2.6.37,
> > though none of the streamzap bits in patch 7 are applicable any longer.
> > Will try to get through looking and commenting (and testing) of the rest
> > of them tonight.
> 
> Also had to make a minor addition to the rc5-sz decoder (same change
> as in the other decoders). Almost have all the requisite test kernels
> for David's, Maxim's and Dmitry's patchsets built and installed, wish
> my laptop was faster... Probably would have been faster to use a lab
> box and copy data over. Oh well. So functional testing to hopefully
> commence tomorrow morning.

Wuff. None of the three builds is at all stable on my laptop, but I can't
actually point the finger at any of the three patchsets, since I'm getting
spontaneous lockups doing nothing at all before even plugging in a
receiver. I did however get occasional periods of a non-panicking (not
starting X seems to help a lot). Initial results:

Dmitry's patchset:
- all good for imon, streamzap and mceusb

David's patchset:
- all good for mceusb, as expected, since David has mce hardware himself,
  did not try the others yet

Maxim's patchset:
- all good for mceusb and imon
- streamzap decoding fails miserably. I have an inkling why, but will need
  to get a stable testing platform before I can really properly dig into
  it.

Still working on that stable testing platform, which is "backport current
ir-core to the latest Fedora 14 kernel", which is 2.6.35.4-based and
rock-solid on this machine. After that, will start applying patchsets.

(I have yet to really look at the lockups, they look like random memory
corruption though).

-- 
Jarod Wilson
jarod@redhat.com

