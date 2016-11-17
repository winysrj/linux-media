Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58476 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754090AbcKQLKi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 06:10:38 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH] [media] docs-rst: cleanup SVG files
Date: Thu, 17 Nov 2016 09:10:17 -0200
Message-Id: <9e3d073009d271b694a1187414663fa89b968523.1479380879.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SVG files are larger than the draw dimentions, have long
lines and aren't cleaned. Use inkscape to automatically fix
those issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/media_api_files/typical_media_device.svg | 2974 +++++++++++++++++++-
 .../subdev-image-processing-crop.svg               |  335 ++-
 .../subdev-image-processing-full.svg               |  865 +++++-
 ...ubdev-image-processing-scaling-multi-source.svg |  606 +++-
 4 files changed, 4471 insertions(+), 309 deletions(-)

diff --git a/Documentation/media/media_api_files/typical_media_device.svg b/Documentation/media/media_api_files/typical_media_device.svg
index f0c82f72c4b6..0c8abd69f39a 100644
--- a/Documentation/media/media_api_files/typical_media_device.svg
+++ b/Documentation/media/media_api_files/typical_media_device.svg
@@ -1,28 +1,2948 @@
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
-<svg stroke-linejoin="round" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://www.w3.org/2000/svg" clip-path="url(#a)" xml:space="preserve" fill-rule="evenodd" height="178.78mm" viewBox="0 0 24285.662 17877.829" width="251.99mm" version="1.2" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" preserveAspectRatio="xMidYMid" stroke-width="28.222"><defs><clipPath id="a" clipPathUnits="userSpaceOnUse"><rect y="0" x="0" width="28000" height="21000"/></clipPath></defs><g transform="matrix(1.004 0 0 1 -2185.6 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#fcf" d="m12231 4800c-516 0-1031 515-1031 1031v4124c0 516 515 1032 1031 1032h8538c516 0 1032-516 1032-1032v-4124c0-516-516-1031-1032-1031h-8538z"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#ffc" d="m3595 15607c-293 0-585 292-585 585v2340c0 293 292 586 585 586h3275c293 0 586-293 586-586v-2340c0-293-293-585-586-585h-3275z"/></g><g transform="translate(-2197.3 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#e6e6e6" d="m2663 2186c-461 0-922 461-922 922v11169c0 461 461 923 922 923h3692c461 0 922-462 922-923v-11169c0-461-461-922-922-922h-3692z"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#ff8080" d="m4461 8602h-2260v-1086h4520v1086h-2260z"/><path fill="none" d="m4461 8602h-2260v-1086h4520v1086h-2260z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="8275" x="2579" class="TextPosition"><tspan fill="#000000">Audio decoder</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#ff8080" d="m4461 11772h-2260v-1270h4520v1270h-2260z"/><path fill="none" d="m4461 11772h-2260v-1270h4520v1270h-2260z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="11353" x="2617" class="TextPosition"><tspan fill="#000000">Video decoder</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#ff8080" d="m4453 10217h-2269v-1224h4537v1224h-2268z"/><path fill="none" d="m4453 10217h-2269v-1224h4537v1224h-2268z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="9821" x="2571" class="TextPosition"><tspan fill="#000000">Audio encoder</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2468.2)" class="com.sun.star.drawing.RectangleShape"><path fill="#cfc" d="m15711 12832h-3810v-1281h7620v1281h-3810z"/><path fill="none" d="m15711 12832h-3810v-1281h7620v1281h-3810z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="12407" x="12377" class="TextPosition"><tspan fill="#000000">Button Key/IR input logic</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2411.8)" class="com.sun.star.drawing.RectangleShape"><path fill="#cfe7f5" d="m14169 14572h-2268v-1412h4536v1412h-2268z"/><path fill="none" d="m14169 14572h-2268v-1412h4536v1412h-2268z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="14082" x="12882" class="TextPosition"><tspan fill="#000000">EEPROM</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#fc9" d="m5140 17662h-1563v-1715h3126v1715h-1563z"/><path fill="none" d="m5140 17662h-1563v-1715h3126v1715h-1563z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="17020" x="4276" class="TextPosition"><tspan fill="#000000">Sensor</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m6719 8030 385-353v176h1167v-176l386 353-386 354v-177h-1167v177l-385-354z"/><path fill="none" d="m6719 8030 385-353v176h1167v-176l386 353-386 354v-177h-1167v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m6719 9612 385-353v176h1167v-176l386 353-386 354v-177h-1167v177l-385-354z"/><path fill="none" d="m6719 9612 385-353v176h1167v-176l386 353-386 354v-177h-1167v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m6721 11100 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z"/><path fill="none" d="m6721 11100 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2411.8)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m9962 13854 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z"/><path fill="none" d="m9962 13854 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2468.2)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m9962 12163 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z"/><path fill="none" d="m9962 12163 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m9962 17158 670-353v176h2028v-176l671 353-671 354v-177h-2028v177l-670-354z"/><path fill="none" d="m9962 17158 670-353v176h2028v-176l671 353-671 354v-177h-2028v177l-670-354z" stroke="#3465af"/></g><g transform="matrix(0 .83339 -1.0005 0 30268 -5276.3)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m23229 12779 1009-978 1009 978h-505v2959h505l-1009 979-1009-979h504v-2959h-504z"/><path fill="none" d="m23229 12779 1009-978 1009 978h-505v2959h505l-1009 979-1009-979h504v-2959h-504z" stroke="#3465af"/></g><g transform="translate(-9973.6 -666.6)" class="com.sun.star.drawing.TextShape"><text class="TextShape"><tspan font-size="706px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="15832" x="24341" class="TextPosition" transform="matrix(0,-1,1,0,8509,40173)"><tspan fill="#000000">System Bus</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#cff" d="m13151 9262h-1250v-875h2499v875h-1249z"/><path fill="none" d="m13151 9262h-1250v-875h2499v875h-1249z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="9040" x="12215" class="TextPosition"><tspan fill="#000000">Demux</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m9996 8765 373-357v178h1130v-178l374 357-374 358v-179h-1130v179l-373-358z"/><path fill="none" d="m9996 8765 373-357v178h1130v-178l374 357-374 358v-179h-1130v179l-373-358z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m9996 7378 373-358v179h1130v-179l374 358-374 358v-179h-1130v179l-373-358z"/><path fill="none" d="m9996 7378 373-358v179h1130v-179l374 358-374 358v-179h-1130v179l-373-358z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#cff" d="m16322 7992h-4421v-1270h8841v1270h-4420z"/><path fill="none" d="m16322 7992h-4421v-1270h8841v1270h-4420z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="7573" x="12786" class="TextPosition"><tspan fill="#000000">Conditional Access Module</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#ff8080" d="m4445 13287h-2269v-1224h4537v1224h-2268z"/><path fill="none" d="m4445 13287h-2269v-1224h4537v1224h-2268z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="12891" x="2601" class="TextPosition"><tspan fill="#000000">Video encoder</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m6721 12634 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z"/><path fill="none" d="m6721 12634 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m20791 7545 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z"/><path fill="none" d="m20791 7545 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2028 -2186)" class="com.sun.star.drawing.TextShape"><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="14478" x="1990" class="TextPosition"><tspan fill="#000000">Radio / Analog TV</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.TextShape"><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="700" class="TextParagraph"><tspan y="10724" x="14956" class="TextPosition"><tspan fill="#000000">Digital TV</tspan></tspan></tspan></text>
-</g><g transform="translate(-8970.5 -1395.8)" class="com.sun.star.drawing.TextShape"><text class="TextShape"><tspan font-size="494px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="19167" x="14724" class="TextPosition"><tspan fill="#000000">PS.: picture is not complete: other blocks may be present</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.TextShape"><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="18561" x="4199" class="TextPosition"><tspan fill="#000000">Webcam</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2468.2)" class="com.sun.star.drawing.RectangleShape"><path fill="#f90" d="m14552 16372h-2650v-1412h5299v1412h-2649z"/><path fill="none" d="m14552 16372h-2650v-1412h5299v1412h-2649z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="15882" x="12265" class="TextPosition"><tspan fill="#000000">Processing blocks</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2468.2)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m9962 15654 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z"/><path fill="none" d="m9962 15654 385-353v176h1166v-176l386 353-386 354v-177h-1166v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m6702 16954 397-353v176h1201v-176l398 353-398 354v-177h-1201v177l-397-354z"/><path fill="none" d="m6702 16954 397-353v176h1201v-176l398 353-398 354v-177h-1201v177l-397-354z" stroke="#3465af"/></g><g transform="translate(-2479.5 -2186)" class="com.sun.star.drawing.TextShape"><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="8792" x="22850" class="TextPosition"><tspan fill="#000000">Smartcard</tspan></tspan></tspan></text>
-</g><g transform="matrix(1.0048 0 0 1 -2207.4 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#fcf" d="m2766 2600c-333 0-666 333-666 666v2668c0 333 333 666 666 666h18368c333 0 667-333 667-666v-2668c0-333-334-666-667-666h-18368z"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#ff8080" d="m5121 5155h-1614v-1816h3227v1816h-1613z"/><path fill="none" d="m5121 5155h-1614v-1816h3227v1816h-1613z" stroke="#3465af"/><text font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextShape"><tspan class="TextParagraph"><tspan y="4111" x="4374" class="TextPosition"><tspan fill="#000000">Tuner</tspan></tspan></tspan><tspan class="TextParagraph"><tspan y="4814" x="4151" class="TextPosition"><tspan fill="#000000">FM/TV</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#ff8080" d="m2902 3702c0 111 40 202 88 202h530c48 0 89-91 89-202 0-110-41-202-89-202h-530c-48 0-88 92-88 202z"/><path fill="none" d="m2902 3702c0 111 40 202 88 202h530c48 0 89-91 89-202 0-110-41-202-89-202h-530c-48 0-88 92-88 202z" stroke="#3465af"/><path fill="#ffb3b3" d="m2902 3702c0 111 40 202 88 202s88-91 88-202c0-110-40-202-88-202s-88 92-88 202z"/><path fill="none" d="m2902 3702c0 111 40 202 88 202s88-91 88-202c0-110-40-202-88-202s-88 92-88 202z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#ff8080" d="m2903 4267c0 110 40 202 88 202h530c48 0 89-92 89-202s-41-203-89-203h-530c-48 0-88 93-88 203z"/><path fill="none" d="m2903 4267c0 110 40 202 88 202h530c48 0 89-92 89-202s-41-203-89-203h-530c-48 0-88 93-88 203z" stroke="#3465af"/><path fill="#ffb3b3" d="m2903 4267c0 110 40 202 88 202s88-92 88-202-40-203-88-203-88 93-88 203z"/><path fill="none" d="m2903 4267c0 110 40 202 88 202s88-92 88-202-40-203-88-203-88 93-88 203z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m6719 4196 385-353v176h1167v-176l386 353-386 354v-177h-1167v177l-385-354z"/><path fill="none" d="m6719 4196 385-353v176h1167v-176l386 353-386 354v-177h-1167v177l-385-354z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m9979 4150 402-368v184h1217v-184l403 368-403 369v-185h-1217v185l-402-369z"/><path fill="none" d="m9979 4150 402-368v184h1217v-184l403 368-403 369v-185h-1217v185l-402-369z" stroke="#3465af"/></g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.RectangleShape"><path fill="#cff" d="m16500 6189h-4500v-1389h9e3v1389h-4500z"/><path fill="none" d="m16500 6189h-4500v-1389h9e3v1389h-4500z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="5710" x="12051" class="TextPosition"><tspan fill="#000000">Satellite Equipment Control (SEC)</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#cff" d="m13400 4600h-1400v-1e3h2800v1e3h-1400z"/><path fill="none" d="m13400 4600h-1400v-1e3h2800v1e3h-1400z" stroke="#3465af"/><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="4316" x="12465" class="TextPosition"><tspan fill="#000000">Demod</tspan></tspan></tspan></text>
-</g><g transform="translate(-2140.9 -2186)" class="com.sun.star.drawing.CustomShape"><path fill="#729fcf" d="m9979 5451 402-368v184h1217v-184l403 368-403 369v-185h-1217v185l-402-369z"/><path fill="none" d="m9979 5451 402-368v184h1217v-184l403 368-403 369v-185h-1217v185l-402-369z" stroke="#3465af"/></g><path fill="#ff9" d="m7855.1 9099v7302h-1270v-14605h1270v7303z"/><path fill="none" d="m7855.1 9099v7302h-1270v-14605h1270v7303z" stroke="#3465af"/><text y="-6640.4663" x="-20770.572" transform="rotate(-90)" class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="7409.5396" x="-11193.634" class="TextPosition" transform="matrix(0,-1,1,0,-4473,23627)"><tspan fill="#000000">I2C Bus (control bus)</tspan></tspan></tspan></text>
-<g transform="translate(-2197.3 -2186)" class="com.sun.star.drawing.TextShape"><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="3278" x="9391" class="TextPosition"><tspan fill="#000000">Digital TV Frontend</tspan></tspan></tspan></text>
-</g><g transform="matrix(1.015 0 0 .99994 -2233.3 -2185.7)" class="com.sun.star.drawing.CustomShape"><g stroke="#3465af" fill="none"><path d="m3e3 2800c-18 0-35 1-53 3"/><path d="m2915 2808c-17 3-35 7-52 12"/><path d="m2832 2830c-16 6-33 12-49 20"/><path d="m2754 2864c-15 8-31 17-46 27"/><path d="m2681 2909c-14 10-28 21-42 32"/><path d="m2614 2962c-13 12-26 24-38 37"/><path d="m2554 3023c-11 13-22 27-33 41"/><path d="m2502 3091c-10 14-19 29-28 45"/><path d="m2459 3164c-8 16-15 32-22 49"/><path d="m2426 3243c-5 17-10 34-14 51"/><path d="m2406 3326c-3 18-5 35-6 53"/><path d="m2400 3411v53"/><path d="m2400 3497v53"/><path d="m2400 3582v53"/><path d="m2400 3668v53"/><path d="m2400 3753v53"/><path d="m2400 3839v53"/><path d="m2400 3924v53"/><path d="m2400 4009v54"/><path d="m2400 4095v53"/><path d="m2400 4180v53"/><path d="m2400 4266v53"/><path d="m2400 4351v53"/><path d="m2400 4437v53"/><path d="m2400 4522v53"/><path d="m2400 4607v54"/><path d="m2400 4693v53"/><path d="m2400 4778v53"/><path d="m2400 4864v53"/><path d="m2400 4949v53"/><path d="m2400 5035v53"/><path d="m2400 5120v53"/><path d="m2400 5205v54"/><path d="m2400 5291v53"/><path d="m2400 5376v53"/><path d="m2400 5462v53"/><path d="m2400 5547v53"/><path d="m2400 5633v53"/><path d="m2400 5718v53"/><path d="m2400 5803c0 18 1 36 3 53"/><path d="m2408 5888c4 18 8 35 13 52"/><path d="m2431 5971c6 16 13 33 20 49"/><path d="m2466 6049c8 15 17 31 27 46"/><path d="m2511 6122c10 14 21 28 32 42"/><path d="m2564 6188c12 13 25 26 38 38"/><path d="m2626 6248c13 11 27 23 41 33"/><path d="m2694 6300c14 10 29 19 45 27"/><path d="m2768 6343c15 7 32 15 48 21"/><path d="m2847 6375c17 5 34 10 51 14"/><path d="m2930 6395c17 2 35 4 53 5"/><path d="m3015 6400h53"/><path d="m3100 6400h53"/><path d="m3186 6400h53"/><path d="m3271 6400h53"/><path d="m3357 6400h53"/><path d="m3442 6400h53"/><path d="m3527 6400h54"/><path d="m3613 6400h53"/><path d="m3698 6400h53"/><path d="m3784 6400h53"/><path d="m3869 6400h53"/><path d="m3955 6400h53"/><path d="m4040 6400h53"/><path d="m4125 6400h54"/><path d="m4211 6400h53"/><path d="m4296 6400h53"/><path d="m4382 6400h53"/><path d="m4467 6400h53"/><path d="m4553 6400h53"/><path d="m4638 6400h53"/><path d="m4723 6400h54"/><path d="m4809 6400h53"/><path d="m4894 6400h53"/><path d="m4980 6400h53"/><path d="m5065 6400h53"/><path d="m5151 6400h53"/><path d="m5236 6400h53"/><path d="m5322 6400h53"/><path d="m5407 6400h53"/><path d="m5492 6400h53"/><path d="m5578 6400h53"/><path d="m5663 6400h53"/><path d="m5749 6400h53"/><path d="m5834 6400h53"/><path d="m5920 6400h53"/><path d="m6005 6400h53"/><path d="m6090 6400h53"/><path d="m6176 6400h53"/><path d="m6261 6400h53"/><path d="m6347 6400h53"/><path d="m6432 6400h53"/><path d="m6518 6400h53"/><path d="m6603 6400h53"/><path d="m6688 6400h54"/><path d="m6774 6400h53"/><path d="m6859 6400h53"/><path d="m6945 6400h53"/><path d="m7030 6400h53"/><path d="m7116 6400h53"/><path d="m7201 6400h53"/><path d="m7286 6400h54"/><path d="m7372 6400h53"/><path d="m7457 6400h53"/><path d="m7543 6400h53"/><path d="m7628 6400h53"/><path d="m7714 6400h53"/><path d="m7799 6400h53"/><path d="m7884 6400h54"/><path d="m7970 6400h53"/><path d="m8055 6400h53"/><path d="m8141 6400h53"/><path d="m8226 6400h53"/><path d="m8312 6400h53"/><path d="m8397 6400h53"/><path d="m8482 6400h54"/><path d="m8568 6400h53"/><path d="m8653 6400h53"/><path d="m8739 6400h53"/><path d="m8824 6400h53"/><path d="m8910 6400h53"/><path d="m8995 6400h53"/><path d="m9081 6400h53"/><path d="m9166 6400h53"/><path d="m9251 6400h53"/><path d="m9337 6400h53"/><path d="m9422 6400h53"/><path d="m9508 6400h53"/><path d="m9593 6400h53"/><path d="m9679 6400h53"/><path d="m9764 6400h53"/><path d="m9849 6400h53"/><path d="m9935 6400h53"/><path d="m10020 6400h53"/><path d="m10106 6400h53"/><path d="m10191 6400h53"/><path d="m10277 6400h53"/><path d="m10362 6400h53"/><path d="m10447 6400h53"/><path d="m10533 6400h53"/><path d="m10618 6400h53"/><path d="m10704 6400h53"/><path d="m10789 6400h53"/><path d="m10875 6400h53"/><path d="m10960 6400h53"/><path d="m11045 6400h54"/><path d="m11131 6400h53"/><path d="m11216 6400h53"/><path d="m11302 6400h53"/><path d="m11387 6400h53"/><path d="m11473 6400h53"/><path d="m11558 6400h53"/><path d="m11643 6400h54"/><path d="m11729 6400h53"/><path d="m11814 6400h53"/><path d="m11900 6400h53"/><path d="m11985 6400h53"/><path d="m12071 6400h53"/><path d="m12156 6400h53"/><path d="m12241 6400h54"/><path d="m12327 6400h53"/><path d="m12412 6400h53"/><path d="m12498 6400h53"/><path d="m12583 6400h53"/><path d="m12669 6400h53"/><path d="m12754 6400h53"/><path d="m12839 6400h54"/><path d="m12925 6400h53"/><path d="m13010 6400h53"/><path d="m13096 6400h53"/><path d="m13181 6400h53"/><path d="m13267 6400h53"/><path d="m13352 6400h53"/><path d="m13438 6400h53"/><path d="m13523 6400h53"/><path d="m13608 6400h53"/><path d="m13694 6400h53"/><path d="m13779 6400h53"/><path d="m13865 6400h53"/><path d="m13950 6400h53"/><path d="m14036 6400h53"/><path d="m14121 6400h53"/><path d="m14206 6400h53"/><path d="m14292 6400h53"/><path d="m14377 6400h53"/><path d="m14463 6400h53"/><path d="m14548 6400h53"/><path d="m14634 6400h53"/><path d="m14719 6400h53"/><path d="m14804 6400h54"/><path d="m14890 6400h53"/><path d="m14975 6400h53"/><path d="m15061 6400h53"/><path d="m15146 6400h53"/><path d="m15232 6400h53"/><path d="m15317 6400h53"/><path d="m15402 6400h54"/><path d="m15488 6400h53"/><path d="m15573 6400h53"/><path d="m15659 6400h53"/><path d="m15744 6400h53"/><path d="m15830 6400h53"/><path d="m15915 6400h53"/><path d="m16000 6400h54"/><path d="m16086 6400h53"/><path d="m16171 6400h53"/><path d="m16257 6400h53"/><path d="m16342 6400h53"/><path d="m16428 6400h53"/><path d="m16513 6400h53"/><path d="m16598 6400h54"/><path d="m16684 6400h53"/><path d="m16769 6400h53"/><path d="m16855 6400h53"/><path d="m16940 6400h53"/><path d="m17026 6400h53"/><path d="m17111 6400h53"/><path d="m17196 6400h54"/><path d="m17282 6400h53"/><path d="m17367 6400h53"/><path d="m17453 6400h53"/><path d="m17538 6400h53"/><path d="m17624 6400h53"/><path d="m17709 6400h53"/><path d="m17795 6400h53"/><path d="m17880 6400h53"/><path d="m17965 6400h53"/><path d="m18051 6400h53"/><path d="m18136 6400h53"/><path d="m18222 6400h53"/><path d="m18307 6400h53"/><path d="m18393 6400h53"/><path d="m18478 6400h53"/><path d="m18563 6400h53"/><path d="m18649 6400h53"/><path d="m18734 6400h53"/><path d="m18820 6400h53"/><path d="m18905 6400h53"/><path d="m18991 6400h53"/><path d="m19076 6400h53"/><path d="m19161 6400h54"/><path d="m19247 6400h53"/><path d="m19332 6400h53"/><path d="m19418 6400h53"/><path d="m19503 6400h53"/><path d="m19589 6400h53"/><path d="m19674 6400h53"/><path d="m19759 6400h54"/><path d="m19845 6400h53"/><path d="m19930 6400h53"/><path d="m20016 6400h53"/><path d="m20101 6400h53"/><path d="m20187 6400h53"/><path d="m20272 6400h53"/><path d="m20357 6400h54"/><path d="m20443 6400h53"/><path d="m20528 6400h53"/><path d="m20614 6400c17-1 35-2 53-5"/><path d="m20699 6390c17-4 34-9 51-14"/><path d="m20781 6365c16-6 32-13 48-21"/><path d="m20858 6329c15-8 31-17 45-27"/><path d="m20930 6283c14-10 28-21 42-32"/><path d="m20996 6229c13-12 25-25 37-38"/><path d="m21055 6167c11-14 22-28 33-42"/><path d="m21106 6098c10-15 19-30 27-45"/><path d="m21148 6024c7-16 14-33 20-49"/><path d="m21179 5944c5-17 9-34 13-51"/><path d="m21197 5861c2-18 4-35 4-53"/><path d="m21201 5776v-54"/><path d="m21201 5690v-53"/><path d="m21201 5605v-53"/><path d="m21201 5519v-53"/><path d="m21201 5434v-53"/><path d="m21201 5348v-53"/><path d="m21201 5263v-53"/><path d="m21201 5178v-54"/><path d="m21201 5092v-53"/><path d="m21201 5007v-53"/><path d="m21201 4921v-53"/><path d="m21201 4836v-53"/><path d="m21201 4750v-53"/><path d="m21201 4665v-53"/><path d="m21201 4579v-53"/><path d="m21201 4494v-53"/><path d="m21201 4409v-53"/><path d="m21201 4323v-53"/><path d="m21201 4238v-53"/><path d="m21201 4152v-53"/><path d="m21201 4067v-53"/><path d="m21201 3981v-53"/><path d="m21201 3896v-53"/><path d="m21201 3811v-53"/><path d="m21201 3725v-53"/><path d="m21201 3640v-53"/><path d="m21201 3554v-53"/><path d="m21201 3469v-53"/><path d="m21201 3383c-1  
-17-3-35-5-52"/><path d="m21190 3299c-4-17-8-35-14-51"/><path d="m21165 3217c-6-16-13-33-21-49"/><path d="m21129 3140c-9-16-18-31-28-46"/><path d="m21082 3068c-10-14-21-28-33-42"/><path d="m21027 3002c-12-13-24-25-37-37"/><path d="m20965 2944c-14-12-28-22-42-33"/><path d="m20896 2893c-15-9-30-18-46-27"/><path d="m20821 2852c-16-8-32-14-49-20"/><path d="m20741 2821c-17-5-34-9-51-12"/><path d="m20658 2804c-18-3-35-4-53-4"/><path d="m20573 2800h-53"/><path d="m20487 2800h-53"/><path d="m20402 2800h-53"/><path d="m20316 2800h-53"/><path d="m20231 2800h-53"/><path d="m20146 2800h-54"/><path d="m20060 2800h-53"/><path d="m19975 2800h-53"/><path d="m19889 2800h-53"/><path d="m19804 2800h-53"/><path d="m19718 2800h-53"/><path d="m19633 2800h-53"/><path d="m19548 2800h-54"/><path d="m19462 2800h-53"/><path d="m19377 2800h-53"/><path d="m19291 2800h-53"/><path d="m19206 2800h-53"/><path d="m19120 2800h-53"/><path d="m19035 2800h-53"/><path d="m18950 2800h-54"/><path d="m18864 2800h-53"/><path d="m18779 2800h-53"/><path d="m18693 2800h-53"/><path d="m18608 2800h-53"/><path d="m18522 2800h-53"/><path d="m18437 2800h-53"/><path d="m18352 2800h-54"/><path d="m18266 2800h-53"/><path d="m18181 2800h-53"/><path d="m18095 2800h-53"/><path d="m18010 2800h-53"/><path d="m17924 2800h-53"/><path d="m17839 2800h-53"/><path d="m17753 2800h-53"/><path d="m17668 2800h-53"/><path d="m17583 2800h-53"/><path d="m17497 2800h-53"/><path d="m17412 2800h-53"/><path d="m17326 2800h-53"/><path d="m17241 2800h-53"/><path d="m17155 2800h-53"/><path d="m17070 2800h-53"/><path d="m16985 2800h-53"/><path d="m16899 2800h-53"/><path d="m16814 2800h-53"/><path d="m16728 2800h-53"/><path d="m16643 2800h-53"/><path d="m16557 2800h-53"/><path d="m16472 2800h-53"/><path d="m16387 2800h-54"/><path d="m16301 2800h-53"/><path d="m16216 2800h-53"/><path d="m16130 2800h-53"/><path d="m16045 2800h-53"/><path d="m15959 2800h-53"/><path d="m15874 2800h-53"/><path d="m15789 2800h-54"/><path d="m15703 2800h-53"/><path d="m15618 2800h-53"/><path d="m15532 2800h-53"/><path d="m15447 2800h-53"/><path d="m15361 2800h-53"/><path d="m15276 2800h-53"/><path d="m15191 2800h-54"/><path d="m15105 2800h-53"/><path d="m15020 2800h-53"/><path d="m14934 2800h-53"/><path d="m14849 2800h-53"/><path d="m14763 2800h-53"/><path d="m14678 2800h-53"/><path d="m14593 2800h-54"/><path d="m14507 2800h-53"/><path d="m14422 2800h-53"/><path d="m14336 2800h-53"/><path d="m14251 2800h-53"/><path d="m14165 2800h-53"/><path d="m14080 2800h-53"/><path d="m13994 2800h-53"/><path d="m13909 2800h-53"/><path d="m13824 2800h-53"/><path d="m13738 2800h-53"/><path d="m13653 2800h-53"/><path d="m13567 2800h-53"/><path d="m13482 2800h-53"/><path d="m13396 2800h-53"/><path d="m13311 2800h-53"/><path d="m13226 2800h-53"/><path d="m13140 2800h-53"/><path d="m13055 2800h-53"/><path d="m12969 2800h-53"/><path d="m12884 2800h-53"/><path d="m12798 2800h-53"/><path d="m12713 2800h-53"/><path d="m12628 2800h-53"/><path d="m12542 2800h-53"/><path d="m12457 2800h-53"/><path d="m12371 2800h-53"/><path d="m12286 2800h-53"/><path d="m12200 2800h-53"/><path d="m12115 2800h-53"/><path d="m12030 2800h-54"/><path d="m11944 2800h-53"/><path d="m11859 2800h-53"/><path d="m11773 2800h-53"/><path d="m11688 2800h-53"/><path d="m11602 2800h-53"/><path d="m11517 2800h-53"/><path d="m11432 2800h-54"/><path d="m11346 2800h-53"/><path d="m11261 2800h-53"/><path d="m11175 2800h-53"/><path d="m11090 2800h-53"/><path d="m11004 2800h-53"/><path d="m10919 2800h-53"/><path d="m10834 2800h-54"/><path d="m10748 2800h-53"/><path d="m10663 2800h-53"/><path d="m10577 2800h-53"/><path d="m10492 2800h-53"/><path d="m10406 2800h-53"/><path d="m10321 2800h-53"/><path d="m10236 2800h-54"/><path d="m10150 2800h-53"/><path d="m10065 2800h-53"/><path d="m9979 2800h-53"/><path d="m9894 2800h-53"/><path d="m9808 2800h-53"/><path d="m9723 2800h-53"/><path d="m9637 2800h-53"/><path d="m9552 2800h-53"/><path d="m9467 2800h-53"/><path d="m9381 2800h-53"/><path d="m9296 2800h-53"/><path d="m9210 2800h-53"/><path d="m9125 2800h-53"/><path d="m9039 2800h-53"/><path d="m8954 2800h-53"/><path d="m8869 2800h-53"/><path d="m8783 2800h-53"/><path d="m8698 2800h-53"/><path d="m8612 2800h-53"/><path d="m8527 2800h-53"/><path d="m8441 2800h-53"/><path d="m8356 2800h-53"/><path d="m8271 2800h-54"/><path d="m8185 2800h-53"/><path d="m8100 2800h-53"/><path d="m8014 2800h-53"/><path d="m7929 2800h-53"/><path d="m7843 2800h-53"/><path d="m7758 2800h-53"/><path d="m7673 2800h-54"/><path d="m7587 2800h-53"/><path d="m7502 2800h-53"/><path d="m7416 2800h-53"/><path d="m7331 2800h-53"/><path d="m7245 2800h-53"/><path d="m7160 2800h-53"/><path d="m7075 2800h-54"/><path d="m6989 2800h-53"/><path d="m6904 2800h-53"/><path d="m6818 2800h-53"/><path d="m6733 2800h-53"/><path d="m6647 2800h-53"/><path d="m6562 2800h-53"/><path d="m6477 2800h-54"/><path d="m6391 2800h-53"/><path d="m6306 2800h-53"/><path d="m6220 2800h-53"/><path d="m6135 2800h-53"/><path d="m6049 2800h-53"/><path d="m5964 2800h-53"/><path d="m5879 2800h-54"/><path d="m5793 2800h-53"/><path d="m5708 2800h-53"/><path d="m5622 2800h-53"/><path d="m5537 2800h-53"/><path d="m5451 2800h-53"/><path d="m5366 2800h-53"/><path d="m5280 2800h-53"/><path d="m5195 2800h-53"/><path d="m5110 2800h-53"/><path d="m5024 2800h-53"/><path d="m4939 2800h-53"/><path d="m4853 2800h-53"/><path d="m4768 2800h-53"/><path d="m4682 2800h-53"/><path d="m4597 2800h-53"/><path d="m4512 2800h-53"/><path d="m4426 2800h-53"/><path d="m4341 2800h-53"/><path d="m4255 2800h-53"/><path d="m4170 2800h-53"/><path d="m4084 2800h-53"/><path d="m3999 2800h-53"/><path d="m3914 2800h-54"/><path d="m3828 2800h-53"/><path d="m3743 2800h-53"/><path d="m3657 2800h-53"/><path d="m3572 2800h-53"/><path d="m3486 2800h-53"/><path d="m3401 2800h-53"/><path d="m3316 2800h-54"/><path d="m3230 2800h-53"/><path d="m3145 2800h-53"/><path d="m3059 2800h-53"/></g></g><g transform="translate(-2197.3 -2186)"><rect height="1100.7" width="1213.6" y="6917.1" x="23255" fill="#f3e777"/><path fill="#ca4677" d="m22802 7700.4v-405.46l150.7-169.16c82.886-93.039 170.53-186.62 194.77-207.96l44.069-38.798 783.23-0.086 783.23-0.086v613.5 613.5h-978-978v-405.46zm1027.7 136.98v-78.372l-169.91 4.925-169.91 4.9249-5.09 45.854c-8.249 74.303 46.711 101.04 207.69 101.04h137.21v-78.372zm235.86-262.94 4.495-341.31 207.2-8.6408 207.2-8.6408 5.144-46.443c9.596-86.615-41.863-102.05-322.02-96.607l-246.71 4.7956-4.438 419.08-4.439 419.08h74.537 74.538l4.494-341.31zm391.3 313.72c26.41-19.286 36.255-41.399 32.697-73.447l-5.09-45.854h-174.05-174.05l-5.38 48.984c-9.97 90.771 0.993 97.91 150.36 97.91 99.305 0 148.27-7.6982 175.52-27.594zm-627.16-274.84v-77.768h-174.05-174.05v66.246c0 36.436 4.973 71.431 11.051 77.768 6.078 6.3366 84.401 11.521 174.05 11.521h163v-77.768zm659.89-4.9154 5.125-74.042-179.18 4.9155-179.18 4.9155-5.38 48.984c-10.473 95.348-2.259 99.57 183.28 94.197l170.2-4.9284 5.125-74.042zm-659.89-237.63v-78.372l-169.91 4.925-169.91 4.925-5.097 73.447-5.097 73.447h175 175v-78.372zm659.86 4.925-5.097-73.447h-174.05-174.05l-5.38 48.984c-10.289 93.673-2.146 97.91 188.15 97.91h175.52l-5.097-73.447zm-659.86-228.98v-77.768h-137.21c-97.358 0-147.91 7.8138-174.05 26.902-34.952 25.523-49.645 92.242-25.79 117.11 6.078 6.3366 84.401 11.521 174.05 11.521h163v-77.768z"/></g><g transform="matrix(.84874 0 0 .76147 2408.1 3615.3)"><rect height="3076.2" width="2734.3" y="13264" x="19249" fill="#6076b3"/><g stroke-linejoin="round" fill-rule="evenodd" stroke-width="28.222" fill="#e0ee2c"><rect y="13369" width="356.65" x="18937" height="180.95"/><rect y="13708" width="356.65" x="18937" height="180.95"/><rect y="14048" width="356.65" x="18937" height="180.95"/><rect y="14387" width="356.65" x="18937" height="180.95"/><rect y="14726" width="356.65" x="18937" height="180.95"/><rect y="15066" width="356.65" x="18937" height="180.95"/><rect y="15405" width="356.65" x="18937" height="180.95"/><rect y="15744" width="356.65" x="18937" height="180.95"/><rect y="16083" width="356.65" x="18937" height="180.95"/><rect y="13324" width="356.65" x="21939" height="180.95"/><rect y="13663" width="356.65" x="21939" height="180.95"/><rect y="14002" width="356.  
65" x="21939" height="180.95"/><rect y="14342" width="356.65" x="21939" height="180.95"/><rect y="14681" width="356.65" x="21939" height="180.95"/><rect y="15020" width="356.65" x="21939" height="180.95"/><rect y="15360" width="356.65" x="21939" height="180.95"/><rect y="15699" width="356.65" x="21939" height="180.95"/><rect y="16038" width="356.65" x="21939" height="180.95"/></g><g stroke-linejoin="round" fill-rule="evenodd" transform="matrix(.98702 0 0 .90336 -2675 7020.8)" class="com.sun.star.drawing.TextShape" stroke-width="28.222"><text class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"/></text>
-<text style="word-spacing:0px;letter-spacing:0px" xml:space="preserve" font-size="1128.9px" y="9042.0264" x="22439.668" font-family="Sans" line-height="125%" fill="#000000"><tspan y="9042.0264" x="22439.668">CPU</tspan></text>
-</g></g><g stroke-linejoin="round" fill-rule="evenodd" transform="translate(-11752 543.6)" class="com.sun.star.drawing.TextShape" stroke-width="28.222"><text class="TextShape"><tspan font-size="706px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="15832" x="24341" class="TextPosition" transform="matrix(0,-1,1,0,8509,40173)"><tspan fill="#000000">PCI, USB, SPI, I2C, ...</tspan></tspan></tspan></text>
-</g><g stroke-linejoin="round" fill-rule="evenodd" transform="translate(-655.31 963.83)" class="com.sun.star.drawing.RectangleShape" stroke-width="28.222"><g transform="matrix(.49166 0 0 1.0059 6045.6 -82.24)"><path fill="#cfe7f5" d="m14169 14572h-2268v-1412h4536v1412h-2268z"/><path fill="none" d="m14169 14572h-2268v-1412h4536v1412h-2268z" stroke="#3465af"/></g><text y="-395.11282" x="-790.22229" class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="13686.9" x="12091.779" class="TextPosition"><tspan fill="#000000">Bridge</tspan></tspan></tspan></text>
-<text y="338.66486" x="-846.66675" class="TextShape"><tspan font-size="635px" font-family="&apos;Times New Roman&apos;, serif" font-weight="400" class="TextParagraph"><tspan y="14420.677" x="12035.335" class="TextPosition"><tspan fill="#000000"> DMA</tspan></tspan></tspan></text>
-</g></svg>
+<svg
+   xmlns:dc="http://purl.org/dc/elements/1.1/"
+   xmlns:cc="http://creativecommons.org/ns#"
+   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
+   xmlns:svg="http://www.w3.org/2000/svg"
+   xmlns="http://www.w3.org/2000/svg"
+   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
+   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
+   clip-path="url(#a)"
+   xml:space="preserve"
+   height="179mm"
+   viewBox="0 0 22648.239 17899.829"
+   width="235mm"
+   version="1.2"
+   preserveAspectRatio="xMidYMid"
+   id="svg2"
+   inkscape:version="0.91 r13725"
+   sodipodi:docname="typical_media_device.svg"
+   style="fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round"><metadata
+     id="metadata1533"><rdf:RDF><cc:Work
+         rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
+           rdf:resource="http://purl.org/dc/dcmitype/StillImage" /><dc:title /></cc:Work></rdf:RDF></metadata><sodipodi:namedview
+     pagecolor="#ffffff"
+     bordercolor="#666666"
+     borderopacity="1"
+     objecttolerance="10"
+     gridtolerance="10"
+     guidetolerance="10"
+     inkscape:pageopacity="0"
+     inkscape:pageshadow="2"
+     inkscape:window-width="1920"
+     inkscape:window-height="997"
+     id="namedview1531"
+     showgrid="false"
+     fit-margin-top="0"
+     fit-margin-left="0"
+     fit-margin-right="0"
+     fit-margin-bottom="0"
+     inkscape:zoom="1.2707744"
+     inkscape:cx="410.32614"
+     inkscape:cy="316.736"
+     inkscape:window-x="1920"
+     inkscape:window-y="30"
+     inkscape:window-maximized="1"
+     inkscape:current-layer="svg2" /><defs
+     id="defs4"><clipPath
+       id="a"
+       clipPathUnits="userSpaceOnUse"><rect
+         y="0"
+         x="0"
+         width="28000"
+         height="21000"
+         id="rect7" /></clipPath></defs><path
+     style="fill:#ffccff"
+     inkscape:connector-curvature="0"
+     id="path11"
+     d="m 10145.77,2636.013 c -518.0641,0 -1035.1241,515 -1035.1241,1031 l 0,4124 c 0,516 517.06,1032 1035.1241,1032 l 8572.152,0 c 518.064,0 1036.128,-516 1036.128,-1032 l 0,-4124 c 0,-516 -518.064,-1031 -1036.128,-1031 l -8572.152,0 z" /><path
+     style="fill:#ffffcc"
+     inkscape:connector-curvature="0"
+     id="path15"
+     d="m 1505.5459,13443.013 c -293,0 -585,292 -585,585 l 0,2340 c 0,293 292,586 585,586 l 3275,0 c 293,0 586,-293 586,-586 l 0,-2340 c 0,-293 -293,-585 -586,-585 l -3275,0 z" /><path
+     style="fill:#e6e6e6"
+     inkscape:connector-curvature="0"
+     id="path19"
+     d="m 517.1459,22.013 c -461,0 -922,461 -922,922 l 0,11169 c 0,461 461,923 922,923 l 3692,0 c 461,0 922,-462 922,-923 l 0,-11169 c 0,-461 -461,-922 -922,-922 l -3692,0 z" /><path
+     style="fill:#ff8080"
+     inkscape:connector-curvature="0"
+     id="path23"
+     d="m 2371.5459,6438.013 -2260,0 0,-1086 4520,0 0,1086 -2260,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path25"
+     d="m 2371.5459,6438.013 -2260,0 0,-1086 4520,0 0,1086 -2260,0 z" /><text
+     id="text27"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan29"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan31"
+         class="TextPosition"
+         x="489.5459"
+         y="6111.0132"><tspan
+           style="fill:#000000"
+           id="tspan33">Audio decoder</tspan></tspan></tspan></text>
+<path
+     style="fill:#ff8080"
+     inkscape:connector-curvature="0"
+     id="path37"
+     d="m 2371.5459,9608.013 -2260,0 0,-1270 4520,0 0,1270 -2260,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path39"
+     d="m 2371.5459,9608.013 -2260,0 0,-1270 4520,0 0,1270 -2260,0 z" /><text
+     id="text41"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan43"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan45"
+         class="TextPosition"
+         x="527.5459"
+         y="9189.0127"><tspan
+           style="fill:#000000"
+           id="tspan47">Video decoder</tspan></tspan></tspan></text>
+<path
+     style="fill:#ff8080"
+     inkscape:connector-curvature="0"
+     id="path51"
+     d="m 2363.5459,8053.013 -2269,0 0,-1224 4537,0 0,1224 -2268,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path53"
+     d="m 2363.5459,8053.013 -2269,0 0,-1224 4537,0 0,1224 -2268,0 z" /><text
+     id="text55"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan57"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan59"
+         class="TextPosition"
+         x="481.5459"
+         y="7657.0132"><tspan
+           style="fill:#000000"
+           id="tspan61">Audio encoder</tspan></tspan></tspan></text>
+<path
+     style="fill:#ccffcc"
+     inkscape:connector-curvature="0"
+     id="path65"
+     d="m 13621.546,10385.813 -3810.0001,0 0,-1281 7620.0001,0 0,1281 -3810,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path67"
+     d="m 13621.546,10385.813 -3810.0001,0 0,-1281 7620.0001,0 0,1281 -3810,0 z" /><text
+     id="text69"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2446.187"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan71"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan73"
+         class="TextPosition"
+         x="10287.546"
+         y="9960.8135"><tspan
+           style="fill:#000000"
+           id="tspan75">Button Key/IR input logic</tspan></tspan></tspan></text>
+<path
+     style="fill:#cfe7f5"
+     inkscape:connector-curvature="0"
+     id="path79"
+     d="m 12079.546,12182.213 -2268.0001,0 0,-1412 4536.0001,0 0,1412 -2268,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path81"
+     d="m 12079.546,12182.213 -2268.0001,0 0,-1412 4536.0001,0 0,1412 -2268,0 z" /><text
+     id="text83"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2389.7871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan85"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan87"
+         class="TextPosition"
+         x="10792.546"
+         y="11692.213"><tspan
+           style="fill:#000000"
+           id="tspan89">EEPROM</tspan></tspan></tspan></text>
+<path
+     style="fill:#ffcc99"
+     inkscape:connector-curvature="0"
+     id="path93"
+     d="m 3050.5459,15498.013 -1563,0 0,-1715 3126,0 0,1715 -1563,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path95"
+     d="m 3050.5459,15498.013 -1563,0 0,-1715 3126,0 0,1715 -1563,0 z" /><text
+     id="text97"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan99"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan101"
+         class="TextPosition"
+         x="2186.5459"
+         y="14856.013"><tspan
+           style="fill:#000000"
+           id="tspan103">Sensor</tspan></tspan></tspan></text>
+<path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path107"
+     d="m 4629.5459,5866.013 385,-353 0,176 1167,0 0,-176 386,353 -386,354 0,-177 -1167,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path109"
+     d="m 4629.5459,5866.013 385,-353 0,176 1167,0 0,-176 386,353 -386,354 0,-177 -1167,0 0,177 -385,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path113"
+     d="m 4629.5459,7448.013 385,-353 0,176 1167,0 0,-176 386,353 -386,354 0,-177 -1167,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path115"
+     d="m 4629.5459,7448.013 385,-353 0,176 1167,0 0,-176 386,353 -386,354 0,-177 -1167,0 0,177 -385,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path119"
+     d="m 4631.5459,8936.013 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path121"
+     d="m 4631.5459,8936.013 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path125"
+     d="m 7872.5459,11464.213 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path127"
+     d="m 7872.5459,11464.213 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path131"
+     d="m 7872.5459,9716.813 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path133"
+     d="m 7872.5459,9716.813 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path137"
+     d="m 7872.5459,14994.013 670,-353 0,176 2028.0001,0 0,-176 671,353 -671,354 0,-177 -2028.0001,0 0,177 -670,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path139"
+     d="m 7872.5459,14994.013 670,-353 0,176 2028.0001,0 0,-176 671,353 -671,354 0,-177 -2028.0001,0 0,177 -670,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path143"
+     d="m 17534.058,14104.529 978.488,840.891 -978.488,840.89 0,-420.862 -2960.48,0 0,420.862 -979.489,-840.89 979.489,-840.891 0,420.029 2960.48,0 0,-420.029 z" /><path
+     style="fill:none;stroke:#3465af;stroke-width:25.77035904"
+     inkscape:connector-curvature="0"
+     id="path145"
+     d="m 17534.058,14104.529 978.488,840.891 -978.488,840.89 0,-420.862 -2960.48,0 0,420.862 -979.489,-840.89 979.489,-840.891 0,420.029 2960.48,0 0,-420.029 z" /><text
+     id="text149"
+     class="TextShape"
+     x="-9922.1533"
+     y="-644.58704"><tspan
+       style="font-weight:400;font-size:706px;font-family:'Times New Roman', serif"
+       id="tspan151"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="706px"><tspan
+         id="tspan153"
+         transform="matrix(0,-1,1,0,8509,40173)"
+         class="TextPosition"
+         x="14418.847"
+         y="15187.413"><tspan
+           style="fill:#000000"
+           id="tspan155">System Bus</tspan></tspan></tspan></text>
+<path
+     style="fill:#ccffff"
+     inkscape:connector-curvature="0"
+     id="path159"
+     d="m 11061.546,7098.013 -1250.0001,0 0,-875 2499.0001,0 0,875 -1249,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path161"
+     d="m 11061.546,7098.013 -1250.0001,0 0,-875 2499.0001,0 0,875 -1249,0 z" /><text
+     id="text163"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan165"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan167"
+         class="TextPosition"
+         x="10125.546"
+         y="6876.0132"><tspan
+           style="fill:#000000"
+           id="tspan169">Demux</tspan></tspan></tspan></text>
+<path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path173"
+     d="m 7906.5459,6601.013 373,-357 0,178 1130,0 0,-178 374,357 -374,358 0,-179 -1130,0 0,179 -373,-358 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path175"
+     d="m 7906.5459,6601.013 373,-357 0,178 1130,0 0,-178 374,357 -374,358 0,-179 -1130,0 0,179 -373,-358 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path179"
+     d="m 7906.5459,5214.013 373,-358 0,179 1130,0 0,-179 374,358 -374,358 0,-179 -1130,0 0,179 -373,-358 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path181"
+     d="m 7906.5459,5214.013 373,-358 0,179 1130,0 0,-179 374,358 -374,358 0,-179 -1130,0 0,179 -373,-358 z" /><path
+     style="fill:#ccffff"
+     inkscape:connector-curvature="0"
+     id="path185"
+     d="m 14232.546,5828.013 -4421.0001,0 0,-1270 8841.0001,0 0,1270 -4420,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path187"
+     d="m 14232.546,5828.013 -4421.0001,0 0,-1270 8841.0001,0 0,1270 -4420,0 z" /><text
+     id="text189"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan191"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan193"
+         class="TextPosition"
+         x="10696.546"
+         y="5409.0132"><tspan
+           style="fill:#000000"
+           id="tspan195">Conditional Access Module</tspan></tspan></tspan></text>
+<path
+     style="fill:#ff8080"
+     inkscape:connector-curvature="0"
+     id="path199"
+     d="m 2355.5459,11123.013 -2269,0 0,-1224 4537,0 0,1224 -2268,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path201"
+     d="m 2355.5459,11123.013 -2269,0 0,-1224 4537,0 0,1224 -2268,0 z" /><text
+     id="text203"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan205"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan207"
+         class="TextPosition"
+         x="511.5459"
+         y="10727.013"><tspan
+           style="fill:#000000"
+           id="tspan209">Video encoder</tspan></tspan></tspan></text>
+<path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path213"
+     d="m 4631.5459,10470.013 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path215"
+     d="m 4631.5459,10470.013 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path219"
+     d="m 18701.546,5381.013 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path221"
+     d="m 18701.546,5381.013 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><text
+     id="text225"
+     class="TextShape"
+     x="-1976.5541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan227"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan229"
+         class="TextPosition"
+         x="13.4459"
+         y="12314.013"><tspan
+           style="fill:#000000"
+           id="tspan231">Radio / Analog TV</tspan></tspan></tspan></text>
+<text
+     id="text235"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:700;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan237"
+       class="TextParagraph"
+       font-weight="700"
+       font-size="635px"><tspan
+         id="tspan239"
+         class="TextPosition"
+         x="12866.546"
+         y="8560.0127"><tspan
+           style="fill:#000000"
+           id="tspan241">Digital TV</tspan></tspan></tspan></text>
+<text
+     id="text245"
+     class="TextShape"
+     x="-8919.0537"
+     y="-1373.787"><tspan
+       style="font-weight:400;font-size:494px;font-family:'Times New Roman', serif"
+       id="tspan247"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="494px"><tspan
+         id="tspan249"
+         class="TextPosition"
+         x="5804.9458"
+         y="17793.213"><tspan
+           style="fill:#000000"
+           id="tspan251">PS.: picture is not complete: other blocks may be present</tspan></tspan></tspan></text>
+<text
+     id="text255"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan257"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan259"
+         class="TextPosition"
+         x="2109.5459"
+         y="16397.014"><tspan
+           style="fill:#000000"
+           id="tspan261">Webcam</tspan></tspan></tspan></text>
+<path
+     style="fill:#ff9900"
+     inkscape:connector-curvature="0"
+     id="path265"
+     d="m 12462.546,13925.813 -2650.0001,0 0,-1412 5299.0001,0 0,1412 -2649,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path267"
+     d="m 12462.546,13925.813 -2650.0001,0 0,-1412 5299.0001,0 0,1412 -2649,0 z" /><text
+     id="text269"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2446.187"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan271"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan273"
+         class="TextPosition"
+         x="10175.546"
+         y="13435.813"><tspan
+           style="fill:#000000"
+           id="tspan275">Processing blocks</tspan></tspan></tspan></text>
+<path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path279"
+     d="m 7872.5459,13207.813 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path281"
+     d="m 7872.5459,13207.813 385,-353 0,176 1166,0 0,-176 386,353 -386,354 0,-177 -1166,0 0,177 -385,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path285"
+     d="m 4612.5459,14790.013 397,-353 0,176 1201,0 0,-176 398,353 -398,354 0,-177 -1201,0 0,177 -397,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path287"
+     d="m 4612.5459,14790.013 397,-353 0,176 1201,0 0,-176 398,353 -398,354 0,-177 -1201,0 0,177 -397,-354 z" /><text
+     id="text291"
+     class="TextShape"
+     x="-2428.0542"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan293"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan295"
+         class="TextPosition"
+         x="20421.945"
+         y="6628.0132"><tspan
+           style="fill:#000000"
+           id="tspan297">Smartcard</tspan></tspan></tspan></text>
+<path
+     style="fill:#ffccff"
+     inkscape:connector-curvature="0"
+     id="path301"
+     d="m 623.3227,436.013 c -334.5984,0 -669.1968,333 -669.1968,666 l 0,2668 c 0,333 334.5984,666 669.1968,666 l 18456.1663,0 c 334.598,0 670.202,-333 670.202,-666 l 0,-2668 c 0,-333 -335.604,-666 -670.202,-666 l -18456.1663,0 z" /><path
+     style="fill:#ff8080"
+     inkscape:connector-curvature="0"
+     id="path305"
+     d="m 3031.5459,2991.013 -1614,0 0,-1816 3227,0 0,1816 -1613,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path307"
+     d="m 3031.5459,2991.013 -1614,0 0,-1816 3227,0 0,1816 -1613,0 z" /><text
+     style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+     id="text309"
+     class="TextShape"
+     font-weight="400"
+     font-size="635px"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       id="tspan311"
+       class="TextParagraph"><tspan
+         id="tspan313"
+         class="TextPosition"
+         x="2284.5459"
+         y="1947.0129"><tspan
+           style="fill:#000000"
+           id="tspan315">Tuner</tspan></tspan></tspan><tspan
+       id="tspan317"
+       class="TextParagraph"><tspan
+         id="tspan319"
+         class="TextPosition"
+         x="2061.5459"
+         y="2650.0129"><tspan
+           style="fill:#000000"
+           id="tspan321">FM/TV</tspan></tspan></tspan></text>
+<path
+     style="fill:#ff8080"
+     inkscape:connector-curvature="0"
+     id="path325"
+     d="m 812.5459,1538.013 c 0,111 40,202 88,202 l 530,0 c 48,0 89,-91 89,-202 0,-110 -41,-202 -89,-202 l -530,0 c -48,0 -88,92 -88,202 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path327"
+     d="m 812.5459,1538.013 c 0,111 40,202 88,202 l 530,0 c 48,0 89,-91 89,-202 0,-110 -41,-202 -89,-202 l -530,0 c -48,0 -88,92 -88,202 z" /><path
+     style="fill:#ffb3b3"
+     inkscape:connector-curvature="0"
+     id="path329"
+     d="m 812.5459,1538.013 c 0,111 40,202 88,202 48,0 88,-91 88,-202 0,-110 -40,-202 -88,-202 -48,0 -88,92 -88,202 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path331"
+     d="m 812.5459,1538.013 c 0,111 40,202 88,202 48,0 88,-91 88,-202 0,-110 -40,-202 -88,-202 -48,0 -88,92 -88,202 z" /><path
+     style="fill:#ff8080"
+     inkscape:connector-curvature="0"
+     id="path335"
+     d="m 813.5459,2103.013 c 0,110 40,202 88,202 l 530,0 c 48,0 89,-92 89,-202 0,-110 -41,-203 -89,-203 l -530,0 c -48,0 -88,93 -88,203 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path337"
+     d="m 813.5459,2103.013 c 0,110 40,202 88,202 l 530,0 c 48,0 89,-92 89,-202 0,-110 -41,-203 -89,-203 l -530,0 c -48,0 -88,93 -88,203 z" /><path
+     style="fill:#ffb3b3"
+     inkscape:connector-curvature="0"
+     id="path339"
+     d="m 813.5459,2103.013 c 0,110 40,202 88,202 48,0 88,-92 88,-202 0,-110 -40,-203 -88,-203 -48,0 -88,93 -88,203 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path341"
+     d="m 813.5459,2103.013 c 0,110 40,202 88,202 48,0 88,-92 88,-202 0,-110 -40,-203 -88,-203 -48,0 -88,93 -88,203 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path345"
+     d="m 4629.5459,2032.013 385,-353 0,176 1167,0 0,-176 386,353 -386,354 0,-177 -1167,0 0,177 -385,-354 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path347"
+     d="m 4629.5459,2032.013 385,-353 0,176 1167,0 0,-176 386,353 -386,354 0,-177 -1167,0 0,177 -385,-354 z" /><path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path351"
+     d="m 7889.5459,1986.013 402,-368 0,184 1217,0 0,-184 403,368 -403,369 0,-185 -1217,0 0,185 -402,-369 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path353"
+     d="m 7889.5459,1986.013 402,-368 0,184 1217,0 0,-184 403,368 -403,369 0,-185 -1217,0 0,185 -402,-369 z" /><path
+     style="fill:#ccffff"
+     inkscape:connector-curvature="0"
+     id="path357"
+     d="m 14410.546,4025.013 -4500.0001,0 0,-1389 9000.0001,0 0,1389 -4500,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path359"
+     d="m 14410.546,4025.013 -4500.0001,0 0,-1389 9000.0001,0 0,1389 -4500,0 z" /><text
+     id="text361"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan363"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan365"
+         class="TextPosition"
+         x="9961.5459"
+         y="3546.0129"><tspan
+           style="fill:#000000"
+           id="tspan367">Satellite Equipment Control (SEC)</tspan></tspan></tspan></text>
+<path
+     style="fill:#ccffff"
+     inkscape:connector-curvature="0"
+     id="path371"
+     d="m 11310.546,2436.013 -1400.0001,0 0,-1000 2800.0001,0 0,1000 -1400,0 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path373"
+     d="m 11310.546,2436.013 -1400.0001,0 0,-1000 2800.0001,0 0,1000 -1400,0 z" /><text
+     id="text375"
+     class="TextShape"
+     x="-2089.4541"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan377"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan379"
+         class="TextPosition"
+         x="10375.546"
+         y="2152.0129"><tspan
+           style="fill:#000000"
+           id="tspan381">Demod</tspan></tspan></tspan></text>
+<path
+     style="fill:#729fcf"
+     inkscape:connector-curvature="0"
+     id="path385"
+     d="m 7889.5459,3287.013 402,-368 0,184 1217,0 0,-184 403,368 -403,369 0,-185 -1217,0 0,185 -402,-369 z" /><path
+     style="fill:none;stroke:#3465af"
+     inkscape:connector-curvature="0"
+     id="path387"
+     d="m 7889.5459,3287.013 402,-368 0,184 1217,0 0,-184 403,368 -403,369 0,-185 -1217,0 0,185 -402,-369 z" /><path
+     d="m 7906.5459,9121.013 0,7302 -1270,0 0,-14605 1270,0 0,7303 z"
+     id="path389"
+     inkscape:connector-curvature="0"
+     style="fill:#ffff99" /><path
+     d="m 7906.5459,9121.013 0,7302 -1270,0 0,-14605 1270,0 0,7303 z"
+     id="path391"
+     inkscape:connector-curvature="0"
+     style="fill:none;stroke:#3465af" /><text
+     y="-6589.021"
+     x="-20792.584"
+     transform="matrix(0,-1,1,0,0,0)"
+     class="TextShape"
+     id="text393"><tspan
+       font-size="635px"
+       font-weight="400"
+       class="TextParagraph"
+       id="tspan395"
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"><tspan
+         y="7460.9849"
+         x="-11215.646"
+         class="TextPosition"
+         transform="matrix(0,-1,1,0,-4473,23627)"
+         id="tspan397"><tspan
+           id="tspan399"
+           style="fill:#000000">I2C Bus (control bus)</tspan></tspan></tspan></text>
+<text
+     id="text403"
+     class="TextShape"
+     x="-2145.854"
+     y="-2163.9871"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan405"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan407"
+         class="TextPosition"
+         x="7245.146"
+         y="1114.0129"><tspan
+           style="fill:#000000"
+           id="tspan409">Digital TV Frontend</tspan></tspan></tspan></text>
+<path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 863.1459,636.145 c -18.27,0 -35.525,0.99994 -53.795,2.99982"
+     id="path415"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 776.8709,644.14452 c -17.255,2.99982 -35.525,6.99958 -52.78,11.99928"
+     id="path417"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 692.6259,666.1432 c -16.24,5.99964 -33.495,11.99928 -49.735,19.9988"
+     id="path419"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 613.4559,700.14116 c -15.225,7.99952 -31.465,16.99898 -46.69,26.99838"
+     id="path421"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 539.3609,745.13846 c -14.21,9.9994 -28.42,20.99874 -42.63,31.99808"
+     id="path423"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 471.3559,798.13528 c -13.195,11.99928 -26.39,23.99856 -38.57,36.99778"
+     id="path425"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 410.4559,859.13162 c -11.165,12.99922 -22.33,26.99838 -33.495,40.99754"
+     id="path427"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 357.6759,927.12754 c -10.15,13.99916 -19.285,28.99826 -28.42,44.9973"
+     id="path429"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 314.0309,1000.1232 c -8.12,15.999 -15.225,31.998 -22.33,48.997"
+     id="path431"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 280.5359,1079.1184 c -5.075,16.999 -10.15,33.998 -14.21,50.997"
+     id="path433"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 260.2359,1162.1134 c -3.045,17.999 -5.075,34.9979 -6.09,52.9969"
+     id="path435"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1247.1083 0,52.9969"
+     id="path437"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1333.1032 0,52.9968"
+     id="path439"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1418.0981 0,52.9968"
+     id="path441"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1504.0929 0,52.9968"
+     id="path443"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1589.0878 0,52.9968"
+     id="path445"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1675.0827 0,52.9968"
+     id="path447"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1760.0776 0,52.9968"
+     id="path449"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1845.0725 0,53.9967"
+     id="path451"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,1931.0673 0,52.9968"
+     id="path453"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2016.0622 0,52.9968"
+     id="path455"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2102.057 0,52.9969"
+     id="path457"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2187.0519 0,52.9969"
+     id="path459"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2273.0468 0,52.9968"
+     id="path461"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2358.0417 0,52.9968"
+     id="path463"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2443.0366 0,53.9967"
+     id="path465"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2529.0314 0,52.9968"
+     id="path467"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2614.0263 0,52.9968"
+     id="path469"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2700.0212 0,52.9968"
+     id="path471"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2785.0161 0,52.9968"
+     id="path473"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2871.0109 0,52.9968"
+     id="path475"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,2956.0058 0,52.9968"
+     id="path477"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,3041.0007 0,53.9968"
+     id="path479"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,3126.9955 0,52.9969"
+     id="path481"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,3211.9904 0,52.9969"
+     id="path483"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,3297.9853 0,52.9968"
+     id="path485"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,3382.9802 0,52.9968"
+     id="path487"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,3468.975 0,52.9968"
+     id="path489"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,3553.9699 0,52.9968"
+     id="path491"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 254.1459,3638.9648 c 0,17.9989 1.015,35.9979 3.045,52.9968"
+     id="path493"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 262.2659,3723.9597 c 4.06,17.9989 8.12,34.9979 13.195,51.9969"
+     id="path495"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 285.6109,3806.9547 c 6.09,15.9991 13.195,32.9981 20.3,48.9971"
+     id="path497"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 321.1359,3884.9501 c 8.12,14.9991 17.255,30.9981 27.405,45.9972"
+     id="path499"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 366.8109,3957.9457 c 10.15,13.9991 21.315,27.9983 32.48,41.9975"
+     id="path501"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 420.6059,4023.9417 c 12.18,12.9992 25.375,25.9985 38.57,37.9977"
+     id="path503"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 483.5359,4083.9381 c 13.195,10.9994 27.405,22.9986 41.615,32.998"
+     id="path505"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 552.5559,4135.935 c 14.21,9.9994 29.435,18.9989 45.675,26.9984"
+     id="path507"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 627.6659,4178.9324 c 15.225,6.9996 32.48,14.9991 48.72,20.9988"
+     id="path509"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 707.8509,4210.9305 c 17.255,4.9997 34.51,9.9994 51.765,13.9992"
+     id="path511"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 792.0959,4230.9293 c 17.255,1.9999 35.525,3.9998 53.795,4.9997"
+     id="path513"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 878.3709,4235.929 53.795,0"
+     id="path515"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 964.6459,4235.929 53.795,0"
+     id="path517"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1051.9359,4235.929 53.795,0"
+     id="path519"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1138.2109,4235.929 53.795,0"
+     id="path521"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1225.5009,4235.929 53.795,0"
+     id="path523"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1311.7759,4235.929 53.795,0"
+     id="path525"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1398.0509,4235.929 54.81,0"
+     id="path527"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1485.3409,4235.929 53.795,0"
+     id="path529"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1571.6159,4235.929 53.795,0"
+     id="path531"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1658.9059,4235.929 53.795,0"
+     id="path533"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1745.1809,4235.929 53.795,0"
+     id="path535"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1832.4709,4235.929 53.795,0"
+     id="path537"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1918.7459,4235.929 53.795,0"
+     id="path539"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2005.0209,4235.929 54.81,0"
+     id="path541"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2092.3109,4235.929 53.795,0"
+     id="path543"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2178.5859,4235.929 53.795,0"
+     id="path545"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2265.8759,4235.929 53.795,0"
+     id="path547"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2352.1509,4235.929 53.795,0"
+     id="path549"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2439.4409,4235.929 53.795,0"
+     id="path551"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2525.7159,4235.929 53.795,0"
+     id="path553"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2611.9909,4235.929 54.81,0"
+     id="path555"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2699.2809,4235.929 53.795,0"
+     id="path557"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2785.5559,4235.929 53.795,0"
+     id="path559"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2872.8459,4235.929 53.795,0"
+     id="path561"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2959.1209,4235.929 53.795,0"
+     id="path563"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3046.4109,4235.929 53.795,0"
+     id="path565"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3132.6859,4235.929 53.795,0"
+     id="path567"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3219.9759,4235.929 53.795,0"
+     id="path569"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3306.2509,4235.929 53.795,0"
+     id="path571"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3392.5259,4235.929 53.795,0"
+     id="path573"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3479.8159,4235.929 53.795,0"
+     id="path575"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3566.0909,4235.929 53.795,0"
+     id="path577"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3653.3809,4235.929 53.795,0"
+     id="path579"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3739.6559,4235.929 53.795,0"
+     id="path581"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3826.9459,4235.929 53.795,0"
+     id="path583"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3913.2209,4235.929 53.795,0"
+     id="path585"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3999.4959,4235.929 53.795,0"
+     id="path587"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4086.7859,4235.929 53.795,0"
+     id="path589"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4173.0609,4235.929 53.795,0"
+     id="path591"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4260.3509,4235.929 53.795,0"
+     id="path593"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4346.6259,4235.929 53.795,0"
+     id="path595"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4433.9159,4235.929 53.795,0"
+     id="path597"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4520.1909,4235.929 53.795,0"
+     id="path599"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4606.4659,4235.929 54.81,0"
+     id="path601"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4693.7559,4235.929 53.795,0"
+     id="path603"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4780.0309,4235.929 53.795,0"
+     id="path605"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4867.3209,4235.929 53.795,0"
+     id="path607"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4953.5959,4235.929 53.795,0"
+     id="path609"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5040.8859,4235.929 53.795,0"
+     id="path611"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5127.1609,4235.929 53.795,0"
+     id="path613"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5213.4359,4235.929 54.81,0"
+     id="path615"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5300.7259,4235.929 53.795,0"
+     id="path617"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5387.0009,4235.929 53.795,0"
+     id="path619"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5474.2909,4235.929 53.795,0"
+     id="path621"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5560.5659,4235.929 53.795,0"
+     id="path623"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5647.8559,4235.929 53.795,0"
+     id="path625"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5734.1309,4235.929 53.795,0"
+     id="path627"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5820.4059,4235.929 54.81,0"
+     id="path629"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5907.6959,4235.929 53.795,0"
+     id="path631"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5993.9709,4235.929 53.795,0"
+     id="path633"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6081.2609,4235.929 53.795,0"
+     id="path635"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6167.5359,4235.929 53.795,0"
+     id="path637"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6254.8259,4235.929 53.795,0"
+     id="path639"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6341.1009,4235.929 53.795,0"
+     id="path641"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6427.3759,4235.929 54.81,0"
+     id="path643"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6514.6659,4235.929 53.795,0"
+     id="path645"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6600.9409,4235.929 53.795,0"
+     id="path647"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6688.2309,4235.929 53.795,0"
+     id="path649"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6774.5059,4235.929 53.795,0"
+     id="path651"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6861.7959,4235.929 53.795,0"
+     id="path653"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6948.0709,4235.929 53.795,0"
+     id="path655"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7035.3609,4235.929 53.795,0"
+     id="path657"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7121.6359,4235.929 53.795,0"
+     id="path659"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7207.9109,4235.929 53.795,0"
+     id="path661"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7295.2009,4235.929 53.795,0"
+     id="path663"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7381.4759,4235.929 53.795,0"
+     id="path665"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7468.7659,4235.929 53.795,0"
+     id="path667"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7555.0409,4235.929 53.795,0"
+     id="path669"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7642.3309,4235.929 53.795,0"
+     id="path671"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7728.6059,4235.929 53.795,0"
+     id="path673"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7814.8809,4235.929 53.795,0"
+     id="path675"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7902.1709,4235.929 53.795,0"
+     id="path677"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7988.4459,4235.929 53.795,0"
+     id="path679"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8075.7359,4235.929 53.795,0"
+     id="path681"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8162.0109,4235.929 53.795,0"
+     id="path683"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8249.3009,4235.929 53.795,0"
+     id="path685"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8335.5759,4235.929 53.795,0"
+     id="path687"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8421.8509,4235.929 53.795,0"
+     id="path689"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8509.1409,4235.929 53.795,0"
+     id="path691"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8595.4159,4235.929 53.795,0"
+     id="path693"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8682.7059,4235.929 53.795,0"
+     id="path695"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8768.9809,4235.929 53.795,0"
+     id="path697"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8856.2709,4235.929 53.795,0"
+     id="path699"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8942.5459,4235.929 53.795,0"
+     id="path701"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9028.8209,4235.929 54.81,0"
+     id="path703"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9116.1109,4235.929 53.795,0"
+     id="path705"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9202.3859,4235.929 53.795,0"
+     id="path707"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9289.6759,4235.929 53.795,0"
+     id="path709"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9375.9509,4235.929 53.795,0"
+     id="path711"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9463.2409,4235.929 53.795,0"
+     id="path713"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9549.5159,4235.929 53.795,0"
+     id="path715"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9635.7909,4235.929 54.81,0"
+     id="path717"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9723.0809,4235.929 53.795,0"
+     id="path719"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9809.3559,4235.929 53.795,0"
+     id="path721"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9896.6459,4235.929 53.795,0"
+     id="path723"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9982.9209,4235.929 53.7951,0"
+     id="path725"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10070.211,4235.929 53.795,0"
+     id="path727"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10156.486,4235.929 53.795,0"
+     id="path729"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10242.761,4235.929 54.81,0"
+     id="path731"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10330.051,4235.929 53.795,0"
+     id="path733"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10416.326,4235.929 53.795,0"
+     id="path735"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10503.616,4235.929 53.795,0"
+     id="path737"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10589.891,4235.929 53.795,0"
+     id="path739"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10677.181,4235.929 53.795,0"
+     id="path741"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10763.456,4235.929 53.795,0"
+     id="path743"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10849.731,4235.929 54.81,0"
+     id="path745"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10937.021,4235.929 53.795,0"
+     id="path747"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11023.296,4235.929 53.795,0"
+     id="path749"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11110.586,4235.929 53.795,0"
+     id="path751"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11196.861,4235.929 53.795,0"
+     id="path753"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11284.151,4235.929 53.795,0"
+     id="path755"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11370.426,4235.929 53.795,0"
+     id="path757"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11457.716,4235.929 53.795,0"
+     id="path759"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11543.991,4235.929 53.795,0"
+     id="path761"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11630.266,4235.929 53.795,0"
+     id="path763"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11717.556,4235.929 53.795,0"
+     id="path765"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11803.831,4235.929 53.795,0"
+     id="path767"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11891.121,4235.929 53.795,0"
+     id="path769"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11977.396,4235.929 53.795,0"
+     id="path771"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12064.686,4235.929 53.795,0"
+     id="path773"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12150.961,4235.929 53.795,0"
+     id="path775"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12237.236,4235.929 53.795,0"
+     id="path777"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12324.526,4235.929 53.795,0"
+     id="path779"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12410.801,4235.929 53.795,0"
+     id="path781"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12498.091,4235.929 53.795,0"
+     id="path783"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12584.366,4235.929 53.795,0"
+     id="path785"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12671.656,4235.929 53.795,0"
+     id="path787"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12757.931,4235.929 53.795,0"
+     id="path789"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12844.206,4235.929 54.81,0"
+     id="path791"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12931.496,4235.929 53.795,0"
+     id="path793"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13017.771,4235.929 53.795,0"
+     id="path795"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13105.061,4235.929 53.795,0"
+     id="path797"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13191.336,4235.929 53.795,0"
+     id="path799"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13278.626,4235.929 53.795,0"
+     id="path801"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13364.901,4235.929 53.795,0"
+     id="path803"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13451.176,4235.929 54.81,0"
+     id="path805"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13538.466,4235.929 53.795,0"
+     id="path807"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13624.741,4235.929 53.795,0"
+     id="path809"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13712.031,4235.929 53.795,0"
+     id="path811"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13798.306,4235.929 53.795,0"
+     id="path813"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13885.596,4235.929 53.795,0"
+     id="path815"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13971.871,4235.929 53.795,0"
+     id="path817"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14058.146,4235.929 54.81,0"
+     id="path819"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14145.436,4235.929 53.795,0"
+     id="path821"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14231.711,4235.929 53.795,0"
+     id="path823"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14319.001,4235.929 53.795,0"
+     id="path825"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14405.276,4235.929 53.795,0"
+     id="path827"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14492.566,4235.929 53.795,0"
+     id="path829"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14578.841,4235.929 53.795,0"
+     id="path831"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14665.116,4235.929 54.81,0"
+     id="path833"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14752.406,4235.929 53.795,0"
+     id="path835"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14838.681,4235.929 53.795,0"
+     id="path837"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14925.971,4235.929 53.795,0"
+     id="path839"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15012.246,4235.929 53.795,0"
+     id="path841"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15099.536,4235.929 53.795,0"
+     id="path843"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15185.811,4235.929 53.795,0"
+     id="path845"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15272.086,4235.929 54.81,0"
+     id="path847"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15359.376,4235.929 53.795,0"
+     id="path849"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15445.651,4235.929 53.795,0"
+     id="path851"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15532.941,4235.929 53.795,0"
+     id="path853"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15619.216,4235.929 53.795,0"
+     id="path855"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15706.506,4235.929 53.795,0"
+     id="path857"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15792.781,4235.929 53.795,0"
+     id="path859"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15880.071,4235.929 53.795,0"
+     id="path861"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15966.346,4235.929 53.795,0"
+     id="path863"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16052.621,4235.929 53.795,0"
+     id="path865"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16139.911,4235.929 53.795,0"
+     id="path867"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16226.186,4235.929 53.795,0"
+     id="path869"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16313.476,4235.929 53.795,0"
+     id="path871"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16399.751,4235.929 53.795,0"
+     id="path873"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16487.041,4235.929 53.795,0"
+     id="path875"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16573.316,4235.929 53.795,0"
+     id="path877"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16659.591,4235.929 53.795,0"
+     id="path879"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16746.881,4235.929 53.795,0"
+     id="path881"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16833.156,4235.929 53.795,0"
+     id="path883"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16920.446,4235.929 53.795,0"
+     id="path885"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17006.721,4235.929 53.795,0"
+     id="path887"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17094.011,4235.929 53.795,0"
+     id="path889"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17180.286,4235.929 53.795,0"
+     id="path891"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17266.561,4235.929 54.81,0"
+     id="path893"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17353.851,4235.929 53.795,0"
+     id="path895"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17440.126,4235.929 53.795,0"
+     id="path897"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17527.416,4235.929 53.795,0"
+     id="path899"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17613.691,4235.929 53.795,0"
+     id="path901"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17700.981,4235.929 53.795,0"
+     id="path903"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17787.256,4235.929 53.795,0"
+     id="path905"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17873.531,4235.929 54.81,0"
+     id="path907"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17960.821,4235.929 53.795,0"
+     id="path909"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18047.096,4235.929 53.795,0"
+     id="path911"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18134.386,4235.929 53.795,0"
+     id="path913"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18220.661,4235.929 53.795,0"
+     id="path915"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18307.951,4235.929 53.795,0"
+     id="path917"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18394.226,4235.929 53.795,0"
+     id="path919"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18480.501,4235.929 54.81,0"
+     id="path921"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18567.791,4235.929 53.795,0"
+     id="path923"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18654.066,4235.929 53.795,0"
+     id="path925"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18741.356,4235.929 c 17.255,-0.9999 35.525,-1.9999 53.795,-4.9997"
+     id="path927"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18827.631,4225.9296 c 17.255,-3.9998 34.51,-8.9995 51.765,-13.9992"
+     id="path929"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18910.861,4200.9311 c 16.24,-5.9996 32.48,-12.9992 48.72,-20.9987"
+     id="path931"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18989.016,4164.9333 c 15.225,-7.9996 31.465,-16.999 45.675,-26.9984"
+     id="path933"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19062.096,4118.936 c 14.21,-9.9994 28.42,-20.9987 42.63,-31.9981"
+     id="path935"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19129.086,4064.9393 c 13.195,-11.9993 25.375,-24.9985 37.555,-37.9978"
+     id="path937"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19188.971,4002.943 c 11.165,-13.9992 22.33,-27.9983 33.495,-41.9975"
+     id="path939"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19240.736,3933.9471 c 10.15,-14.9991 19.285,-29.9982 27.405,-44.9973"
+     id="path941"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19283.366,3859.9516 c 7.105,-15.9991 14.21,-32.9981 20.3,-48.9971"
+     id="path943"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19314.831,3779.9564 c 5.075,-16.999 9.135,-33.998 13.195,-50.997"
+     id="path945"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19333.101,3696.9613 c 2.03,-17.9989 4.06,-34.9979 4.06,-52.9968"
+     id="path947"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,3611.9664 0,-53.9967"
+     id="path949"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,3525.9716 0,-52.9968"
+     id="path951"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,3440.9767 0,-52.9968"
+     id="path953"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,3354.9819 0,-52.9969"
+     id="path955"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,3269.987 0,-52.9969"
+     id="path957"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,3183.9921 0,-52.9968"
+     id="path959"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,3098.9972 0,-52.9968"
+     id="path961"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,3014.0023 0,-53.9967"
+     id="path963"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2928.0075 0,-52.9968"
+     id="path965"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2843.0126 0,-52.9968"
+     id="path967"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2757.0177 0,-52.9968"
+     id="path969"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2672.0228 0,-52.9968"
+     id="path971"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2586.028 0,-52.9968"
+     id="path973"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2501.0331 0,-52.9968"
+     id="path975"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2415.0383 0,-52.9969"
+     id="path977"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2330.0434 0,-52.9969"
+     id="path979"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2245.0485 0,-52.9969"
+     id="path981"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2159.0536 0,-52.9968"
+     id="path983"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,2074.0587 0,-52.9968"
+     id="path985"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1988.0639 0,-52.9968"
+     id="path987"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1903.069 0,-52.9968"
+     id="path989"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1817.0741 0,-52.9968"
+     id="path991"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1732.0792 0,-52.9968"
+     id="path993"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1647.0843 0,-52.9968"
+     id="path995"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1561.0895 0,-52.9968"
+     id="path997"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1476.0946 0,-52.9968"
+     id="path999"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1390.0998 0,-52.9969"
+     id="path1001"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1305.1049 0,-52.9969"
+     id="path1003"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19337.161,1219.11 c -1.015,-16.999 -3.045,-34.9979 -5.075,-51.9969"
+     id="path1005"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19325.996,1135.1151 c -4.06,-16.999 -8.12,-34.9979 -14.21,-50.997"
+     id="path1007"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19300.621,1053.12 c -6.09,-15.9991 -13.195,-32.998 -21.315,-48.9971"
+     id="path1009"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19264.081,976.1246 c -9.135,-15.99904 -18.27,-30.99814 -28.42,-45.99724"
+     id="path1011"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19216.376,904.12892 c -10.15,-13.99916 -21.315,-27.99832 -33.495,-41.99748"
+     id="path1013"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19160.551,838.13288 c -12.18,-12.99922 -24.36,-24.9985 -37.555,-36.99778"
+     id="path1015"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19097.621,780.13636 c -14.21,-11.99928 -28.42,-21.99868 -42.63,-32.99802"
+     id="path1017"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 19027.586,729.13942 c -15.225,-8.99946 -30.45,-17.99892 -46.69,-26.99838"
+     id="path1019"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18951.461,688.14188 c -16.24,-7.99952 -32.48,-13.99916 -49.735,-19.9988"
+     id="path1021"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18870.261,657.14374 c -17.255,-4.9997 -34.51,-8.99946 -51.765,-11.99928"
+     id="path1023"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18786.016,640.14476 c -18.27,-2.99982 -35.525,-3.99976 -53.795,-3.99976"
+     id="path1025"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18699.741,636.145 -53.795,0"
+     id="path1027"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18612.451,636.145 -53.795,0"
+     id="path1029"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18526.176,636.145 -53.795,0"
+     id="path1031"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18438.886,636.145 -53.795,0"
+     id="path1033"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18352.611,636.145 -53.795,0"
+     id="path1035"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18266.336,636.145 -54.81,0"
+     id="path1037"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18179.046,636.145 -53.795,0"
+     id="path1039"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18092.771,636.145 -53.795,0"
+     id="path1041"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 18005.481,636.145 -53.795,0"
+     id="path1043"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17919.206,636.145 -53.795,0"
+     id="path1045"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17831.916,636.145 -53.795,0"
+     id="path1047"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17745.641,636.145 -53.795,0"
+     id="path1049"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17659.366,636.145 -54.81,0"
+     id="path1051"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17572.076,636.145 -53.795,0"
+     id="path1053"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17485.801,636.145 -53.795,0"
+     id="path1055"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17398.511,636.145 -53.795,0"
+     id="path1057"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17312.236,636.145 -53.795,0"
+     id="path1059"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17224.946,636.145 -53.795,0"
+     id="path1061"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17138.671,636.145 -53.795,0"
+     id="path1063"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 17052.396,636.145 -54.81,0"
+     id="path1065"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16965.106,636.145 -53.795,0"
+     id="path1067"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16878.831,636.145 -53.795,0"
+     id="path1069"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16791.541,636.145 -53.795,0"
+     id="path1071"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16705.266,636.145 -53.795,0"
+     id="path1073"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16617.976,636.145 -53.795,0"
+     id="path1075"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16531.701,636.145 -53.795,0"
+     id="path1077"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16445.426,636.145 -54.81,0"
+     id="path1079"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16358.136,636.145 -53.795,0"
+     id="path1081"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16271.861,636.145 -53.795,0"
+     id="path1083"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16184.571,636.145 -53.795,0"
+     id="path1085"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16098.296,636.145 -53.795,0"
+     id="path1087"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 16011.006,636.145 -53.795,0"
+     id="path1089"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15924.731,636.145 -53.795,0"
+     id="path1091"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15837.441,636.145 -53.795,0"
+     id="path1093"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15751.166,636.145 -53.795,0"
+     id="path1095"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15664.891,636.145 -53.795,0"
+     id="path1097"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15577.601,636.145 -53.795,0"
+     id="path1099"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15491.326,636.145 -53.795,0"
+     id="path1101"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15404.036,636.145 -53.795,0"
+     id="path1103"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15317.761,636.145 -53.795,0"
+     id="path1105"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15230.471,636.145 -53.795,0"
+     id="path1107"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15144.196,636.145 -53.795,0"
+     id="path1109"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 15057.921,636.145 -53.795,0"
+     id="path1111"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14970.631,636.145 -53.795,0"
+     id="path1113"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14884.356,636.145 -53.795,0"
+     id="path1115"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14797.066,636.145 -53.795,0"
+     id="path1117"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14710.791,636.145 -53.795,0"
+     id="path1119"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14623.501,636.145 -53.795,0"
+     id="path1121"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14537.226,636.145 -53.795,0"
+     id="path1123"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14450.951,636.145 -54.81,0"
+     id="path1125"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14363.661,636.145 -53.795,0"
+     id="path1127"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14277.386,636.145 -53.795,0"
+     id="path1129"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14190.096,636.145 -53.795,0"
+     id="path1131"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14103.821,636.145 -53.795,0"
+     id="path1133"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 14016.531,636.145 -53.795,0"
+     id="path1135"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13930.256,636.145 -53.795,0"
+     id="path1137"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13843.981,636.145 -54.81,0"
+     id="path1139"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13756.691,636.145 -53.795,0"
+     id="path1141"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13670.416,636.145 -53.795,0"
+     id="path1143"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13583.126,636.145 -53.795,0"
+     id="path1145"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13496.851,636.145 -53.795,0"
+     id="path1147"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13409.561,636.145 -53.795,0"
+     id="path1149"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13323.286,636.145 -53.795,0"
+     id="path1151"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13237.011,636.145 -54.81,0"
+     id="path1153"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13149.721,636.145 -53.795,0"
+     id="path1155"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 13063.446,636.145 -53.795,0"
+     id="path1157"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12976.156,636.145 -53.795,0"
+     id="path1159"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12889.881,636.145 -53.795,0"
+     id="path1161"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12802.591,636.145 -53.795,0"
+     id="path1163"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12716.316,636.145 -53.795,0"
+     id="path1165"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12630.041,636.145 -54.81,0"
+     id="path1167"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12542.751,636.145 -53.795,0"
+     id="path1169"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12456.476,636.145 -53.795,0"
+     id="path1171"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12369.186,636.145 -53.795,0"
+     id="path1173"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12282.911,636.145 -53.795,0"
+     id="path1175"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12195.621,636.145 -53.795,0"
+     id="path1177"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12109.346,636.145 -53.795,0"
+     id="path1179"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 12022.056,636.145 -53.795,0"
+     id="path1181"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11935.781,636.145 -53.795,0"
+     id="path1183"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11849.506,636.145 -53.795,0"
+     id="path1185"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11762.216,636.145 -53.795,0"
+     id="path1187"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11675.941,636.145 -53.795,0"
+     id="path1189"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11588.651,636.145 -53.795,0"
+     id="path1191"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11502.376,636.145 -53.795,0"
+     id="path1193"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11415.086,636.145 -53.795,0"
+     id="path1195"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11328.811,636.145 -53.795,0"
+     id="path1197"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11242.536,636.145 -53.795,0"
+     id="path1199"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11155.246,636.145 -53.795,0"
+     id="path1201"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 11068.971,636.145 -53.795,0"
+     id="path1203"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10981.681,636.145 -53.795,0"
+     id="path1205"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10895.406,636.145 -53.795,0"
+     id="path1207"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10808.116,636.145 -53.795,0"
+     id="path1209"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10721.841,636.145 -53.795,0"
+     id="path1211"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10635.566,636.145 -53.795,0"
+     id="path1213"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10548.276,636.145 -53.795,0"
+     id="path1215"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10462.001,636.145 -53.795,0"
+     id="path1217"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10374.711,636.145 -53.795,0"
+     id="path1219"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10288.436,636.145 -53.795,0"
+     id="path1221"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10201.146,636.145 -53.795,0"
+     id="path1223"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10114.871,636.145 -53.795,0"
+     id="path1225"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 10028.596,636.145 -54.8101,0"
+     id="path1227"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9941.3059,636.145 -53.795,0"
+     id="path1229"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9855.0309,636.145 -53.795,0"
+     id="path1231"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9767.7409,636.145 -53.795,0"
+     id="path1233"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9681.4659,636.145 -53.795,0"
+     id="path1235"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9594.1759,636.145 -53.795,0"
+     id="path1237"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9507.9009,636.145 -53.795,0"
+     id="path1239"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9421.6259,636.145 -54.81,0"
+     id="path1241"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9334.3359,636.145 -53.795,0"
+     id="path1243"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9248.0609,636.145 -53.795,0"
+     id="path1245"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9160.7709,636.145 -53.795,0"
+     id="path1247"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 9074.4959,636.145 -53.795,0"
+     id="path1249"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8987.2059,636.145 -53.795,0"
+     id="path1251"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8900.9309,636.145 -53.795,0"
+     id="path1253"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8814.6559,636.145 -54.81,0"
+     id="path1255"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8727.3659,636.145 -53.795,0"
+     id="path1257"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8641.0909,636.145 -53.795,0"
+     id="path1259"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8553.8009,636.145 -53.795,0"
+     id="path1261"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8467.5259,636.145 -53.795,0"
+     id="path1263"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8380.2359,636.145 -53.795,0"
+     id="path1265"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8293.9609,636.145 -53.795,0"
+     id="path1267"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8207.6859,636.145 -54.81,0"
+     id="path1269"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8120.3959,636.145 -53.795,0"
+     id="path1271"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 8034.1209,636.145 -53.795,0"
+     id="path1273"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7946.8309,636.145 -53.795,0"
+     id="path1275"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7860.5559,636.145 -53.795,0"
+     id="path1277"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7773.2659,636.145 -53.795,0"
+     id="path1279"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7686.9909,636.145 -53.795,0"
+     id="path1281"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7599.7009,636.145 -53.795,0"
+     id="path1283"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7513.4259,636.145 -53.795,0"
+     id="path1285"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7427.1509,636.145 -53.795,0"
+     id="path1287"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7339.8609,636.145 -53.795,0"
+     id="path1289"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7253.5859,636.145 -53.795,0"
+     id="path1291"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7166.2959,636.145 -53.795,0"
+     id="path1293"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 7080.0209,636.145 -53.795,0"
+     id="path1295"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6992.7309,636.145 -53.795,0"
+     id="path1297"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6906.4559,636.145 -53.795,0"
+     id="path1299"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6820.1809,636.145 -53.795,0"
+     id="path1301"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6732.8909,636.145 -53.795,0"
+     id="path1303"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6646.6159,636.145 -53.795,0"
+     id="path1305"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6559.3259,636.145 -53.795,0"
+     id="path1307"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6473.0509,636.145 -53.795,0"
+     id="path1309"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6385.7609,636.145 -53.795,0"
+     id="path1311"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6299.4859,636.145 -53.795,0"
+     id="path1313"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6213.2109,636.145 -54.81,0"
+     id="path1315"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6125.9209,636.145 -53.795,0"
+     id="path1317"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 6039.6459,636.145 -53.795,0"
+     id="path1319"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5952.3559,636.145 -53.795,0"
+     id="path1321"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5866.0809,636.145 -53.795,0"
+     id="path1323"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5778.7909,636.145 -53.795,0"
+     id="path1325"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5692.5159,636.145 -53.795,0"
+     id="path1327"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5606.2409,636.145 -54.81,0"
+     id="path1329"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5518.9509,636.145 -53.795,0"
+     id="path1331"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5432.6759,636.145 -53.795,0"
+     id="path1333"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5345.3859,636.145 -53.795,0"
+     id="path1335"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5259.1109,636.145 -53.795,0"
+     id="path1337"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5171.8209,636.145 -53.795,0"
+     id="path1339"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 5085.5459,636.145 -53.795,0"
+     id="path1341"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4999.2709,636.145 -54.81,0"
+     id="path1343"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4911.9809,636.145 -53.795,0"
+     id="path1345"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4825.7059,636.145 -53.795,0"
+     id="path1347"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4738.4159,636.145 -53.795,0"
+     id="path1349"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4652.1409,636.145 -53.795,0"
+     id="path1351"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4564.8509,636.145 -53.795,0"
+     id="path1353"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4478.5759,636.145 -53.795,0"
+     id="path1355"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4392.3009,636.145 -54.81,0"
+     id="path1357"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4305.0109,636.145 -53.795,0"
+     id="path1359"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4218.7359,636.145 -53.795,0"
+     id="path1361"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4131.4459,636.145 -53.795,0"
+     id="path1363"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 4045.1709,636.145 -53.795,0"
+     id="path1365"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3957.8809,636.145 -53.795,0"
+     id="path1367"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3871.6059,636.145 -53.795,0"
+     id="path1369"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3785.3309,636.145 -54.81,0"
+     id="path1371"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3698.0409,636.145 -53.795,0"
+     id="path1373"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3611.7659,636.145 -53.795,0"
+     id="path1375"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3524.4759,636.145 -53.795,0"
+     id="path1377"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3438.2009,636.145 -53.795,0"
+     id="path1379"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3350.9109,636.145 -53.795,0"
+     id="path1381"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3264.6359,636.145 -53.795,0"
+     id="path1383"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3177.3459,636.145 -53.795,0"
+     id="path1385"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3091.0709,636.145 -53.795,0"
+     id="path1387"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 3004.7959,636.145 -53.795,0"
+     id="path1389"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2917.5059,636.145 -53.795,0"
+     id="path1391"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2831.2309,636.145 -53.795,0"
+     id="path1393"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2743.9409,636.145 -53.795,0"
+     id="path1395"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2657.6659,636.145 -53.795,0"
+     id="path1397"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2570.3759,636.145 -53.795,0"
+     id="path1399"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2484.1009,636.145 -53.795,0"
+     id="path1401"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2397.8259,636.145 -53.795,0"
+     id="path1403"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2310.5359,636.145 -53.795,0"
+     id="path1405"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2224.2609,636.145 -53.795,0"
+     id="path1407"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2136.9709,636.145 -53.795,0"
+     id="path1409"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 2050.6959,636.145 -53.795,0"
+     id="path1411"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1963.4059,636.145 -53.795,0"
+     id="path1413"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1877.1309,636.145 -53.795,0"
+     id="path1415"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1790.8559,636.145 -54.81,0"
+     id="path1417"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1703.5659,636.145 -53.795,0"
+     id="path1419"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1617.2909,636.145 -53.795,0"
+     id="path1421"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1530.0009,636.145 -53.795,0"
+     id="path1423"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1443.7259,636.145 -53.795,0"
+     id="path1425"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1356.4359,636.145 -53.795,0"
+     id="path1427"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1270.1609,636.145 -53.795,0"
+     id="path1429"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1183.8859,636.145 -54.81,0"
+     id="path1431"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1096.5959,636.145 -53.795,0"
+     id="path1433"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 1010.3209,636.145 -53.795,0"
+     id="path1435"
+     inkscape:connector-curvature="0" /><path
+     style="fill:none;stroke:#3465af;stroke-width:28.432024"
+     d="m 923.0309,636.145 -53.795,0"
+     id="path1437"
+     inkscape:connector-curvature="0" /><g
+     id="g4044"><rect
+       height="1100.7"
+       width="1213.6"
+       y="4753.1133"
+       x="21109.146"
+       id="rect1441"
+       style="fill:#f3e777" /><path
+       d="m 20656.146,5536.413 0,-405.46 150.7,-169.16 c 82.886,-93.039 170.53,-186.62 194.77,-207.96 l 44.069,-38.798 783.23,-0.086 783.23,-0.086 0,613.5 0,613.5 -978,0 -978,0 0,-405.46 z m 1027.7,136.98 0,-78.372 -169.91,4.925 -169.91,4.9249 -5.09,45.854 c -8.249,74.303 46.711,101.04 207.69,101.04 l 137.21,0 0,-78.372 z m 235.86,-262.94 4.495,-341.31 207.2,-8.6408 207.2,-8.6408 5.144,-46.443 c 9.596,-86.615 -41.863,-102.05 -322.02,-96.607 l -246.71,4.7956 -4.438,419.08 -4.439,419.08 74.537,0 74.538,0 4.494,-341.31 z m 391.3,313.72 c 26.41,-19.286 36.255,-41.399 32.697,-73.447 l -5.09,-45.854 -174.05,0 -174.05,0 -5.38,48.984 c -9.97,90.771 0.993,97.91 150.36,97.91 99.305,0 148.27,-7.6982 175.52,-27.594 z m -627.16,-274.84 0,-77.768 -174.05,0 -174.05,0 0,66.246 c 0,36.436 4.973,71.431 11.051,77.768 6.078,6.3366 84.401,11.521 174.05,11.521 l 163,0 0,-77.768 z m 659.89,-4.9154 5.125,-74.042 -179.18,4.9155 -179.18,4.9155 -5.38,48.984 c -10.473,95.348 -2.259,99.57 183.28,94.197 l 170.2,-4.9284 5.125,-74.042 z m -659.89,-237.63 0,-78.372 -169.91,4.925 -169.91,4.925 -5.097,73.447 -5.097,73.447 175,0 175,0 0,-78.372 z m 659.86,4.925 -5.097,-73.447 -174.05,0 -174.05,0 -5.38,48.984 c -10.289,93.673 -2.146,97.91 188.15,97.91 l 175.52,0 -5.097,-73.447 z m -659.86,-228.98 0,-77.768 -137.21,0 c -97.358,0 -147.91,7.8138 -174.05,26.902 -34.952,25.523 -49.645,92.242 -25.79,117.11 6.078,6.3366 84.401,11.521 174.05,11.521 l 163,0 0,-77.768 z"
+       id="path1443"
+       inkscape:connector-curvature="0"
+       style="fill:#ca4677" /></g><text
+     style="font-size:9.10937119px;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round"
+     class="TextShape"
+     id="text1489"
+     transform="scale(1.1035537,0.9061634)"
+     x="171.41566"
+     y="9913.7109"><tspan
+       font-size="635px"
+       font-weight="400"
+       class="TextParagraph"
+       id="tspan1491"
+       style="font-weight:400;font-size:482.03753662px;font-family:'Times New Roman', serif" /></text>
+<g
+     id="g4048"><rect
+       height="2342.4341"
+       width="2320.7097"
+       y="13737.451"
+       x="18796.941"
+       id="rect1447"
+       style="fill:#6076b3" /><rect
+       id="rect1451"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="13817.405"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1453"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="14075.544"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1455"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="14334.443"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1457"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="14592.582"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1459"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="14850.721"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1461"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="15109.62"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1463"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="15367.759"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1465"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="15625.896"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1467"
+       height="137.78799"
+       x="18532.135"
+       width="302.70312"
+       y="15884.035"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1469"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="13783.14"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1471"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="14041.277"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1473"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="14299.416"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1475"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="14558.315"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1477"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="14816.454"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1479"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="15074.593"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1481"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="15333.492"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1483"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="15591.631"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><rect
+       id="rect1485"
+       height="137.78799"
+       x="21080.053"
+       width="302.70312"
+       y="15849.769"
+       style="fill:#e0ee2c;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><text
+       transform="scale(1.1035537,0.9061634)"
+       sodipodi:linespacing="125%"
+       id="text1493"
+       line-height="125%"
+       x="17205.688"
+       y="16777.641"
+       font-size="1128.9px"
+       xml:space="preserve"
+       style="font-size:856.96411133px;line-height:125%;font-family:Sans;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round"><tspan
+         id="tspan1495"
+         x="17205.688"
+         y="16777.641">CPU</tspan></text>
+</g><text
+     style="fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round"
+     id="text1499"
+     class="TextShape"
+     x="-11700.553"
+     y="565.61298"><tspan
+       style="font-weight:400;font-size:706px;font-family:'Times New Roman', serif"
+       id="tspan1501"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="706px"><tspan
+         id="tspan1503"
+         transform="matrix(0,-1,1,0,8509,40173)"
+         class="TextPosition"
+         x="12640.447"
+         y="16397.613"><tspan
+           style="fill:#000000"
+           id="tspan1505">PCI, USB, SPI, I2C, ...</tspan></tspan></tspan></text>
+<path
+     d="m 12408.066,15561.578 -1115.084,0 0,-1420.331 2230.169,0 0,1420.331 -1115.085,0 z"
+     id="path1511"
+     inkscape:connector-curvature="0"
+     style="fill:#cfe7f5;fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round" /><path
+     d="m 12408.066,15561.578 -1115.084,0 0,-1420.331 2230.169,0 0,1420.331 -1115.085,0 z"
+     id="path1513"
+     inkscape:connector-curvature="0"
+     style="fill:none;fill-rule:evenodd;stroke:#3465af;stroke-width:19.84712601;stroke-linejoin:round" /><text
+     style="fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round"
+     id="text1515"
+     class="TextShape"
+     x="-1394.0863"
+     y="590.73016"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan1517"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan1519"
+         class="TextPosition"
+         x="11487.915"
+         y="14672.743"><tspan
+           style="fill:#000000"
+           id="tspan1521">Bridge</tspan></tspan></tspan></text>
+<text
+     style="fill-rule:evenodd;stroke-width:28.22200012;stroke-linejoin:round"
+     id="text1523"
+     class="TextShape"
+     x="-1450.5308"
+     y="1324.5078"><tspan
+       style="font-weight:400;font-size:635px;font-family:'Times New Roman', serif"
+       id="tspan1525"
+       class="TextParagraph"
+       font-weight="400"
+       font-size="635px"><tspan
+         id="tspan1527"
+         class="TextPosition"
+         x="11431.471"
+         y="15406.52"><tspan
+           style="fill:#000000"
+           id="tspan1529"> DMA</tspan></tspan></tspan></text>
+</svg>
\ No newline at end of file
diff --git a/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.svg b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.svg
index 18b0f5de9ed2..1903dd3846c2 100644
--- a/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.svg
+++ b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.svg
@@ -1,63 +1,302 @@
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
-<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
-<svg width="43cm" height="10cm" viewBox="-194 128 844 196" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
-  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="-8" y="130" width="469.774" height="193"/>
-  <g>
-    <rect style="fill: #ffffff" x="4.5" y="189" width="159" height="104"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="4.5" y="189" width="159" height="104"/>
+<svg
+   xmlns:dc="http://purl.org/dc/elements/1.1/"
+   xmlns:cc="http://creativecommons.org/ns#"
+   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
+   xmlns:svg="http://www.w3.org/2000/svg"
+   xmlns="http://www.w3.org/2000/svg"
+   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
+   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
+   width="42.799767cm"
+   height="9.9348345cm"
+   viewBox="-194 128 840.06984 194.72276"
+   id="svg2"
+   version="1.1"
+   inkscape:version="0.91 r13725"
+   sodipodi:docname="subdev-image-processing-crop.svg">
+  <metadata
+     id="metadata100">
+    <rdf:RDF>
+      <cc:Work
+         rdf:about="">
+        <dc:format>image/svg+xml</dc:format>
+        <dc:type
+           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
+        <dc:title />
+      </cc:Work>
+    </rdf:RDF>
+  </metadata>
+  <defs
+     id="defs98" />
+  <sodipodi:namedview
+     pagecolor="#ffffff"
+     bordercolor="#666666"
+     borderopacity="1"
+     objecttolerance="10"
+     gridtolerance="10"
+     guidetolerance="10"
+     inkscape:pageopacity="0"
+     inkscape:pageshadow="2"
+     inkscape:window-width="1920"
+     inkscape:window-height="997"
+     id="namedview96"
+     showgrid="false"
+     fit-margin-top="0"
+     fit-margin-left="0"
+     fit-margin-right="0"
+     fit-margin-bottom="0"
+     inkscape:zoom="0.3649199"
+     inkscape:cx="764.40286"
+     inkscape:cy="176.91347"
+     inkscape:window-x="1920"
+     inkscape:window-y="30"
+     inkscape:window-maximized="1"
+     inkscape:current-layer="svg2" />
+  <rect
+     style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+     x="-9.6002426"
+     y="128.86047"
+     width="469.77399"
+     height="193"
+     id="rect4" />
+  <g
+     id="g6"
+     transform="translate(-1.6002426,-1.1395339)">
+    <rect
+       style="fill:#ffffff"
+       x="4.5"
+       y="189"
+       width="159"
+       height="104"
+       id="rect8" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#a52a2a;stroke-width:2"
+       x="4.5"
+       y="189"
+       width="159"
+       height="104"
+       id="rect10" />
   </g>
