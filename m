Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11822 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341AbcHJSJL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:09:11 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Markus Heiser <markus.heiser@darmarit.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: parts of media docs sphinx re-building every time?
In-Reply-To: <8760rbp8zh.fsf@intel.com>
References: <8760rbp8zh.fsf@intel.com>
Date: Wed, 10 Aug 2016 10:42:27 +0300
Message-ID: <87wpjpvzmk.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 08 Aug 2016, Jani Nikula <jani.nikula@intel.com> wrote:
> I wonder if it's related to Documentation/media/Makefile... which I have
> to say I am not impressed by. I was really hoping we could build all the
> documentation by standalone sphinx-build invocation too, relying only on
> the conf.py so that e.g. Read the Docs can build the docs. Part of that
> motivation was to keep the build clean in makefiles, and handing the
> dependency tracking completely to Sphinx.
>
> I believe what's in Documentation/media/Makefile,
> Documentation/sphinx/parse-headers.pl, and
> Documentation/sphinx/kernel_include.py could be replaced by a Sphinx
> extension looking at the sources directly. (I presume kernel_include.py
> is mostly a workaround to keep out-of-tree builds working?)

Additionally, 'make pdfdocs' fails with e.g. 

/path/to/linux/Documentation/media/uapi/cec/cec-header.rst:9: SEVERE: Problems with "kernel-include" directive path:
InputError: [Errno 2] No such file or directory: '/path/to/linux/Documentation/output/cec.h.rst'.
/path/to/linux/Documentation/media/uapi/dvb/audio_h.rst:9: SEVERE: Problems with "kernel-include" directive path:
InputError: [Errno 2] No such file or directory: '/path/to/linux/Documentation/output/audio.h.rst'.
/path/to/linux/Documentation/media/uapi/dvb/ca_h.rst:9: SEVERE: Problems with "kernel-include" directive path:
InputError: [Errno 2] No such file or directory: '/path/to/linux/Documentation/output/ca.h.rst'.
/path/to/linux/Documentation/media/uapi/dvb/dmx_h.rst:9: SEVERE: Problems with "kernel-include" directive path:
InputError: [Errno 2] No such file or directory: '/path/to/linux/Documentation/output/dmx.h.rst'.

because the makefile hack is only done on htmldocs target.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
