Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49456 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1K3Bvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 20:51:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alex <alex.vizor@gmail.com>
Subject: Re: uvcvideo: Failed to query (SET_CUR) UVC control 10 on unit 2: -32 (exp. 2).
Date: Wed, 30 Nov 2011 02:51:54 +0100
Cc: linux-media@vger.kernel.org
References: <4ED29713.1010202@gmail.com> <201111282020.47745.laurent.pinchart@ideasonboard.com> <4ED402CF.2010100@gmail.com>
In-Reply-To: <4ED402CF.2010100@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111300251.55083.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On Monday 28 November 2011 22:53:19 Alex wrote:
> On 11/28/2011 10:20 PM, Laurent Pinchart wrote:
> > On Monday 28 November 2011 20:14:25 Alex wrote:
> >> On 11/28/2011 10:08 PM, Laurent Pinchart wrote:
> >>> On Monday 28 November 2011 19:04:22 Alex wrote:
> >>>> Fortunately my laptop is alive now so I'm sending you lsusb output.
> >>> 
> >>> Thanks. Would you mind re-running lsusb -v -d '04f2:b221' as root ?
> >>> What laptop brand/model is the camera embedded in ?
> >>> 
> >>>> About reverting commit - will try bit later.
> >>> 
> >>> I've received reports that reverting the commit helps. A proper patch
> >>> has also been posted to the linux-usb mailing list ("EHCI : Fix a
> >>> regression in the ISO scheduler"). It would be nice if you could check
> >>> whether that fixes your first issue as well.
> >> 
> >> That is lsusb output you asked. Laptop is Thinkpad T420s. Camera works
> >> OK with 3.1.x kernel BTW.
> > 
> > Thank you.
> > 
> >> Could you send this fix patch to me please?
> > 
> > http://www.spinics.net/lists/linux-usb/msg54992.html
> > 
> > It was the first hit on Google...
> 
> Laurent,
> 
> Seems this patch didn't help I recompiled kernel and still get same error:
> [  101.100914] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
> unit 2: -32 (exp. 2).
> [  103.900163] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
> unit 2: -32 (exp. 2).
> [  103.909735] uvcvideo: Failed to submit URB 0 (-28).
> [  107.896939] uvcvideo: Failed to query (SET_CUR) UVC control 10 on
> unit 2: -32 (exp. 2).

I'm surprised. The patch has been included in 3.1.4, could you please try it ?

-- 
Regards,

Laurent Pinchart
