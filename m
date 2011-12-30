Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:41016 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1L3Hw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 02:52:28 -0500
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LX000MMFB7AJX00@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Dec 2011 16:52:27 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LX000C3KB7E0D50@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 30 Dec 2011 16:52:26 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <201112281501.25091.laurent.pinchart@ideasonboard.com>
 <001601ccc5f1$4db353d0$e919fb70$%kim@samsung.com>
 <201112300116.28572.laurent.pinchart@ideasonboard.com>
In-reply-to: <201112300116.28572.laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC PATCH 0/4] Add some new camera controls
Date: Fri, 30 Dec 2011 16:52:26 +0900
Message-id: <000101ccc6c7$f9384db0$eba8e910$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Friday, December 30, 2011 9:16 AM
> To: HeungJun, Kim
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl;
> sakari.ailus@iki.fi; s.nawrocki@samsung.com; kyungmin.park@samsung.com
> Subject: Re: [RFC PATCH 0/4] Add some new camera controls
> 
> Hi,
> 
> On Thursday 29 December 2011 07:15:46 HeungJun, Kim wrote:
> > On Wednesday, December 28, 2011 11:01 PM Laurent Pinchart wrote:
> > > On Wednesday 28 December 2011 07:23:44 HeungJun, Kim wrote:
> > > > Hi everyone,
> > > >
> > > > This RFC patch series include new 4 controls ID for digital camera.
> > > > I about to suggest these controls by the necessity enabling the M-5MOLS
> > > > sensor's function, and I hope to discuss this in here.
> > >
> > > Thanks for the patches.
> > >
> > > The new controls introduced by these patches are very high level. Should
> > > they be put in their own class ? I also think we should specify how
> > > those high- level controls interact with low-level controls, otherwise
> > > applications will likely get very confused.
> >
> > I did not consider yet, but I think it's first to define about what
> > low-/high- is. I think this is not high- level controls. And, honestly, I
> > don't understand it's really important to categorize low-/high-, or not.
> >
> > IMHO, The importance is the just complexity of interacting with each
> > modules. If this means the level of low-/high-, I can understand this.
> > But I'm wrong, please explain this. :)
> 
> Low level controls are usually handled in hardware and pretty much self-
> contained. High level controls are usually software algorithms (possibly
> running on the sensor itself) that modify low level controls behind the scene.
> 
> If a sensor exposes both an exposure time control and a scene mode control
> that modifies exposure time handling, documentation of the scene mode control
> must explain how the two interacts and what applications can and can't do.
Ok, thanks for the explanation.
I should include the ISP's contents in the documentation, and this might be
the key I explain easily.

I'll prepare the next RFC add the more details in the document.
Probably, it seems to be lack of explanation about these controls I suggested.

Regards,
Heungjun Kim

> 
> > There is some different story, I just got the N900 some days ago :).
> > The purpose is just understanding Nokia and TI OMAP camera architecture
> > well. Probably, it helps for me to talk more easily, and I'll be able to
> > speak more well
> > with omap workers - you and Sakari.
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