-  <g>
-    <rect style="fill: #ffffff" x="63.5" y="211" width="94" height="77"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="63.5" y="211" width="94" height="77"/>
+  <g
+     id="g12"
+     transform="translate(-1.6002426,-1.1395339)">
+    <rect
+       style="fill:#ffffff"
+       x="63.5"
+       y="211"
+       width="94"
+       height="77"
+       id="rect14" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#0000ff;stroke-width:2"
+       x="63.5"
+       y="211"
+       width="94"
+       height="77"
+       id="rect16" />
   </g>
-  <text style="fill: #0000ff;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="74.5" y="227.75">
-    <tspan x="74.5" y="227.75">sink</tspan>
-    <tspan x="74.5" y="243.75">crop</tspan>
-    <tspan x="74.5" y="259.75">selection</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#0000ff"
+     x="72.899757"
+     y="226.61047"
+     id="text18">
+    <tspan
+       x="72.899757"
+       y="226.61047"
+       id="tspan20">sink</tspan>
+    <tspan
+       x="72.899757"
+       y="242.61047"
+       id="tspan22">crop</tspan>
+    <tspan
+       x="72.899757"
+       y="258.61047"
+       id="tspan24">selection</tspan>
   </text>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="29.5" y="158">
-    <tspan x="29.5" y="158"></tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="27.899757"
+     y="156.86047"
+     id="text26">
+    <tspan
+       x="27.899757"
+       y="156.86047"
+       id="tspan28" />
   </text>
