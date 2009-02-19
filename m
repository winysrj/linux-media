Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:49093 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZBSQ2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 11:28:24 -0500
Date: Thu, 19 Feb 2009 10:28:20 -0600
From: David Engel <david@istwok.net>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090219162820.GA23759@opus.istwok.net>
References: <20090217155335.GB6196@opus.istwok.net> <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net> <499B1E19.80302@linuxtv.org> <20090218051945.GA12934@opus.istwok.net> <499C218D.7050406@linuxtv.org> <20090218153422.GC15359@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218153422.GC15359@opus.istwok.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2009 at 09:34:22AM -0600, David Engel wrote:
> On Wed, Feb 18, 2009 at 09:56:13AM -0500, Steven Toth wrote:
> >> I then removed the 250 from slot 4 leaving the 115s in slots 1 and 2.
> >> The ber was through the roof and the recorded strams were filled with
> >> errors and were barely playable at best.
> >
> > This ^^^^ is bad, you have something wrong with your feeds. They're 
> > probably over amp'd and your leaking RF like crazy.
> >
> > Go back to basics, put the single unsplit and unamped feed into a single 
> > 115 and get that working reliably. Then, split (or amp) and try the 
> > second 115.
> >
> > Try to work out what's causing BER to be > 0 and fix that first.
> >
> > Personally, I wouldn't add the 250/350 back into the system until I had 
> > both 115's running flawlessly with 0 BER and 0 UNC.
> >
> > Chances are, the 250/350 will work correctly after this - unless the 
> > drivers really do have a DMA issue. It's too early to say given the 
> > BER/UNC issues you're seeing though.
> 
> OK.  I've got another window this evening where I can do some testing
> without disupting things too much.

Well, that was a frustrating, mostly waste of time!

I'll start with what worked.

I replaced the active, 4-way splitter with a passive one.  The BER
reported by the ATSC 115s increased by about 50-100% from what it
showed with the active splitter.  There were still no UNCs reported.
The 115 recordings followed the same pattern as before -- clean when
no x50 activity and some corruption with x50 activity.

FWIW, an analog TV connected off one of the splitter legs (via yet
another splitter) clearly showed a degraded signal with the passive,
4-way splitter.  The PVR x50s faired a little better.  The x50
recordings looked OK, but I really only checked those to make sure
something could be reocrded.

I replaced the passive, 4-way splitter with a passive, 2-way splitter.
This left only the 115s and x50s in the troublesome system connected.
Everything else in my clulttered computer room was left unconnected.
The BER reported by the ATSC 115s was about 25-50% higher than with
the active spllitter.  Again, there were no UNCs.  The same clean
vs. corrupted recordings pattern held.

Now, here is the stuff that didn't work and has me completely stumped.
I'm sure I'm missing something very stupid, but I don't know what.

The 115s absolutely refused to work if the x50s were not connected to
anything or were removed from the system altogether.  I tried with a
cable straight from the wall to each 115, one at a time, and with a
calbe from the wall with a single 2-way splitter to both 115s at the
same time.  I tried this with and without the x50s installed.  In all
cases, the 115s reported a BER at or near 7ff8 and UNC around 00ff and
FE_HAS_LOCK most of the time.  MythTV apparently never received
anything meaningful since it never wrote anything to the recording
file.

FWIW, I used a different 115 with that same motherboard for several
months up until about two weeks ago and with that same graphics card
for most of that time.  Like I said above, I've got to be missing
something very stupid here.  

BTW, during all of the testing without the active splitter, I had it
unplugged to make sure it wasn't contributing any extra RF noise.  I
won't have an opportunity to do any more testing until this weekend.

David
-- 
David Engel
david@istwok.net
