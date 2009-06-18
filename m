Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4658 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbZFRGLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 02:11:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [DaVinci] patches for linux-media
Date: Thu, 18 Jun 2009 08:11:51 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Subrahmanya, Chaithrika" <chaithrika@ti.com>,
	David Cohen <david.cohen@nokia.com>,
	"Curran, Dominic" <dcurran@ti.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
	Felipe Balbi <felipe.balbi@nokia.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	Mikko Hurskainen <mikko.hurskainen@nokia.com>,
	"Menon, Nishanth" <nm@ti.com>, "R, Sivaraj" <sivaraj@ti.com>,
	"Paulraj, Sandeep" <s-paulraj@ti.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@nokia.com>,
	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20090616104018.44075a80@pedra.chehab.org> <200906170830.14052.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40139DF9EE9@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139DF9EE9@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906180811.51808.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 June 2009 23:01:21 Karicheri, Muralidharan wrote:
> Hi Hans & Mauro,
>
> The v3 version of the DaVici VPFE Capture driver and TVP514x driver has
> been sent to the list for review. I expect this to sail through with out
> any comments as I have addressed few minor comments from last review. I
> think Hans will send you the pull request for these patches. Once again,
> it will be great if this can be merged to 2.6.31.

I'll prepare a pull request for this tomorrow.

Regards,

	Hans

>
> Murali Karicheri
> m-karicheri2@ti.com
>
> >I have proposed this before, but I'll do it again: I'm more than happy
> > to be
> >the official person who collects and organizes the omap and davinci
> > patches for you and who does the initial reviews. This is effectively
> > already the case since I've been reviewing both omap and davinci
> > patches pretty much from the beginning.
> >
> >Both the omap2/3 display driver and the davinci drivers are now very
> > close to be ready for inclusion in the kernel as my last reviews only
> > found some minor things.
> >
> >Part of the reason for the delays for both omap and davinci was that
> > they had to be modified for v4l2_subdev, which was an absolute
> > necessity, and because they simply needed quite a bit of work to make
> > them suitable for inclusion in the kernel.
> >
> >Regards,
> >
> >	Hans
> >
> >--
> >Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
