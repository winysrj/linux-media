Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25147 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab2EYTsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:48:00 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_eqMue9jqF5bO8JbsX68V3w)"
Date: Fri, 25 May 2012 21:47:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 0/13] Add device tree support for s5p-fimc SoC camera host
 interface driver
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4FBFE1EC.9060209@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_eqMue9jqF5bO8JbsX68V3w)
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT

Hi All,

This patch series adds device tree support for Samsung S5P/Exynos SoC
camera devices - camera host interface (FIMC), MIPI-CSI2 receiver
(a frontend to FIMC) and S5K6AA image sensor.

It also defines common "data-lanes" property for MIPI-CSI2 receivers and 
transmitters, as well as "video-bus-type" for image sensors, video encoders 
etc. and camera host interface drivers.

For an overview of the topology of devices in an SoC I have attached sample
graph generated from output at /dev/media? Media Controller devnode.
It's not generated from latest kernel, however it depicts well how the image
sensor (S5K6AA), MIPI-CSIS and FIMC devices are connected.

In coming few weeks I'm going to be offline and Bartlomiej will continue with
this RFC during that time.

The patches will be available in few hours at:
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/camera-of

Base tree for this series is available at git repository:
git://git.infradead.org/users/kmpark/linux-samsung camera-of


Comments are welcome.


Regards,
Sylwester

--Boundary_(ID_eqMue9jqF5bO8JbsX68V3w)
Content-type: application/postscript; name=camera_graph.ps
Content-transfer-encoding: 7bit
Content-disposition: attachment; filename=camera_graph.ps

%!PS-Adobe-3.0 EPSF-3.0
%%Creator: Graphviz version 2.20.2 (Tue Mar  2 19:03:41 UTC 2010)
%%For: (snawrocki) Sylwester Nawrocki,,,
%%Title: board
%%Pages: (atend)
%%BoundingBox: (atend)
%%EndComments
save
%%BeginProlog
/DotDict 200 dict def
DotDict begin

/setupLatin1 {
mark
/EncodingVector 256 array def
 EncodingVector 0

ISOLatin1Encoding 0 255 getinterval putinterval
EncodingVector 45 /hyphen put

% Set up ISO Latin 1 character encoding
/starnetISO {
        dup dup findfont dup length dict begin
        { 1 index /FID ne { def }{ pop pop } ifelse
        } forall
        /Encoding EncodingVector def
        currentdict end definefont
} def
/Times-Roman starnetISO def
/Times-Italic starnetISO def
/Times-Bold starnetISO def
/Times-BoldItalic starnetISO def
/Helvetica starnetISO def
/Helvetica-Oblique starnetISO def
/Helvetica-Bold starnetISO def
/Helvetica-BoldOblique starnetISO def
/Courier starnetISO def
/Courier-Oblique starnetISO def
/Courier-Bold starnetISO def
/Courier-BoldOblique starnetISO def
cleartomark
} bind def

%%BeginResource: procset graphviz 0 0
/coord-font-family /Times-Roman def
/default-font-family /Times-Roman def
/coordfont coord-font-family findfont 8 scalefont def

/InvScaleFactor 1.0 def
/set_scale {
       dup 1 exch div /InvScaleFactor exch def
       scale
} bind def

% styles
/solid { [] 0 setdash } bind def
/dashed { [9 InvScaleFactor mul dup ] 0 setdash } bind def
/dotted { [1 InvScaleFactor mul 6 InvScaleFactor mul] 0 setdash } bind def
/invis {/fill {newpath} def /stroke {newpath} def /show {pop newpath} def} bind def
/bold { 2 setlinewidth } bind def
/filled { } bind def
/unfilled { } bind def
/rounded { } bind def
/diagonals { } bind def

% hooks for setting color 
/nodecolor { sethsbcolor } bind def
/edgecolor { sethsbcolor } bind def
/graphcolor { sethsbcolor } bind def
/nopcolor {pop pop pop} bind def

