Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3.bullet.mail.ird.yahoo.com ([77.238.189.60]:46378 "HELO
	nm3.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751418Ab2GGKhp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 06:37:45 -0400
Message-ID: <1341657463.85418.YahooMailClassic@web29402.mail.ird.yahoo.com>
Date: Sat, 7 Jul 2012 11:37:43 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: channel scanning (Re: success! (Re: media_build and Terratec Cinergy T Black.))
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <4FF8096F.7050908@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sat, 7/7/12, Antti Palosaari <crope@iki.fi> wrote:

<snipped>
> > scandvb still does not work at all, nor those sample
> config files under
> /usr/share/doc/dvb-apps-1.1.2/channels-conf/dvb-t/* , or use
> those (tried about 6 different transmitter config various
> distance away). It is also true that I have poor reception:
> all the BBC* channels seems to work okay - about 18 channels
> - but none of the non-BBC stations. Also they are not there
> on a 2nd scan, so I guess they are weaker.
> 
> UK is a little bit special case as it uses different channel
> raster. I 
> just looked and there seems to be "auto-With167kHzOffsets"
> which could 
> be used. It scans all the possible channels using auto
> parameter detection.

Those files (dvb-t/uk-{regions}) are not in the dvb-apps hg repo, so I don't know where they came from, but considered that they don't work for me at all (and w_scan does find some), their contents are either wrong or outdated.

The fedora package changelog possibly says tuning files are kept elsewhere and were last updated over 2 years ago - I know it is probably cliche to assume every *.fi person knows every other *.fi person, but do you? :-)

* Sat Jun 05 2010 Ville Skyttä <ville.skytta@iki.fi> - 1.1.1-22
- Patch to fix dvbnet -h crash (#597604).
- Update tuning files to 20100605.

> > So obviously there are a lot of rough edges. I also
> think it is a bit stupid for w_scan not to offer writing
> *all* the formats, since all the information should be there
> after a scan. It takes about 8 minutes to do a full scan. It
> would be more logical to generate all the channels.conf
> formats on one scan, and let the user throw away the ones he
> does not need, if it takes that long to do a full scan.
> 
> Yes there is. There is no many desktop applications
> supporting DVB and 
> even less applications having own channels scanner.

With a full scan taking 8 minutes (and quick "assisted" scan based on presets not working at all), channel-scanning can't really be modularized and built into an application. Actually even w_scan needs assistance about which *country*. 
Also a typical user might like to try a few different applications. I use mplayer-derivatives - mplayer, gmplayer, gnome-mplayer, dragonplayer - mostly because of its widest/earliest codec support, but I am not against using another if it offers more DVB-centric user-interface. I really think w_scan should by default write all variants of channels.conf formats, or a master-form convertable to others, just to save the 8 minutes of re-scan. (being able to convert quickly, or for application to standardize would be nice, but seeing as the formats have different info, that idea does not seem likely).
