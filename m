Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51890 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbJBK12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 06:27:28 -0400
Message-ID: <1443781636.3445.62.camel@pengutronix.de>
Subject: Re: [PATCH v3 5/5] [media] imx-ipu: Add i.MX IPUv3 scaler driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	David Airlie <airlied@linux.ie>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Kamil Debski <kamil@wypas.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Sascha Hauer <kernel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Michael Olbrich <m.olbrich@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 02 Oct 2015 12:27:16 +0200
In-Reply-To: <CAH-u=82YoBzV4KWGP+eSdzOEnk8UuRreL_sH6NU+smNnjDanuw@mail.gmail.com>
References: <1437063883-23981-1-git-send-email-p.zabel@pengutronix.de>
	 <1437063883-23981-6-git-send-email-p.zabel@pengutronix.de>
	 <55B255CD.3050304@xs4all.nl>
	 <CAH-u=81qpYNgMvkKocc6weDqoWB3tW0r5csmVZfxSYfQ-74wsQ@mail.gmail.com>
	 <1443775046.3445.49.camel@pengutronix.de>
	 <CAH-u=82YoBzV4KWGP+eSdzOEnk8UuRreL_sH6NU+smNnjDanuw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 02.10.2015, 11:06 +0200 schrieb Jean-Michel Hautbois:
> 2015-10-02 10:37 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> > Hi Jean-Michel,
> >
> > Am Donnerstag, den 01.10.2015, 09:55 +0200 schrieb Jean-Michel Hautbois:
> >> Hi Philipp, Hans,
> >>
> >>
> >> 2015-07-24 17:12 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> > [...]
> >> What is the status of this driver ?
> >> I can test it here, Philipp, are you planning to take Hans remarks
> >> into account in one of your trees ?
> >
> > Thank you for the reminder!
> >
> > I have fixed most of the issues Hans pointed out, but got distracted at
> > some point and left for other things. I'll prepare a new version of this
> > series.
> 
> OK, don't hesitate if you need some tests ;-).
> BTW, I am modifying coda support V4L2_ENC_CMD_STOP.
> I will propose a patch during the day, it is probably not perfect, so
> your review will be appreciated :).
> 
> JM
> PS: Will you be there at ELCE next week ?

Yes, let's meet there.

regards
Philipp

