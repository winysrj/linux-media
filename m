Return-path: <mchehab@pedra>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:55684 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab0I3V7H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 17:59:07 -0400
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
Date: Thu, 30 Sep 2010 23:59:02 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	eric.valette@free.fr
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr> <201009302309.58546.yann.morin.1998@anciens.enib.fr> <4CA505C9.1040400@iki.fi>
In-Reply-To: <4CA505C9.1040400@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009302359.02905.yann.morin.1998@anciens.enib.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Antti, All,

On Thursday 30 September 2010 23:48:57 Antti Palosaari wrote:
> On 10/01/2010 12:09 AM, Yann E. MORIN wrote:
> > I'm using the latest tree from:
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> No, it is too old. Correct tree is staging/v2.6.37 at:
> http://git.linuxtv.org/media_tree.git

OK!

> > I would make use of the entries left. The af9015_properties is an array
> > with currently 3 entries. Each entries currently all have 9 device
> > description. Do you prefer that I add the new description:
> > - in the first entry,
> > - just below the existing A850, (my pick)
> > - or in the last entry?
> Add it to the first free slot find. It was TerraTec Cinergy T Dual RC I 
> added lastly. If there is free space put it just behind that, otherwise 
> to the first free slot in next entry. This entry/dev count really sucks 
> a little bit, it should be fixed if possible... but as now we left it.

OK!

> Hmm, now I like it when it is identified as AverMedia AVerTV Red HD+.
[--SNIP--]
> If you can make patch against latest 2.6.37 pointed I it will be OK. 

Yes, I will.

> Also possible remote could be nice... 2.6.37 af9015 have totally 
> different remote implementation.

I am not using the remote for now. As soon I have it working, I'll either
submit a patch, or acknowledge existing stuff works.

Thank you!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
