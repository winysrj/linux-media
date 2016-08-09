Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35872
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbcHISCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2016 14:02:30 -0400
Date: Tue, 9 Aug 2016 15:02:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/3] doc-rst: more generic way to build only sphinx
 sub-folders
Message-ID: <20160809150223.28fca182@recife.lan>
In-Reply-To: <20160809092108.266f37c2@lwn.net>
References: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
	<20160809092108.266f37c2@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 9 Aug 2016 09:21:08 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Mon,  8 Aug 2016 15:14:57 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
> > this is my approach for a more generic way to build only sphinx sub-folders, we
> > discussed in [1]. The last patch adds a minimal conf.py to the gpu folder, if
> > you don't want to patch the gpu folder drop it.  
> 
> I haven't had a chance to really mess with this yet, but it seems like a
> reasonable solution. 

Agreed.

> Mauro, does it give you what you need?

Yes. Just tested it here, and it works fine, allowing to build
everything, just one of the books and the media book with the nitpick
configuration.

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Please notice that Markus based his patch on my previous patch
series.

So, if it is easier for you, you could pull them altogether from my tree:

	git://linuxtv.org/mchehab/experimental.git docs-next

Or otherwise just pick the individual patches, adding my ack on the
Markus ones.

Thanks,
Mauro

The following changes since commit a157b3aaa44829998d5a079174df989e5d8c20ff:

  Merge tag 'pwm/for-4.8-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm (2016-08-06 00:01:33 -0400)

are available in the git repository at:

  docs-next 

for you to fetch changes up to 78c63a7a941d053a7dfaf787b586ff25a8e2fae9:

  doc-rst: add stand-alone conf.py to gpu folder (2016-08-09 14:48:01 -0300)

----------------------------------------------------------------
Markus Heiser (4):
      doc-rst: support additional Sphinx build config override
      doc-rst: generic way to build only sphinx sub-folders
      doc-rst: add stand-alone conf.py to media folder
      doc-rst: add stand-alone conf.py to gpu folder

Mauro Carvalho Chehab (2):
      doc-rst: add an option to build media documentation in nitpick mode
      doc-rst: remove a bogus comment from Documentation/index.rst

 Documentation/DocBook/Makefile      |  2 +-
 Documentation/Makefile.sphinx       | 46 ++++++++++++++++++++++++++++++++++++++--------
 Documentation/conf.py               |  9 +++++++++
 Documentation/gpu/conf.py           |  3 +++
 Documentation/index.rst             |  7 +------
 Documentation/media/conf.py         |  3 +++
 Documentation/media/conf_nitpick.py | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/media/index.rst       | 12 ++++++++++++
 Documentation/sphinx/load_config.py | 32 ++++++++++++++++++++++++++++++++
 9 files changed, 190 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/gpu/conf.py
 create mode 100644 Documentation/media/conf.py
 create mode 100644 Documentation/media/conf_nitpick.py
 create mode 100644 Documentation/media/index.rst
 create mode 100644 Documentation/sphinx/load_config.py


