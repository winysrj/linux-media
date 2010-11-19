Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:43393 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0KSXzp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:55:45 -0500
Date: Sat, 20 Nov 2010 00:55:42 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Jarod Wilson <jarod@wilsonet.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101119235542.GA4694@hardeman.nu>
References: <20101104193823.GA9107@hardeman.nu>
 <4CD30CE5.5030003@redhat.com>
 <da4aa0687909ae3843c682fbf446e452@hardeman.nu>
 <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com>
 <4CE2743D.5040501@redhat.com>
 <20101116232636.GA28261@hardeman.nu>
 <20101118163304.GB16899@redhat.com>
 <20101118204319.GA8213@hardeman.nu>
 <20101118204952.GC16899@redhat.com>
 <4CE593BF.4010908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CE593BF.4010908@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, Nov 18, 2010 at 06:59:43PM -0200, Mauro Carvalho Chehab wrote:
>Em 18-11-2010 18:49, Jarod Wilson escreveu:
>> On Thu, Nov 18, 2010 at 09:43:19PM +0100, David Härdeman wrote:
>>> On Thu, Nov 18, 2010 at 11:33:04AM -0500, Jarod Wilson wrote:
>>>> Mauro's suggestion, iirc, was that max scancode size should be a
>>>> property of the keytable uploaded, and something set at load time (and
>>>> probably exposed as a sysfs node, similar to protocols).
>>>
>>> I think that would be a step in the wrong direction. It would make the
>>> keytables less flexible while providing no real advantages.
>
>We can't simply just change NEC to 32 bits, as we'll break userspace ABI 
>(as current NEC keycode tables use only 16 bits). So, an old table will not
>worky anymore, if we do such change.

The idea was to do the conversion from <whatever> to 32 bits in
get/setkeycode.


-- 
David Härdeman
