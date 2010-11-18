Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:37510 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0KRUnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 15:43:23 -0500
Date: Thu, 18 Nov 2010 21:43:19 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101118204319.GA8213@hardeman.nu>
References: <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
 <37bb20b43afce52964a95a72a725b0e4@hardeman.nu>
 <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
 <20101104193823.GA9107@hardeman.nu>
 <4CD30CE5.5030003@redhat.com>
 <da4aa0687909ae3843c682fbf446e452@hardeman.nu>
 <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com>
 <4CE2743D.5040501@redhat.com>
 <20101116232636.GA28261@hardeman.nu>
 <20101118163304.GB16899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101118163304.GB16899@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 18, 2010 at 11:33:04AM -0500, Jarod Wilson wrote:
>Mauro's suggestion, iirc, was that max scancode size should be a
>property of the keytable uploaded, and something set at load time (and
>probably exposed as a sysfs node, similar to protocols).

I think that would be a step in the wrong direction. It would make the
keytables less flexible while providing no real advantages.

-- 
David Härdeman
