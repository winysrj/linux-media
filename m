Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:16495 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1JRWg1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 18:36:27 -0400
Date: Wed, 19 Oct 2011 01:33:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: devel@driverdev.osuosl.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Piotr Chmura <chmooreck@poczta.onet.pl>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/14] staging/media/as102: initial import from Abilis
Message-ID: <20111018223318.GC24215@longonot.mountain>
References: <20110927213300.6893677a@stein>
 <4E999733.2010802@poczta.onet.pl>
 <4E99F2FC.5030200@poczta.onet.pl>
 <20111016105731.09d66f03@stein>
 <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
 <4E9ADFAE.8050208@redhat.com>
 <20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
 <20111018111134.8482d1f8.chmooreck@poczta.onet.pl>
 <20111018162423.GA24215@longonot.mountain>
 <4E9DABA3.1070609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9DABA3.1070609@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 18, 2011 at 02:38:59PM -0200, Mauro Carvalho Chehab wrote:
> > It would be better to separate these two chunks out and put them at
> > the end after you've fixed the compile errors in [PATCH 13/14].
> 
> This doesn't really matter, as the driver won't be added to the Kernel building system
> before patch 13/14, as drivers/staging/Makefile wasn't touch on patch 1/14.

Ah sorry.  My bad.

regards,
dan carpenter
