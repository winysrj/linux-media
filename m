Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m671lgKU028001
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 21:47:42 -0400
Received: from web35605.mail.mud.yahoo.com (web35605.mail.mud.yahoo.com
	[66.163.179.144])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m671lUBK016149
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 21:47:30 -0400
Date: Sun, 6 Jul 2008 18:47:24 -0700 (PDT)
From: Sam Logen <starz909@yahoo.com>
To: video4linux-list@redhat.com
In-Reply-To: <788446.81818.qm@web35609.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <839002.10441.qm@web35605.mail.mud.yahoo.com>
Cc: mkrufky@linuxtv.org
Subject: Re: latest HG revision (6858) causing artifacts
Reply-To: starz909@yahoo.com
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--- On Tue, 12/18/07, Sam Logen <starz909@yahoo.com> wrote:

> From: Sam Logen <starz909@yahoo.com>
> Subject: Re: latest HG revision (6858) causing artifacts
> To: "Michael Krufky" <mkrufky@linuxtv.org>
> Cc: video4linux-list@redhat.com
> Date: Tuesday, December 18, 2007, 7:57 PM
> --- Michael Krufky <mkrufky@linuxtv.org> wrote:
> 
> > Sam,
> > 
> > Sam Logen wrote:
> > > I don't know if this is known yet, but I
> updated
> > my
> > > v4l-dvb sources to the latest hg a half-hour ago.
> 
> > > When I went to Mythtv, to check the picture, half
> > of
> > > my HD channels were corrupted and had artifacts.
> > > 
> > > By the way, I tested the picture with a
> > > FusionHDTV5-RT, which is a cx88 dvb device.
> > 
> > I tested today's tip ( 0055b5f238fa ) , which
> should
> > be
> > the exact code that you're using, with the same
> > hardware
> > that you're using ( DViCO FusionHDTV 5 RT Gold )
> > 
> > I am unable to reproduce the behavior that you are
> > reporting.
> > 
> > What kernel version are you running?  I am running:
> > 
> > Ubuntu Gutsy32 2.6.22-14-generic, with today's hg
> > tip of v4l-dvb
> > 
> > > Then I reverted my hg sources to revision 6836. 
> I
> > > built them, rebooted the system, and check the
> > same HD
> > > channels.  Now they're clear and uncorrupted.
> > 
> > You've mainly reverted changes to tda9887 and
> > tuner-xc2028.
> > These should not have affected your device. 
> > FusionHDTV5 has
> > a tda9887 inside the LG-H064F NIM, but it is only
> > used in
> > analog mode.
> > 
> > I didn't experience any problem, and I used the
> > FusionHDTV5
> > RT Gold for testing when I worked on those tda9887
> > changes
> > this past weekend.
> > 
> > > I suspect it might have something to do with rev.
> > > 6837, which is the bitfield change, but I
> can't be
> > > certain yet.  I might try to update to that and
> > check
> > > it again for you all.
> > 
> > Definitely not.  If that change would affect you at
> > all, it
> > would show with missing or incorrect audio input
> > source
> > when viewing television / composite / svideo in
> > analog mode.
> > 
> > Can you try to update to tip again and see if it
> > works for you now?
> > 
> > It seems like there must have been some other
> > variable at play --
> > it doesn't look like this is a driver issue.
> > 
> > If you *do* find that tip still doesn't work for
> > you, then I'll
> > need to know the exact changeset that causes the
> > breakage.  Then,
> > we'll also have to figure out why I am not having
> > this problem,
> > while testing with the same hardware.
> > 
> > Thanks for reporting -- please let us know what you
> > find after
> > repeating your tests.
> > 
> > Regards,
> > 
> > Mike
> > 
> 
> Ok, I've officially run out of free time for the time
> being, but when I am free, I'll continue the tests. 
> Note that since Gentoo has unmasked 2.6.23-r3 kernel,
> I've been using it with the various hg repositories
> that I've been testing.
> 
> I did test revision 6837, and that doesn't have a
> problem, so never mind about the bitfield change.  I'm
> using this repository for the time being.
> 
> I mentioned this in a subsequent email to my first
> one, but I took a random revision between 6837 and the
> tip from hg and tested that.  It was revision 6849,
> and this one had the exact same problem as the tip
> revision.
> 
> So it appears that the problem lies after the revision
> I'm using now, 6837, and with 6849 or before it.
> 
> Best regards, and you're welcome,
> 
> Sam

Hi, I thought I'd give an update on this problem I had last year.  I started working on my DV software again - updating software, re-scanning channels.

Now I'm using gentoo-sources kernel 2.6.24-r8.  I'm still using the Dvico Fusionhdtv 5-rt gold card.  Using Mythtv .21 to test free HD and digital channels, and the latest V4L-DVB tip repo, channel scanning only picked up a handful of channels, and these were too corrupted with artifacts to watch.

I found the problem with this was the cable splitter was lowering the signal quality to 75%.

So removing the signal splitter, and using a straight line from the comcast splitter to my box, I rescanned the channels (with latest hg V4L tip modules).  I got much more channels, including the elusive KGO multiplexed channels.  All channels came in 95%-86% quality.

Now, with the V4L tip modules, digital channels (including HD) that came in at about 88% quality or lower suffered slightly from frequent visual artifacts.

First I completely uninstalled the V4L tip modules.  Then I looked back to the V4L repo to see which repository worked for me last.  I pulled hg rev. 6836, compiled it, installed it, then _completely_ cycled the power of the computer.

After that, all channels, even the KGO multiplex which comes at the lowest quality, have a perfect picture under mythtv.  I would love to keep these modules, except there are updates for the ivtv driver that I'd also like to use.  Plus, I'm sure there have been many stability fixes and improvements since rev 6836.

I think that something happened in the code that made the cx88 drivers more sensitive to signal quality.  The above description of the test I made was really simplified.  I actually tried all sorts of revisions for days, until I realized that the signal splitter was killing my signal quality.  The older modules ( < 6838 ) gave a better picture comparatively than tip modules, even with the splitter lowering the signal.  I really can't explain it clearer than that.  I just want to share this info.  If no one else has experienced the problems I outlined last year, it could be that the channels that were tested came in at a higher quality for others.

Best regards,
Sam


      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
