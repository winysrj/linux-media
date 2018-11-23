Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58582 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730291AbeKXFYO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 00:24:14 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Subject: [PATCH 4/6] media: svg files: dual-licence some files with GPL and GFDL
Date: Fri, 23 Nov 2018 16:38:37 -0200
Message-Id: <c6fbc45db904b3284faec7a31055072850f90536.1542997584.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1542997584.git.mchehab+samsung@kernel.org>
References: <cover.1542997584.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Along the time, several image files got replaced by me by
new ones with similar contents.

As those were not simple conversions, dual-license them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/uapi/dvb/dvbstb.svg       | 33 ++++++++++++++-----
 Documentation/media/uapi/v4l/bayer.svg        | 33 ++++++++++++++-----
 Documentation/media/uapi/v4l/constraints.svg  | 33 ++++++++++++++-----
 Documentation/media/uapi/v4l/nv12mt.svg       | 33 ++++++++++++++-----
 .../media/uapi/v4l/nv12mt_example.svg         | 33 ++++++++++++++-----
 Documentation/media/uapi/v4l/selection.svg    | 33 ++++++++++++++-----
 6 files changed, 150 insertions(+), 48 deletions(-)

diff --git a/Documentation/media/uapi/dvb/dvbstb.svg b/Documentation/media/uapi/dvb/dvbstb.svg
index 3fe083b3b410..9700c864d3c3 100644
--- a/Documentation/media/uapi/dvb/dvbstb.svg
+++ b/Documentation/media/uapi/dvb/dvbstb.svg
@@ -1,13 +1,30 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <!--
-    Permission is granted to copy, distribute and/or modify this
-    document under the terms of the GNU Free Documentation License,
-    Version 1.1 or any later version published by the Free Software
-    Foundation, with no Invariant Sections, no Front-Cover Texts
-    and no Back-Cover Texts. A copy of the license is included at
-    Documentation/media/uapi/fdl-appendix.rst.
-
-    TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
+    This file is dual-licensed: you can use it either under the terms
+    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    dual licensing only applies to this file, and not this project as a
+    whole.
+
+    a) This file is free software; you can redistribute it and/or
+       modify it under the terms of the GNU General Public License as
+       published by the Free Software Foundation; either version 2 of
+       the License, or (at your option) any later version.
+
+       This file is distributed in the hope that it will be useful,
+       but WITHOUT ANY WARRANTY; without even the implied warranty of
+       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+       GNU General Public License for more details.
+
+    Or, alternatively,
+
+    b) Permission is granted to copy, distribute and/or modify this
+       document under the terms of the GNU Free Documentation License,
+       Version 1.1 or any later version published by the Free Software
+       Foundation, with no Invariant Sections, no Front-Cover Texts
+       and no Back-Cover Texts. A copy of the license is included at
+       Documentation/media/uapi/fdl-appendix.rst.
+
+    TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 -->
 <svg id="svg2" width="15.847cm" height="8.4187cm" fill-rule="evenodd" stroke-linejoin="round" stroke-width="28.222" preserveAspectRatio="xMidYMid" version="1.2" viewBox="0 0 23770.123 12628.122" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><defs id="defs142"><marker id="Arrow1Lend" overflow="visible" orient="auto"><path id="path954" transform="matrix(-.8 0 0 -.8 -10 0)" d="m0 0 5-5-17.5 5 17.5 5z" fill-rule="evenodd" stroke="#000" stroke-width="1pt"/></marker><marker id="marker1243" overflow="visible" orient="auto"><path id="path1241" transform="matrix(-.8 0 0 -.8 -10 0)" d="m0 0 5-5-17.5 5 17.5 5z" fill-rule="evenodd" stroke="#000" stroke-width="1pt"/></marker></defs><metadata id="metadata519"><rdf:RDF><cc:Work
 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><rect id="rect197" class="BoundingBox" x="5355.1" y="13.122" width="18403" height="9603" fill="none"/><path id="path199" d="m14556 9614.1h-9200v-9600h18400v9600z" fill="#fff"/><path id="path201" d="m14556 9614.1h-9200v-9600h18400v9600z" fill="none" stroke="#000"/><rect id="rect206" class="BoundingBox" x="13.122" y="4013.1" width="4544" height="2403" fill="none"/><path id="path208" d="m2285.1 6414.1h-2271v-2400h4541v2400z" fill="#fff"/><path id="path210" d="m2285.1 6414.1h-2271v-2400h4541v2400z" fill="none" stroke="#000"/><text id="text212" class="TextShape" x="-2443.8779" y="-4585.8779"><tspan id="tspan214" class="TextParagraph" font-family="sans-serif" font-size="635px" font-weight="400"><tspan id="tspan216" class="TextPosition"