-  <text style="fill: #a52a2a;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="8.53836" y="157.914">
-    <tspan x="8.53836" y="157.914">sink media</tspan>
-    <tspan x="8.53836" y="173.914">bus format</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#a52a2a"
+     x="6.938117"
+     y="156.77448"
+     id="text30">
+    <tspan
+       x="6.938117"
+       y="156.77448"
+       id="tspan32">sink media</tspan>
+    <tspan
+       x="6.938117"
+       y="172.77448"
+       id="tspan34">bus format</tspan>
   </text>
-  <text style="fill: #8b6914;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="349.774" y="155">
-    <tspan x="349.774" y="155">source media</tspan>
-    <tspan x="349.774" y="171">bus format</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#8b6914"
+     x="348.17374"
+     y="153.86047"
+     id="text36">
+    <tspan
+       x="348.17374"
+       y="153.86047"
+       id="tspan38">source media</tspan>
+    <tspan
+       x="348.17374"
+       y="169.86047"
+       id="tspan40">bus format</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="350.488" y="190.834" width="93.2863" height="75.166"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="350.488" y="190.834" width="93.2863" height="75.166"/>
+  <g
+     id="g42"
+     transform="translate(-1.6002426,-1.1395339)">
+    <rect
+       style="fill:#ffffff"
+       x="350.48801"
+       y="190.834"
+       width="93.286301"
+       height="75.166"
+       id="rect44" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#8b6914;stroke-width:2"
+       x="350.48801"
+       y="190.834"
+       width="93.286301"
+       height="75.166"
+       id="rect46" />
   </g>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="350.488" y1="266" x2="63.5" y2="288"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="350.488" y1="190.834" x2="63.5" y2="211"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="443.774" y1="266" x2="157.5" y2="288"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="443.774" y1="190.834" x2="157.5" y2="211"/>
