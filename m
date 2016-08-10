Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:51100 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936506AbcHJTEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 15:04:38 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: parts of media docs sphinx re-building every time?
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160810074635.515fe28b@lwn.net>
Date: Wed, 10 Aug 2016 16:16:11 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Transfer-Encoding: 8BIT
Message-Id: <59C5F886-CAB7-49D0-87A6-134E37AB0856@darmarit.de>
References: <8760rbp8zh.fsf@intel.com> <20160810054755.0175f331@vela.lan> <87k2fpvuyj.fsf@intel.com> <20160810074635.515fe28b@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 10.08.2016 um 15:46 schrieb Jonathan Corbet <corbet@lwn.net>:

> On Wed, 10 Aug 2016 12:23:16 +0300
> Jani Nikula <jani.nikula@intel.com> wrote:
> 
>>>> I just noticed running 'make htmldocs' rebuilds parts of media docs
>>>> every time on repeated runs. This shouldn't happen. Please investigate.  
>>> 
>>> I was unable to reproduce it here. Are you passing any special options
>>> to the building system?  
>> 
>> Hmh, I can't reproduce this now either. I was able to hit this on
>> another machine consistently, even with 'make cleandocs' in
>> between. I'll check the environment on the other machine when I get my
>> hands on it.
> 
> Just FWIW, I've been trying to find a moment to come back to this because
> I couldn't reproduce it either...
> 
> jon


Hmm, I have had problems with the relative BUILDDIR make environment, so I switched
to absolute pathname .. see my "more generic way" patch:

 htmldocs:
-	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/media/Makefile $@
+	$(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) -f $(srctree)/Documentation/media/Makefile $@

could this the reason why you can't reproduce it?

My problem was vice versa, if I called "make O=/tmp/kernel htmldocs" after
a make with normal output, the rst files has been found in Documents/output
and not regenerated in /tmp/kernel/Documents/output. 

And with "make O=/tmp/kernel clean", the rst files in Documents/output resists.

This was very confusing to me, so I changed it to absolute pathname.

--Markus--

