Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37765 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbbBUTmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 14:42:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id D5A942097F
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2015 14:42:53 -0500 (EST)
Date: Sat, 21 Feb 2015 11:42:52 -0800
From: Greg KH <greg@kroah.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, Pavel Machek <pavel@ucw.cz>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
Message-ID: <20150221194252.GB14032@kroah.com>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
 <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
 <20150218224747.GA3999@amd>
 <20150219090204.GI3915@valkosipuli.retiisi.org.uk>
 <20150219214043.GB29875@kroah.com>
 <54E6E89B.4050404@samsung.com>
 <20150220153616.GB18111@kroah.com>
 <54E75D8E.40004@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54E75D8E.40004@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 20, 2015 at 05:15:10PM +0100, Jacek Anaszewski wrote:
> On 02/20/2015 04:36 PM, Greg KH wrote:
> >On Fri, Feb 20, 2015 at 08:56:11AM +0100, Jacek Anaszewski wrote:
> >>On 02/19/2015 10:40 PM, Greg KH wrote:
> >>>On Thu, Feb 19, 2015 at 11:02:04AM +0200, Sakari Ailus wrote:
> >>>>On Wed, Feb 18, 2015 at 11:47:47PM +0100, Pavel Machek wrote:
> >>>>>
> >>>>>On Wed 2015-02-18 17:20:22, Jacek Anaszewski wrote:
> >>>>>>Add a documentation of LED Flash class specific sysfs attributes.
> >>>>>>
> >>>>>>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>>>>>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>>>>Cc: Bryan Wu <cooloney@gmail.com>
> >>>>>>Cc: Richard Purdie <rpurdie@rpsys.net>
> >>>>>
> >>>>>NAK-ed-by: Pavel Machek
> >>>>>
> >>>>>>+What:		/sys/class/leds/<led>/available_sync_leds
> >>>>>>+Date:		February 2015
> >>>>>>+KernelVersion:	3.20
> >>>>>>+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
> >>>>>>+Description:	read/write
> >>>>>>+		Space separated list of LEDs available for flash strobe
> >>>>>>+		synchronization, displayed in the format:
> >>>>>>+
> >>>>>>+		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.
> >>>>>
> >>>>>Multiple values per file, with all the problems we had in /proc. I
> >>>>>assume led_id is an integer? What prevents space or dot in led name?
> >>>>
> >>>>Very good point. How about using a newline instead? That'd be a little bit
> >>>>easier to parse, too.
> >>>
> >>>No, please make it one value per-file, which is what sysfs requires.
> >>
> >>The purpose of this attribute is only to provide an information about
> >>the range of valid identifiers that can be written to the
> >>flash_sync_strobe attribute. Wouldn't splitting this to many attributes
> >>be an unnecessary inflation of sysfs files?
> >
> >Ok a list of allowed values to write is acceptable, as long as it is not
> >hard to parse and always is space separated.
> 
> Is a new line character also acceptable as a delimiter?

No.

Again, sysfs files should not need to be "parsed", they are
one-value-per-file for a good reason.

If you want to do something else, wonderful, but don't use sysfs.  It's
looking like this whole interface should not be using sysfs as it
doesn't fit there at all.

sorry,

greg k-h
