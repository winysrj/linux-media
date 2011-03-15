Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:52546 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753093Ab1CONu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 09:50:27 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH] DVB-APPS: azap gets -p argument
Date: Tue, 15 Mar 2011 14:50:05 +0100
Cc: Christian Ulrich <chrulri@gmail.com>, linux-media@vger.kernel.org
References: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com> <AANLkTingP4tLViGTMvKeBM4XNj-cRZtqECh4WjLgZM40@mail.gmail.com> <20110315123258.GA6570@aniel>
In-Reply-To: <20110315123258.GA6570@aniel>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103151450.08708@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 15 March 2011 13:32:58 Janne Grunau wrote:
> On Tue, Mar 15, 2011 at 01:23:40PM +0100, Christian Ulrich wrote:
> > Hi, thank you for your feedback.
> > 
> > Indeed, I never used -r alone, but only with -p.
> > So with your patch, [acst]zap -r will be the same as -rp. That looks good to me.
> 
> well, azap not yet. iirc I implemented -p for azap but it was never
> applied since nobody tested it. see attached patch for [cst]zap

NAK.

The PAT/PMT from the stream does not describe the dvr stream correctly.

The dvr device provides *some* PIDs of the transponder, while the
PAT/PMT reference *all* programs of the transponder.

For correct results the PAT/PMT has to be re-created.

The separate -p option seems acceptable - as a debug feature.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
