Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43797 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbZAUIfE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 03:35:04 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LPYYA-0008CW-Rh
	for linux-media@vger.kernel.org; Wed, 21 Jan 2009 08:35:02 +0000
Received: from vax.chrillesen.dk ([193.88.12.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 08:35:02 +0000
Received: from free_beer_for_all by vax.chrillesen.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 08:35:02 +0000
To: linux-media@vger.kernel.org
From: Barry Bouwsma <free_beer_for_all@yahoo.com>
Subject: Re: Siano's patches
Date: Mon, 19 Jan 2009 15:33:58 +0000 (UTC)
Message-ID: <gl26h5$al6$1@ger.gmane.org>
References: <244108.33255.qm@web110806.mail.gq1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(Oops, looks like I'm losing references, sorry)

Uri wrote...

>Siano added some kernel support (tiny sub system) and user-space library.
>The kernel code is of course GPLv2.
>*Everything* is available to *all*, include detailed documentation. You can see
> on the ML some recent posts about it (people who use it to get DAB streams wit
>h very little effort).

Of course, I'm assuming this user-space library is a substitute
for a full-fledged API, and exists to give end-users the
ability to at least make more use of their hardware than is
presently possible with the lack-of-API.

I'm happy to be able to tune DAB, though the library functionality
is limited and essentially it's like a computer-interface to an
ordinary desktop DAB radio, with the benefit of getting the actual
payload, or something resembling it (the original DAB error-
detection and -correction leaves much to be desired).  That
would be fine for the majority of users, I expect, but as you
noted, with this library it's not possible to get at the raw
ensemble data for whatever reason, study of the data within,
and the like.

So it seems this is somewhat like the `dabusb' source that
already exists for one specific receiver, neither of which
are a good basis for starting on an API, but which at least
bring something to the end-user who today, due to lack of a
common API to get access to DAB/DAB+ and the many other
widespread standards that Uri mentioned, but which, sadly,
so far few companies are producing hardware for, that can
be used in a generic Linux box, what a run-on sentence this
is, and I've forgotten my point already.


barry bouwsma
speaking of regressions, either someone broke the 44BSD
UFS filesystem in the latest kernel I'm working with, or
I've hosed more superblocks in my attempt to upgrade.
And I'd rather be spending my time trying to figure out
why I'm not getting the clean DAB reception I expect,
having eliminated some faulty hardware I haven't been
able to test until now...


