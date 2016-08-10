Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbcHJSvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:51:11 -0400
Date: Wed, 10 Aug 2016 05:47:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Markus Heiser <markus.heiser@darmarit.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: parts of media docs sphinx re-building every time?
Message-ID: <20160810054755.0175f331@vela.lan>
In-Reply-To: <8760rbp8zh.fsf@intel.com>
References: <8760rbp8zh.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 08 Aug 2016 18:37:38 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> Hi Mauro & co -
> 
> I just noticed running 'make htmldocs' rebuilds parts of media docs
> every time on repeated runs. This shouldn't happen. Please investigate.

I was unable to reproduce it here. Are you passing any special options
to the building system?

According to media Makefile, it should run the script only on four
conditions:
	- if the dynamically-generated rst file is not found (e. g. after
	  make cleandocs);
	- if the header file is changed;
	- if the exceptions file changes;
	- if the perl parser is changed.

All rules are like:

$(BUILDDIR)/audio.h.rst: ${UAPI}/dvb/audio.h ${PARSER} $(SRC_DIR)/audio.h.rst.exceptions

Regards,
Mauro



Cheers,
Mauro
