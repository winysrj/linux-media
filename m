Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:50834 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab0DQVB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 17:01:28 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Vidar Tyldum Hansen <vidar@tyldum.com>
Cc: linux-media@vger.kernel.org
Subject: Re: mantis crashes
References: <20100413150153.GB11631@mail.tyldum.com>
	<87ochne35i.fsf@nemi.mork.no> <20100413165616.GC11631@mail.tyldum.com>
	<loom.20100414T133315-652@post.gmane.org>
	<20100417054749.GA6067@mail.tyldum.com>
Date: Sat, 17 Apr 2010 23:01:20 +0200
In-Reply-To: <20100417054749.GA6067@mail.tyldum.com> (Vidar Tyldum Hansen's
	message of "Sat, 17 Apr 2010 07:47:49 +0200")
Message-ID: <87aat1dc9r.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vidar Tyldum Hansen <vidar@tyldum.com> writes:

> Things left to try hardware-wise is to switch to a different PCI slot,
> but I guess I'll go down the new kernel route... I'll have to do some
> research regarding v4l versions in .31, .32 and .33 to figure out to
> which kernel I can 'backport' mantis without replacing v4l completely.

I attached a patch for 2.6.32 to http://bugs.debian.org/577264

This keeps most of the existing DVB subsystem intact, only adding new
files with the exception of the necessary one-liner in tda10021.c to
avoid unwanted binding to tda10023.

I based the patch on the driver in 2.6.34-rc4, but updating it with
newer versions should be trivial.


Bjørn
