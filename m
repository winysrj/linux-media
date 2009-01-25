Return-path: <linux-media-owner@vger.kernel.org>
Received: from killer.cirr.com ([192.67.63.5]:54647 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZAYVtm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 16:49:42 -0500
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>)
	id 1LRCoQ-0003KU-Bo
	for linux-media@vger.kernel.org; Sun, 25 Jan 2009 16:46:38 -0500
Date: Sun, 25 Jan 2009 16:46:38 -0500
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Tuning a pvrusb2 device.  Every attempt has failed.
Message-ID: <20090125214637.GA11948@shibaya.lonestar.org>
References: <20090123015815.GA22113@shibaya.lonestar.org> <497CB355.3030408@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497CB355.3030408@rogers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 25, 2009 at 01:45:41PM -0500, CityK wrote:
> A. F. Cano wrote:
> > Still trying to get the OnAir Creator to work.  It is properly recognized
> > by the pvrusb2 driver, but I can't seem to get any further.  I'm now
> > trying to scan the digital channels.
> >   
> 
> While you seem to be trying to scan for OTA channels, I would like
> confirmation that this is indeed the case of what you are attempting, as
> opposed to searching for digital cable channels.

Yes.  The RF input is hooked up to an 11ft Winegard roof antenna, mounted on
a stand behind me, properly oriented according to antennaweb.com for the
local stations, and with a UHF pre-amp for good measure.  It is inside, but
a foot below the reasonably high ceiling, so it doesn't interfere with moving
around.  With this setup I have succeeded in receiving barely visible
analog channels when the Creator is set up as a v4l device using /dev/video0.
Yes, the reception sucks, but I want to make sure that it is not something
more fundamental before I go to the trouble of mounting the antenna on the
roof.

Right now, the unit is set up (in mythtv) as a DVB DTV receiver.  I have
observed that the red led seems to be on when configured in digital mode,
as it is right now.

> > ...
> 
> If you are mistakenly searching for digital cable channels using the OTA
> settings, that would explain a number of the observations you have
> described.

I'm not sure how to change the cable vs. ota setting.  Doesn't the digital
tuner determine what it is plugged into?  As far as mythtv, it thinks the
attached device is a DVB/DTV receiver.  Kaffeine has been told to use the
us ATSC frequencies, with the results I pointed out earlier.

A.

