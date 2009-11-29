Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:42287 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZK2Vbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 16:31:51 -0500
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc> <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> <m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com> <1259450815.3137.19.camel@palomino.walls.org> <m3ocml6ppt.fsf@intrepid.localdomain>
Message-Id: <D9ED2E54-7B65-4841-AADF-110C8E51DD0E@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <m3ocml6ppt.fsf@intrepid.localdomain>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
Date: Sun, 29 Nov 2009 13:31:46 -0800
Cc: Andy Walls <awalls@radix.net>, Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	"j@jannau.net" <j@jannau.net>,
	"jarod@redhat.com" <jarod@redhat.com>,
	"jarod@wilsonet.com" <jarod@wilsonet.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"maximlevitsky@gmail.com" <maximlevitsky@gmail.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"stefanr@s5r6.in-berlin.de" <stefanr@s5r6.in-berlin.de>,
	"superm1@ubuntu.com" <superm1@ubuntu.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 29, 2009, at 12:27 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:

> 1. Do we agree that a lirc (-style) kernel-user interface is needed at
>   least?
>
> 2. Is there any problem with lirc kernel-user interface?
>
> If the answer for #1 is "yes" and for #2 is "no" then perhaps we merge
> the Jarod's lirc patches (at least the core) so at least the
> non-controversial part is done?


Isn't the meat of Jarod's patch the lirc interface?

-- 
>

Dmitry