/beginpage {	% i j npages
	/npages exch def
	/j exch def
	/i exch def
	/str 10 string def
	npages 1 gt {
		gsave
			coordfont setfont
			0 0 moveto
			(\() show i str cvs show (,) show j str cvs show (\)) show
		grestore
	} if
} bind def

/set_font {
	findfont exch
	scalefont setfont
} def

% draw text fitted to its expected width
/alignedtext {			% width text
	/text exch def
	/width exch def
	gsave
		width 0 gt {
			[] 0 setdash
			text stringwidth pop width exch sub text length div 0 text ashow
		} if
	grestore
} def

/boxprim {				% xcorner ycorner xsize ysize
		4 2 roll
		moveto
		2 copy
		exch 0 rlineto
		0 exch rlineto
		pop neg 0 rlineto
		closepath
} bind def

/ellipse_path {
	/ry exch def
	/rx exch def
	/y exch def
	/x exch def
	matrix currentmatrix
	newpath
	x y translate
	rx ry scale
	0 0 1 0 360 arc
	setmatrix
} bind def

/endpage { showpage } bind def
/showpage { } def

/layercolorseq
	[	% layer color sequence - darkest to lightest
		[0 0 0]
		[.2 .8 .8]
		[.4 .8 .8]
		[.6 .8 .8]
		[.8 .8 .8]
	]
def

/layerlen layercolorseq length def

/setlayer {/maxlayer exch def /curlayer exch def
	layercolorseq curlayer 1 sub layerlen mod get
	aload pop sethsbcolor
	/nodecolor {nopcolor} def
	/edgecolor {nopcolor} def
	/graphcolor {nopcolor} def
} bind def

/onlayer { curlayer ne {invis} if } def

/onlayers {
	/myupper exch def
	/mylower exch def
	curlayer mylower lt
	curlayer myupper gt
	or
	{invis} if
} def

/curlayer 0 def

%%EndResource
%%EndProlog
%%BeginSetup
14 default-font-family set_font
1 setmiterlimit
% /arrowlength 10 def
% /arrowwidth 5 def

