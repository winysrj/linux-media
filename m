Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38648 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbcEDQPo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 12:15:44 -0400
Date: Wed, 4 May 2016 13:15:29 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160504131529.0be6a9c3@recife.lan>
In-Reply-To: <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<1457076530.13171.13.camel@winder.org.uk>
	<CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
	<87a8m9qoy8.fsf@intel.com>
	<20160308082948.4e2e0f82@recife.lan>
	<CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com>
	<20160308103922.48d87d9d@recife.lan>
	<20160308123921.6f2248ab@recife.lan>
	<20160309182709.7ab1e5db@recife.lan>
	<87fuvypr2h.fsf@intel.com>
	<20160310122101.2fca3d79@recife.lan>
	<AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de>
	<8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de>
	<20160412094620.4fbf05c0@lwn.net>
	<CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com>
	<CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
	<54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 4 May 2016 11:34:08 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi all, (hi Jonathan, please take note of my offer below)
> 
> Am 03.05.2016 um 16:31 schrieb Daniel Vetter <daniel.vetter@ffwll.ch>:
> 
> > Hi all,
> > 
> > So sounds like moving ahead with rst/sphinx is the option that should
> > allow us to address everyone's concerns eventually? Of course the
> > first one won't have it all (media seems really tricky), ...  
> 
> BTW: Mauro mentioned that ASCII-art tables are not diff-friendly ... 
> 
> Am 18.04.2016 um 13:16 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> 
> > With that sense, the "List tables" format is also not good, as
> > one row addition would generate several hunks (one for each column
> > of the table), making harder to review the patch by just looking at
> > the diff.  
> 
> For this, I wrote the "flat-table" reST-directive, which adds 
> missing cells automatically:
> 
> doc:    http://return42.github.io/sphkerneldoc/articles/table_concerns.html#flat-table
> source: https://github.com/return42/sphkerneldoc/blob/master/doc/extensions/rstFlatTable.py

Yeah, this should address the lack of a proper way to markup cell/row
spans, providing the additional bits for the tables we have at media.

Yet, there are some issues with table conversions. See below.

> 
> I used "flat-table" to migrate all DocBook-XML documents to reST. With this
> directive, I also managed to migrate the complete media book (no more TODOs)
> incl. the large tables like them from subdev-formats:
> 
> https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/subdev-formats.html
> 
> (Rendering large tables is a general discussion which should not take place in this MT)

Some tables, like the one here:
	https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/control.html

are truncated (tested with Mozilla and Chrome), and part of the information is
lost due to that.

Regards,
Mauro
