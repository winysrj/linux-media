Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.65]:50335 "EHLO mout01.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425501AbcBRNel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 08:34:41 -0500
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 5EBF320C00
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2016 14:34:39 +0100 (CET)
Date: Thu, 18 Feb 2016 14:34:31 +0100
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160218143431.2e0a9150@lappi3.vsora>
In-Reply-To: <20160218104434.25d11e33@recife.lan>
References: <20160213145317.247c63c7@lwn.net>
	<86fuwwcdmd.fsf@hiro.keithp.com>
	<CAKMK7uGeU_grgC7pRCdqw+iDGWQfXhHwvX+tkSgRmdimxMrthA@mail.gmail.com>
	<20160217151401.3cb82f65@lwn.net>
	<CAKMK7uEqbSrhc2nh0LjC1fztciM4eTjtKE9T_wMVCqAkkTnzkA@mail.gmail.com>
	<874md6fkna.fsf@intel.com>
	<CAKMK7uE72wFEFCyw1dHbt+f3-ex3fr_9MbjoGfnKFZkd5+9S2Q@mail.gmail.com>
	<20160218082657.5a1a5b0f@recife.lan>
	<87r3gadzye.fsf@intel.com>
	<20160218100427.6471cb22@recife.lan>
	<56C5B3E7.6030509@xs4all.nl>
	<20160218104434.25d11e33@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Feb 2016 10:44:34 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> > > It is workable, but I guess nested tables produced a better
> > > result.
> > > 
> > > I did myself a test with nested tables with asciidoc too:
> > > 
> > > https://mchehab.fedorapeople.org/media-kabi-docs-test/pandoc_asciidoc/table.html
> > > https://mchehab.fedorapeople.org/media-kabi-docs-test/pandoc_asciidoc/table.ascii
> > > 
> > > With looks very decent to me.    
> > 
> > It does, except for the vertical alignment of the third column (at
> > least when viewed with google chrome).  
> 
> Not sure what you mean. Here, it looks fine on both Firefox and
> Chrome, except that the second colum size could be smaller. If this
> is what you're meaning this can be fixed by changing the second line
> from:

I think Hans' problem (I see it as well) is coming from css-style of
"paragraph" which is:

￼    margin-top: 0.5em;
￼    margin-bottom: 0.5em;

This makes the third column non-vertical-aligned

--
Patrick
