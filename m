Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44159 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab2KMSCn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 13:02:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TYKov-0007QD-Pr
	for linux-media@vger.kernel.org; Tue, 13 Nov 2012 19:02:45 +0100
Received: from 84-72-11-174.dclient.hispeed.ch ([84.72.11.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 19:02:45 +0100
Received: from auslands-kv by 84-72-11-174.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 19:02:45 +0100
To: linux-media@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: Color problem with MPX-885 card (cx23885)
Date: Tue, 13 Nov 2012 19:02:25 +0100
Message-ID: <k7u1vf$q5h$1@ger.gmane.org>
References: <k7tkcu$m6j$1@ger.gmane.org> <CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com> <k7tt38$aol$1@ger.gmane.org> <CAGoCfiww92i7w9xuG199Pdv5EQbFButWxT=CHC9Wg2ypY+M1PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAGoCfiww92i7w9xuG199Pdv5EQbFButWxT=CHC9Wg2ypY+M1PA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.11.2012 18:07, schrieb Devin Heitmueller:
> On Tue, Nov 13, 2012 at 11:39 AM, Neuer User <auslands-kv@gmx.de> wrote:
>> The minor ones (card not autodetected, and black border on the left
>> side) can probably be dealt with, e.g. in postprocessing. Or is there a
>> chance to fix these in the driver?
> 
> They can almost certainly be fixed in the driver (the black border is
> a result of incorrect HSYNC configuration for PAL standards).  The
> bigger issue though is finding someone willing to do the work.  If
> this is for a commercial application, you may wish to reach out to
> Steven Toth.  He did the original MPX support as a consulting project.
> 
> Devin
> 

Hi Devin

Thanks for the help.

The HSYNC problem is bigger than I thought. I compared the captured
image with an image from another (USB) video digitizer and it is obvious
that the image has lost about 10-20% on the right side and on the bottom.

Can probably be easily fixed. But it is no commercial project, so I need
to do it myself, I guess. I hope there are some settings in the driver.
Any idea where I need to look? (Is it the cx23885 driver at all or even
the cx25840?)

Michael

