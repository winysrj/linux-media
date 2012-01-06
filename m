Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:53108 "HELO
	exprod6ob111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752966Ab2AFUjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 15:39:40 -0500
Received: by eaac11 with SMTP id c11so2144987eaa.39
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 12:39:37 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Jan 2012 14:39:37 -0600
Message-ID: <CAPc4S2aqGXSdFnOnSsNM1dL6Xp9qJYMctFPExJ4M_9q890g6-w@mail.gmail.com>
Subject: Best "card=n" option for no-name SAA7134-based card?
From: Christopher Peters <cpeters@ucmo.edu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At the recommendation of the developer of a piece of software called
openreplay, I purchased one of these cards: http://tinyurl.com/7kupvw7
from eBay.  Some Googling suggests the manufacturer *might* be an
outfit called "wave-p". It's detected by the saa7134 module as a card
with no EEPROM, so the module loads in generic mode.  I get four
/dev/video<n> interfaces, but I get no video on any of the interfaces
from xawtv, vlc, or mplayer.  I also don't see (as I saw from a
Hauppauge card I have in the system) any encoders/decoders registered
(e.g. " ivtv0: Registered device video4 for encoder MPG").

Should I be able to get video from the card in generic mode?  If so,
any suggestions on what I should be doing?  If not, what "card=n"
option should I try?

Physically, the card has 4 Trident SAA7134 chips, a chip numbered
P17C8140A  on the board and 4 BNC-F connectors on the bezel.

--
Kit Peters (W0KEH), Engineer II
KMOS TV Channel 6 / KTBG 90.9 FM
University of Central Missouri
http://kmos.org/ | http://ktbg.fm/