-  <g>
-    <ellipse style="fill: #ffffff" cx="473.1" cy="219.984" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="473.1" cy="219.984" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="473.1" cy="219.984" rx="8.5" ry="8.5"/>
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="348.88776"
+     y1="264.86047"
+     x2="61.899757"
+     y2="286.86047"
+     id="line48" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="348.88776"
+     y1="189.69447"
+     x2="61.899757"
+     y2="209.86047"
+     id="line50" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="442.17374"
+     y1="264.86047"
+     x2="155.89977"
+     y2="286.86047"
+     id="line52" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="442.17374"
+     y1="189.69447"
+     x2="155.89977"
+     y2="209.86047"
+     id="line54" />
+  <g
+     id="g56"
+     transform="translate(-1.6002426,-1.1395339)">
+    <circle
+       style="fill:#ffffff"
+       cx="473.10001"
+       cy="219.98399"
+       id="ellipse58"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="473.10001"
+       cy="219.98399"
+       id="ellipse60"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="473.10001"
+       cy="219.98399"
+       id="ellipse62"
+       r="8.5" />
   </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="481.6" y1="219.984" x2="637.934" y2="220.012"/>
-    <polygon style="fill: #000000" points="645.434,220.014 635.433,225.012 637.934,220.012 635.435,215.012 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="645.434,220.014 635.433,225.012 637.934,220.012 635.435,215.012 "/>
+  <g
+     id="g64"
+     transform="translate(-1.6002426,-1.1395339)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="481.60001"
+       y1="219.98399"
+       x2="637.93402"
+       y2="220.01199"
+       id="line66" />
+    <polygon
+       style="fill:#000000"
+       points="635.435,215.012 645.434,220.014 635.433,225.012 637.934,220.012 "
+       id="polygon68" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="635.435,215.012 645.434,220.014 635.433,225.012 637.934,220.012 "
+       id="polygon70" />
   </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="506.908" y="209.8">
