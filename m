Return-path: <linux-media-owner@vger.kernel.org>
Received: from web23204.mail.ird.yahoo.com ([217.146.189.59]:48787 "HELO
	web23204.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753133AbZGSLHm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 07:07:42 -0400
Message-ID: <209977.44258.qm@web23204.mail.ird.yahoo.com>
Date: Sun, 19 Jul 2009 11:00:59 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Subject: [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts on  HDchannels
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


is there any news about that topic? Did anyone find a solution? Also Orange @Atlantic Bird3 5W 11471 V 29950 2/3 8PSK suffers this problem.

--- Chris Silva <2manybills@gmail.com> schrieb am Sa, 14.2.2009:

> Von: Chris Silva <2manybills@gmail.com>
> Betreff: Re : [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts on  HDchannels
> An: linux-media@vger.kernel.org
> Datum: Samstag, 14. Februar 2009, 23:46
> On Sat, Feb 14, 2009 at 10:34 PM,
> Chris Silva <2manybills@gmail.com>
> wrote:
> > On Fri, Feb 6, 2009 at 3:22 PM, Manu <eallaud@gmail.com>
> wrote:
> >>> Can you please send me a complete trace with
> the stb6100 and stb0899
> >>> modules loaded with verbose=5 for the 30MSPS
> transponder what you
> >>> are trying ? One simple szap would be enough
> (no scan please) based
> >>> on the http://jusst.de/hg/v4l-dvb tree.
> >>>
> >>> Before you start testing, start clean from a
> cold boot after a
> >>> powerdown. This makes it a bit more easier
> identify things.
> >>
> >> OK I did just that with latest multiproto on a
> 11495 MHz trnaposnder,
> >> DVB-S2, 30MS/s, FEC 5/6 which works using the
> provider's STB . I put
> >> the log in attachement. You will observe a lock is
> acquired really
> >> briefly and then nothing. Obtained using:
> >> szap2 -t 2
> >> I hope this can give you some data. Let me know if
> you need more info
> >> (like putting some more printksin the source).
> >> Bye
> >> Manu
> >>
> >
> > Sorry for the late reply, but the new list confuses
> the hell out of me
> > and I missed this message, somehow...
> >
> > Attached is a log file with the results of
> dvb-apps/szap on a 30000
> > 3/4 channel using a http://jusst.de/hg/v4l-dvb clean compile and cold
> > boot as recommended.
> >
> > Also loaded stb6100 and stb0899 with verbose=5
> >
> > Command line used and result:
> >
> >
> root@vdr:/usr/local/src/v4l-dvb_multi/dvb-apps/util/szap#
> ./szap -c
> > /video/channels.conf -n 7
> > reading channels from file '/video/channels.conf'
> > zapping to 7 '[006b]':
> > sat 0, frequency = 12012 MHz H, symbolrate 30000000,
> vpid = 0x1031,
> > apid = 0x1032 sid = 0x1004
> > using '/dev/dvb/adapter0/frontend0' and
> '/dev/dvb/adapter0/demux0'
> > status 00 | signal 7fb2 | snr 0000 | ber 00000000 |
> unc fffffffe |
> > status 00 | signal 7fb2 | snr 0000 | ber 00000000 |
> unc fffffffe |
> > [...]
> > status 00 | signal 7fb2 | snr 0000 | ber 00000000 |
> unc fffffffe |
> > status 00 | signal 7fb2 | snr 0000 | ber 00000000 |
> unc fffffffe |
> >
> > After that szapping to that problematic channel, I
> tried a DVB-S
> > channel, which locks without problems.
> >
> >
> root@vdr:/usr/local/src/v4l-dvb_multi/dvb-apps/util/szap#
> ./szap -c
> > /video/channels.conf -H -n 33
> > reading channels from file '/video/channels.conf'
> > zapping to 33 'FOX':
> > sat 0, frequency = 11617 MHz V, symbolrate 27500000,
> vpid = 0x1b30,
> > apid = 0x1b31 sid = 0x0000
> > using '/dev/dvb/adapter0/frontend0' and
> '/dev/dvb/adapter0/demux0'
> > status 00 | signal  49% | snr   0%
> | ber 0 | unc -2 |
> > status 1e | signal   0% |
> snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
> >
> > Going to test your the same multiproto tree _with_
> both patches you
> > mentioned early on this thread.
> >
> > BTW, I can see all those channels just fine using a
> DM800 and the
> > provider original decoder with my subscription card.
> >
> > I'm positive that dish/lnb/connections aren't the
> problem.
> >
> > Thanks for taking the time to address this particular
> issue.
> >
> > Chris
> >
> 
> As promised, a log with the exact same conditions described
> above, but
> with increase_timeout.patch and fix_iterations.patch
> applied, referred
> to on this same thread.
> 
> Chris
> 


      