diff --git a/Documentation/media/uapi/v4l/bayer.svg b/Documentation/media/uapi/v4l/bayer.svg
index 2ce3ebc70b29..abec45b7873b 100644
--- a/Documentation/media/uapi/v4l/bayer.svg
+++ b/Documentation/media/uapi/v4l/bayer.svg
@@ -1,13 +1,30 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <!--
-    Permission is granted to copy, distribute and/or modify this
-    document under the terms of the GNU Free Documentation License,
-    Version 1.1 or any later version published by the Free Software
-    Foundation, with no Invariant Sections, no Front-Cover Texts
-    and no Back-Cover Texts. A copy of the license is included at
-    Documentation/media/uapi/fdl-appendix.rst.
-
-    TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
+    This file is dual-licensed: you can use it either under the terms
+    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    dual licensing only applies to this file, and not this project as a
+    whole.
+
+    a) This file is free software; you can redistribute it and/or
+       modify it under the terms of the GNU General Public License as
+       published by the Free Software Foundation; either version 2 of
+       the License, or (at your option) any later version.
+
+       This file is distributed in the hope that it will be useful,
+       but WITHOUT ANY WARRANTY; without even the implied warranty of
+       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+       GNU General Public License for more details.
+
+    Or, alternatively,
+
+    b) Permission is granted to copy, distribute and/or modify this
+       document under the terms of the GNU Free Documentation License,
+       Version 1.1 or any later version published by the Free Software
+       Foundation, with no Invariant Sections, no Front-Cover Texts
+       and no Back-Cover Texts. A copy of the license is included at
+       Documentation/media/uapi/fdl-appendix.rst.
+
+    TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 -->
 <svg id="svg2" width="164.15mm" height="46.771mm" fill-rule="evenodd" stroke-linejoin="round" stroke-width="28.222" preserveAspectRatio="xMidYMid" version="1.2" viewBox="0 0 16415.333 4677.1107" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata id="metadata652"><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><g id="g186" class="com.sun.star.drawing.CustomShape" transform="translate(-3285.9 -3185.9)"><g id="id6"><rect id="rect189" class="BoundingBox" x="3299" y="3199" width="1303" height="1203" fill="none"/><path id="path191" d="m3950 4400h-650v-1200h1300v1200h-650z" fill="#00f"/><path id="path193" d="m3950
 4400h-650v-1200h1300v1200h-650z" fill="none" stroke="#3465a4"/><text id="text195" class="TextShape"><tspan id="tspan197" class="TextParagraph" font-family="sans-serif" font-size="635px" font-weight="400"><tspan id="tspan199" class="TextPosition" x="3739" y="4021"><tspan id="tspan201" fill="#ffffff">B</tspan></tspan></tspan></text>
