Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.4]:56130 "EHLO
	IMPaqm4.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0EQTcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 May 2010 15:32:31 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: AF9015 suspend problem
Date: Mon, 17 May 2010 21:32:23 +0200
Cc: linux-media@vger.kernel.org
References: <201005021739.18393.jareguero@telefonica.net> <201005140250.30481.jareguero@telefonica.net> <4BED3F73.3010708@iki.fi>
In-Reply-To: <4BED3F73.3010708@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005172132.23964.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El Viernes, 14 de Mayo de 2010, Antti Palosaari escribió:
> On 05/14/2010 03:50 AM, Jose Alberto Reguero wrote:
> > El Jueves, 13 de Mayo de 2010, Antti Palosaari escribió:
> >> Terve!
> >> 
> >> On 05/02/2010 06:39 PM, Jose Alberto Reguero wrote:
> >>> When I have a af9015 DVB-T stick plugged I can not recover from pc
> >>> suspend. I must unplug the stick to suspend work. Even if I remove the
> >>> modules I cannot recover from suspend.
> >>> Any idea why this happen?
> >> 
> >> Did you asked this 7 months ago from me?
> >> I did some tests (http://linuxtv.org/hg/~anttip/suspend/) and looks like
> >> it is firmware loader problem (fw loader misses something or like
> >> that...). No one answered when I asked that from ML, but few weeks ago I
> >> saw some discussion. Look ML archives.
> >> 
> >> regards
> >> Antti
> > 
> > I think that is another problem. If I blacklist the af9015 driver and
> > have the stick plugged in, the suspend don't finish, and the system
> > can't resume. If I unplugg the stick the suspend feature work well.
> 
> Look these and check if it is same problem:
> 
> DVB USB resume from suspend crash
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg09974.html
> 
> Re: tuner XC5000 race condition??
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg18012.html
> 
> Bug 15294 -  Oops due to an apparent race between udev and a timeout in
> firmware_class.c
> https://bugzilla.kernel.org/show_bug.cgi?id=15294
> 
> I haven't examined those yet, but I think they could be coming from same
> issue.
> 
> br,
> Antti

I found my problem. Was a quirk that I have in the kernel parameters:
usbhid.quirks=0x07ca:0xa815:0x04
Without the quirk, the system go to sleep an can wake, although only the first 
time. The second time the system don't sleep. Perhaps I have some wrong in my 
scripts.

Jose Alberto

