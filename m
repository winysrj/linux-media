Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58845 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0FAQkh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 12:40:37 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OJUW3-0004Je-S9
	for linux-media@vger.kernel.org; Tue, 01 Jun 2010 18:40:35 +0200
Received: from 151.82.2.202 ([151.82.2.202])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 01 Jun 2010 18:40:35 +0200
Received: from francescolavra by 151.82.2.202 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 01 Jun 2010 18:40:35 +0200
To: linux-media@vger.kernel.org
From: Francesco Lavra <francescolavra@interfree.it>
Subject: Re: 2.6.35-rc1 fails to boot: OOPS in =?utf-8?b?aXJfcmVnaXN0ZXJfY2xhc3M=?=
Date: Tue, 1 Jun 2010 16:40:26 +0000 (UTC)
Message-ID: <loom.20100601T183044-479@post.gmane.org>
References: <201006010847.34422.martin.dauskardt@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin Dauskardt <martin.dauskardt <at> gmx.de> writes:

> 
> It's sad that this bug has gone into 2.6.35-rc1.
> 
> I already reported it on 24.05.2010: 
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/19564/
> Unfortunately it didn't get any attention, which makes me a little bit
depressive...
> 
> What is the right way to report bugs if code is still in linux-next, but not
in a release candidate? 
> Should I make an entry in https://bugzilla.kernel.org/? 
> Or ist this list the right place to report it?

This list is the right place to report such bugs.
If in your report you had said the problem was present in linux-next, I think
this bug would have gotten more attention and wouldn't have made it to
2.6.35-rc1 :)

Francesco


