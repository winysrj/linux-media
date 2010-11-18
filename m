Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0KRUtz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 15:49:55 -0500
Date: Thu, 18 Nov 2010 15:49:52 -0500
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101118204952.GC16899@redhat.com>
References: <37bb20b43afce52964a95a72a725b0e4@hardeman.nu>
 <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
 <20101104193823.GA9107@hardeman.nu>
 <4CD30CE5.5030003@redhat.com>
 <da4aa0687909ae3843c682fbf446e452@hardeman.nu>
 <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com>
 <4CE2743D.5040501@redhat.com>
 <20101116232636.GA28261@hardeman.nu>
 <20101118163304.GB16899@redhat.com>
 <20101118204319.GA8213@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101118204319.GA8213@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 18, 2010 at 09:43:19PM +0100, David Härdeman wrote:
> On Thu, Nov 18, 2010 at 11:33:04AM -0500, Jarod Wilson wrote:
> >Mauro's suggestion, iirc, was that max scancode size should be a
> >property of the keytable uploaded, and something set at load time (and
> >probably exposed as a sysfs node, similar to protocols).
> 
> I think that would be a step in the wrong direction. It would make the
> keytables less flexible while providing no real advantages.

I think it was supposed to be something you could update on the fly when
uploading new keys, so its not entirely inflexible. Default keymap might
be 24-bit NEC, then you upload 32-bit NEC codes, and the max scancode size
would get updated at the same time. Of course, it probably wouldn't work
terribly well to have a mix of 24-bit and 32-bit NEC codes in the same
table.

-- 
Jarod Wilson
jarod@redhat.com

