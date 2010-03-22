Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45966 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0CVNc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 09:32:27 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Pawel Osciak <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 22 Mar 2010 19:02:19 +0530
Subject: RE: [REPORT] Brainstorm meeting on V4L2 memory handling
Message-ID: <19F8576C6E063C45BE387C64729E7394044DE0E7BA@dbde02.ent.ti.com>
References: <201003131456.21510.hverkuil@xs4all.nl>
 <19F8576C6E063C45BE387C64729E7394044DE0E50D@dbde02.ent.ti.com>
 <004801cac9bf$b2e32e90$18a98bb0$%osciak@samsung.com>
In-Reply-To: <004801cac9bf$b2e32e90$18a98bb0$%osciak@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Pawel Osciak [mailto:p.osciak@samsung.com]
> Sent: Monday, March 22, 2010 6:31 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Subject: RE: [REPORT] Brainstorm meeting on V4L2 memory handling
> 
> Hello!
> 
> >Hiremath, Vaibhav wrote:
> >> 1) Memory-to-memory devices
> >>
> >> Original thread with the proposal from Samsung:
> >>
> >> http://www.mail-archive.com/linux-samsung-
> soc@vger.kernel.org/msg00391.html
> >>
> >[Hiremath, Vaibhav] Pawel,
> >
> >I wanted to start prototyping Resizer and Previewer driver to this
> framework,
> > before starting just wanted to make sure that I start with latest and
> > greatest. Is V2 post still holds latest? Did you do any changes after
> that?
> >
> 
> Only some minor tweaks for v3, which is currently underway. This is the
> expected
> changelog for it:
> 
> - streamon/off will have to be called on both queues instead of just either
> one
> - automatic rescheduling for instances if they have more buffers waiting
> - addressing comments from Andy Walls
> 
> All in all, I do not expect any other API changes and only minor tweaks
> under
> the hood. It should be ready this week.
> 
[Hiremath, Vaibhav] In that case I can start with V2 as of now and will migrate to V3 once you post it to list. 

Thanks,
Vaibhav

> 
> >Also, have you validated this with actual hardware module? If not then I
> think
> >I can now start on this and add resizer driver to it.
> 
> Yes, we have actually been using v2 for several real devices, one of which
> was
> the previously posted S3C rotator driver:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg13606.html
> 
> And there is always the test device, which was posted along with v2.
> 
> If you come across any problems or have more questions, I would be happy to
> help.
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center
> 

