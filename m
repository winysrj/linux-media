Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f39.mail.ru ([194.67.57.77])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KYamY-0006Ha-5N
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 08:14:58 +0200
From: Goga777 <goga777@bk.ru>
To: free_beer_for_all@yahoo.com
Mime-Version: 1.0
Date: Thu, 28 Aug 2008 10:14:23 +0400
In-Reply-To: <613687.9380.qm@web46107.mail.sp1.yahoo.com>
References: <613687.9380.qm@web46107.mail.sp1.yahoo.com>
Message-Id: <E1KYalz-000GZm-00.goga777-bk-ru@f39.mail.ru>
Cc: Hans Werner <HWerner4@gmx.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?TVBsYXllciBjYW4ndCBwbGF5IGguMjY0IGR2Yi1z?=
	=?koi8-r?b?dHJlYW0gKHdhcyAtIEhWUiA0MDAwIHJlY29tbmVkZWQgZHJpdmVy?=
	=?koi8-r?b?IGFuZCBmaXJtd2FyZSBmb3IgVkRSMS43LjAp?=
Reply-To: Goga777 <goga777@bk.ru>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi

I have read that szap -r -p options was broken. May be is it reason of your problem with the latest MPlayer ?
http://marc.info/?l=linux-dvb&m=121660960211299&w=2

could you try please to play in another way - after of tine with szap2 help please try like this 

dvbsnoop -s ts -b -tsraw | mplayer -
dvbsnoop -s ts -b -tsraw | xine stdin://

or

dvbstream -o 8192 | xine stdin://
dvbstream -o 8192 | mplayer -

Goga


-----Original Message-----
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Hans Werner <HWerner4@gmx.de>
Date: Wed, 27 Aug 2008 21:24:26 -0700 (PDT)
Subject: Re: [linux-dvb] HVR 4000 recomneded driver and firmware for VDR1.7.0

> 
> --- On Wed, 8/27/08, Hans Werner <HWerner4@gmx.de> wrote:
> 
> > Barry, thanks for your messge. You didn't say whether you tried what
> > I did with HVR4000+liplianindvb+szap2 (-p option). 
> 
> First, my apologies -- I've only been half-reading all the
> messages, without really paying attention to things that do
> not immediately concern me, and I probably should have kept
> quiet.
> 
> Second, I don't have any DVB-S2 hardware yet, though the HVR4000
> has been on my Interest-O-Meter -- nor is my machine fast enough
> to play any streams in realtime, so I'm always writing a file
> (which takes little CPU power) for playback later; in the case
> of H.264 1080i video, I see at best part of one, two, or maybe
> three full frames per second, which actually gives me time to
> judge the quality of the video compression.
> 
> So, no, I haven't tried that, but I'm confused -- based on your
> posted debug output, it looked as though you were playing a
> recorded file, testfile_anixe.ts ...
> 
> 
> The output you gave reminded me of that of ITV-HD, which uses
> some (PAFF?) encoding for which mplayer recently got support,
> so I posted, in case you had a distro-supplied player.
> 
> 
> > I regularly update mplayer from SVN and recompile too.  I
> > have tried the following:
> > 
> > MPlayer dev-SVN-r27489-4.1.2  (today!): runs but video very
> > slow and out of sync, audio ok.
> > MPlayer dev-SVN-r27341-4.1.2  (about 1 month old): crashes
> > in <1s
> 
> Good to know, and thanks for making me look like a fool, and
> I'm happy for it.  No, really.  It's not just worth it for its
> own sake, but if it helps others, that's even better.
> 
> 
> > And I have some sample TS files for Astra HD+ made with
> > another card which all the
> > mplayers play perfectly so I know h264 is working.
> 
> I am going to plead ignorance of what does, and what does not
> work for you.  Please correct me where I ass-u-me wrong:
> 
> arte HD plays fine for you, both from a recorded TS file, and
> live from szap2.
> 
> Anixe HD / Astra HD+ play fine from recorded files from another
> machine.
> 
> Anixe HD played from your anixe.ts file crashed?
> Anixe HD played from szap2 crashed?
> 
> 
> I pointed out the different debug output from BBC-HD/ITV-HD to
> show that of ITV matched your errors, and that's using an encoding
> for which support has only within the last month or two appeared
> in mplayer, and will not be as mature as the support used by
> other streams.
> 
> 
> Just a thought, if you cannot play a realtime stream, is that the
> decoder needs to do seeking within the stream, which it could do
> within a file, but the support is not yet mature enough to be able
> to do the same within a stream.  I could be completely wrong...
> 
> 
> If you have short examples of recorded files that crash, and others
> from the same source that play properly, I'd be interested to be
> able to download them and look for obvious problems.
> 
> And likewise, if I'm not understanding where you have success and
> failures with mplayer, please correct me, if you think it's worth
> it, as I don't have the hardware to test on my own.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