diff --git a/Documentation/media/uapi/v4l/constraints.svg b/Documentation/media/uapi/v4l/constraints.svg
index 3e3887629389..18e314c60757 100644
--- a/Documentation/media/uapi/v4l/constraints.svg
+++ b/Documentation/media/uapi/v4l/constraints.svg
@@ -1,13 +1,30 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <!--
-    Permission is granted to copy, distribute and/or modify this
-    document under the terms of the GNU Free Documentation License,
-    Version 1.1 or any later version published by the Free Software
-    Foundation, with no Invariant Sections, no Front-Cover Texts
-    and no Back-Cover Texts. A copy of the license is included at
-    Documentation/media/uapi/fdl-appendix.rst.
-
-    TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
+    This file is dual-licensed: you can use it either under the terms
+    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    dual licensing only applies to this file, and not this project as a
+    whole.
+
+    a) This file is free software; you can redistribute it and/or
+       modify it under the terms of the GNU General Public License as
+       published by the Free Software Foundation; either version 2 of
+       the License, or (at your option) any later version.
+
+       This file is distributed in the hope that it will be useful,
+       but WITHOUT ANY WARRANTY; without even the implied warranty of
+       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+       GNU General Public License for more details.
+
+    Or, alternatively,
+
+    b) Permission is granted to copy, distribute and/or modify this
+       document under the terms of the GNU Free Documentation License,
+       Version 1.1 or any later version published by the Free Software
+       Foundation, with no Invariant Sections, no Front-Cover Texts
+       and no Back-Cover Texts. A copy of the license is included at
+       Documentation/media/uapi/fdl-appendix.rst.
+
+    TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 -->
 <svg id="svg2" width="249.01mm" height="143.01mm" fill-rule="evenodd" stroke-linejoin="round" stroke-width="28.222" preserveAspectRatio="xMidYMid" version="1.2" viewBox="0 0 24900.998 14300.999" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><metadata id="metadata325"><rdf:RDF><cc:Work rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/><dc:title/></cc:Work></rdf:RDF></metadata><defs id="defs4" class="ClipPathGroup"><marker id="marker6261" overflow="visible" orient="auto"><path id="path6263" transform="matrix(-.4 0 0 -.4 -4 0)" d="m0 0 5-5-17.5 5 17.5 5-5-5z" fill="#f00" fill-rule="evenodd" stroke="#f00" stroke-width="1pt"/></marker><marker id="marker6125" overflow="visible"
 orient="auto"><path id="path6127" transform="matrix(-.4 0 0 -.4 -4 0)" d="m0 0 5-5-17.5 5 17.5 5-5-5z" fill="#f00" fill-rule="evenodd" stroke="#f00" stroke-width="1pt"/></marker><marker id="marker6001" overflow="visible" orient="auto"><path id="path6003" transform="matrix(-.4 0 0 -.4 -4 0)" d="m0 0 5-5-17.5 5 17.5 5-5-5z" fill="#f00" fill-rule="evenodd" stroke="#f00" stroke-width="1pt"/></marker><marker id="marker5693" overflow="visible" orient="auto"><path id="path5695" transform="matrix(-.4 0 0 -.4 -4 0)" d="m0 0 5-5-17.5 5 17.5 5-5-5z" fill="#f00" fill-rule="evenodd" stroke="#f00" stroke-width="1pt"/></marker><marker id="marker5575" overflow="visible" orient="auto"><path id="path5577" transform="matrix(-.4 0 0 -.4 -4 0)" d="m0 0 5-5-17.5 5 17.5 5-5-5z" fill="#000080" fill-rule="evenodd" stroke="#000080" stroke-width="1pt"/></marker><marker id="marker5469" overflow="visible"
diff --git a/Documentation/media/uapi/v4l/nv12mt.svg b/Documentation/media/uapi/v4l/nv12mt.svg
index 924937366d52..54ae99d64342 100644
--- a/Documentation/media/uapi/v4l/nv12mt.svg
+++ b/Documentation/media/uapi/v4l/nv12mt.svg
@@ -1,13 +1,30 @@
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
 <!--
-    Permission is granted to copy, distribute and/or modify this
-    document under the terms of the GNU Free Documentation License,
-    Version 1.1 or any later version published by the Free Software
-    Foundation, with no Invariant Sections, no Front-Cover Texts
-    and no Back-Cover Texts. A copy of the license is included at
-    Documentation/media/uapi/fdl-appendix.rst.
-
-    TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
+    This file is dual-licensed: you can use it either under the terms
+    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    dual licensing only applies to this file, and not this project as a
+    whole.
+
+    a) This file is free software; you can redistribute it and/or
+       modify it under the terms of the GNU General Public License as
+       published by the Free Software Foundation; either version 2 of
+       the License, or (at your option) any later version.
+
+       This file is distributed in the hope that it will be useful,
+       but WITHOUT ANY WARRANTY; without even the implied warranty of
+       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+       GNU General Public License for more details.
+
+    Or, alternatively,
+
+    b) Permission is granted to copy, distribute and/or modify this
+       document under the terms of the GNU Free Documentation License,
+       Version 1.1 or any later version published by the Free Software
+       Foundation, with no Invariant Sections, no Front-Cover Texts
+       and no Back-Cover Texts. A copy of the license is included at
+       Documentation/media/uapi/fdl-appendix.rst.
+
+    TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 -->
 <svg
    xmlns:dc="http://purl.org/dc/elements/1.1/"
