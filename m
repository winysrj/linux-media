Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 32/51] Documentation: fdl-appendix: Fix formatting issues
Date: Mon,  4 Jul 2016 08:46:53 -0300
Message-Id: <fa8b7885c146721b783344bbe44dac6c772c061d.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion didn't add blank lines where needed, but it
added were it weren't ;)

Fix it, to make it to parse correctly by Sphinx. This also
fixes a bunch or warnings:
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/fdl-appendix.rst:44: WARNING: Explicit markup ends without a blank line; unexpected unindent.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/fdl-appendix.rst:52: WARNING: Explicit markup ends without a blank line; unexpected unindent.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/fdl-appendix.rst:58: WARNING: Explicit markup ends without a blank line; unexpected unindent.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/fdl-appendix.rst:71: WARNING: Explicit markup ends without a blank line; unexpected unindent.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/fdl-appendix.rst:78: WARNING: Explicit markup ends without a blank line; unexpected unindent.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/fdl-appendix.rst:84: WARNING: Explicit markup ends without a blank line; unexpected unindent.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/fdl-appendix.rst:107: WARNING: Explicit markup ends without a blank line; unexpected unindent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/fdl-appendix.rst | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/fdl-appendix.rst b/Documentation/linux_tv/media/v4l/fdl-appendix.rst
index cb0704883744..9f3a494cf497 100644
--- a/Documentation/linux_tv/media/v4l/fdl-appendix.rst
+++ b/Documentation/linux_tv/media/v4l/fdl-appendix.rst
@@ -41,6 +41,7 @@ works whose purpose is instruction or reference.
 
 
 .. _fdl-document:
+
 This License applies to any manual or other work that contains a notice
 placed by the copyright holder saying it can be distributed under the
 terms of this License. The “Document”, below, refers to any such manual
@@ -49,12 +50,14 @@ or work. Any member of the public is a licensee, and is addressed as
 
 
 .. _fdl-modified:
+
 A “Modified Version” of the Document means any work containing the
 Document or a portion of it, either copied verbatim, or with
 modifications and/or translated into another language.
 
 
 .. _fdl-secondary:
+
 A “Secondary Section” is a named appendix or a front-matter section of
 the :ref:`Document <fdl-document>` that deals exclusively with the
 relationship of the publishers or authors of the Document to the
@@ -68,6 +71,7 @@ regarding them.
 
 
 .. _fdl-invariant:
+
 The “Invariant Sections” are certain
 :ref:`Secondary Sections <fdl-secondary>` whose titles are designated,
 as being those of Invariant Sections, in the notice that says that the
@@ -75,12 +79,14 @@ as being those of Invariant Sections, in the notice that says that the
 
 
 .. _fdl-cover-texts:
+
 The “Cover Texts” are certain short passages of text that are listed, as
 Front-Cover Texts or Back-Cover Texts, in the notice that says that the
 :ref:`Document <fdl-document>` is released under this License.
 
 
 .. _fdl-transparent:
+
 A “Transparent” copy of the :ref:`Document <fdl-document>` means a
 machine-readable copy, represented in a format whose specification is
 available to the general public, whose contents can be viewed and edited
@@ -104,6 +110,7 @@ word processors for output purposes only.
 
 
 .. _fdl-title-page:
+
 The “Title Page” means, for a printed book, the title page itself, plus
 such following pages as are needed to hold, legibly, the material this
 License requires to appear in the title page. For works in formats which
@@ -191,7 +198,6 @@ possesses a copy of it. In addition, you must do these things in the
 Modified Version:
 
 -  **A.**
-
    Use in the :ref:`Title Page <fdl-title-page>` (and on the covers,
    if any) a title distinct from that of the
    :ref:`Document <fdl-document>`, and from those of previous versions
@@ -200,7 +206,6 @@ Modified Version:
    the original publisher of that version gives permission.
 
 -  **B.**
-
    List on the :ref:`Title Page <fdl-title-page>`, as authors, one or
    more persons or entities responsible for authorship of the
    modifications in the :ref:`Modified Version <fdl-modified>`,
@@ -209,41 +214,34 @@ Modified Version:
    has less than five).
 
 -  **C.**
-
    State on the :ref:`Title Page <fdl-title-page>` the name of the
    publisher of the :ref:`Modified Version <fdl-modified>`, as the
    publisher.
 
 -  **D.**
-
    Preserve all the copyright notices of the
    :ref:`Document <fdl-document>`.
 
 -  **E.**
-
    Add an appropriate copyright notice for your modifications adjacent
    to the other copyright notices.
 
 -  **F.**
-
    Include, immediately after the copyright notices, a license notice
    giving the public permission to use the
    :ref:`Modified Version <fdl-modified>` under the terms of this
    License, in the form shown in the Addendum below.
 
 -  **G.**
-
    Preserve in that license notice the full lists of
    :ref:`Invariant Sections <fdl-invariant>` and required
    :ref:`Cover Texts <fdl-cover-texts>` given in the
    :ref:`Document's <fdl-document>` license notice.
 
 -  **H.**
-
    Include an unaltered copy of this License.
 
 -  **I.**
-
    Preserve the section entitled “History”, and its title, and add to it
    an item stating at least the title, year, new authors, and publisher
    of the :ref:`Modified Version <fdl-modified>` as given on the
@@ -254,7 +252,6 @@ Modified Version:
    stated in the previous sentence.
 
 -  **J.**
-
    Preserve the network location, if any, given in the
    :ref:`Document <fdl-document>` for public access to a
    :ref:`Transparent <fdl-transparent>` copy of the Document, and
@@ -265,26 +262,22 @@ Modified Version:
    original publisher of the version it refers to gives permission.
 
 -  **K.**
-
    In any section entitled “Acknowledgements” or “Dedications”, preserve
    the section's title, and preserve in the section all the substance
    and tone of each of the contributor acknowledgements and/or
    dedications given therein.
 
 -  **L.**
-
    Preserve all the :ref:`Invariant Sections <fdl-invariant>` of the
    :ref:`Document <fdl-document>`, unaltered in their text and in
    their titles. Section numbers or the equivalent are not considered
    part of the section titles.
 
 -  **M.**
-
    Delete any section entitled “Endorsements”. Such a section may not be
    included in the :ref:`Modified Version <fdl-modified>`.
 
 -  **N.**
-
    Do not retitle any existing section as “Endorsements” or to conflict
    in title with any :ref:`Invariant Section <fdl-invariant>`.
 
-- 
2.7.4


