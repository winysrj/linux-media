Return-path: <linux-media-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:38894 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbZLHQXI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 11:23:08 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Andy Walls <awalls@radix.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <4B0E8B32.3020509@redhat.com>
	<1259264614.1781.47.camel@localhost>
	<6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com>
	<1260240142.3086.14.camel@palomino.walls.org>
	<20091208042210.GA11147@core.coreip.homeip.net>
	<1260275743.3094.6.camel@palomino.walls.org>
	<4B1E54FF.8060404@redhat.com>
	<9e4733910912080547j75c2c885o29664470ff5e2c6a@mail.gmail.com>
	<4B1E5BDF.7010202@redhat.com>
	<9e4733910912080619t36089c9bg5e54114844b9694a@mail.gmail.com>
	<4B1E640B.6030705@redhat.com>
Date: Tue, 08 Dec 2009 17:22:49 +0100
In-Reply-To: <4B1E640B.6030705@redhat.com> (Mauro Carvalho Chehab's message of
	"Tue, 08 Dec 2009 12:34:51 -0200")
Message-ID: <87ocm9wi3q.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> Jon Smirl wrote:
>
>> This model is complicated by the fact that some remotes that look
>> like multi-function remotes aren't really multifunction. The remote
>> bundled with the MS MCE receiver is one. That remote is a single
>> function device even though it has function buttons for TV, Music,
>> Pictures, etc.
>
> An unsolved question on my mind is how should we map such IR's? Should
> we provide a way for them to emulate a multifunction IR (for example,
> after pressing TV key, subsequent keystrokes would be directed to the
> TV evdev device?), or should we let this up to some userspace app to
> handle this case?

This case feels similar to that of Caps Lock, Num Lock and Scrool Lock,
but I don't know if that scheme could be applied here.
-- 
Regards,
Feri.
