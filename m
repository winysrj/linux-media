Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40152 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1K1TUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 14:20:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alex <alex.vizor@gmail.com>
Subject: Re: uvcvideo: Failed to query (SET_CUR) UVC control 10 on unit 2: -32 (exp. 2).
Date: Mon, 28 Nov 2011 20:20:46 +0100
Cc: linux-media@vger.kernel.org
References: <4ED29713.1010202@gmail.com> <201111282008.44684.laurent.pinchart@ideasonboard.com> <4ED3DD91.1060505@gmail.com>
In-Reply-To: <4ED3DD91.1060505@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111282020.47745.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On Monday 28 November 2011 20:14:25 Alex wrote:
> On 11/28/2011 10:08 PM, Laurent Pinchart wrote:
> > On Monday 28 November 2011 19:04:22 Alex wrote:
> >> 
> >> Fortunately my laptop is alive now so I'm sending you lsusb output.
> > 
> > Thanks. Would you mind re-running lsusb -v -d '04f2:b221' as root ? What
> > laptop brand/model is the camera embedded in ?
> > 
> >> About reverting commit - will try bit later.
> > 
> > I've received reports that reverting the commit helps. A proper patch has
> > also been posted to the linux-usb mailing list ("EHCI : Fix a regression
> > in the ISO scheduler"). It would be nice if you could check whether that
> > fixes your first issue as well.
> 
> That is lsusb output you asked. Laptop is Thinkpad T420s. Camera works
> OK with 3.1.x kernel BTW.

Thank you.

> Could you send this fix patch to me please?

http://www.spinics.net/lists/linux-usb/msg54992.html

It was the first hit on Google...

-- 
Regards,

Laurent Pinchart
