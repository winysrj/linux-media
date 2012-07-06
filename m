Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm6-vm0.bullet.mail.ird.yahoo.com ([77.238.189.210]:45369 "HELO
	nm6-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758287Ab2GFVGI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:08 -0400
Message-ID: <1341608766.83055.YahooMailClassic@web29403.mail.ird.yahoo.com>
Date: Fri, 6 Jul 2012 22:06:06 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: media_build and Terratec Cinergy T Black.
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <4FF6CE48.3000300@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Fri, 6/7/12, Antti Palosaari <crope@iki.fi> wrote:

> On 07/06/2012 01:54 PM, Hin-Tak Leung
> wrote:
> > - $ lsdvb seems to be doing garbage:(fedora 17's)
> > 
> > usb (-1975381336:62 64848224:32767) on PCI
> Domain:-1965359032 Bus:62 Device:64848416 Function:32767
> >     DEVICE:0 ADAPTER:0 FRONTEND:0
> (Realtek RTL2832 (DVB-T))
> >    
>      FE_OFDM Fmin=174MHz
> Fmax=862MHz
> > 
> > lsdvb on mercury is only marginally better with the PCI
> zero's, but the other numbers swapped:
> > 
> > usb (62:-1975379912 32767:-348245472) on PCI Domain:0
> Bus:0 Device:0 Function:0
> >     DEVICE:0 ADAPTER:0 FRONTEND:0
> (Realtek RTL2832 (DVB-T))
> >    
>      FE_OFDM Fmin=174MHz
> Fmax=862MHz
> 
> I was aware of that tool but didn't know it lists USB
> devices too.
> Someone should fix it working properly for USB devices.

The mercury repository is on linuxtv, so presumably one of you can do it :-). It is wierd that (1) those numbers are swapped between fc17's vs upstream, (2) the numbers also change between runs....
 
> > - 'scandvb' segfault at the end on its own.
> 
> I didn't see that.

This is fc17's - it does so in a string function (v*printf) - probably easy to fix if/when I get the debuginfo package, if it isn't fixed upstream already.

> > - "scandvb /usr/share/dvb/dvb-t/uk-SandyHeath"
> (supposedly where I am) got a few "WARNING: >>>
> tuning failed!!!" and no list.

This is where it gets confusing - /usr/share/dvb/dvb-t/* and  /usr/share/doc/dvb-apps-1.1.2/channels-conf/dvb-t/* have similiar names, but different content, and no explanation which is which. The latter seems to be in the correct format you wrote below, but does not work.

One thing would be nice to do would be write up a description of those formats, and say which is which.

> > - 'w_scan -G -c GB'
> >    have a few curious
> > WARNING: received garbage data: crc = 0xcc93876c;
> expected crc = 0xb81bb6c4
> > 
> > return a list of 26, with entries like (which seems to
> be vaguely correct):
> > 
> > BBC
> ONE;(null):522000:B8C23D0G32M64T8Y0:T:27500:101=2:102,106=eng:0:0:4173:9018:4173:0:100

w_scan is the only one which seems to be able to scan, but its output format isn't correct.

Any ideas about the garbage data message?

> Both scandvb and w_scan works here, same device used. I
> suspect your signal is just simply too weak for reception.
> Small antenna coming with those DVB sticks is not suitable
> unless you are living very near transmitter. Try to connect
> it roof antenna. One thing that helps a lot is to attach
> small bundled antenna to outside window.

I was using my satellite dish as antenna, BTW. Nothing with the small antenna.

> There is both dvbscan and scandvb in Fedora dvb-apps. It is
> not clear for me why two similar looking tools. Anyhow it is
> just scandvb which I found working one.

I just found a dvbv5-scan on my harddisk (fc17) also, and dvbscan is in locate.db but gone. Apparently one might be 'scan' but too confusing and got its name changed during packaging.


> > So I just put it in ~/.mplayer:channels.conf
> > 
> > Took me a while to figure out that mplayer wants:
> > 
> > mplayer 'dvb://BBC ONE;(null)'
> > 
> > rather than anything else - curious about the ';(null)'
> part.
> > 
> > --------
> > Playing dvb://BBC ONE;(null).
> > dvb_tune Freq: 522000
> > ERROR IN SETTING DMX_FILTER 9018 for fd 4: ERRNO:
> 22ERROR, COULDN'T SET CHANNEL  8: Failed to open
> dvb://BBC ONE;(null).
> > ----------
> 
> Typical channels.conf entry looks like that:
> MTV3:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:305:561:49
> 
> And tuning to that channel using mplayer:
> mplayer dvb://MTV3

Well that at least clear up something - I tried this form (from  /usr/share/doc/dvb-apps-1.1.2/channels-conf/dvb-t/* ) but did not get anything either - the error message seemed worse so I didn't go further. I guess I should try getting w_scan to do this form.

> However, I prefer VLC. Just open channels.conf to VLC and
> should show playlist. Totem does not work anymore. at least
> stream used here in Finland. It went broken when they
> changed from playbin to playbin2 which is really shame as it
> is default video player for Gnome desktop.
> 
> 
> > At this point I am lost :-).
> 
> Not big surprise unfortunately :/
> 
> Unfortunately desktop integration is currently poor and most
> users are coming from the HTPC.

There seems to be at least two channels.conf formats (one for mplayer/vlc/gstreamer, one for vdr?), and unfortunately both seems to have the same name conventionally, but different content. I can't find documentation about either, or even examples :-).

I am also surprised by the checksum failed message with w_scan, and that it does not change output format with adding options, etc.

