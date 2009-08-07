Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:39713 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbZHGCuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 22:50:08 -0400
Date: Thu, 6 Aug 2009 21:50:03 -0500
From: David Engel <david@istwok.net>
To: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090807025003.GB27235@opus.istwok.net>
References: <20090217155335.GB6196@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217155335.GB6196@opus.istwok.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 17, 2009 at 09:53:35AM -0600, David Engel wrote:
> I moved the disks and tuner cards (2 Kworld ATSC 115s, 1 Hauppauge PVR
> 250 and 1 Hauppauge PVR 350) to the new system (AMD X2 3600 CPU and
> Biostar TForce 550 motherboard).  Things went fairly smoothly and I
> seemed to have full stability again for the first time in several
> weeks.
> 
> Then, I started noticing frequent corruption in some of my claar QAM
> recordings from the ATSC 115 cards.  When the corruption is present,
> it occurs every few seconds -- a splotch of garbage in the picture
> here, a stutter and a skipped frame there.  Sure enough, MythTV and
> mplayer both report CRC, damage, splice and other errors when playing
> the streams.
> 
> I finally determined the stream corruption happens if and only if one
> of the PVR x50 cards is being used at the same time.  If only the ATSC
> 115s are used, there is no corruption.  As soon as either of the PVr
> X50 is used with an ATSC 115, there is corruption.  I tested with the
> stock drivers from the 2.6.27.17 kernel and from current Hg.  The
> corruption happens with both sets of drivers.  FWIW, I haven't noticed
> any corruption with the analog recordings from the PVR x50s.
> 
> Does anyone know what might be going on?  These very same tuner cards
> worked fine in the old system (Intel P4 3.0GHz CPU and Abit IC7
> motherboard) for close to two years.

I want to follow up on this for the benefit of anyone who runs across
it in the archives.

The short version is the problem appears to have been caused by the
motherboard.  My guess is noise or a grounding problem.

The slightly longer version is I've been using a non-optimal
arrangement of tuner cards to avoid the corruption problems described
above.  About two weeks ago, I started having problems with one and
then multiple SATA disks.  Process of elimination led to the
motherboard.  I tried the previously troublesome combination of cards
today with the new motherboard and no longer see the problem.

David
-- 
David Engel
david@istwok.net
