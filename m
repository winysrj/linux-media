Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4506 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZCJHPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 03:15:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: V4L2 spec
Date: Tue, 10 Mar 2009 08:14:41 +0100
Cc: Andy Walls <awalls@radix.net>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	wk <handygewinnspiel@gmx.de>, linux-media@vger.kernel.org
References: <200903061523.15766.hverkuil@xs4all.nl> <1236642394.3104.25.camel@palomino.walls.org> <20090309215415.6445054d@pedra.chehab.org>
In-Reply-To: <20090309215415.6445054d@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903100814.41383.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 March 2009 01:54:15 Mauro Carvalho Chehab wrote:
> On Mon, 09 Mar 2009 19:46:34 -0400
>
> Andy Walls <awalls@radix.net> wrote:
> > > and integrating it into the existing v4l docbook,
> >
> > I'm not sure of the value in that.
>
> The DVB conversion to docbook allows us to add it at the kernel docbook
> docs (probably, not the entire doc, but the parts that describe the
> internal kernel API).
>
> > <opinion>
> > Implmenting something to multiple (or multi-volume) specifications is
> > indeed a pain, but it makes documentation maintenance easier as the
> > task is easily divided along areas of personnel expertise.  Assuming
> > the rate of documentation maintencance does not rapidly increase,
> > keeping documentation maintenace simple is paramount.
>
> If you take a look on V4L docbooks, it is divided into multiple volume
> files:
>
> biblio.sgml          pixfmt-nv16.sgml                 vidioc-enumstd.sgml
> common.sgml          pixfmt-packed-rgb.sgml          
> vidioc-g-audioout.sgml compat.sgml          pixfmt-packed-yuv.sgml       
>    vidioc-g-audio.sgml controls.sgml        pixfmt-sbggr16.sgml          
>    vidioc-g-crop.sgml dev-capture.sgml     pixfmt-sbggr8.sgml            
>   vidioc-g-ctrl.sgml dev-codec.sgml       pixfmt-sgbrg8.sgml             
>  vidioc-g-enc-index.sgml ...
>
> If we merge DVB there, for sure we should break it into some files, and
> maybe even having they on separate directories.
>
> > Also multiple specifcations (or volumes) clearly group requirements
> > into large chunks of "I don't care about that volume" and "I do care
> > about this volume".  Combining the V4L2 and DVB spec into one volume
> > would probably be a strategic error for some tactical advantage in
> > dealing with hybrid devices.
>
> This is a good point.
>
> On my opinion, it seems good to merge the docs. This is just my 2 cents.
>
> If we merge both, IMO, we should break the doc into two parts, being one
> for analog and another for digital, with an introductory text with the
> hybrid devices glue.
>
> If we decide not to merge, we can at least try to follow the same model
> on both documents, and link a common sgml introductory text for hybrid
> devices to be added on both documents.

Part of the DVB API relating to audio/video decoding is actually shared 
between DVB and V4L (ivtv uses it for decoding). So that alone is a good 
argument IMHO to merge the two.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
