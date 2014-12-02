Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38888 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbaLBOKS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 09:10:18 -0500
Date: Tue, 2 Dec 2014 12:10:09 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>,
	Masanari Iida <standby24x7@gmail.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	Ricardo Ribalda <ricardo.ribalda@gmail.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kiran AVND <avnd.kiran@samsung.com>,
	Amit Grover <amit.grover@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	James Hogan <james.hogan@imgtec.com>,
	Antti =?UTF-8?B?U2VwcMOkbMOk?= <a.seppala@gmail.com>,
	Antonio Ospite <ospite@studenti.unina.it>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Arun Kumar K <arun.kk@samsung.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [media] Documentation: cleanup whitespace at DocBook
 files
Message-ID: <20141202121009.1f4f395b@recife.lan>
In-Reply-To: <20141202085349.397c4091@lwn.net>
References: <648a1c5b8d46891cc515f6b690c19a266f7a6fd8.1417526360.git.mchehab@osg.samsung.com>
	<20141202085349.397c4091@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Dec 2014 08:53:49 -0500
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue,  2 Dec 2014 11:20:26 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > While reviewing the colorspace changeset 1afed88381bb, I noticed
> > that several bad whitespaces were introduced. A deeper look showed
> > that several other changes at DocBook files added lots of
> > whitespacing issues.
> > 
> > So, clean them.
> 
> Looks good to me, I'll toss it into my docs tree unless you want to send
> it via media.

Hi Jon,

It is probably better to send it via media, as it depends on another patch
that improves documentation for colorspaces.

Regards,
Mauro
