Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36109 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbZAOP40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 10:56:26 -0500
Date: Thu, 15 Jan 2009 13:55:58 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Alec Christie" <alec.christie@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: kernel soft lockup on boot loading cx2388x based DVB-S card
 (TeVii S420)
Message-ID: <20090115135558.73f61f1b@pedra.chehab.org>
In-Reply-To: <9e70b14f0901150325g5c02da7dtba7c3cbbd5987fb2@mail.gmail.com>
References: <496F1168.3030007@bat.id.au>
	<9e70b14f0901150325g5c02da7dtba7c3cbbd5987fb2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Jan 2009 11:25:38 +0000
"Alec Christie" <alec.christie@gmail.com> wrote:

> I am getting the same with the Haupauge HVR-4000 after a recent Kernel
> Upgrade in Ubuntu Hardy (8.04).
> 
> Any help greatly appreciated.
> 
> Alec Christie
> 
> 
> 
> 2009/1/15 Aaron Theodore <aaron@bat.id.au>
> >
> > Hi I'm running Debian with kernel: 2.6.24-etchnhalf.1-686
> > I recently baught a TeVii S420 DVB-S card and have been tring to get it to work.
> >
> > Firstly i built the v4l from: http://linuxtv.org/hg/v4l-dvb (hg clone) as the card was not detected.
> > On first reboot after new modules are installed i get a kernel soft lockup....
> > cx88[0]/2: cx2388x based DVB/ATSC card
> > BUG: soft lockup - CPU#0 stuck for 11s! [modprobe:1767]

I just merged on http://linuxtv.org/hg/v4l-dvb a patch for fixing this bug. Please test.

Cheers,
Mauro
