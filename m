Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:49757 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZBQPxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 10:53:38 -0500
Date: Tue, 17 Feb 2009 09:53:35 -0600
From: David Engel <david@istwok.net>
To: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090217155335.GB6196@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

My old, MythTV, master backend finally gave up the ghost this past
weekend.  The power supply or motherboard got bad enough there wa no
stability.  No big deal.  I was planning to replace that system soon
and had all of the parts ready anyway.

I moved the disks and tuner cards (2 Kworld ATSC 115s, 1 Hauppauge PVR
250 and 1 Hauppauge PVR 350) to the new system (AMD X2 3600 CPU and
Biostar TForce 550 motherboard).  Things went fairly smoothly and I
seemed to have full stability again for the first time in several
weeks.

Then, I started noticing frequent corruption in some of my claar QAM
recordings from the ATSC 115 cards.  When the corruption is present,
it occurs every few seconds -- a splotch of garbage in the picture
here, a stutter and a skipped frame there.  Sure enough, MythTV and
mplayer both report CRC, damage, splice and other errors when playing
the streams.

I finally determined the stream corruption happens if and only if one
of the PVR x50 cards is being used at the same time.  If only the ATSC
115s are used, there is no corruption.  As soon as either of the PVr
X50 is used with an ATSC 115, there is corruption.  I tested with the
stock drivers from the 2.6.27.17 kernel and from current Hg.  The
corruption happens with both sets of drivers.  FWIW, I haven't noticed
any corruption with the analog recordings from the PVR x50s.

Does anyone know what might be going on?  These very same tuner cards
worked fine in the old system (Intel P4 3.0GHz CPU and Abit IC7
motherboard) for close to two years.

David
-- 
David Engel
david@istwok.net
