Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55714 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0IMRsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 13:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <20100908153435.GA4190@core.coreip.homeip.net>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
	<20100908143121.GD22323@redhat.com>
	<20100908153435.GA4190@core.coreip.homeip.net>
Date: Mon, 13 Sep 2010 13:48:14 -0400
Message-ID: <AANLkTikV9jWWPhK0C-1ipFei18pHUg86Yj1Pm10010An@mail.gmail.com>
Subject: Re: [PATCH 0/6] Large scancode handling
From: Jarod Wilson <jarod@wilsonet.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Sep 8, 2010 at 11:34 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Sep 08, 2010 at 10:31:21AM -0400, Jarod Wilson wrote:
>> On Wed, Sep 08, 2010 at 12:41:38AM -0700, Dmitry Torokhov wrote:
...
>> > Ville, do you still have the hardware to try our ati_remote2 changes?
>>
>> If not, I've got the hardware. (Speaking of which, porting ati_remote*
>> over to {ir,rc}-core is also on the TODO list, albeit with very very
>> low priority at the moment).
>
> Ok, then we'' pencil you in for testing if we do not hear from Ville ;)

We've heard from Ville, but I went ahead and did some testing anyway.
My RWII with the default mode (didn't try any of the others) works
just fine after applying this patch atop 2.6.36-rc3-git1, as do my
imon and mceusb receivers. Ran into some problems with streamzap, but
I'm fairly sure they're not the fault of this patchset.

-- 
Jarod Wilson
jarod@wilsonet.com