% make sure pdfmark is harmless for PS-interpreters other than Distiller
/pdfmark where {pop} {userdict /pdfmark /cleartomark load put} ifelse
% make '<<' and '>>' safe on PS Level 1 devices
/languagelevel where {pop languagelevel}{1} ifelse
2 lt {
    userdict (<<) cvn ([) cvn load put
    userdict (>>) cvn ([) cvn load put
} if

%%EndSetup
setupLatin1
%%Page: 1 1
%%PageBoundingBox: 36 36 1074 438
%%PageOrientation: Portrait
0 0 1 beginpage
gsave
36 36 1038 402 boxprim clip newpath
1 1 set_scale 0 rotate 40 40 translate
% n00000001
gsave
0.165 1.000 1.000 nodecolor
newpath 222 377 moveto
64 377 lineto
64 335 lineto
222 335 lineto
closepath fill
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 222 377 moveto
64 377 lineto
64 335 lineto
222 335 lineto
closepath stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
71.5 360.4 moveto 143 (exynos4-fimc.0.m2m) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
103 343.4 moveto 80 (/dev/video0) alignedtext
grestore
% n00000002
gsave
0.333 1.000 1.000 nodecolor
newpath 96 78 moveto
206 78 lineto
218 90 lineto
218 158 lineto
206 170 lineto
96 170 lineto
84 158 lineto
84 90 lineto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 96 78 moveto
206 78 lineto
218 90 lineto
218 158 lineto
206 170 lineto
96 170 lineto
84 158 lineto
84 90 lineto
closepath stroke
0.333 1.000 1.000 nodecolor
newpath 206 78 moveto
212 78 218 84 218 90 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 206 78 moveto
212 78 218 84 218 90 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 218 158 moveto
218 164 212 170 206 170 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 218 158 moveto
218 164 212 170 206 170 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 96 170 moveto
90 170 84 164 84 158 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 96 170 moveto
90 170 84 164 84 158 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 84 90 moveto
84 84 90 78 96 78 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 84 90 moveto
84 84 90 78 96 78 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 96 78 moveto
206 78 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 206 78 moveto
212 78 218 84 218 90 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 218 90 moveto
218 158 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 218 158 moveto
218 164 212 170 206 170 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 206 170 moveto
96 170 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 96 170 moveto
90 170 84 164 84 158 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 84 158 moveto
84 90 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 84 90 moveto
84 84 90 78 96 78 curveto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
146.5 152.9 moveto 9 (0) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 84 145 moveto
218 145 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
127 128.4 moveto 48 (FIMC.0) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
92 111.4 moveto 118 (/dev/v4l-subdev0) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 84 103 moveto
218 103 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
146.5 85.9 moveto 9 (1) alignedtext
grestore
% n00000003
gsave
0.165 1.000 1.000 nodecolor
newpath 176 42 moveto
0 42 lineto
0 0 lineto
176 0 lineto
closepath fill
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 176 42 moveto
0 42 lineto
0 0 lineto
176 0 lineto
closepath stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
7.5 25.4 moveto 161 (exynos4-fimc.0.capture) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
48 8.4 moveto 80 (/dev/video1) alignedtext
grestore
% n00000002->n00000003
gsave
2 setlinewidth
bold
0.000 0.000 0.000 edgecolor
newpath 139 78 moveto
132 70 122 60 114 50 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 116.22 47.22 moveto
107 42 lineto
110.95 51.83 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 116.22 47.22 moveto
107 42 lineto
110.95 51.83 lineto
closepath stroke
grestore
% n00000004
gsave
0.165 1.000 1.000 nodecolor
newpath 544 377 moveto
386 377 lineto
386 335 lineto
544 335 lineto
closepath fill
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 544 377 moveto
386 377 lineto
386 335 lineto
544 335 lineto
closepath stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
393.5 360.4 moveto 143 (exynos4-fimc.1.m2m) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
425 343.4 moveto 80 (/dev/video2) alignedtext
grestore
% n00000005
gsave
0.333 1.000 1.000 nodecolor
newpath 248 78 moveto
358 78 lineto
370 90 lineto
370 158 lineto
358 170 lineto
248 170 lineto
236 158 lineto
236 90 lineto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 248 78 moveto
358 78 lineto
370 90 lineto
370 158 lineto
358 170 lineto
248 170 lineto
236 158 lineto
236 90 lineto
closepath stroke
0.333 1.000 1.000 nodecolor
newpath 358 78 moveto
364 78 370 84 370 90 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 358 78 moveto
364 78 370 84 370 90 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 370 158 moveto
370 164 364 170 358 170 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 370 158 moveto
370 164 364 170 358 170 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 248 170 moveto
242 170 236 164 236 158 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 248 170 moveto
242 170 236 164 236 158 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 236 90 moveto
236 84 242 78 248 78 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 236 90 moveto
236 84 242 78 248 78 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 248 78 moveto
358 78 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 358 78 moveto
364 78 370 84 370 90 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 370 90 moveto
370 158 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 370 158 moveto
370 164 364 170 358 170 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 358 170 moveto
248 170 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 248 170 moveto
242 170 236 164 236 158 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 236 158 moveto
236 90 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 236 90 moveto
236 84 242 78 248 78 curveto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
298.5 152.9 moveto 9 (0) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 236 145 moveto
370 145 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
279 128.4 moveto 48 (FIMC.1) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
244 111.4 moveto 118 (/dev/v4l-subdev1) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 236 103 moveto
370 103 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
298.5 85.9 moveto 9 (1) alignedtext
grestore
% n00000006
gsave
0.165 1.000 1.000 nodecolor
newpath 370 42 moveto
194 42 lineto
194 0 lineto
370 0 lineto
closepath fill
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 370 42 moveto
194 42 lineto
194 0 lineto
370 0 lineto
closepath stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
201.5 25.4 moveto 161 (exynos4-fimc.1.capture) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
242 8.4 moveto 80 (/dev/video3) alignedtext
grestore
% n00000005->n00000006
gsave
2 setlinewidth
bold
0.000 0.000 0.000 edgecolor
newpath 299 78 moveto
297 71 294 61 291 52 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 294.23 50.57 moveto
288 42 lineto
287.52 52.58 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 294.23 50.57 moveto
288 42 lineto
287.52 52.58 lineto
closepath stroke
grestore
% n00000007
gsave
0.165 1.000 1.000 nodecolor
newpath 720 377 moveto
562 377 lineto
562 335 lineto
720 335 lineto
closepath fill
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 720 377 moveto
562 377 lineto
562 335 lineto
720 335 lineto
closepath stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
569.5 360.4 moveto 143 (exynos4-fimc.2.m2m) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
601 343.4 moveto 80 (/dev/video4) alignedtext
grestore
% n00000008
gsave
0.333 1.000 1.000 nodecolor
newpath 400 78 moveto
510 78 lineto
522 90 lineto
522 158 lineto
510 170 lineto
400 170 lineto
388 158 lineto
388 90 lineto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 400 78 moveto
510 78 lineto
522 90 lineto
522 158 lineto
510 170 lineto
400 170 lineto
388 158 lineto
388 90 lineto
closepath stroke
0.333 1.000 1.000 nodecolor
newpath 510 78 moveto
516 78 522 84 522 90 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 510 78 moveto
516 78 522 84 522 90 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 522 158 moveto
522 164 516 170 510 170 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 522 158 moveto
522 164 516 170 510 170 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 400 170 moveto
394 170 388 164 388 158 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 400 170 moveto
394 170 388 164 388 158 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 388 90 moveto
388 84 394 78 400 78 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 388 90 moveto
388 84 394 78 400 78 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 400 78 moveto
510 78 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 510 78 moveto
516 78 522 84 522 90 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 522 90 moveto
522 158 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 522 158 moveto
522 164 516 170 510 170 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 510 170 moveto
400 170 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 400 170 moveto
394 170 388 164 388 158 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 388 158 moveto
388 90 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 388 90 moveto
388 84 394 78 400 78 curveto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
450.5 152.9 moveto 9 (0) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 388 145 moveto
522 145 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
431 128.4 moveto 48 (FIMC.2) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
396 111.4 moveto 118 (/dev/v4l-subdev2) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 388 103 moveto
522 103 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
450.5 85.9 moveto 9 (1) alignedtext
grestore
% n00000009
gsave
0.165 1.000 1.000 nodecolor
newpath 564 42 moveto
388 42 lineto
388 0 lineto
564 0 lineto
closepath fill
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 564 42 moveto
388 42 lineto
388 0 lineto
564 0 lineto
closepath stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
395.5 25.4 moveto 161 (exynos4-fimc.2.capture) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
436 8.4 moveto 80 (/dev/video5) alignedtext
grestore
% n00000008->n00000009
gsave
2 setlinewidth
bold
0.000 0.000 0.000 edgecolor
newpath 459 78 moveto
461 71 464 61 467 52 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 470.48 52.58 moveto
470 42 lineto
463.77 50.57 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 470.48 52.58 moveto
470 42 lineto
463.77 50.57 lineto
closepath stroke
grestore
% n0000000a
gsave
0.165 1.000 1.000 nodecolor
newpath 896 377 moveto
738 377 lineto
738 335 lineto
896 335 lineto
closepath fill
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 896 377 moveto
738 377 lineto
738 335 lineto
896 335 lineto
closepath stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
745.5 360.4 moveto 143 (exynos4-fimc.3.m2m) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
777 343.4 moveto 80 (/dev/video6) alignedtext
grestore
% n0000000b
gsave
0.333 1.000 1.000 nodecolor
newpath 552 78 moveto
662 78 lineto
674 90 lineto
674 158 lineto
662 170 lineto
552 170 lineto
540 158 lineto
540 90 lineto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 552 78 moveto
662 78 lineto
674 90 lineto
674 158 lineto
662 170 lineto
552 170 lineto
540 158 lineto
540 90 lineto
closepath stroke
0.333 1.000 1.000 nodecolor
newpath 662 78 moveto
668 78 674 84 674 90 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 662 78 moveto
668 78 674 84 674 90 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 674 158 moveto
674 164 668 170 662 170 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 674 158 moveto
674 164 668 170 662 170 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 552 170 moveto
546 170 540 164 540 158 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 552 170 moveto
546 170 540 164 540 158 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 540 90 moveto
540 84 546 78 552 78 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 540 90 moveto
540 84 546 78 552 78 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 552 78 moveto
662 78 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 662 78 moveto
668 78 674 84 674 90 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 674 90 moveto
674 158 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 674 158 moveto
674 164 668 170 662 170 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 662 170 moveto
552 170 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 552 170 moveto
546 170 540 164 540 158 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 540 158 moveto
540 90 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 540 90 moveto
540 84 546 78 552 78 curveto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
602.5 152.9 moveto 9 (0) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 540 145 moveto
674 145 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
583 128.4 moveto 48 (FIMC.3) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
548 111.4 moveto 118 (/dev/v4l-subdev3) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 540 103 moveto
674 103 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
602.5 85.9 moveto 9 (1) alignedtext
grestore
% n0000000c
gsave
0.165 1.000 1.000 nodecolor
newpath 758 42 moveto
582 42 lineto
582 0 lineto
758 0 lineto
closepath fill
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 758 42 moveto
582 42 lineto
582 0 lineto
758 0 lineto
closepath stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
589.5 25.4 moveto 161 (exynos4-fimc.3.capture) alignedtext
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
630 8.4 moveto 80 (/dev/video7) alignedtext
grestore
% n0000000b->n0000000c
gsave
2 setlinewidth
bold
0.000 0.000 0.000 edgecolor
newpath 619 78 moveto
626 70 636 60 644 50 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 647.05 51.83 moveto
651 42 lineto
641.78 47.22 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 647.05 51.83 moveto
651 42 lineto
641.78 47.22 lineto
closepath stroke
grestore
% n0000000d
gsave
0.333 1.000 1.000 nodecolor
newpath 258 206 moveto
351 206 lineto
363 218 lineto
363 269 lineto
351 281 lineto
258 281 lineto
246 269 lineto
246 218 lineto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 258 206 moveto
351 206 lineto
363 218 lineto
363 269 lineto
351 281 lineto
258 281 lineto
246 269 lineto
246 218 lineto
closepath stroke
0.333 1.000 1.000 nodecolor
newpath 351 206 moveto
357 206 363 212 363 218 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 351 206 moveto
357 206 363 212 363 218 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 363 269 moveto
363 275 357 281 351 281 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 363 269 moveto
363 275 357 281 351 281 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 258 281 moveto
252 281 246 275 246 269 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 258 281 moveto
252 281 246 275 246 269 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 246 218 moveto
246 212 252 206 258 206 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 246 218 moveto
246 212 252 206 258 206 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 258 206 moveto
351 206 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 351 206 moveto
357 206 363 212 363 218 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 363 218 moveto
363 269 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 363 269 moveto
363 275 357 281 351 281 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 351 281 moveto
258 281 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 258 281 moveto
252 281 246 275 246 269 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 246 269 moveto
246 218 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 246 218 moveto
246 212 252 206 258 206 curveto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
299.5 263.9 moveto 9 (0) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 246 256 moveto
363 256 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
253.5 238.9 moveto 101 (s5p-mipi-csis.0) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 246 231 moveto
363 231 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
299.5 213.9 moveto 9 (1) alignedtext
grestore
% n0000000d->n00000002
gsave
1 setlinewidth
dashed
0.000 0.000 0.000 edgecolor
newpath 272 206 moveto
249 197 217 184 192 174 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 193.56 170.86 moveto
183 170 lineto
190.72 177.26 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 193.56 170.86 moveto
183 170 lineto
190.72 177.26 lineto
closepath stroke
grestore
% n0000000d->n00000005
gsave
1 setlinewidth
0.000 0.000 0.000 edgecolor
newpath 304 206 moveto
303 199 303 189 303 180 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 306.5 180 moveto
303 170 lineto
299.5 180 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 306.5 180 moveto
303 170 lineto
299.5 180 lineto
closepath stroke
grestore
% n0000000d->n00000008
gsave
1 setlinewidth
dashed
0.000 0.000 0.000 edgecolor
newpath 336 206 moveto
359 197 390 184 414 174 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 415.28 177.26 moveto
423 170 lineto
412.44 170.86 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 415.28 177.26 moveto
423 170 lineto
412.44 170.86 lineto
closepath stroke
grestore
% n0000000d->n0000000b
gsave
1 setlinewidth
dashed
0.000 0.000 0.000 edgecolor
newpath 363 207 moveto
412 197 481 183 533 172 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 533.88 175.39 moveto
543 170 lineto
532.51 168.53 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 533.88 175.39 moveto
543 170 lineto
532.51 168.53 lineto
closepath stroke
grestore
% n0000000e
gsave
0.333 1.000 1.000 nodecolor
newpath 926 318 moveto
1019 318 lineto
1031 330 lineto
1031 381 lineto
1019 393 lineto
926 393 lineto
914 381 lineto
914 330 lineto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 926 318 moveto
1019 318 lineto
1031 330 lineto
1031 381 lineto
1019 393 lineto
926 393 lineto
914 381 lineto
914 330 lineto
closepath stroke
0.333 1.000 1.000 nodecolor
newpath 1019 318 moveto
1025 318 1031 324 1031 330 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 1019 318 moveto
1025 318 1031 324 1031 330 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 1031 381 moveto
1031 387 1025 393 1019 393 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 1031 381 moveto
1031 387 1025 393 1019 393 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 926 393 moveto
920 393 914 387 914 381 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 926 393 moveto
920 393 914 387 914 381 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 914 330 moveto
914 324 920 318 926 318 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 914 330 moveto
914 324 920 318 926 318 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 926 318 moveto
1019 318 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 1019 318 moveto
1025 318 1031 324 1031 330 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 1031 330 moveto
1031 381 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 1031 381 moveto
1031 387 1025 393 1019 393 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 1019 393 moveto
926 393 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 926 393 moveto
920 393 914 387 914 381 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 914 381 moveto
914 330 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 914 330 moveto
914 324 920 318 926 318 curveto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
967.5 375.9 moveto 9 (0) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 914 368 moveto
1031 368 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
921.5 350.9 moveto 101 (s5p-mipi-csis.1) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 914 343 moveto
1031 343 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
967.5 325.9 moveto 9 (1) alignedtext
grestore
% n0000000f
gsave
0.333 1.000 1.000 nodecolor
newpath 252 318 moveto
356 318 lineto
368 330 lineto
368 381 lineto
356 393 lineto
252 393 lineto
240 381 lineto
240 330 lineto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 252 318 moveto
356 318 lineto
368 330 lineto
368 381 lineto
356 393 lineto
252 393 lineto
240 381 lineto
240 330 lineto
closepath stroke
0.333 1.000 1.000 nodecolor
newpath 356 318 moveto
362 318 368 324 368 330 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 356 318 moveto
362 318 368 324 368 330 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 368 381 moveto
368 387 362 393 356 393 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 368 381 moveto
368 387 362 393 356 393 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 252 393 moveto
246 393 240 387 240 381 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 252 393 moveto
246 393 240 387 240 381 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 240 330 moveto
240 324 246 318 252 318 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 240 330 moveto
240 324 246 318 252 318 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 252 318 moveto
356 318 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 356 318 moveto
362 318 368 324 368 330 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 368 330 moveto
368 381 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 368 381 moveto
368 387 362 393 356 393 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 356 393 moveto
252 393 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 252 393 moveto
246 393 240 387 240 381 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 240 381 moveto
240 330 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 240 330 moveto
240 324 246 318 252 318 curveto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
301.5 375.9 moveto 5 ( ) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 240 368 moveto
368 368 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
248 350.9 moveto 112 (M5MOLS 0-001f) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 240 343 moveto
368 343 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
299.5 325.9 moveto 9 (0) alignedtext
grestore
% n0000000f->n0000000d
gsave
2 setlinewidth
bold
0.000 0.000 0.000 edgecolor
newpath 304 318 moveto
304 310 304 300 304 291 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 307.5 291 moveto
304 281 lineto
300.5 291 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 307.5 291 moveto
304 281 lineto
300.5 291 lineto
closepath stroke
grestore
% n00000010
gsave
0.333 1.000 1.000 nodecolor
newpath 394 206 moveto
514 206 lineto
526 218 lineto
526 269 lineto
514 281 lineto
394 281 lineto
382 269 lineto
382 218 lineto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 394 206 moveto
514 206 lineto
526 218 lineto
526 269 lineto
514 281 lineto
394 281 lineto
382 269 lineto
382 218 lineto
closepath stroke
0.333 1.000 1.000 nodecolor
newpath 514 206 moveto
520 206 526 212 526 218 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 514 206 moveto
520 206 526 212 526 218 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 526 269 moveto
526 275 520 281 514 281 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 526 269 moveto
526 275 520 281 514 281 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 394 281 moveto
388 281 382 275 382 269 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 394 281 moveto
388 281 382 275 382 269 curveto
stroke
0.333 1.000 1.000 nodecolor
newpath 382 218 moveto
382 212 388 206 394 206 curveto
closepath fill
1 setlinewidth
filled
0.333 1.000 1.000 nodecolor
newpath 382 218 moveto
382 212 388 206 394 206 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 394 206 moveto
514 206 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 514 206 moveto
520 206 526 212 526 218 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 526 218 moveto
526 269 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 526 269 moveto
526 275 520 281 514 281 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 514 281 moveto
394 281 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 394 281 moveto
388 281 382 275 382 269 curveto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 382 269 moveto
382 218 lineto
stroke
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 382 218 moveto
382 212 388 206 394 206 curveto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
451.5 263.9 moveto 5 ( ) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 382 256 moveto
526 256 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
390 238.9 moveto 128 (S5K6AAFX 0-003c) alignedtext
1 setlinewidth
filled
0.000 0.000 0.000 nodecolor
newpath 382 231 moveto
526 231 lineto
stroke
0.000 0.000 0.000 nodecolor
14 /Times-Roman set_font
449.5 213.9 moveto 9 (0) alignedtext
grestore
% n00000010->n00000002
gsave
1 setlinewidth
0.000 0.000 0.000 edgecolor
newpath 390 206 moveto
341 197 275 183 224 172 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 224.49 168.53 moveto
214 170 lineto
223.12 175.39 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 224.49 168.53 moveto
214 170 lineto
223.12 175.39 lineto
closepath stroke
grestore
% n00000010->n00000005
gsave
1 setlinewidth
dashed
0.000 0.000 0.000 edgecolor
newpath 422 206 moveto
399 197 368 184 344 174 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 345.56 170.86 moveto
335 170 lineto
342.72 177.26 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 345.56 170.86 moveto
335 170 lineto
342.72 177.26 lineto
closepath stroke
grestore
% n00000010->n00000008
gsave
1 setlinewidth
dashed
0.000 0.000 0.000 edgecolor
newpath 454 206 moveto
455 199 455 189 455 180 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 458.5 180 moveto
455 170 lineto
451.5 180 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 458.5 180 moveto
455 170 lineto
451.5 180 lineto
closepath stroke
grestore
% n00000010->n0000000b
gsave
1 setlinewidth
dashed
0.000 0.000 0.000 edgecolor
newpath 486 206 moveto
509 197 541 184 566 174 curveto
stroke
0.000 0.000 0.000 edgecolor
newpath 567.28 177.26 moveto
575 170 lineto
564.44 170.86 lineto
closepath fill
1 setlinewidth
solid
0.000 0.000 0.000 edgecolor
newpath 567.28 177.26 moveto
575 170 lineto
564.44 170.86 lineto
closepath stroke
grestore
endpage
showpage
grestore
%%PageTrailer
%%EndPage: 1
%%Trailer
%%Pages: 1
%%BoundingBox: 36 36 1074 438
end
restore
%%EOF

--Boundary_(ID_eqMue9jqF5bO8JbsX68V3w)--
