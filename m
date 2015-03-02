Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58727 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbbCBOeI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2015 09:34:08 -0500
Date: Mon, 2 Mar 2015 11:34:01 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>
Subject: Re: [PATCH 1/2] [media] dvbdev: use adapter arg for
 dvb_create_media_graph()
Message-ID: <20150302113401.47208e75@recife.lan>
In-Reply-To: <54F46E83.2010008@xs4all.nl>
References: <b32471cf9f1ac95ae4bf181c7abfcbd6382554d7.1425304947.git.mchehab@osg.samsung.com>
	<54F46E83.2010008@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 02 Mar 2015 15:06:59 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Small nitpick:
> 
> >  extern void dvb_unregister_device (struct dvb_device *dvbdev);
> > -void dvb_create_media_graph(struct media_device *mdev);
> > +
> > +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
> > +void dvb_create_media_graph(struct dvb_adapter *adap);
> > +#else
> > +static inline void dvb_create_media_graph(struct dvb_adapter *adap) {};
> 
> Unnecessary trailing ';'.
> 
> Regards,
> 
> 	Hans
>
Fixed, thanks!

Regards,
Mauro
