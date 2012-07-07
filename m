Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.ird.yahoo.com ([77.238.189.193]:45337 "HELO
	nm14-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751326Ab2GGCLs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 22:11:48 -0400
Message-ID: <1341627106.90091.YahooMailClassic@web29405.mail.ird.yahoo.com>
Date: Sat, 7 Jul 2012 03:11:46 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: success! (Re: media_build and Terratec Cinergy T Black.)
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1341608766.83055.YahooMailClassic@web29403.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Fri, 6/7/12, Hin-Tak Leung <htl10@users.sourceforge.net> wrote:

<snipped>
> > Typical channels.conf entry looks like that:
> >
> MTV3:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:305:561:49
> > 
> > And tuning to that channel using mplayer:
> > mplayer dvb://MTV3
> 
> Well that at least clear up something - I tried this form
> (from 
> /usr/share/doc/dvb-apps-1.1.2/channels-conf/dvb-t/* ) but
> did not get anything either - the error message seemed worse
> so I didn't go further. I guess I should try getting w_scan
> to do this form.

<snipped>
> There seems to be at least two channels.conf formats (one
> for mplayer/vlc/gstreamer, one for vdr?), and unfortunately
> both seems to have the same name conventionally, but
> different content. I can't find documentation about either,
> or even examples :-).

Apparently it was just me not reading the manual/options properly. There are 3 formats - gstreamer, vdr and mplayer's! I thought it was just vdr vs everything else. It was also confusing that mplayer did not complain about it.

scandvb still does not work at all, nor those sample config files under /usr/share/doc/dvb-apps-1.1.2/channels-conf/dvb-t/* , or use those (tried about 6 different transmitter config various distance away). It is also true that I have poor reception: all the BBC* channels seems to work okay - about 18 channels - but none of the non-BBC stations. Also they are not there on a 2nd scan, so I guess they are weaker.

So obviously there are a lot of rough edges. I also think it is a bit stupid for w_scan not to offer writing *all* the formats, since all the information should be there after a scan. It takes about 8 minutes to do a full scan. It would be more logical to generate all the channels.conf formats on one scan, and let the user throw away the ones he does not need, if it takes that long to do a full scan.



