Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56962 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbcCDHqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 02:46:55 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <1457076530.13171.13.camel@winder.org.uk>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk>
Date: Fri, 04 Mar 2016 09:46:48 +0200
Message-ID: <87vb52r8gn.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 04 Mar 2016, Russel Winder <russel@winder.org.uk> wrote:
> On Thu, 2016-03-03 at 15:23 -0800, Keith Packard wrote:
>>   1) the python version (asciidoc) appears to have been abandoned in
>>      favor of the ruby version. 
>
> This is I think true, however the Java-based tool chain Asciidoctor is
> I believe the standard bearer for ASCIIdoc these days, albeit called
> ASCIIdoctor.

If we're talking about the same asciidoctor (http://asciidoctor.org/)
it's written in ruby but you can apparently run it in JVM using
JRuby. Calling it Java-based is misleading.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
