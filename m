Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:15999 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751Ab0IMNaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 09:30:55 -0400
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc
 driver
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <4C8E0ABF.5060601@redhat.com>
References: <201009122226.11970.hverkuil@xs4all.nl>
	 <1284325962.2394.24.camel@localhost> <1284326939.2394.29.camel@localhost>
	 <4C8E0ABF.5060601@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 09:30:34 -0400
Message-ID: <1284384634.2031.71.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-09-13 at 08:27 -0300, Mauro Carvalho Chehab wrote:
> Em 12-09-2010 18:28, Andy Walls escreveu:
> > On Sun, 2010-09-12 at 17:12 -0400, Andy Walls wrote:
> >> On Sun, 2010-09-12 at 22:26 +0200, Hans Verkuil wrote:
> >>
> >>> And other news on the V4L1 front:
> >>
> >>> I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
> >>> support can be removed from that driver as well.
> >>
> >> FYI, that will break this 2005 vintage piece of V4L1 software people may
> >> still be using for the QX5 microscope:
> > 
> > Sorry, that is of course, if there is no V4L1 compat layer still in
> > place.
> > 
> > BTW, qx5view uses a private ioctl() to change the lights on a QX5 and
> > not the V4L2 control.
> 
> The better would be to port qx5view to use libv4l and implement the new
> illuminator ctrl on the driver and on the userspase app. Do you have
> hardware for testing this?

No.  I did check Amazon.com and eBay and saw a QX5 for about US$75 after
shipping costs:

http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=380262406989&rvr_id=139147359954&crlp=1_263602_263622&UA=L*F%3F&GUID=0b3b537412b0a0e203e63006ff9becb0&itemid=380262406989&ff4=263602_263622

I'm not sure if I want to buy one at that price, since I already have a
QX3.

Regards,
Andy

