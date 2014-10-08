Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:3395 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbaJHPzf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Oct 2014 11:55:35 -0400
Date: Wed, 8 Oct 2014 17:49:57 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/1] Add a libv4l plugin for Exynos4 camera
Message-Id: <20141008174957.8451ebb426619d88d7a30cfd@ao2.it>
In-Reply-To: <54353AA3.3040506@samsung.com>
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
	<1412757980-23570-2-git-send-email-j.anaszewski@samsung.com>
	<54353124.1060704@redhat.com>
	<54353AA3.3040506@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 08 Oct 2014 15:22:43 +0200
Jacek Anaszewski <j.anaszewski@samsung.com> wrote:

> Hi Hans,
> 
> On 10/08/2014 02:42 PM, Hans de Goede wrote:
> > Hi,
> >
> > On 10/08/2014 10:46 AM, Jacek Anaszewski wrote:
> >> The plugin provides support for the media device on Exynos4 SoC.
> >> Added is also a media device configuration file parser.
> >> The media configuration file is used for conveying information
> >> about media device links that need to be established as well
> >> as V4L2 user control ioctls redirection to a particular
> >> sub-device.
> >>
> >> The plugin performs single plane <-> multi plane API conversion,
> >> video pipeline linking and takes care of automatic data format
> >> negotiation for the whole pipeline, after intercepting
> >> VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.
> >>
> >> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>   configure.ac                                       |    1 +
> >>   lib/Makefile.am                                    |    5 +-
> >>   lib/libv4l-exynos4-camera/Makefile.am              |    7 +
> >>   .../libv4l-devconfig-parser.h                      |  145 ++
> >>   lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c  | 2486 ++++++++++++++++++++
> >>   5 files changed, 2642 insertions(+), 2 deletions(-)
> >>   create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
> >>   create mode 100644 lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h
> >>   create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
> >
> > Ugh, that is a big plugin. Can you please split out the parser stuff
> > into a separate file ?
> 
> Yes, I tried to split it, but spent so much time fighting with
> autotools, that I decided to submit it in this form and ask
> more experienced v4l-utils build system maintainers for the advice.
> I mentioned this in the cover letter.
> 

What autotools issue in particular?
The following change followed by "automake && ./configure" should be
enough to add a new file libv4l-devconfig-parser.c:

diff --git a/lib/libv4l-exynos4-camera/Makefile.am b/lib/libv4l-exynos4-camera/Makefile.am
index 3552ec8..14d461a 100644
--- a/lib/libv4l-exynos4-camera/Makefile.am
+++ b/lib/libv4l-exynos4-camera/Makefile.am
@@ -2,6 +2,6 @@ if WITH_V4L_PLUGINS
 libv4l2plugin_LTLIBRARIES = libv4l-exynos4-camera.la
 endif

-libv4l_exynos4_camera_la_SOURCES = libv4l-exynos4-camera.c
+libv4l_exynos4_camera_la_SOURCES = libv4l-exynos4-camera.c libv4l-devconfig-parser.c
 libv4l_exynos4_camera_la_CPPFLAGS = -fvisibility=hidden -std=gnu99
 libv4l_exynos4_camera_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread


If you wanted to completely reset the build environment you could
even use "git clean", FWIW I have this "git distclean" alias in
~/.gitconfig:

[alias]
	distclean = clean -f -d -X

You'll need to rerun "autoreconf -i" after such a cleanup.

Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