diff --git a/Documentation/media/uapi/v4l/nv12mt_example.svg b/Documentation/media/uapi/v4l/nv12mt_example.svg
index 4dd9cbf7c72e..5eb8bcacc56c 100644
--- a/Documentation/media/uapi/v4l/nv12mt_example.svg
+++ b/Documentation/media/uapi/v4l/nv12mt_example.svg
@@ -1,13 +1,30 @@
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
 <!--
-    Permission is granted to copy, distribute and/or modify this
-    document under the terms of the GNU Free Documentation License,
-    Version 1.1 or any later version published by the Free Software
-    Foundation, with no Invariant Sections, no Front-Cover Texts
-    and no Back-Cover Texts. A copy of the license is included at
-    Documentation/media/uapi/fdl-appendix.rst.
-
-    TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
+    This file is dual-licensed: you can use it either under the terms
+    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    dual licensing only applies to this file, and not this project as a
+    whole.
+
+    a) This file is free software; you can redistribute it and/or
+       modify it under the terms of the GNU General Public License as
+       published by the Free Software Foundation; either version 2 of
+       the License, or (at your option) any later version.
+
+       This file is distributed in the hope that it will be useful,
+       but WITHOUT ANY WARRANTY; without even the implied warranty of
+       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+       GNU General Public License for more details.
+
+    Or, alternatively,
+
+    b) Permission is granted to copy, distribute and/or modify this
+       document under the terms of the GNU Free Documentation License,
+       Version 1.1 or any later version published by the Free Software
+       Foundation, with no Invariant Sections, no Front-Cover Texts
+       and no Back-Cover Texts. A copy of the license is included at
+       Documentation/media/uapi/fdl-appendix.rst.
+
+    TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 -->
 <svg
    xmlns:dc="http://purl.org/dc/elements/1.1/"
diff --git a/Documentation/media/uapi/v4l/selection.svg b/Documentation/media/uapi/v4l/selection.svg
index fa97217f1195..eeb195744e60 100644
--- a/Documentation/media/uapi/v4l/selection.svg
+++ b/Documentation/media/uapi/v4l/selection.svg
@@ -1,13 +1,30 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <!--
-    Permission is granted to copy, distribute and/or modify this
-    document under the terms of the GNU Free Documentation License,
-    Version 1.1 or any later version published by the Free Software
-    Foundation, with no Invariant Sections, no Front-Cover Texts
-    and no Back-Cover Texts. A copy of the license is included at
-    Documentation/media/uapi/fdl-appendix.rst.
-
-    TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
+    This file is dual-licensed: you can use it either under the terms
+    of the GPL or the GFDL 1.1+ license, at your option. Note that this
+    dual licensing only applies to this file, and not this project as a
+    whole.
+
+    a) This file is free software; you can redistribute it and/or
+       modify it under the terms of the GNU General Public License as
+       published by the Free Software Foundation; either version 2 of
+       the License, or (at your option) any later version.
+
+       This file is distributed in the hope that it will be useful,
+       but WITHOUT ANY WARRANTY; without even the implied warranty of
+       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+       GNU General Public License for more details.
+
+    Or, alternatively,
+
+    b) Permission is granted to copy, distribute and/or modify this
+       document under the terms of the GNU Free Documentation License,
+       Version 1.1 or any later version published by the Free Software
+       Foundation, with no Invariant Sections, no Front-Cover Texts
+       and no Back-Cover Texts. A copy of the license is included at
+       Documentation/media/uapi/fdl-appendix.rst.
+
+    TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
 -->
 <svg enable-background="new" version="1" viewBox="0 0 4226.3 1686.8" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
-- 
2.19.1
