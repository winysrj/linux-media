Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:33576 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbcHOOIv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 10:08:51 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH 0/5] doc-rst: improvements Sphinx's C-domain
Date: Mon, 15 Aug 2016 16:08:23 +0200
Message-Id: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi,

this is my approach to eliminate some distortions we have with the c/cpp Sphinx
domains. The C domain is simple: it assumes that all functions, enums, etc
are global, e. g. there should be just one function called "ioctl", or "open".
With the 'name' option e.g.:

    .. c:function:: int ioctl( int fd, int request )
       :name: VIDIOC_LOG_STATUS

we can rename those functions. Another nice feature around this *global*
namespace topic is, that the *duplicate C object description* warnings for
function declarations are moved to the nitpicky mode.

Thanks for your comments

  -- Markus --

Markus Heiser (5):
  doc-rst: add boilerplate to customize c-domain
  doc-rst:c-domain: ref-name of a function declaration
  doc-rst: moved *duplicate* warnings to nitpicky mode
  doc-rst: Revert "kernel-doc: fix handling of address_space tags"
  doc-rst: migrate ioctl CEC_DQEVENT to c-domain

 Documentation/conf.py                            |   2 +-
 Documentation/kernel-documentation.rst           |  29 +++++++
 Documentation/media/uapi/cec/cec-func-open.rst   |   2 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst |   5 +-
 Documentation/sphinx/cdomain.py                  | 102 +++++++++++++++++++++++
 scripts/kernel-doc                               |   3 -
 6 files changed, 136 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/sphinx/cdomain.py

-- 
2.7.4

