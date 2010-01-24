Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59205 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab0AXWDy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 17:03:54 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NZAYe-0007jh-Et
	for linux-media@vger.kernel.org; Sun, 24 Jan 2010 23:03:48 +0100
Received: from vau75-5-82-229-154-200.fbx.proxad.net ([82.229.154.200])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 23:03:48 +0100
Received: from ticapix by vau75-5-82-229-154-200.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 23:03:48 +0100
To: linux-media@vger.kernel.org
From: pierre gronlier <ticapix@gmail.com>
Subject: Re: problem with libdvben50221 and powercam pro V4 [almost solved]
Date: Sun, 24 Jan 2010 22:03:25 +0000 (UTC)
Message-ID: <loom.20100124T225424-639@post.gmane.org>
References: <4B5CA8F8.3000301@crans.ens-cachan.fr> <1a297b361001241322q2b077683v8ac55b35afb4fe97@mail.gmail.com> <4B5CBF14.1000005@crans.ens-cachan.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DUBOST Brice <dubost <at> crans.ens-cachan.fr> writes:
> 
> Manu Abraham a écrit :
> > Hi Brice,
> > 
> > On Mon, Jan 25, 2010 at 12:09 AM, DUBOST Brice
> > <dubost <at> crans.ens-cachan.fr> wrote:
> >> Hello
> >>
> >> Powercam just made a new version of their cam, the version 4
> >>
> >> Unfortunately this CAM doesn't work with gnutv and applications based on
> >> libdvben50221
> >>
> >> This cam return TIMEOUT errors (en50221_stdcam_llci_poll: Error reported
> >> by stack:-3) after showing the supported ressource id.
> >>
> >> The problem is that this camreturns two times the list of supported ids
> >> (as shown in the log) this behavior make the llci_lookup_callback
> >> (en50221_stdcam_llci.c line 338)  failing to give the good ressource_id
> >> at the second call because there is already a session number (in the
> >> test app the session number is not tested)
> >>
> >> I solved the problem commenting out the test for the session number as
> >> showed in the joined patch (against the latest dvb-apps, cloned today)
> > 
> > Very strange that, it responds twice on the same session.
> > Btw, What DVB driver are you using ? budget_ci or budget_av ?
> 
> Hello
> 
> The card is a "DVB: registering new adapter (TT-Budget S2-3200 PCI)" and
> the driver used is budget_ci
> 
> Do you want me to run some more tests ?
> 

Hello Manu, Hello Brice,

I will run some tests with a TT3200 card too and a Netup card tomorrow.

Regarding the cam returning two times the list of valid cam ids, wouldn't be
better if the manufacturer corrects it in the cam firmware ?
What says the en50221 norm about it ?

Regards

-- 
Pierre




