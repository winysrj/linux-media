Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36441 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab1GCUig (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 16:38:36 -0400
Received: by wwe5 with SMTP id 5so4557194wwe.1
        for <linux-media@vger.kernel.org>; Sun, 03 Jul 2011 13:38:35 -0700 (PDT)
Subject: RE: [PATCH] STV0288 Fast Channel Acquisition
From: Malcolm Priestley <tvboxspy@gmail.com>
To: =?ISO-8859-1?Q?S=E9bastien?= "RAILLARD (COEXSI)" <sr@coexsi.fr>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	o.endriss@gmx.de
In-Reply-To: <004901cc37c7$147763d0$3d662b70$@coexsi.fr>
References: <00a301cc365e$b6d415c0$247c4140$@coexsi.fr>
	 <1309472493.11947.12.camel@localhost>
	 <004901cc37c7$147763d0$3d662b70$@coexsi.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Jul 2011 21:38:27 +0100
Message-ID: <1309725507.6571.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2011-07-01 at 10:15 +0200, Sébastien RAILLARD (COEXSI) wrote:
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Malcolm Priestley
> > Sent: vendredi 1 juillet 2011 00:22
> > To: Linux Media Mailing List
> > Cc: Sébastien RAILLARD (COEXSI)
> > Subject: [PATCH] STV0288 Fast Channel Acquisition
> > 
> > On Wed, 2011-06-29 at 15:16 +0200, Sébastien RAILLARD (COEXSI) wrote:
> > 
> > > On some other transponders, like ASTRA 19.2E 11567-V-22000, the card
> > > nearly never manage to get the lock: it's looking like the signal
> > > isn't good enough.
> > > I turned on the debugging of the stb6000 and stv0288 modules, but I
> > > can't see anything wrong.
> > 
> > I have had similar problems with the stv0288 on astra 19.2 and 28.2 with
> > various frequencies.
> > 
> > I have been using this patch for some time which seems to improve
> > things.
> > 
> > The STV0288 has a fast channel function which eliminates the need for
> > software carrier search.
> > 
> > The patch removes the slow carrier search and replaces it with this
> > faster and more reliable built-in chip function.
> > 
> > If carrier is lost while channel is running, fast channel attempts to
> > recover it.
> > 
> > The patch also reguires registers 50-57 to be set correctly with
> > inittab. All current combinations in the kernel media tree have been
> > checked and tested.
> > 
> 
> Thanks Macolm for this patch!
> 
> Regarding the TT-S-1500b, it's using a specific inittab, I hope Oliver can have a look and check if this patch is compatible with the ALPS BSBE1 tuner.
> 
> Sebastien
> 
For some reason, I have had nothing but trouble today testing this patch
scanning and tuning certain frequencies. Especially 11426V on Astra
28.2.

So this patch is for review only and marked not applicable on Patchwork.

tvboxspy

