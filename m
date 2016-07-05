Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 01/41] Documentation: linux_tv: Fix some occurences of :sub:
Date: Mon,  4 Jul 2016 22:30:36 -0300
Message-Id: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The right way to use it seems to do suscript is to use
this pattern: "\ :sub:"

Make sure all places of the media document will fit, by
using this script:

$n=0;
while (<>) {
	$n++;
	$t = $_;
	@matches = $t =~ m/(..\:sub\:)/g;
	foreach my $m (@matches) {
		$m =~ m/(.)(.)(\:sub\:)/;
		$s1=$1;
		$s2=$2;
		$s3=$3;
		next if (($s1 eq "\\") && ($s2 eq " "));
		if ($s2 eq " ") {
			$t =~ s/$s1$s2$s3/$s1\\$s2$s3/;
			next;
		}
		$t =~ s/$s1$s2$s3/$s1$s2\\ $s3/;
	}
	print $t;
}

And running it with:

for i in $(git grep -l sub Documentation/linux_tv/); do ./sub.pl $i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-m420.rst    | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst    | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst   | 4 ++--
 Documentation/linux_tv/media/v4l/pixfmt-nv16.rst    | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst   | 2 +-
 Documentation/linux_tv/media/v4l/vidioc-enumstd.rst | 4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
index 4c14f39bbc80..726edf554eb1 100644
--- a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
@@ -676,7 +676,7 @@ number).
           sliced VBI data. The sliced VBI data lines present correspond to
           the bits set in the ``linemask`` array, starting from b\ :sub:`0`
           of ``linemask``\ [0] up through b\ :sub:`31` of ``linemask``\ [0],
-          and from b\ :sub:`0` of ``linemask``\ [1] up through b :sub:`3` of
+          and from b\ :sub:`0` of ``linemask``\ [1] up through b\ :sub:`3` of
           ``linemask``\ [1]. ``line``\ [0] corresponds to the first bit
           found set in the ``linemask`` array, ``line``\ [1] corresponds to
           the second bit found set in the ``linemask`` array, etc. If no
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst b/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
index 4434ee1b1be9..2ef35cfc14fa 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
@@ -22,7 +22,7 @@ Two lines of luma data are followed by one line of chroma data.
 The luma plane has one byte per pixel. The chroma plane contains
 interleaved CbCr pixels subsampled by ½ in the horizontal and vertical
 directions. Each CbCr pair belongs to four pixels. For example,
-Cb\ :sub:`0`/Cr:sub:`0` belongs to Y'\ :sub:`00`, Y'\ :sub:`01`,
+Cb\ :sub:`0`/Cr\ :sub:`0` belongs to Y'\ :sub:`00`, Y'\ :sub:`01`,
 Y'\ :sub:`10`, Y'\ :sub:`11`.
 
 All line lengths are identical: if the Y lines include pad bytes so do
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
index 363e9484aef4..c15437c0cb23 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
@@ -23,7 +23,7 @@ first. The Y plane has one byte per pixel. For ``V4L2_PIX_FMT_NV12``, a
 combined CbCr plane immediately follows the Y plane in memory. The CbCr
 plane is the same width, in bytes, as the Y plane (and of the image),
 but is half as tall in pixels. Each CbCr pair belongs to four pixels.
-For example, Cb\ :sub:`0`/Cr:sub:`0` belongs to Y'\ :sub:`00`,
+For example, Cb\ :sub:`0`/Cr\ :sub:`0` belongs to Y'\ :sub:`00`,
 Y'\ :sub:`01`, Y'\ :sub:`10`, Y'\ :sub:`11`. ``V4L2_PIX_FMT_NV21`` is
 the same except the Cb and Cr bytes are swapped, the CrCb plane starts
 with a Cr byte.
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
index a769808aab9b..ed0fe226a733 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
@@ -26,8 +26,8 @@ occupies the first plane. The Y plane has one byte per pixel. In the
 second plane there is a chrominance data with alternating chroma
 samples. The CbCr plane is the same width, in bytes, as the Y plane (and
 of the image), but is half as tall in pixels. Each CbCr pair belongs to
-four pixels. For example, Cb :sub:`0`/Cr :sub:`0` belongs to
-Y' :sub:`00`, Y' :sub:`01`, Y' :sub:`10`, Y' :sub:`11`.
+four pixels. For example, Cb\ :sub:`0`/Cr\ :sub:`0` belongs to
+Y'\ :sub:`00`, Y'\ :sub:`01`, Y'\ :sub:`10`, Y'\ :sub:`11`.
 ``V4L2_PIX_FMT_NV12MT_16X16`` is the tiled version of
 ``V4L2_PIX_FMT_NV12M`` with 16x16 macroblock tiles. Here pixels are
 arranged in 16x16 2D tiles and tiles are arranged in linear order in
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
index a82f46c77d2d..74be442eba23 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
@@ -23,7 +23,7 @@ first. The Y plane has one byte per pixel. For ``V4L2_PIX_FMT_NV16``, a
 combined CbCr plane immediately follows the Y plane in memory. The CbCr
 plane is the same width and height, in bytes, as the Y plane (and of the
 image). Each CbCr pair belongs to two pixels. For example,
-Cb\ :sub:`0`/Cr:sub:`0` belongs to Y'\ :sub:`00`, Y'\ :sub:`01`.
+Cb\ :sub:`0`/Cr\ :sub:`0` belongs to Y'\ :sub:`00`, Y'\ :sub:`01`.
 ``V4L2_PIX_FMT_NV61`` is the same except the Cb and Cr bytes are
 swapped, the CrCb plane starts with a Cr byte.
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
index f6a82defe492..9caa243550a1 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
@@ -25,7 +25,7 @@ occupies the first plane. The Y plane has one byte per pixel. In the
 second plane there is chrominance data with alternating chroma samples.
 The CbCr plane is the same width and height, in bytes, as the Y plane.
 Each CbCr pair belongs to two pixels. For example,
-Cb\ :sub:`0`/Cr:sub:`0` belongs to Y'\ :sub:`00`, Y'\ :sub:`01`.
+Cb\ :sub:`0`/Cr\ :sub:`0` belongs to Y'\ :sub:`00`, Y'\ :sub:`01`.
 ``V4L2_PIX_FMT_NV61M`` is the same as ``V4L2_PIX_FMT_NV16M`` except the
 Cb and Cr bytes are swapped, the CrCb plane starts with a Cr byte.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index 098251b8be30..0576d2f9cc79 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -328,7 +328,7 @@ support digital TV. See also the Linux DVB API at
 
        -  4433618.75 ± 1
 
-       -  :cspan:`3` f :sub:`OR` = 4406250 ± 2000, f :sub:`OB` = 4250000
+       -  :cspan:`3` f\ :sub:`OR` = 4406250 ± 2000, f\ :sub:`OB` = 4250000
           ± 2000
 
     -  .. row 5
@@ -408,7 +408,7 @@ ENODATA
 
 .. [3]
    The values in brackets apply to the combination N/PAL a.k.a.
-   N :sub:`C` used in Argentina (V4L2_STD_PAL_Nc).
+   N\ :sub:`C` used in Argentina (V4L2_STD_PAL_Nc).
 
 .. [4]
    In the Federal Republic of Germany, Austria, Italy, the Netherlands,
-- 
2.7.4