-    <tspan x="506.908" y="209.8">pad 1 (source)</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="505.30774"
+     y="208.66048"
+     id="text72">
+    <tspan
+       x="505.30774"
+       y="208.66048"
+       id="tspan74">pad 1 (source)</tspan>
   </text>
-  <g>
-    <ellipse style="fill: #ffffff" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
+  <g
+     id="g76"
+     transform="translate(-1.6002426,-1.1395339)">
+    <circle
+       style="fill:#ffffff"
+       cx="-20.398199"
+       cy="241.51199"
+       id="ellipse78"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="-20.398199"
+       cy="241.51199"
+       id="ellipse80"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="-20.398199"
+       cy="241.51199"
+       id="ellipse82"
+       r="8.5" />
   </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="-192.398" y1="241.8" x2="-38.6343" y2="241.529"/>
-    <polygon style="fill: #000000" points="-31.1343,241.516 -41.1254,246.534 -38.6343,241.529 -41.1431,236.534 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="-31.1343,241.516 -41.1254,246.534 -38.6343,241.529 -41.1431,236.534 "/>
+  <g
+     id="g84"
+     transform="translate(-1.6002426,-1.1395339)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="-192.39799"
+       y1="241.8"
+       x2="-38.6343"
+       y2="241.52901"
+       id="line86" />
+    <polygon
+       style="fill:#000000"
+       points="-41.1431,236.534 -31.1343,241.516 -41.1254,246.534 -38.6343,241.529 "
+       id="polygon88" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="-41.1431,236.534 -31.1343,241.516 -41.1254,246.534 -38.6343,241.529 "
+       id="polygon90" />
   </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="-147.858" y="229.8">
