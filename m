Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425960AbcBRKDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 05:03:20 -0500
Date: Thu, 18 Feb 2016 08:03:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Russel Winder <russel@winder.org.uk>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
Message-ID: <20160218080313.12e0821a@recife.lan>
In-Reply-To: <87y4aie4uy.fsf@intel.com>
References: <20160217145254.3085b333@lwn.net>
	<20160217215138.15b6de82@recife.lan>
	<1455783420.10645.21.camel@winder.org.uk>
	<20160218063114.370b84cf@recife.lan>
	<87y4aie4uy.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 Feb 2016 11:37:41 +0200
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Thu, 18 Feb 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > Are there any tools that would convert from DocBook to ASCIIDoc?  
> 
> I used pandoc when I tested the asciidoc pipeline. Something along the
> lines of this for filtering docbook in stdin to asciidoc in stdout:
> 
> pandoc --atx-headers -f docbook -t asciidoc
>

Results are at:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/pandoc_asciidoc/

pandoc/asciidoc also broke the tables.


Thanks,
Mauro
