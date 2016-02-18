Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34184 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425542AbcBRJhr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 04:37:47 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Russel Winder <russel@winder.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
In-Reply-To: <20160218063114.370b84cf@recife.lan>
References: <20160217145254.3085b333@lwn.net> <20160217215138.15b6de82@recife.lan> <1455783420.10645.21.camel@winder.org.uk> <20160218063114.370b84cf@recife.lan>
Date: Thu, 18 Feb 2016 11:37:41 +0200
Message-ID: <87y4aie4uy.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Feb 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Are there any tools that would convert from DocBook to ASCIIDoc?

I used pandoc when I tested the asciidoc pipeline. Something along the
lines of this for filtering docbook in stdin to asciidoc in stdout:

pandoc --atx-headers -f docbook -t asciidoc


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