-    <tspan x="-147.858" y="229.8">pad 0 (sink)</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="-149.45824"
+     y="228.66048"
+     id="text92">
+    <tspan
+       x="-149.45824"
+       y="228.66048"
+       id="tspan94">pad 0 (sink)</tspan>
   </text>
 </svg>
diff --git a/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.svg b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.svg
index 3322cf4c0093..91cf51832c12 100644
--- a/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.svg
+++ b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.svg
@@ -1,163 +1,742 @@
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
-<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
-<svg width="59cm" height="18cm" viewBox="-186 71 1178 346" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
-  <g>
-    <rect style="fill: #ffffff" x="318.9" y="129" width="208.1" height="249"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #ff765a" x="318.9" y="129" width="208.1" height="249"/>
-  </g>
-  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="-2" y="73" width="806" height="343"/>
-  <g>
-    <ellipse style="fill: #ffffff" cx="-12.5" cy="166.712" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-12.5" cy="166.712" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-12.5" cy="166.712" rx="8.5" ry="8.5"/>
-  </g>
-  <g>
-    <ellipse style="fill: #ffffff" cx="815.232" cy="205.184" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="815.232" cy="205.184" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="815.232" cy="205.184" rx="8.5" ry="8.5"/>
-  </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="-184.5" y1="167" x2="-30.7361" y2="166.729"/>
-    <polygon style="fill: #000000" points="-23.2361,166.716 -33.2272,171.734 -30.7361,166.729 -33.2449,161.734 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="-23.2361,166.716 -33.2272,171.734 -30.7361,166.729 -33.2449,161.734 "/>
-  </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="823.732" y1="205.184" x2="980.066" y2="205.212"/>
-    <polygon style="fill: #000000" points="987.566,205.214 977.565,210.212 980.066,205.212 977.567,200.212 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="987.566,205.214 977.565,210.212 980.066,205.212 977.567,200.212 "/>
-  </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="-139.96" y="155">
-    <tspan x="-139.96" y="155">pad 0 (sink)</tspan>
+<svg
+   xmlns:dc="http://purl.org/dc/elements/1.1/"
+   xmlns:cc="http://creativecommons.org/ns#"
+   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
+   xmlns:svg="http://www.w3.org/2000/svg"
+   xmlns="http://www.w3.org/2000/svg"
+   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
+   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
+   width="58.825298cm"
+   height="17.279287cm"
+   viewBox="-186 71 1174.5119 332.1463"
+   id="svg2"
+   version="1.1"
+   inkscape:version="0.91 r13725"
+   sodipodi:docname="subdev-image-processing-full.svg">
+  <metadata
+     id="metadata260">
+    <rdf:RDF>
+      <cc:Work
+         rdf:about="">
+        <dc:format>image/svg+xml</dc:format>
+        <dc:type
+           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
+        <dc:title />
+      </cc:Work>
+    </rdf:RDF>
+  </metadata>
+  <defs
+     id="defs258" />
+  <sodipodi:namedview
+     pagecolor="#ffffff"
+     bordercolor="#666666"
+     borderopacity="1"
+     objecttolerance="10"
+     gridtolerance="10"
+     guidetolerance="10"
+     inkscape:pageopacity="0"
+     inkscape:pageshadow="2"
+     inkscape:window-width="1920"
+     inkscape:window-height="997"
+     id="namedview256"
+     showgrid="false"
+     fit-margin-top="0"
+     fit-margin-left="0"
+     fit-margin-right="0"
+     fit-margin-bottom="0"
+     inkscape:zoom="0.26595857"
+     inkscape:cx="1050.1367"
+     inkscape:cy="307.01645"
+     inkscape:window-x="1920"
+     inkscape:window-y="30"
+     inkscape:window-maximized="1"
+     inkscape:current-layer="svg2" />
+  <g
+     id="g4"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="318.89999"
+       y="129"
+       width="208.10001"
+       height="249"
+       id="rect6" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#ff765a;stroke-width:2"
+       x="318.89999"
+       y="129"
+       width="208.10001"
+       height="249"
+       id="rect8" />
+  </g>
+  <rect
+     style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+     x="-3.4982376"
+     y="65.305092"
+     width="806"
+     height="343"
+     id="rect10" />
+  <g
+     id="g12"
+     transform="translate(-1.4982376,-7.6949076)">
+    <circle
+       style="fill:#ffffff"
+       cx="-12.5"
+       cy="166.71201"
+       id="ellipse14"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="-12.5"
+       cy="166.71201"
+       id="ellipse16"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="-12.5"
+       cy="166.71201"
+       id="ellipse18"
+       r="8.5" />
+  </g>
+  <g
+     id="g20"
+     transform="translate(-1.4982376,-7.6949076)">
+    <circle
+       style="fill:#ffffff"
+       cx="815.23199"
+       cy="205.18401"
+       id="ellipse22"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="815.23199"
+       cy="205.18401"
+       id="ellipse24"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="815.23199"
+       cy="205.18401"
+       id="ellipse26"
+       r="8.5" />
+  </g>
+  <g
+     id="g28"
+     transform="translate(-1.4982376,-7.6949076)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="-184.5"
+       y1="167"
+       x2="-30.736099"
+       y2="166.729"
+       id="line30" />
+    <polygon
+       style="fill:#000000"
+       points="-33.2449,161.734 -23.2361,166.716 -33.2272,171.734 -30.7361,166.729 "
+       id="polygon32" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="-33.2449,161.734 -23.2361,166.716 -33.2272,171.734 -30.7361,166.729 "
+       id="polygon34" />
+  </g>
+  <g
+     id="g36"
+     transform="translate(-1.4982376,-7.6949076)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="823.73199"
+       y1="205.18401"
+       x2="980.06598"
+       y2="205.21201"
+       id="line38" />
+    <polygon
+       style="fill:#000000"
+       points="977.567,200.212 987.566,205.214 977.565,210.212 980.066,205.212 "
+       id="polygon40" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="977.567,200.212 987.566,205.214 977.565,210.212 980.066,205.212 "
+       id="polygon42" />
+  </g>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="-141.45824"
+     y="147.3051"
+     id="text44">
+    <tspan
+       x="-141.45824"
+       y="147.3051"
+       id="tspan46">pad 0 (sink)</tspan>
   </text>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="849.04" y="195">
