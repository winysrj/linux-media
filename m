Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:51526
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZK3Eup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 23:50:45 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <D9ED2E54-7B65-4841-AADF-110C8E51DD0E@gmail.com>
Date: Sun, 29 Nov 2009 23:50:45 -0500
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Andy Walls <awalls@radix.net>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	"j@jannau.net" <j@jannau.net>,
	"jarod@redhat.com" <jarod@redhat.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"maximlevitsky@gmail.com" <maximlevitsky@gmail.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"stefanr@s5r6.in-berlin.de" <stefanr@s5r6.in-berlin.de>,
	"superm1@ubuntu.com" <superm1@ubuntu.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <AFCCABA5-177F-4FA5-827E-BFF216510943@wilsonet.com>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc> <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> <m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com> <1259450815.3137.19.camel@palomino.walls.org> <m3ocml6ppt.fsf@intrepid.localdomain> <D9ED2E54-7B65-4841-AADF-110C8E51DD0E@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 29, 2009, at 4:31 PM, Dmitry Torokhov wrote:

> On Nov 29, 2009, at 12:27 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> 
>> 1. Do we agree that a lirc (-style) kernel-user interface is needed at
>>  least?
>> 
>> 2. Is there any problem with lirc kernel-user interface?
>> 
>> If the answer for #1 is "yes" and for #2 is "no" then perhaps we merge
>> the Jarod's lirc patches (at least the core) so at least the
>> non-controversial part is done?
> 
> 
> Isn't the meat of Jarod's patch the lirc interface?

Patch 1 was the lirc interface, 2 and 3 are individual device drivers that use it.

/me has some catching up to do on this thread after being partially detached from the computer over the holiday weekend here in the US...

-- 
Jarod Wilson
jarod@wilsonet.com



