Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966239Ab0BZVmT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 16:42:19 -0500
Message-ID: <4B884034.8080508@redhat.com>
Date: Fri, 26 Feb 2010 18:42:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Curtis Hall <curt@bluecherry.net>
CC: linux-media@vger.kernel.org
Subject: Re: [bttv] Auto detection for Provideo PV- series capture cards
References: <4B882E3A.8050604@bluecherry.net>
In-Reply-To: <4B882E3A.8050604@bluecherry.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's go by parts:

Curtis Hall wrote:
> I'm writing concerning the Provideo PV-149, PV-155, PV-981-* and
> PV-183-*.   These cards, for the most part, are drop in and 'just work'
> with the bttv driver.
> 
> However the PV-149 / PV-981 / PV-155 is auto detected as the Provideo
> PV-150, which is not a valid Provideo part number. 

>From your logs, both PV-149 and PV-981 shares the same PCI ID = aa00:1460,
which is the same ID for PV-150.

The entry for PV-150 were added at -hg tree by this changeset:
changeset:   784:3c31d7e0b4bc
user:        Gerd Knorr
date:        Sun Feb 22 01:59:34 2004 +0000
summary:     Initial revision

Probably, this is a discontinued model, but I don't know for sure.

> The PV-183-* is
> detected as 'Unknown / Generic' and requires setting
> card=98,98,98,98,98,98,98,98.

This one is easy:
[   13.438412] bttv0: subsystem: 1830:1540 (UNKNOWN)

As this PCI ID is not known, it is just a matter of associating the PV-183
ID's with card 98.

> 
> I believe the text concerning 'detected: Provideo PV150A-1' should be
> changed to 'detected: Provideo PV149 / PV981 / PV155'

Seems ok to me for PV-981.

> I've attached outputs from the bttv kernel logs for the PV-149 / PV-981
> / PV-183.  If there's something I'm missing please let me know and I'll
> get it for you.
> 
> Just for reference the PV-149 / PV-981 / PV-183 series cards are:
> 
> PV-149 - 4 port, 4 BT878a chips - no forced card setting required
> PV-155 - 16 port, 4 BT878a chips - card=77,77,77,77  (Shares the same
> board and PCI ID / subsystem as the PV-149)

Hmm... PV-155 shares the same PCI ID as PV-149, but require a different
entry, then we shouldn't add it to the PV-150 autodetection code.

The better would be to check with the manufacturer if is there a
way to detect between those two boards (maybe reading eeprom?).

> 
> PV-183-8: 8 port, 8 BT878a chips - card=98,98,98,98,98,98,98,98
> PV-183-16: 16 port, 8 BT878a chips - card=98,98,98,98,98,98,98,98
> (Shares the same board and PCI ID / subsystem as the PV-183-8)
> 
> PV-981-4: 4 port, 4 BT878a chips - no modprobe setting required
> PV-981-8: 8 port, 4 BT878a chips  - no modprobe setting required (Shares
> the same board as the PV-981-4)
> PV-981-16: 16 port, 4 BT878a chips - card=98,98,98,98,98,98,98,98
> (Shares the same board and PCI ID / subsystem as the PV-981-4)

Why do you need the card=  parameter, if it shares the same subsystem ID
as the other PV-981 models?
> 
> 
> Thanks!
> 
> -- 
> Curtis Hall (curt@bluecherry.net)
> Bluecherry - www.bluecherry.net
> (877) 418-3391 x 201
> 


-- 

Cheers,
Mauro