-    <tspan x="849.04" y="195">pad 2 (source)</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="847.54175"
+     y="187.3051"
+     id="text48">
+    <tspan
+       x="847.54175"
+       y="187.3051"
+       id="tspan50">pad 2 (source)</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="5.5" y="120" width="159" height="104"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="5.5" y="120" width="159" height="104"/>
+  <g
+     id="g52"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="5.5"
+       y="120"
+       width="159"
+       height="104"
+       id="rect54" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#a52a2a;stroke-width:2"
+       x="5.5"
+       y="120"
+       width="159"
+       height="104"
+       id="rect56" />
   </g>
-  <g>
-    <rect style="fill: #ffffff" x="62.5" y="136" width="94" height="77"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="62.5" y="136" width="94" height="77"/>
+  <g
+     id="g58"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="62.5"
+       y="136"
+       width="94"
+       height="77"
+       id="rect60" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#0000ff;stroke-width:2"
+       x="62.5"
+       y="136"
+       width="94"
+       height="77"
+       id="rect62" />
   </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="30.5" y="89">
-    <tspan x="30.5" y="89"></tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="29.001762"
+     y="81.305092"
+     id="text64">
+    <tspan
+       x="29.001762"
+       y="81.305092"
+       id="tspan66" />
   </text>
-  <text style="fill: #a52a2a;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="9.53836" y="88.9138">
-    <tspan x="9.53836" y="88.9138">sink media</tspan>
-    <tspan x="9.53836" y="104.914">bus format</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#a52a2a"
+     x="8.040122"
+     y="81.218895"
+     id="text68">
+    <tspan
+       x="8.040122"
+       y="81.218895"
+       id="tspan70">sink media</tspan>
+    <tspan
+       x="8.040122"
+       y="97.219093"
+       id="tspan72">bus format</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="333.644" y="185.65" width="165.2" height="172.478"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #00ff00" x="333.644" y="185.65" width="165.2" height="172.478"/>
-  </g>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="333.644" y1="358.128" x2="62.5" y2="213"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="333.644" y1="185.65" x2="62.5" y2="136"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="498.844" y1="358.128" x2="156.5" y2="213"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="498.844" y1="185.65" x2="156.5" y2="136"/>
-  <text style="fill: #00ff00;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="334.704" y="149.442">
-    <tspan x="334.704" y="149.442">sink compose</tspan>
-    <tspan x="334.704" y="165.442">selection (scaling)</tspan>
+  <g
+     id="g74"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="333.64401"
+       y="185.64999"
+       width="165.2"
+       height="172.478"
+       id="rect76" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#00ff00;stroke-width:2"
+       x="333.64401"
+       y="185.64999"
+       width="165.2"
+       height="172.478"
+       id="rect78" />
+  </g>
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="332.14578"
+     y1="350.43307"
+     x2="61.001762"
+     y2="205.3051"
+     id="line80" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="332.14578"
+     y1="177.95509"
+     x2="61.001762"
+     y2="128.3051"
+     id="line82" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="497.34576"
+     y1="350.43307"
+     x2="155.00177"
+     y2="205.3051"
+     id="line84" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="497.34576"
+     y1="177.95509"
+     x2="155.00177"
+     y2="128.3051"
+     id="line86" />
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#00ff00"
+     x="333.20578"
+     y="141.7471"
+     id="text88">
+    <tspan
+       x="333.20578"
+       y="141.7471"
+       id="tspan90">sink compose</tspan>
+    <tspan
+       x="333.20578"
+       y="157.7471"
+       id="tspan92">selection (scaling)</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="409.322" y="194.565" width="100.186" height="71.4523"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="409.322" y="194.565" width="100.186" height="71.4523"/>
+  <g
+     id="g94"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="409.32199"
+       y="194.565"
+       width="100.186"
+       height="71.452301"
+       id="rect96" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       x="409.32199"
+       y="194.565"
+       width="100.186"
+       height="71.452301"
+       id="rect98" />
   </g>
-  <text style="fill: #8b6914;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="689.5" y="105.128">
-    <tspan x="689.5" y="105.128">source media</tspan>
-    <tspan x="689.5" y="121.128">bus format</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#8b6914"
+     x="688.00177"
+     y="97.43309"
+     id="text100">
+    <tspan
+       x="688.00177"
+       y="97.43309"
+       id="tspan102">source media</tspan>
+    <tspan
+       x="688.00177"
+       y="113.43309"
+       id="tspan104">bus format</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="688.488" y="173.834" width="100.186" height="71.4523"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="688.488" y="173.834" width="100.186" height="71.4523"/>
-  </g>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="688.488" y1="245.286" x2="409.322" y2="266.018"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="688.488" y1="173.834" x2="409.322" y2="194.565"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="788.674" y1="245.286" x2="509.508" y2="266.018"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="788.674" y1="173.834" x2="509.508" y2="194.565"/>
-  <text style="fill: #ff765a;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="325" y="103">
-    <tspan x="325" y="103">sink compose</tspan>
-    <tspan x="325" y="119">bounds selection</tspan>
+  <g
+     id="g106"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="688.48798"
+       y="173.834"
+       width="100.186"
+       height="71.452301"
+       id="rect108" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#8b6914;stroke-width:2"
+       x="688.48798"
+       y="173.834"
+       width="100.186"
+       height="71.452301"
+       id="rect110" />
+  </g>
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="686.98975"
+     y1="237.59109"
+     x2="407.82376"
+     y2="258.32309"
+     id="line112" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="686.98975"
+     y1="166.1391"
+     x2="407.82376"
+     y2="186.8701"
+     id="line114" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="787.17578"
+     y1="237.59109"
+     x2="508.00977"
+     y2="258.32309"
+     id="line116" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="787.17578"
+     y1="166.1391"
+     x2="508.00977"
+     y2="186.8701"
+     id="line118" />
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#ff765a"
+     x="323.50177"
+     y="95.305092"
+     id="text120">
+    <tspan
+       x="323.50177"
+       y="95.305092"
+       id="tspan122">sink compose</tspan>
+    <tspan
+       x="323.50177"
+       y="111.30509"
+       id="tspan124">bounds selection</tspan>
   </text>
-  <g>
-    <ellipse style="fill: #ffffff" cx="-12.0982" cy="341.512" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-12.0982" cy="341.512" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-12.0982" cy="341.512" rx="8.5" ry="8.5"/>
-  </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="-184.098" y1="341.8" x2="-30.3343" y2="341.529"/>
-    <polygon style="fill: #000000" points="-22.8343,341.516 -32.8254,346.534 -30.3343,341.529 -32.8431,336.534 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="-22.8343,341.516 -32.8254,346.534 -30.3343,341.529 -32.8431,336.534 "/>
-  </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="-139" y="329">
-    <tspan x="-139" y="329">pad 1 (sink)</tspan>
+  <g
+     id="g126"
+     transform="translate(-1.4982376,-7.6949076)">
+    <circle
+       style="fill:#ffffff"
+       cx="-12.0982"
+       cy="341.51199"
+       id="ellipse128"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="-12.0982"
+       cy="341.51199"
+       id="ellipse130"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="-12.0982"
+       cy="341.51199"
+       id="ellipse132"
+       r="8.5" />
+  </g>
+  <g
+     id="g134"
+     transform="translate(-1.4982376,-7.6949076)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="-184.09801"
+       y1="341.79999"
+       x2="-30.334299"
+       y2="341.52899"
+       id="line136" />
+    <polygon
+       style="fill:#000000"
+       points="-32.8431,336.534 -22.8343,341.516 -32.8254,346.534 -30.3343,341.529 "
+       id="polygon138" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="-32.8431,336.534 -22.8343,341.516 -32.8254,346.534 -30.3343,341.529 "
+       id="polygon140" />
+  </g>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="-140.49823"
+     y="321.30508"
+     id="text142">
+    <tspan
+       x="-140.49823"
+       y="321.30508"
+       id="tspan144">pad 1 (sink)</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="7.80824" y="292.8" width="112.092" height="82.2"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="7.80824" y="292.8" width="112.092" height="82.2"/>
+  <g
+     id="g146"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="7.8082399"
+       y="292.79999"
+       width="112.092"
+       height="82.199997"
+       id="rect148" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#a52a2a;stroke-width:2"
+       x="7.8082399"
+       y="292.79999"
+       width="112.092"
+       height="82.199997"
+       id="rect150" />
   </g>
-  <g>
-    <rect style="fill: #ffffff" x="52.9" y="314.8" width="58.1" height="50.2"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="52.9" y="314.8" width="58.1" height="50.2"/>
+  <g
+     id="g152"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="52.900002"
+       y="314.79999"
+       width="58.099998"
+       height="50.200001"
+       id="rect154" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#0000ff;stroke-width:2"
+       x="52.900002"
+       y="314.79999"
+       width="58.099998"
+       height="50.200001"
+       id="rect156" />
   </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="31.9" y="259.8">
-    <tspan x="31.9" y="259.8"></tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="30.401762"
+     y="252.10509"
+     id="text158">
+    <tspan
+       x="30.401762"
+       y="252.10509"
+       id="tspan160" />
   </text>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="358.9" y1="251.9" x2="52.9" y2="314.8"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="358.9" y1="316" x2="52.9" y2="365"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="434" y1="316" x2="111" y2="365"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="434" y1="251.9" x2="111" y2="314.8"/>
-  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #00ff00" x="358.9" y="251.9" width="75.1" height="64.1"/>
-  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="443.262" y="284.466" width="64.738" height="48.534"/>
-  <g>
-    <rect style="fill: #ffffff" x="693.428" y="324.734" width="63.572" height="49.266"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="693.428" y="324.734" width="63.572" height="49.266"/>
-  </g>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="693.428" y1="374" x2="443.262" y2="333"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="693.428" y1="324.734" x2="443.262" y2="284.466"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="757" y1="374" x2="508" y2="333"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="757" y1="324.734" x2="508" y2="284.466"/>
-  <g>
-    <ellipse style="fill: #ffffff" cx="815.44" cy="343.984" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="815.44" cy="343.984" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="815.44" cy="343.984" rx="8.5" ry="8.5"/>
-  </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="823.94" y1="343.984" x2="980.274" y2="344.012"/>
-    <polygon style="fill: #000000" points="987.774,344.014 977.773,349.012 980.274,344.012 977.775,339.012 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="987.774,344.014 977.773,349.012 980.274,344.012 977.775,339.012 "/>
-  </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="849.248" y="333.8">
-    <tspan x="849.248" y="333.8">pad 3 (source)</tspan>
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="357.40176"
+     y1="244.20509"
+     x2="51.401764"
+     y2="307.10507"
+     id="line162" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="357.40176"
+     y1="308.30508"
+     x2="51.401764"
+     y2="357.30508"
+     id="line164" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="432.50177"
+     y1="308.30508"
+     x2="109.50176"
+     y2="357.30508"
+     id="line166" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="432.50177"
+     y1="244.20509"
+     x2="109.50176"
+     y2="307.10507"
+     id="line168" />
+  <rect
+     style="fill:none;fill-opacity:0;stroke:#00ff00;stroke-width:2"
+     x="357.40176"
+     y="244.20509"
+     width="75.099998"
+     height="64.099998"
+     id="rect170" />
+  <rect
+     style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+     x="441.76376"
+     y="276.77109"
+     width="64.737999"
+     height="48.534"
+     id="rect172" />
+  <g
+     id="g174"
+     transform="translate(-1.4982376,-7.6949076)">
+    <rect
+       style="fill:#ffffff"
+       x="693.42798"
+       y="324.73401"
+       width="63.571999"
+       height="49.265999"
+       id="rect176" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#8b6914;stroke-width:2"
+       x="693.42798"
+       y="324.73401"
+       width="63.571999"
+       height="49.265999"
+       id="rect178" />
+  </g>
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="691.92975"
+     y1="366.30508"
+     x2="441.76376"
+     y2="325.30508"
+     id="line180" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="691.92975"
+     y1="317.03909"
+     x2="441.76376"
+     y2="276.77109"
+     id="line182" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="755.50177"
+     y1="366.30508"
+     x2="506.50177"
+     y2="325.30508"
+     id="line184" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="755.50177"
+     y1="317.03909"
+     x2="506.50177"
+     y2="276.77109"
+     id="line186" />
+  <g
+     id="g188"
+     transform="translate(-1.4982376,-7.6949076)">
+    <circle
+       style="fill:#ffffff"
+       cx="815.44"
+       cy="343.98401"
+       id="ellipse190"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="815.44"
+       cy="343.98401"
+       id="ellipse192"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="815.44"
+       cy="343.98401"
+       id="ellipse194"
+       r="8.5" />
+  </g>
+  <g
+     id="g196"
+     transform="translate(-1.4982376,-7.6949076)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="823.94"
+       y1="343.98401"
+       x2="980.27399"
+       y2="344.01199"
+       id="line198" />
+    <polygon
+       style="fill:#000000"
+       points="977.775,339.012 987.774,344.014 977.773,349.012 980.274,344.012 "
+       id="polygon200" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="977.775,339.012 987.774,344.014 977.773,349.012 980.274,344.012 "
+       id="polygon202" />
+  </g>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="847.74976"
+     y="326.10507"
+     id="text204">
+    <tspan
+       x="847.74976"
+       y="326.10507"
+       id="tspan206">pad 3 (source)</tspan>
   </text>
-  <text style="fill: #0000ff;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="197" y="91">
-    <tspan x="197" y="91">sink</tspan>
-    <tspan x="197" y="107">crop</tspan>
-    <tspan x="197" y="123">selection</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#0000ff"
+     x="195.50177"
+     y="83.305092"
+     id="text208">
+    <tspan
+       x="195.50177"
+       y="83.305092"
+       id="tspan210">sink</tspan>
+    <tspan
+       x="195.50177"
+       y="99.305092"
+       id="tspan212">crop</tspan>
+    <tspan
+       x="195.50177"
+       y="115.30509"
+       id="tspan214">selection</tspan>
   </text>
-  <text style="fill: #a020f0;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="553" y="95">
-    <tspan x="553" y="95">source</tspan>
-    <tspan x="553" y="111">crop</tspan>
-    <tspan x="553" y="127">selection</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#a020f0"
+     x="551.50177"
+     y="87.305092"
+     id="text216">
+    <tspan
+       x="551.50177"
+       y="87.305092"
+       id="tspan218">source</tspan>
+    <tspan
+       x="551.50177"
+       y="103.30509"
+       id="tspan220">crop</tspan>
+    <tspan
+       x="551.50177"
+       y="119.30509"
+       id="tspan222">selection</tspan>
   </text>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x1="211" y1="132" x2="166.21" y2="135.287"/>
-    <polygon style="fill: #0000ff" points="158.73,135.836 168.337,130.118 166.21,135.287 169.069,140.091 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" points="158.73,135.836 168.337,130.118 166.21,135.287 169.069,140.091 "/>
-  </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x1="209" y1="131" x2="115.581" y2="306.209"/>
-    <polygon style="fill: #0000ff" points="112.052,312.827 112.345,301.65 115.581,306.209 121.169,306.355 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" points="112.052,312.827 112.345,301.65 115.581,306.209 121.169,306.355 "/>
-  </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x1="550.492" y1="133.214" x2="514.916" y2="186.469"/>
-    <polygon style="fill: #a020f0" points="510.75,192.706 512.147,181.613 514.916,186.469 520.463,187.168 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" points="510.75,192.706 512.147,181.613 514.916,186.469 520.463,187.168 "/>
-  </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x1="550.072" y1="133.787" x2="510.618" y2="275.089"/>
-    <polygon style="fill: #a020f0" points="508.601,282.312 506.475,271.336 510.618,275.089 516.106,274.025 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" points="508.601,282.312 506.475,271.336 510.618,275.089 516.106,274.025 "/>
+  <g
+     id="g224"
+     transform="translate(-1.4982376,-7.6949076)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#0000ff;stroke-width:2"
+       x1="211"
+       y1="132"
+       x2="166.21001"
+       y2="135.287"
+       id="line226" />
+    <polygon
+       style="fill:#0000ff"
+       points="169.069,140.091 158.73,135.836 168.337,130.118 166.21,135.287 "
+       id="polygon228" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#0000ff;stroke-width:2"
+       points="169.069,140.091 158.73,135.836 168.337,130.118 166.21,135.287 "
+       id="polygon230" />
+  </g>
+  <g
+     id="g232"
+     transform="translate(-1.4982376,-7.6949076)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#0000ff;stroke-width:2"
+       x1="209"
+       y1="131"
+       x2="115.581"
+       y2="306.20901"
+       id="line234" />
+    <polygon
+       style="fill:#0000ff"
+       points="121.169,306.355 112.052,312.827 112.345,301.65 115.581,306.209 "
+       id="polygon236" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#0000ff;stroke-width:2"
+       points="121.169,306.355 112.052,312.827 112.345,301.65 115.581,306.209 "
+       id="polygon238" />
+  </g>
+  <g
+     id="g240"
+     transform="translate(-1.4982376,-7.6949076)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       x1="550.492"
+       y1="133.214"
+       x2="514.91602"
+       y2="186.46899"
+       id="line242" />
+    <polygon
+       style="fill:#a020f0"
+       points="520.463,187.168 510.75,192.706 512.147,181.613 514.916,186.469 "
+       id="polygon244" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       points="520.463,187.168 510.75,192.706 512.147,181.613 514.916,186.469 "
+       id="polygon246" />
+  </g>
+  <g
+     id="g248"
+     transform="translate(-1.4982376,-7.6949076)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       x1="550.07202"
+       y1="133.787"
+       x2="510.61801"
+       y2="275.08899"
+       id="line250" />
+    <polygon
+       style="fill:#a020f0"
+       points="516.106,274.025 508.601,282.312 506.475,271.336 510.618,275.089 "
+       id="polygon252" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       points="516.106,274.025 508.601,282.312 506.475,271.336 510.618,275.089 "
+       id="polygon254" />
   </g>
 </svg>
