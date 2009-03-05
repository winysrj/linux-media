Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:65137 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCEHrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 02:47:07 -0500
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: identifying camera sensor
Date: Thu, 5 Mar 2009 09:46:47 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
References: <63862.62.70.2.252.1236178340.squirrel@webmail.xs4all.nl>
In-Reply-To: <63862.62.70.2.252.1236178340.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903050946.47565.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 March 2009 16:52:20 ext Hans Verkuil wrote:
> > Alternatively, VIDIOC_QUERYCAP could be used to identify the sensor.
> > Would it make more sense if it would return something like
> >   capability.card:  `omap3/smia-sensor-12-1234-5678//'
> > where 12 would be manufacturer_id, 1234 model_id, and
> > 5678 revision_number?
> 
> Yuck :-)

Agreed :)

Also, if there are many slaves, the length of the capability.card
field is not sufficient.

From: Trent Piepho <xyzzy@speakeasy.org>
> You could always try to decode the manufacturer name and maybe even the
> model name.  After all, pretty much every other driver does this.

That would be possible, but the driver would then need a device name table
which would need to be modified whenever a new chip comes up :(

On Wednesday 04 March 2009 16:52:20 ext Hans Verkuil wrote:
> G_CHIP_IDENT is probably the way to go, provided you are aware of the
> limitations of this ioctl. Should this be a problem, then we need to think
> of a better solution.

Could you tell me what limitations?

I thought about that ioctl initially, but then read that it is going
to be removed, that's why abandoned it.

http://n2.nabble.com/-REVIEW--v4l2-debugging:-match-drivers-by-name-instead-of-the-deprecated-ID-td1681635.html

But if you say it's a good way, then I'll go that way.
The intention is to get the SMIA driver included into official kernel,
so I'd prefer a method which allows that :-)


- Tuukka
