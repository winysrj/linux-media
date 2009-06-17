Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59262 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbZFQVBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 17:01:47 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Sakari Ailus <sakari.ailus@nokia.com>,
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
Date: Wed, 17 Jun 2009 16:01:21 -0500
Subject: RE: [DaVinci] patches for linux-media
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF9EE9@dlee06.ent.ti.com>
References: <20090616104018.44075a80@pedra.chehab.org>
 <200906170830.14052.hverkuil@xs4all.nl>
In-Reply-To: <200906170830.14052.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans & Mauro,

The v3 version of the DaVici VPFE Capture driver and TVP514x driver has been sent to the list for review. I expect this to sail through with out any comments as I have addressed few minor comments from last review. I think Hans will send you the pull request for these patches. Once again, it will be great if this can be merged to 2.6.31.

Murali Karicheri
m-karicheri2@ti.com

>I have proposed this before, but I'll do it again: I'm more than happy to
>be
>the official person who collects and organizes the omap and davinci patches
>for you and who does the initial reviews. This is effectively already the
>case since I've been reviewing both omap and davinci patches pretty much
>from the beginning.
>
>Both the omap2/3 display driver and the davinci drivers are now very close
>to be ready for inclusion in the kernel as my last reviews only found some
>minor things.
>
>Part of the reason for the delays for both omap and davinci was that they
>had to be modified for v4l2_subdev, which was an absolute necessity, and
>because they simply needed quite a bit of work to make them suitable for
>inclusion in the kernel.
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