diff --git a/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg
index 2340c0f8bc92..cedcbf598923 100644
--- a/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg
+++ b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg
@@ -1,116 +1,540 @@
 <?xml version="1.0" encoding="UTF-8" standalone="no"?>
-<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
-<svg width="59cm" height="17cm" viewBox="-194 128 1179 330" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
-  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="-8" y="130" width="806" height="327"/>
-  <g>
-    <rect style="fill: #ffffff" x="4.5" y="189" width="159" height="104"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="4.5" y="189" width="159" height="104"/>
+<svg
+   xmlns:dc="http://purl.org/dc/elements/1.1/"
+   xmlns:cc="http://creativecommons.org/ns#"
+   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
+   xmlns:svg="http://www.w3.org/2000/svg"
+   xmlns="http://www.w3.org/2000/svg"
+   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
+   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
+   width="58.803326cm"
+   height="16.463955cm"
+   viewBox="-194 128 1175.0698 319.59442"
+   id="svg2"
+   version="1.1"
+   inkscape:version="0.91 r13725"
+   sodipodi:docname="subdev-image-processing-scaling-multi-source.svg">
+  <metadata
+     id="metadata186">
+    <rdf:RDF>
+      <cc:Work
+         rdf:about="">
+        <dc:format>image/svg+xml</dc:format>
+        <dc:type
+           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
+        <dc:title />
+      </cc:Work>
+    </rdf:RDF>
+  </metadata>
+  <defs
+     id="defs184" />
+  <sodipodi:namedview
+     pagecolor="#ffffff"
+     bordercolor="#666666"
+     borderopacity="1"
+     objecttolerance="10"
+     gridtolerance="10"
+     guidetolerance="10"
+     inkscape:pageopacity="0"
+     inkscape:pageshadow="2"
+     inkscape:window-width="1920"
+     inkscape:window-height="997"
+     id="namedview182"
+     showgrid="false"
+     fit-margin-top="0"
+     fit-margin-left="0"
+     fit-margin-right="0"
+     fit-margin-bottom="0"
+     inkscape:zoom="0.26595857"
+     inkscape:cx="1049.9581"
+     inkscape:cy="292.5708"
+     inkscape:window-x="1920"
+     inkscape:window-y="30"
+     inkscape:window-maximized="1"
+     inkscape:current-layer="svg2" />
+  <rect
+     style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+     x="-9.6002426"
+     y="124.14409"
+     width="806"
+     height="327"
+     id="rect4" />
+  <g
+     id="g6"
+     transform="translate(-1.6002426,-5.8559115)">
+    <rect
+       style="fill:#ffffff"
+       x="4.5"
+       y="189"
+       width="159"
+       height="104"
+       id="rect8" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#a52a2a;stroke-width:2"
+       x="4.5"
+       y="189"
+       width="159"
+       height="104"
+       id="rect10" />
   </g>
-  <g>
-    <rect style="fill: #ffffff" x="49.5" y="204" width="94" height="77"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="49.5" y="204" width="94" height="77"/>
+  <g
+     id="g12"
+     transform="translate(-1.6002426,-5.8559115)">
+    <rect
+       style="fill:#ffffff"
+       x="49.5"
+       y="204"
+       width="94"
+       height="77"
+       id="rect14" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#0000ff;stroke-width:2"
+       x="49.5"
+       y="204"
+       width="94"
+       height="77"
+       id="rect16" />
   </g>
-  <text style="fill: #0000ff;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="60" y="224">
-    <tspan x="60" y="224">sink</tspan>
-    <tspan x="60" y="240">crop</tspan>
-    <tspan x="60" y="256">selection</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#0000ff"
+     x="58.399757"
+     y="218.14409"
+     id="text18">
+    <tspan
+       x="58.399757"
+       y="218.14409"
+       id="tspan20">sink</tspan>
+    <tspan
+       x="58.399757"
+       y="234.14409"
+       id="tspan22">crop</tspan>
+    <tspan
+       x="58.399757"
+       y="250.14409"
+       id="tspan24">selection</tspan>
   </text>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="29.5" y="158">
-    <tspan x="29.5" y="158"></tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="27.899757"
+     y="152.14409"
+     id="text26">
+    <tspan
+       x="27.899757"
+       y="152.14409"
+       id="tspan28" />
   </text>
-  <text style="fill: #a52a2a;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="8.53836" y="157.914">
-    <tspan x="8.53836" y="157.914">sink media</tspan>
-    <tspan x="8.53836" y="173.914">bus format</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#a52a2a"
+     x="6.938117"
+     y="152.05809"
+     id="text30">
+    <tspan
+       x="6.938117"
+       y="152.05809"
+       id="tspan32">sink media</tspan>
+    <tspan
+       x="6.938117"
+       y="168.05809"
+       id="tspan34">bus format</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="333.644" y="185.65" width="165.2" height="172.478"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #00ff00" x="333.644" y="185.65" width="165.2" height="172.478"/>
+  <g
+     id="g36"
+     transform="translate(-1.6002426,-5.8559115)">
+    <rect
+       style="fill:#ffffff"
+       x="333.64401"
+       y="185.64999"
+       width="165.2"
+       height="172.478"
+       id="rect38" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#00ff00;stroke-width:2"
+       x="333.64401"
+       y="185.64999"
+       width="165.2"
+       height="172.478"
+       id="rect40" />
   </g>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="333.644" y1="358.128" x2="49.5" y2="281"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="333.644" y1="185.65" x2="49.5" y2="204"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="498.844" y1="358.128" x2="143.5" y2="281"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="498.844" y1="185.65" x2="143.5" y2="204"/>
-  <text style="fill: #00ff00;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="334.704" y="149.442">
-    <tspan x="334.704" y="149.442">sink compose</tspan>
-    <tspan x="334.704" y="165.442">selection (scaling)</tspan>
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="332.04376"
+     y1="352.27206"
+     x2="47.899757"
+     y2="275.14407"
+     id="line42" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="332.04376"
+     y1="179.79408"
+     x2="47.899757"
+     y2="198.14409"
+     id="line44" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="497.24374"
+     y1="352.27206"
+     x2="141.89977"
+     y2="275.14407"
+     id="line46" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="497.24374"
+     y1="179.79408"
+     x2="141.89977"
+     y2="198.14409"
+     id="line48" />
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#00ff00"
+     x="333.10376"
+     y="143.58609"
+     id="text50">
+    <tspan
+       x="333.10376"
+       y="143.58609"
+       id="tspan52">sink compose</tspan>
+    <tspan
+       x="333.10376"
+       y="159.58609"
+       id="tspan54">selection (scaling)</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="382.322" y="199.565" width="100.186" height="71.4523"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="382.322" y="199.565" width="100.186" height="71.4523"/>
+  <g
+     id="g56"
+     transform="translate(-1.6002426,-5.8559115)">
+    <rect
+       style="fill:#ffffff"
+       x="382.32199"
+       y="199.565"
+       width="100.186"
+       height="71.452301"
+       id="rect58" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       x="382.32199"
+       y="199.565"
+       width="100.186"
+       height="71.452301"
+       id="rect60" />
   </g>
-  <text style="fill: #a020f0;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="543.322" y="149.442">
-    <tspan x="543.322" y="149.442">source</tspan>
-    <tspan x="543.322" y="165.442">crop</tspan>
-    <tspan x="543.322" y="181.442">selection</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#a020f0"
+     x="541.7218"
+     y="143.58609"
+     id="text62">
+    <tspan
+       x="541.7218"
+       y="143.58609"
+       id="tspan64">source</tspan>
+    <tspan
+       x="541.7218"
+       y="159.58609"
+       id="tspan66">crop</tspan>
+    <tspan
+       x="541.7218"
+       y="175.58609"
+       id="tspan68">selection</tspan>
   </text>
-  <text style="fill: #8b6914;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="691.5" y="157.128">
-    <tspan x="691.5" y="157.128">source media</tspan>
-    <tspan x="691.5" y="173.128">bus format</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#8b6914"
+     x="689.89978"
+     y="151.27209"
+     id="text70">
+    <tspan
+       x="689.89978"
+       y="151.27209"
+       id="tspan72">source media</tspan>
+    <tspan
+       x="689.89978"
+       y="167.27209"
+       id="tspan74">bus format</tspan>
   </text>
-  <g>
-    <rect style="fill: #ffffff" x="690.488" y="225.834" width="100.186" height="71.4523"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="690.488" y="225.834" width="100.186" height="71.4523"/>
+  <g
+     id="g76"
+     transform="translate(-1.6002426,-5.8559115)">
+    <rect
+       style="fill:#ffffff"
+       x="690.48798"
+       y="225.834"
+       width="100.186"
+       height="71.452301"
+       id="rect78" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#8b6914;stroke-width:2"
+       x="690.48798"
+       y="225.834"
+       width="100.186"
+       height="71.452301"
+       id="rect80" />
   </g>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="690.488" y1="297.286" x2="382.322" y2="271.018"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="690.488" y1="225.834" x2="382.322" y2="199.565"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="790.674" y1="297.286" x2="482.508" y2="271.018"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="790.674" y1="225.834" x2="482.508" y2="199.565"/>
-  <g>
-    <ellipse style="fill: #ffffff" cx="808.1" cy="249.984" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="808.1" cy="249.984" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="808.1" cy="249.984" rx="8.5" ry="8.5"/>
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="688.88776"
+     y1="291.43008"
+     x2="380.72174"
+     y2="265.16208"
+     id="line82" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="688.88776"
+     y1="219.97809"
+     x2="380.72174"
+     y2="193.70909"
+     id="line84" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="789.07379"
+     y1="291.43008"
+     x2="480.90775"
+     y2="265.16208"
+     id="line86" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="789.07379"
+     y1="219.97809"
+     x2="480.90775"
+     y2="193.70909"
+     id="line88" />
+  <g
+     id="g90"
+     transform="translate(-1.6002426,-5.8559115)">
+    <circle
+       style="fill:#ffffff"
+       cx="808.09998"
+       cy="249.98399"
+       id="ellipse92"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="808.09998"
+       cy="249.98399"
+       id="ellipse94"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="808.09998"
+       cy="249.98399"
+       id="ellipse96"
+       r="8.5" />
   </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="816.6" y1="249.984" x2="972.934" y2="250.012"/>
-    <polygon style="fill: #000000" points="980.434,250.014 970.433,255.012 972.934,250.012 970.435,245.012 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="980.434,250.014 970.433,255.012 972.934,250.012 970.435,245.012 "/>
+  <g
+     id="g98"
+     transform="translate(-1.6002426,-5.8559115)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="816.59998"
+       y1="249.98399"
+       x2="972.93402"
+       y2="250.01199"
+       id="line100" />
+    <polygon
+       style="fill:#000000"
+       points="970.435,245.012 980.434,250.014 970.433,255.012 972.934,250.012 "
+       id="polygon102" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="970.435,245.012 980.434,250.014 970.433,255.012 972.934,250.012 "
+       id="polygon104" />
   </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="841.908" y="239.8">
-    <tspan x="841.908" y="239.8">pad 1 (source)</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="840.3078"
+     y="233.94409"
+     id="text106">
+    <tspan
+       x="840.3078"
+       y="233.94409"
+       id="tspan108">pad 1 (source)</tspan>
   </text>
-  <g>
-    <ellipse style="fill: #ffffff" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
+  <g
+     id="g110"
+     transform="translate(-1.6002426,-5.8559115)">
+    <circle
+       style="fill:#ffffff"
+       cx="-20.398199"
+       cy="241.51199"
+       id="ellipse112"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="-20.398199"
+       cy="241.51199"
+       id="ellipse114"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="-20.398199"
+       cy="241.51199"
+       id="ellipse116"
+       r="8.5" />
   </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="-192.398" y1="241.8" x2="-38.6343" y2="241.529"/>
-    <polygon style="fill: #000000" points="-31.1343,241.516 -41.1254,246.534 -38.6343,241.529 -41.1431,236.534 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="-31.1343,241.516 -41.1254,246.534 -38.6343,241.529 -41.1431,236.534 "/>
+  <g
+     id="g118"
+     transform="translate(-1.6002426,-5.8559115)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="-192.39799"
+       y1="241.8"
+       x2="-38.6343"
+       y2="241.52901"
+       id="line120" />
+    <polygon
+       style="fill:#000000"
+       points="-41.1431,236.534 -31.1343,241.516 -41.1254,246.534 -38.6343,241.529 "
+       id="polygon122" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="-41.1431,236.534 -31.1343,241.516 -41.1254,246.534 -38.6343,241.529 "
+       id="polygon124" />
   </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="-147.858" y="229.8">
-    <tspan x="-147.858" y="229.8">pad 0 (sink)</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="-149.45824"
+     y="223.94409"
+     id="text126">
+    <tspan
+       x="-149.45824"
+       y="223.94409"
+       id="tspan128">pad 0 (sink)</tspan>
   </text>
-  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="389.822" y="276.666" width="100.186" height="71.4523"/>
-  <g>
-    <rect style="fill: #ffffff" x="689.988" y="345.934" width="100.186" height="71.4523"/>
-    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="689.988" y="345.934" width="100.186" height="71.4523"/>
+  <rect
+     style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+     x="388.22174"
+     y="270.81006"
+     width="100.186"
+     height="71.452301"
+     id="rect130" />
+  <g
+     id="g132"
+     transform="translate(-1.6002426,-5.8559115)">
+    <rect
+       style="fill:#ffffff"
+       x="689.98798"
+       y="345.93399"
+       width="100.186"
+       height="71.452301"
+       id="rect134" />
+    <rect
+       style="fill:none;fill-opacity:0;stroke:#8b6914;stroke-width:2"
+       x="689.98798"
+       y="345.93399"
+       width="100.186"
+       height="71.452301"
+       id="rect136" />
   </g>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="689.988" y1="417.386" x2="389.822" y2="348.118"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="689.988" y1="345.934" x2="389.822" y2="276.666"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="790.174" y1="417.386" x2="490.008" y2="348.118"/>
-  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #e60505" x1="790.174" y1="345.934" x2="490.008" y2="276.666"/>
-  <g>
-    <ellipse style="fill: #ffffff" cx="805.6" cy="384.084" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="805.6" cy="384.084" rx="8.5" ry="8.5"/>
-    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="805.6" cy="384.084" rx="8.5" ry="8.5"/>
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="688.38776"
+     y1="411.53006"
+     x2="388.22174"
+     y2="342.26208"
+     id="line138" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="688.38776"
+     y1="340.07806"
+     x2="388.22174"
+     y2="270.81006"
+     id="line140" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="788.57379"
+     y1="411.53006"
+     x2="488.40775"
+     y2="342.26208"
+     id="line142" />
+  <line
+     style="fill:none;fill-opacity:0;stroke:#e60505;stroke-width:2;stroke-dasharray:4"
+     x1="788.57379"
+     y1="340.07806"
+     x2="488.40775"
+     y2="270.81006"
+     id="line144" />
+  <g
+     id="g146"
+     transform="translate(-1.6002426,-5.8559115)">
+    <circle
+       style="fill:#ffffff"
+       cx="805.59998"
+       cy="384.08401"
+       id="ellipse148"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="805.59998"
+       cy="384.08401"
+       id="ellipse150"
+       r="8.5" />
+    <circle
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       cx="805.59998"
+       cy="384.08401"
+       id="ellipse152"
+       r="8.5" />
   </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="814.1" y1="384.084" x2="970.434" y2="384.112"/>
-    <polygon style="fill: #000000" points="977.934,384.114 967.933,389.112 970.434,384.112 967.935,379.112 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="977.934,384.114 967.933,389.112 970.434,384.112 967.935,379.112 "/>
+  <g
+     id="g154"
+     transform="translate(-1.6002426,-5.8559115)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       x1="814.09998"
+       y1="384.08401"
+       x2="970.43402"
+       y2="384.112"
+       id="line156" />
+    <polygon
+       style="fill:#000000"
+       points="967.935,379.112 977.934,384.114 967.933,389.112 970.434,384.112 "
+       id="polygon158" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#000000;stroke-width:2"
+       points="967.935,379.112 977.934,384.114 967.933,389.112 970.434,384.112 "
+       id="polygon160" />
   </g>
-  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="839.408" y="373.9">
-    <tspan x="839.408" y="373.9">pad 2 (source)</tspan>
+  <text
+     style="font-style:normal;font-weight:normal;font-size:12.80000019px;font-family:sanserif;text-anchor:start;fill:#000000"
+     x="837.8078"
+     y="368.04407"
+     id="text162">
+    <tspan
+       x="837.8078"
+       y="368.04407"
+       id="tspan164">pad 2 (source)</tspan>
   </text>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x1="546" y1="191" x2="492.157" y2="198.263"/>
-    <polygon style="fill: #a020f0" points="484.724,199.266 493.966,192.974 492.157,198.263 495.303,202.884 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" points="484.724,199.266 493.966,192.974 492.157,198.263 495.303,202.884 "/>
+  <g
+     id="g166"
+     transform="translate(-1.6002426,-5.8559115)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       x1="546"
+       y1="191"
+       x2="492.15701"
+       y2="198.263"
+       id="line168" />
+    <polygon
+       style="fill:#a020f0"
+       points="495.303,202.884 484.724,199.266 493.966,192.974 492.157,198.263 "
+       id="polygon170" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       points="495.303,202.884 484.724,199.266 493.966,192.974 492.157,198.263 "
+       id="polygon172" />
   </g>
-  <g>
-    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x1="546.908" y1="190.725" x2="495.383" y2="268.548"/>
-    <polygon style="fill: #a020f0" points="491.242,274.802 492.594,263.703 495.383,268.548 500.932,269.224 "/>
-    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" points="491.242,274.802 492.594,263.703 495.383,268.548 500.932,269.224 "/>
+  <g
+     id="g174"
+     transform="translate(-1.6002426,-5.8559115)">
+    <line
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       x1="546.90802"
+       y1="190.72501"
+       x2="495.383"
+       y2="268.548"
+       id="line176" />
+    <polygon
+       style="fill:#a020f0"
+       points="500.932,269.224 491.242,274.802 492.594,263.703 495.383,268.548 "
+       id="polygon178" />
+    <polygon
+       style="fill:none;fill-opacity:0;stroke:#a020f0;stroke-width:2"
+       points="500.932,269.224 491.242,274.802 492.594,263.703 495.383,268.548 "
+       id="polygon180" />
   </g>
 </svg>
-- 
2.7.4

