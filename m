Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35694 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754295AbcHSDqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:46:49 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 19/20] [media] subdev-formats.rst: adjust most of the tables to fill in page
Date: Thu, 18 Aug 2016 13:15:48 -0300
Message-Id: <de670e2a556a7fbd48c74a2b4aade58e6880ea6b.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix mosto fo the tables there in order to make them fit at the
page size.

There are, however, two exceptions: RGB and YUV big tables,
where adding the raw latex adjustbox caused the tables to not
be properly formatted. I suspect that the problem is because
those are long tables, but not really sure.

The thing is that Sphinx lacks an "adjustbox" tag that would
avoid the raw latex hacks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 5575 ++++++++++++-----------
 1 file changed, 2806 insertions(+), 2769 deletions(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 265a6dc5fe92..7d9b55dd6e91 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -155,12 +155,16 @@ half of the green value) transferred first will be named
 
 The following tables list existing packed RGB formats.
 
+.. FIXME: I was unable to find a way to use adjustbox or landscape for this table!
+
+.. tabularcolumns:: |p{7.6cm}|p{1.6cm}|p{0.7cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{-1.0cm}|
 
 .. _v4l2-mbus-pixelcode-rgb:
 
 .. flat-table:: RGB formats
     :header-rows:  2
     :stub-columns: 0
+    :widths: 36 7 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 
 
     -  .. row 1
@@ -249,45 +253,45 @@ The following tables list existing packed RGB formats.
        -  0x1016
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`3`
 
@@ -320,53 +324,53 @@ The following tables list existing packed RGB formats.
        -  0x1001
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  0
 
@@ -389,53 +393,53 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`3`
 
@@ -460,53 +464,53 @@ The following tables list existing packed RGB formats.
        -  0x1002
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`3`
 
@@ -529,53 +533,53 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  0
 
@@ -600,53 +604,53 @@ The following tables list existing packed RGB formats.
        -  0x1003
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  0
 
@@ -669,53 +673,53 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`2`
 
@@ -740,53 +744,53 @@ The following tables list existing packed RGB formats.
        -  0x1004
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`2`
 
@@ -809,53 +813,53 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  0
 
@@ -880,37 +884,37 @@ The following tables list existing packed RGB formats.
        -  0x1017
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`4`
 
@@ -951,53 +955,53 @@ The following tables list existing packed RGB formats.
        -  0x1005
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`4`
 
@@ -1020,53 +1024,53 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`2`
 
@@ -1091,53 +1095,53 @@ The following tables list existing packed RGB formats.
        -  0x1006
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`2`
 
@@ -1160,53 +1164,53 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`4`
 
@@ -1231,53 +1235,53 @@ The following tables list existing packed RGB formats.
        -  0x1007
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`4`
 
@@ -1300,53 +1304,53 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`2`
 
@@ -1371,53 +1375,53 @@ The following tables list existing packed RGB formats.
        -  0x1008
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`2`
 
@@ -1440,53 +1444,53 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`4`
 
@@ -1511,33 +1515,33 @@ The following tables list existing packed RGB formats.
        -  0x1009
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`5`
 
@@ -1582,21 +1586,21 @@ The following tables list existing packed RGB formats.
        -  0x100e
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`7`
 
@@ -1653,21 +1657,21 @@ The following tables list existing packed RGB formats.
        -  0x1015
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  0
 
@@ -1724,21 +1728,21 @@ The following tables list existing packed RGB formats.
        -  0x1013
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`7`
 
@@ -1795,21 +1799,21 @@ The following tables list existing packed RGB formats.
        -  0x1014
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`7`
 
@@ -1866,21 +1870,21 @@ The following tables list existing packed RGB formats.
        -  0x100a
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`7`
 
@@ -1937,45 +1941,45 @@ The following tables list existing packed RGB formats.
        -  0x100b
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`7`
 
@@ -2006,45 +2010,45 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`3`
 
@@ -2077,45 +2081,45 @@ The following tables list existing packed RGB formats.
        -  0x100c
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`3`
 
@@ -2146,45 +2150,45 @@ The following tables list existing packed RGB formats.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`7`
 
@@ -2352,7 +2356,6 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-
 On LVDS buses, usually each sample is transferred serialized in seven
 time slots per pixel clock, on three (18-bit) or four (24-bit)
 differential data pairs at the same time. The remaining bits are used
@@ -2361,6 +2364,9 @@ for control signals as defined by SPWG/PSWG/VESA or JEIDA standards. The
 JEIDA defined bit mapping will be named
 ``MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA``, for example.
 
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
 
 .. _v4l2-mbus-pixelcode-rgb-lvds:
 
@@ -2404,7 +2410,7 @@ JEIDA defined bit mapping will be named
        -  0
 
        -
-       -  -
+       -
 
        -  d
 
@@ -2419,7 +2425,7 @@ JEIDA defined bit mapping will be named
        -  1
 
        -
-       -  -
+       -
 
        -  d
 
@@ -2434,7 +2440,7 @@ JEIDA defined bit mapping will be named
        -  2
 
        -
-       -  -
+       -
 
        -  d
 
@@ -2449,7 +2455,7 @@ JEIDA defined bit mapping will be named
        -  3
 
        -
-       -  -
+       -
 
        -  b\ :sub:`5`
 
@@ -2464,7 +2470,7 @@ JEIDA defined bit mapping will be named
        -  4
 
        -
-       -  -
+       -
 
        -  b\ :sub:`4`
 
@@ -2479,7 +2485,7 @@ JEIDA defined bit mapping will be named
        -  5
 
        -
-       -  -
+       -
 
        -  b\ :sub:`3`
 
@@ -2494,7 +2500,7 @@ JEIDA defined bit mapping will be named
        -  6
 
        -
-       -  -
+       -
 
        -  b\ :sub:`2`
 
@@ -2716,6 +2722,9 @@ JEIDA defined bit mapping will be named
 
        -  r\ :sub:`2`
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
 
 
 Bayer Formats
@@ -2770,8 +2779,16 @@ The following table lists existing packed Bayer formats. The data
 organization is given as an example for the first pixel only.
 
 
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{7.6cm}|p{1.6cm}|p{0.7cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|
+
 .. _v4l2-mbus-pixelcode-bayer:
 
+.. cssclass: longtable
+
 .. flat-table:: Bayer Formats
     :header-rows:  2
     :stub-columns: 0
@@ -2823,13 +2840,13 @@ organization is given as an example for the first pixel only.
        -  0x3001
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`7`
 
@@ -2854,13 +2871,13 @@ organization is given as an example for the first pixel only.
        -  0x3013
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`7`
 
@@ -2885,13 +2902,13 @@ organization is given as an example for the first pixel only.
        -  0x3002
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`7`
 
@@ -2916,13 +2933,13 @@ organization is given as an example for the first pixel only.
        -  0x3014
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`7`
 
@@ -2947,13 +2964,13 @@ organization is given as an example for the first pixel only.
        -  0x3015
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`7`
 
@@ -2978,13 +2995,13 @@ organization is given as an example for the first pixel only.
        -  0x3016
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`7`
 
@@ -3009,13 +3026,13 @@ organization is given as an example for the first pixel only.
        -  0x3017
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`7`
 
@@ -3040,13 +3057,13 @@ organization is given as an example for the first pixel only.
        -  0x3018
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`7`
 
@@ -3071,13 +3088,13 @@ organization is given as an example for the first pixel only.
        -  0x300b
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`7`
 
@@ -3102,13 +3119,13 @@ organization is given as an example for the first pixel only.
        -  0x300c
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`7`
 
@@ -3133,13 +3150,13 @@ organization is given as an example for the first pixel only.
        -  0x3009
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`7`
 
@@ -3164,13 +3181,13 @@ organization is given as an example for the first pixel only.
        -  0x300d
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`7`
 
@@ -3195,13 +3212,13 @@ organization is given as an example for the first pixel only.
        -  0x3003
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  0
 
@@ -3224,13 +3241,13 @@ organization is given as an example for the first pixel only.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`7`
 
@@ -3255,13 +3272,13 @@ organization is given as an example for the first pixel only.
        -  0x3004
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`7`
 
@@ -3284,13 +3301,13 @@ organization is given as an example for the first pixel only.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  0
 
@@ -3315,13 +3332,13 @@ organization is given as an example for the first pixel only.
        -  0x3005
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`9`
 
@@ -3344,13 +3361,13 @@ organization is given as an example for the first pixel only.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`1`
 
@@ -3375,13 +3392,13 @@ organization is given as an example for the first pixel only.
        -  0x3006
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`1`
 
@@ -3404,13 +3421,13 @@ organization is given as an example for the first pixel only.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`9`
 
@@ -3435,9 +3452,9 @@ organization is given as an example for the first pixel only.
        -  0x3007
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
        -  b\ :sub:`9`
 
@@ -3466,9 +3483,9 @@ organization is given as an example for the first pixel only.
        -  0x300e
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`9`
 
@@ -3497,9 +3514,9 @@ organization is given as an example for the first pixel only.
        -  0x300a
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
        -  g\ :sub:`9`
 
@@ -3528,9 +3545,9 @@ organization is given as an example for the first pixel only.
        -  0x300f
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
        -  r\ :sub:`9`
 
@@ -3676,6 +3693,9 @@ organization is given as an example for the first pixel only.
 
        -  r\ :sub:`0`
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
 
 
 Packed YUV Formats
@@ -3728,17 +3748,22 @@ the following codes.
 
 -  a\ :sub:`x` for alpha component bit number x
 
--  - for non-available bits (for positions higher than the bus width)
+- for non-available bits (for positions higher than the bus width)
 
 -  d for dummy bits
 
+.. FIXME: I was unable to find a way to use adjustbox or landscape for this table!
+
+.. tabularcolumns:: |p{7.6cm}|p{1.6cm}|p{0.7cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{-1.0cm}|
 
 .. _v4l2-mbus-pixelcode-yuv8:
 
+.. cssclass: longtable
+
 .. flat-table:: YUV Formats
     :header-rows:  2
     :stub-columns: 0
-
+    :widths: 36 7 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 
     -  .. row 1
 
@@ -3826,53 +3851,53 @@ the following codes.
        -  0x2001
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -3897,53 +3922,53 @@ the following codes.
        -  0x2015
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -3966,53 +3991,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -4037,53 +4062,53 @@ the following codes.
        -  0x2002
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -4106,53 +4131,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4175,53 +4200,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4244,53 +4269,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -4313,53 +4338,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4382,53 +4407,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4453,53 +4478,53 @@ the following codes.
        -  0x2003
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -4522,53 +4547,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4591,53 +4616,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4660,53 +4685,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -4729,53 +4754,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4798,53 +4823,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4869,53 +4894,53 @@ the following codes.
        -  0x2004
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -4938,53 +4963,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5007,53 +5032,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -5076,53 +5101,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5145,53 +5170,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5214,53 +5239,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -5285,53 +5310,53 @@ the following codes.
        -  0x2005
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5354,53 +5379,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5423,53 +5448,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -5492,53 +5517,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5561,53 +5586,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5630,53 +5655,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -5701,53 +5726,53 @@ the following codes.
        -  0x2006
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -5770,53 +5795,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5839,53 +5864,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -5908,53 +5933,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -5979,53 +6004,53 @@ the following codes.
        -  0x2007
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -6048,53 +6073,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -6117,53 +6142,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -6186,53 +6211,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -6257,53 +6282,53 @@ the following codes.
        -  0x2008
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -6326,53 +6351,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -6395,53 +6420,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -6464,53 +6489,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -6535,53 +6560,53 @@ the following codes.
        -  0x2009
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -6604,53 +6629,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -6673,53 +6698,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -6742,53 +6767,53 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -6813,49 +6838,49 @@ the following codes.
        -  0x200a
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -6884,49 +6909,49 @@ the following codes.
        -  0x2018
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`9`
 
@@ -6953,49 +6978,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -7022,49 +7047,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`9`
 
@@ -7091,49 +7116,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -7162,49 +7187,49 @@ the following codes.
        -  0x2019
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`9`
 
@@ -7231,49 +7256,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -7300,49 +7325,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`9`
 
@@ -7369,49 +7394,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -7440,49 +7465,49 @@ the following codes.
        -  0x200b
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -7509,49 +7534,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`9`
 
@@ -7578,49 +7603,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -7647,49 +7672,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`9`
 
@@ -7718,49 +7743,49 @@ the following codes.
        -  0x200c
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -7787,49 +7812,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`9`
 
@@ -7856,49 +7881,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -7925,49 +7950,49 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`9`
 
@@ -7996,45 +8021,45 @@ the following codes.
        -  0x2013
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -8067,45 +8092,45 @@ the following codes.
        -  0x201c
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`11`
 
@@ -8136,45 +8161,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -8205,45 +8230,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`11`
 
@@ -8274,45 +8299,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -8345,45 +8370,45 @@ the following codes.
        -  0x201d
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`11`
 
@@ -8414,45 +8439,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -8483,45 +8508,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`11`
 
@@ -8552,45 +8577,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -8623,45 +8648,45 @@ the following codes.
        -  0x201e
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -8692,45 +8717,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`11`
 
@@ -8761,45 +8786,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -8830,45 +8855,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`11`
 
@@ -8901,45 +8926,45 @@ the following codes.
        -  0x201f
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -8970,45 +8995,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`11`
 
@@ -9039,45 +9064,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -9108,45 +9133,45 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`11`
 
@@ -9179,37 +9204,37 @@ the following codes.
        -  0x200f
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -9248,37 +9273,37 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -9319,37 +9344,37 @@ the following codes.
        -  0x2010
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -9388,37 +9413,37 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`7`
 
@@ -9459,37 +9484,37 @@ the following codes.
        -  0x2011
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -9528,37 +9553,37 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -9599,37 +9624,37 @@ the following codes.
        -  0x2012
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -9668,37 +9693,37 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -9739,37 +9764,37 @@ the following codes.
        -  0x2014
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -9808,37 +9833,37 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -9877,37 +9902,37 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -9946,37 +9971,37 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -10017,29 +10042,29 @@ the following codes.
        -  0x201a
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`9`
 
@@ -10086,29 +10111,29 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`9`
 
@@ -10157,29 +10182,29 @@ the following codes.
        -  0x201b
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`9`
 
@@ -10226,29 +10251,29 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`9`
 
@@ -10297,29 +10322,29 @@ the following codes.
        -  0x200d
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -10366,29 +10391,29 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -10437,29 +10462,29 @@ the following codes.
        -  0x200e
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -10506,29 +10531,29 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -10577,21 +10602,21 @@ the following codes.
        -  0x201a
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`7`
 
@@ -10648,21 +10673,21 @@ the following codes.
        -  0x2025
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`7`
 
@@ -10719,21 +10744,21 @@ the following codes.
        -  0x2020
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`11`
 
@@ -10788,21 +10813,21 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`11`
 
@@ -10859,21 +10884,21 @@ the following codes.
        -  0x2021
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  v\ :sub:`11`
 
@@ -10928,21 +10953,21 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  u\ :sub:`11`
 
@@ -10999,21 +11024,21 @@ the following codes.
        -  0x2022
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -11068,21 +11093,21 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -11139,21 +11164,21 @@ the following codes.
        -  0x2023
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -11208,21 +11233,21 @@ the following codes.
        -
        -
        -
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`11`
 
@@ -11279,9 +11304,9 @@ the following codes.
        -  0x2016
 
        -
-       -  -
+       -
 
-       -  -
+       -
 
        -  y\ :sub:`9`
 
@@ -11449,13 +11474,18 @@ following information.
 
 The following table lists existing HSV/HSL formats.
 
+.. raw:: latex
+
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{6.2cm}|p{1.6cm}|p{0.7cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|
 
 .. _v4l2-mbus-pixelcode-hsv:
 
 .. flat-table:: HSV/HSL formats
     :header-rows:  2
     :stub-columns: 0
-
+    :widths: 28 7 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 
     -  .. row 1
 
@@ -11607,6 +11637,9 @@ The following table lists existing HSV/HSL formats.
 
        -  v\ :sub:`0`
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
 
 
 JPEG Compressed Formats
@@ -11628,6 +11661,8 @@ The following table lists existing JPEG compressed formats.
 
 .. _v4l2-mbus-pixelcode-jpeg:
 
+.. tabularcolumns:: |p{5.6cm}|p{1.2cm}|p{10.7cm}|
+
 .. flat-table:: JPEG Formats
     :header-rows:  1
     :stub-columns: 0
@@ -11667,6 +11702,8 @@ formats.
 
 .. _v4l2-mbus-pixelcode-vendor-specific:
 
+.. tabularcolumns:: |p{6.6cm}|p{1.2cm}|p{9.7cm}|
+
 .. flat-table:: Vendor and device specific formats
     :header-rows:  1
     :stub-columns: 0
-- 
2.7.4


