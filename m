Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab0IHXPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 19:15:00 -0400
Message-ID: <4C8818F0.6060201@redhat.com>
Date: Wed, 08 Sep 2010 20:14:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 4/6] Input: winbond-cir - switch to using new keycode
 interface
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv> <20100908074200.32365.98120.stgit@hammer.corenet.prv> <20100908211617.GB13938@hardeman.nu> <20100908230003.GB9405@core.coreip.homeip.net> <20100908230946.GB7121@hardeman.nu>
In-Reply-To: <20100908230946.GB7121@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 08-09-2010 20:09, David Härdeman escreveu:
> On Wed, Sep 08, 2010 at 04:00:04PM -0700, Dmitry Torokhov wrote:
>> On Wed, Sep 08, 2010 at 11:16:17PM +0200, David Härdeman wrote:
>>> On Wed, Sep 08, 2010 at 12:42:00AM -0700, Dmitry Torokhov wrote:
>>>> Switch the code to use new style of getkeycode and setkeycode
>>>> methods to allow retrieving and setting keycodes not only by
>>>> their scancodes but also by index.
>>>>
>>>> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>>>> ---
>>>>
>>>>  drivers/input/misc/winbond-cir.c |  248 +++++++++++++++++++++++++-------------
>>>>  1 files changed, 163 insertions(+), 85 deletions(-)
>>>
>>> Thanks for doing the conversion for me, but I think you can skip this 
>>> patch. The driver will (if I understood your patchset correctly) still 
>>> work with the old get/setkeycode ioctls and I have a patch lined up that 
>>> converts winbond-cir.c to use ir-core which means all of the input 
>>> related code is removed.
>>>
>>
>> Yes, it should still work with old get/setkeycode. What are the plans
>> for your patch? .37 or later?
> 
> Up to Mauro but I believe it's .37 (sometime after your input patches 
> land).

.37 seems feasible, if you submit your patch in time for review.

Maybe I should create a temporary staging tree for .37 with the input patches
applied there, to allow people to better review and test the rc patches with
everything applied.

Cheers,
Mauro.

