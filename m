Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbcHFVBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2016 17:01:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] Add a way to build only media docs
Date: Sat,  6 Aug 2016 09:00:31 -0300
Message-Id: <cover.1470484077.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Being able to build just the media docs is important for us due to several
reasons:

1) Media developers community hosts a copy of the media documentation at linuxtv.org
    with the very latest  under development documents;

2) Nitpicking to identify broken references is important to identify documentation gaps
    that need to be addressed on future releases;

3) As media maintainers check patch per patch if a documentation gap is introduced, building
    media documentation should be as fast as possible.

This patchset adds a media file adding nitpick support and an extra build target that will
compile only the media documentation. It also groups all media documentation into one
section on the main Kernel document, with is, IMHO, a good thing as we start adding more
stuff there.

Jon,

I'd love to see this patch merged early at the -rc cycle, in order to avoid merge
conflicts when people start converting other docbooks to Sphinx, as it touches
at the main Makefile and at the Sphinx common stuff. Also, as I'll need to patch my
build scripts to check for documentation issues with Sphinx, I need them on my
master branch, as otherwise my workflow will be broken until the next Kernel release.

So, If you're ok with this patch series, can you submit to Linus on early -rc? Or 
if you prefer, I can do it myself, with your ack.

Thanks!
Mauro

PS.: I would prefer to have a more generic way to add support to build documentation
for only one subsystem, but, as we also need to load an extra python module to be
able to enable nitpick mode, I opted, for now, on not doing it too generic. We can rework
on it later, as other subsystems would need a similar feature.


Markus Heiser (1):
  doc-rst: support additional Sphinx build config override

Mauro Carvalho Chehab (2):
  doc-rst: add an option to build media documentation in nitpick mode
  doc-rst: remove a bogus comment from Documentation/index.rst

 Documentation/Makefile.sphinx       | 10 ++++-
 Documentation/conf.py               |  9 ++++
 Documentation/index.rst             |  7 +--
 Documentation/media/conf_nitpick.py | 85 +++++++++++++++++++++++++++++++++++++
 Documentation/media/index.rst       | 12 ++++++
 Documentation/sphinx/load_config.py | 25 +++++++++++
 Makefile                            |  6 +++
 7 files changed, 146 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/media/conf_nitpick.py
 create mode 100644 Documentation/media/index.rst
 create mode 100644 Documentation/sphinx/load_config.py

-- 
2.7.4


