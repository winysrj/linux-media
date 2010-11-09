Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40786 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab0KIK1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 05:27:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 09 Nov 2010 11:27:40 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>, <jarod@wilsonet.com>
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
In-Reply-To: <20101102201733.12010.30019.stgit@localhost.localdomain>
References: <20101102201733.12010.30019.stgit@localhost.localdomain>
Message-ID: <66b8b2f940b40cc67fa95c3ae064ef91@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 02 Nov 2010 21:17:38 +0100, David Härdeman <david@hardeman.nu>
wrote:
> This is my current patch queue, the main change is to make struct rc_dev
> the primary interface for rc drivers and to abstract away the fact that
> there's an input device lurking in there somewhere.

Mauro,

you have neither commented on the patches nor committed them. At the same
time you've created a "for_v2.6.38" branch where you've already committed
other IR related patches. Could you please provide some feedback on what
the plan is?

-- 
David Härdeman
