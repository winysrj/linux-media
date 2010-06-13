Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58185 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753765Ab0FMPXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 11:23:13 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Date: Sun, 13 Jun 2010 17:22:41 +0200
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	"Christian Kujau" <lists@nerdbynature.de>,
	"Michael Ellerman" <michael@ellerman.id.au>,
	linux-media@vger.kernel.org, mchehab@infradead.org
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera> <YPGdyfWGvNK.A.C8B.d9OFMB@chimera>
In-Reply-To: <YPGdyfWGvNK.A.C8B.d9OFMB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006131722.44062.s.L-H@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Sunday 13 June 2010, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
> Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> Date		: 2010-03-13 23:53 (93 days old)
> Message-ID	: <<alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>>
> References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2
> Handled-By	: Michael Ellerman <michael@ellerman.id.au>
> Patch		: http://patchwork.ozlabs.org/patch/52978/

Still existing in 2.6.34 and 2.6.35 HEAD, however a patch fixing the issue 
for b2c2-flexcop/ flexcop-pci has been posted last week:
	From:		Jindřich Makovička <makovick@gmail.com>
	Subject:		[PATCH] DVB flexcop-pci: sanitize driver name to avoid warning on load
	Date:		Mon, 7 Jun 2010 14:51:30 +0200
	Message-ID:	<AANLkTikNcCtUn9SQwKu2b3IE6NiAwAhciHsm1HVH4EJh@mail.gmail.com>
	URL:			http://lkml.indiana.edu/hypermail/linux/kernel/1006.0/00137.html

Regards
	Stefan Lippers-Hollmann
