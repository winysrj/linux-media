Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58151 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbZFPPke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 11:40:34 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
CC: "Jadav, Brijesh R" <brijesh.j@ti.com>,
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
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 16 Jun 2009 10:40:18 -0500
Subject: RE: OMAP patches for linux-media
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF9796@dlee06.ent.ti.com>
References: <20090616104018.44075a80@pedra.chehab.org>
In-Reply-To: <20090616104018.44075a80@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

[snip]
>
>I'm seeing lots of patches and discussions for OMAP and DaVinci being
>handled
>at the linux-media Mailing List, as part of the development process of the
>open
>source drivers.

[MK] I along with Chaithrika are working with Hans Verkuil to get the DaVinci video drivers added to open source. I believe VPIF display driver for DM6467 is ready for merge. The VPFE capture driver for DM355 and DM6446 is almost ready. I will be creating the version 3 (hopefully final) version of the patch and review the same in the list.
Do you think these patches can be merged to 2.6.31? This will be of great help to us if this can be done since we have other works lined up based on these and our customers are waiting for this for a very long time.

[snip]
>
>One fundamental concept on Kernel development is the concept of "Commit
>earlier
>and commit often", meaning that the better is to send small, incremental,
>and
>periodic patches, than wait until having everything done, then submit a big

[MK] With that in mind, we began our porting work with minimum set of features and stripped off many of the features so that we can add them incrementally.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com



