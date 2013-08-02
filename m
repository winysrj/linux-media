Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56339 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3HBBCc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 21:02:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v5 5/9] v4l: Add media format codes for ARGB8888 and AYUV8888 on 32-bit busses
Date: Fri,  2 Aug 2013 03:03:24 +0200
Message-Id: <1375405408-17134-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 609 +++++++++------------
 Documentation/DocBook/media_api.tmpl               |   6 +
 include/uapi/linux/v4l2-mediabus.h                 |   6 +-
 3 files changed, 254 insertions(+), 367 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 0c2b1f2..f72c1cc 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -97,31 +97,39 @@
 	  <colspec colname="id" align="left" />
 	  <colspec colname="code" align="center"/>
 	  <colspec colname="bit" />
-	  <colspec colnum="4" colname="b23" align="center" />
-	  <colspec colnum="5" colname="b22" align="center" />
-	  <colspec colnum="6" colname="b21" align="center" />
-	  <colspec colnum="7" colname="b20" align="center" />
-	  <colspec colnum="8" colname="b19" align="center" />
-	  <colspec colnum="9" colname="b18" align="center" />
-	  <colspec colnum="10" colname="b17" align="center" />
-	  <colspec colnum="11" colname="b16" align="center" />
-	  <colspec colnum="12" colname="b15" align="center" />
-	  <colspec colnum="13" colname="b14" align="center" />
-	  <colspec colnum="14" colname="b13" align="center" />
-	  <colspec colnum="15" colname="b12" align="center" />
-	  <colspec colnum="16" colname="b11" align="center" />
-	  <colspec colnum="17" colname="b10" align="center" />
-	  <colspec colnum="18" colname="b09" align="center" />
-	  <colspec colnum="19" colname="b08" align="center" />
-	  <colspec colnum="20" colname="b07" align="center" />
-	  <colspec colnum="21" colname="b06" align="center" />
-	  <colspec colnum="22" colname="b05" align="center" />
-	  <colspec colnum="23" colname="b04" align="center" />
-	  <colspec colnum="24" colname="b03" align="center" />
-	  <colspec colnum="25" colname="b02" align="center" />
-	  <colspec colnum="26" colname="b01" align="center" />
-	  <colspec colnum="27" colname="b00" align="center" />
-	  <spanspec namest="b23" nameend="b00" spanname="b0" />
+	  <colspec colnum="4" colname="b31" align="center" />
+	  <colspec colnum="5" colname="b20" align="center" />
+	  <colspec colnum="6" colname="b29" align="center" />
+	  <colspec colnum="7" colname="b28" align="center" />
+	  <colspec colnum="8" colname="b27" align="center" />
+	  <colspec colnum="9" colname="b26" align="center" />
+	  <colspec colnum="10" colname="b25" align="center" />
+	  <colspec colnum="11" colname="b24" align="center" />
+	  <colspec colnum="12" colname="b23" align="center" />
+	  <colspec colnum="13" colname="b22" align="center" />
+	  <colspec colnum="14" colname="b21" align="center" />
+	  <colspec colnum="15" colname="b20" align="center" />
+	  <colspec colnum="16" colname="b19" align="center" />
+	  <colspec colnum="17" colname="b18" align="center" />
+	  <colspec colnum="18" colname="b17" align="center" />
+	  <colspec colnum="19" colname="b16" align="center" />
+	  <colspec colnum="20" colname="b15" align="center" />
+	  <colspec colnum="21" colname="b14" align="center" />
+	  <colspec colnum="22" colname="b13" align="center" />
+	  <colspec colnum="23" colname="b12" align="center" />
+	  <colspec colnum="24" colname="b11" align="center" />
+	  <colspec colnum="25" colname="b10" align="center" />
+	  <colspec colnum="26" colname="b09" align="center" />
+	  <colspec colnum="27" colname="b08" align="center" />
+	  <colspec colnum="28" colname="b07" align="center" />
+	  <colspec colnum="29" colname="b06" align="center" />
+	  <colspec colnum="30" colname="b05" align="center" />
+	  <colspec colnum="31" colname="b04" align="center" />
+	  <colspec colnum="32" colname="b03" align="center" />
+	  <colspec colnum="33" colname="b02" align="center" />
+	  <colspec colnum="34" colname="b01" align="center" />
+	  <colspec colnum="35" colname="b00" align="center" />
+	  <spanspec namest="b31" nameend="b00" spanname="b0" />
 	  <thead>
 	    <row>
 	      <entry>Identifier</entry>
@@ -133,6 +141,14 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry>Bit</entry>
+	      <entry>31</entry>
+	      <entry>30</entry>
+	      <entry>29</entry>
+	      <entry>28</entry>
+	      <entry>27</entry>
+	      <entry>26</entry>
+	      <entry>25</entry>
+	      <entry>24</entry>
 	      <entry>23</entry>
 	      <entry>22</entry>
 	      <entry>21</entry>
@@ -164,7 +180,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE</entry>
 	      <entry>0x1001</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>0</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
@@ -178,7 +194,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>g<subscript>3</subscript></entry>
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
@@ -192,7 +208,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE</entry>
 	      <entry>0x1002</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>g<subscript>3</subscript></entry>
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
@@ -206,7 +222,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>0</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
@@ -220,7 +236,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</entry>
 	      <entry>0x1003</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>0</entry>
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
@@ -234,7 +250,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -248,7 +264,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE</entry>
 	      <entry>0x1004</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -262,7 +278,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>0</entry>
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
@@ -276,7 +292,7 @@
 	      <entry>V4L2_MBUS_FMT_BGR565_2X8_BE</entry>
 	      <entry>0x1005</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>b<subscript>4</subscript></entry>
 	      <entry>b<subscript>3</subscript></entry>
 	      <entry>b<subscript>2</subscript></entry>
@@ -290,7 +306,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -304,7 +320,7 @@
 	      <entry>V4L2_MBUS_FMT_BGR565_2X8_LE</entry>
 	      <entry>0x1006</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -318,7 +334,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>b<subscript>4</subscript></entry>
 	      <entry>b<subscript>3</subscript></entry>
 	      <entry>b<subscript>2</subscript></entry>
@@ -332,7 +348,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB565_2X8_BE</entry>
 	      <entry>0x1007</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
 	      <entry>r<subscript>2</subscript></entry>
@@ -346,7 +362,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -360,7 +376,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB565_2X8_LE</entry>
 	      <entry>0x1008</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -374,7 +390,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-24;
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
 	      <entry>r<subscript>2</subscript></entry>
@@ -388,12 +404,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB666_1X18</entry>
 	      <entry>0x1009</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-14;
 	      <entry>r<subscript>5</subscript></entry>
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
@@ -417,6 +428,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB888_1X24</entry>
 	      <entry>0x100a</entry>
 	      <entry></entry>
+	      &dash-ent-8;
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -446,9 +458,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB888_2X12_BE</entry>
 	      <entry>0x100b</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-20;
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -466,9 +476,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-20;
 	      <entry>g<subscript>3</subscript></entry>
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
@@ -486,9 +494,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB888_2X12_LE</entry>
 	      <entry>0x100c</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-20;
 	      <entry>g<subscript>3</subscript></entry>
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
@@ -506,9 +512,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-20;
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -522,6 +526,43 @@
 	      <entry>g<subscript>5</subscript></entry>
 	      <entry>g<subscript>4</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-ARGB888-1X32">
+	      <entry>V4L2_MBUS_FMT_ARGB888_1X32</entry>
+	      <entry>0x100d</entry>
+	      <entry></entry>
+	      <entry>a<subscript>7</subscript></entry>
+	      <entry>a<subscript>6</subscript></entry>
+	      <entry>a<subscript>5</subscript></entry>
+	      <entry>a<subscript>4</subscript></entry>
+	      <entry>a<subscript>3</subscript></entry>
+	      <entry>a<subscript>2</subscript></entry>
+	      <entry>a<subscript>1</subscript></entry>
+	      <entry>a<subscript>0</subscript></entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
 	  </tbody>
 	</tgroup>
       </table>
@@ -1149,6 +1190,7 @@
 	   <listitem><para>y<subscript>x</subscript> for luma component bit number x</para></listitem>
 	   <listitem><para>u<subscript>x</subscript> for blue chroma component bit number x</para></listitem>
 	   <listitem><para>v<subscript>x</subscript> for red chroma component bit number x</para></listitem>
+	   <listitem><para>a<subscript>x</subscript> for alpha component bit number x</para></listitem>
 	   <listitem><para>- for non-available bits (for positions higher than the bus width)</para></listitem>
 	   <listitem><para>d for dummy bits</para></listitem>
 	</itemizedlist>
@@ -1159,37 +1201,39 @@
 	  <colspec colname="id" align="left" />
 	  <colspec colname="code" align="center"/>
 	  <colspec colname="bit" />
-	  <colspec colnum="4" colname="b29" align="center" />
-	  <colspec colnum="5" colname="b28" align="center" />
-	  <colspec colnum="6" colname="b27" align="center" />
-	  <colspec colnum="7" colname="b26" align="center" />
-	  <colspec colnum="8" colname="b25" align="center" />
-	  <colspec colnum="9" colname="b24" align="center" />
-	  <colspec colnum="10" colname="b23" align="center" />
-	  <colspec colnum="11" colname="b22" align="center" />
-	  <colspec colnum="12" colname="b21" align="center" />
-	  <colspec colnum="13" colname="b20" align="center" />
-	  <colspec colnum="14" colname="b19" align="center" />
-	  <colspec colnum="15" colname="b18" align="center" />
-	  <colspec colnum="16" colname="b17" align="center" />
-	  <colspec colnum="17" colname="b16" align="center" />
-	  <colspec colnum="18" colname="b15" align="center" />
-	  <colspec colnum="19" colname="b14" align="center" />
-	  <colspec colnum="20" colname="b13" align="center" />
-	  <colspec colnum="21" colname="b12" align="center" />
-	  <colspec colnum="22" colname="b11" align="center" />
-	  <colspec colnum="23" colname="b10" align="center" />
-	  <colspec colnum="24" colname="b09" align="center" />
-	  <colspec colnum="25" colname="b08" align="center" />
-	  <colspec colnum="26" colname="b07" align="center" />
-	  <colspec colnum="27" colname="b06" align="center" />
-	  <colspec colnum="28" colname="b05" align="center" />
-	  <colspec colnum="29" colname="b04" align="center" />
-	  <colspec colnum="30" colname="b03" align="center" />
-	  <colspec colnum="31" colname="b02" align="center" />
-	  <colspec colnum="32" colname="b01" align="center" />
-	  <colspec colnum="33" colname="b00" align="center" />
-	  <spanspec namest="b29" nameend="b00" spanname="b0" />
+	  <colspec colnum="4" colname="b31" align="center" />
+	  <colspec colnum="5" colname="b20" align="center" />
+	  <colspec colnum="6" colname="b29" align="center" />
+	  <colspec colnum="7" colname="b28" align="center" />
+	  <colspec colnum="8" colname="b27" align="center" />
+	  <colspec colnum="9" colname="b26" align="center" />
+	  <colspec colnum="10" colname="b25" align="center" />
+	  <colspec colnum="11" colname="b24" align="center" />
+	  <colspec colnum="12" colname="b23" align="center" />
+	  <colspec colnum="13" colname="b22" align="center" />
+	  <colspec colnum="14" colname="b21" align="center" />
+	  <colspec colnum="15" colname="b20" align="center" />
+	  <colspec colnum="16" colname="b19" align="center" />
+	  <colspec colnum="17" colname="b18" align="center" />
+	  <colspec colnum="18" colname="b17" align="center" />
+	  <colspec colnum="19" colname="b16" align="center" />
+	  <colspec colnum="20" colname="b15" align="center" />
+	  <colspec colnum="21" colname="b14" align="center" />
+	  <colspec colnum="22" colname="b13" align="center" />
+	  <colspec colnum="23" colname="b12" align="center" />
+	  <colspec colnum="24" colname="b11" align="center" />
+	  <colspec colnum="25" colname="b10" align="center" />
+	  <colspec colnum="26" colname="b09" align="center" />
+	  <colspec colnum="27" colname="b08" align="center" />
+	  <colspec colnum="28" colname="b07" align="center" />
+	  <colspec colnum="29" colname="b06" align="center" />
+	  <colspec colnum="30" colname="b05" align="center" />
+	  <colspec colnum="31" colname="b04" align="center" />
+	  <colspec colnum="32" colname="b03" align="center" />
+	  <colspec colnum="33" colname="b02" align="center" />
+	  <colspec colnum="34" colname="b01" align="center" />
+	  <colspec colnum="35" colname="b00" align="center" />
+	  <spanspec namest="b31" nameend="b00" spanname="b0" />
 	  <thead>
 	    <row>
 	      <entry>Identifier</entry>
@@ -1201,6 +1245,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry>Bit</entry>
+	      <entry>31</entry>
+	      <entry>30</entry>
 	      <entry>29</entry>
 	      <entry>28</entry>
 	      <entry>27</entry>
@@ -1238,10 +1284,7 @@
 	      <entry>V4L2_MBUS_FMT_Y8_1X8</entry>
 	      <entry>0x2001</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1255,18 +1298,7 @@
 	      <entry>V4L2_MBUS_FMT_UV8_1X8</entry>
 	      <entry>0x2015</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1280,18 +1312,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1305,10 +1326,7 @@
 	      <entry>V4L2_MBUS_FMT_UYVY8_1_5X8</entry>
 	      <entry>0x2002</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1322,10 +1340,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1339,10 +1354,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1356,10 +1368,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1373,10 +1382,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1390,10 +1396,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1407,10 +1410,7 @@
 	      <entry>V4L2_MBUS_FMT_VYUY8_1_5X8</entry>
 	      <entry>0x2003</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1424,10 +1424,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1441,10 +1438,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1458,10 +1452,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1475,10 +1466,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1492,10 +1480,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1509,10 +1494,7 @@
 	      <entry>V4L2_MBUS_FMT_YUYV8_1_5X8</entry>
 	      <entry>0x2004</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1526,10 +1508,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1543,10 +1522,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1560,10 +1536,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1577,10 +1550,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1594,10 +1564,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1611,10 +1578,7 @@
 	      <entry>V4L2_MBUS_FMT_YVYU8_1_5X8</entry>
 	      <entry>0x2005</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1628,10 +1592,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1645,10 +1606,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1662,10 +1620,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1679,10 +1634,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1696,10 +1648,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1713,10 +1662,7 @@
 	      <entry>V4L2_MBUS_FMT_UYVY8_2X8</entry>
 	      <entry>0x2006</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1730,10 +1676,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1747,10 +1690,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1764,10 +1704,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1781,10 +1718,7 @@
 	      <entry>V4L2_MBUS_FMT_VYUY8_2X8</entry>
 	      <entry>0x2007</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1798,10 +1732,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1815,10 +1746,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1832,10 +1760,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1849,10 +1774,7 @@
 	      <entry>V4L2_MBUS_FMT_YUYV8_2X8</entry>
 	      <entry>0x2008</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1866,10 +1788,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1883,10 +1802,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1900,10 +1816,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1917,10 +1830,7 @@
 	      <entry>V4L2_MBUS_FMT_YVYU8_2X8</entry>
 	      <entry>0x2009</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1934,10 +1844,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -1951,10 +1858,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -1968,10 +1872,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-24;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -1985,8 +1886,7 @@
 	      <entry>V4L2_MBUS_FMT_Y10_1X10</entry>
 	      <entry>0x200a</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2002,8 +1902,7 @@
 	      <entry>V4L2_MBUS_FMT_YUYV10_2X10</entry>
 	      <entry>0x200b</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2019,8 +1918,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>u<subscript>9</subscript></entry>
 	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -2036,8 +1934,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2053,8 +1950,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>v<subscript>9</subscript></entry>
 	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -2070,8 +1966,7 @@
 	      <entry>V4L2_MBUS_FMT_YVYU10_2X10</entry>
 	      <entry>0x200c</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2087,8 +1982,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>v<subscript>9</subscript></entry>
 	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -2104,8 +1998,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2121,8 +2014,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      &dash-ent-10;
+	      &dash-ent-22;
 	      <entry>u<subscript>9</subscript></entry>
 	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -2138,15 +2030,7 @@
 	      <entry>V4L2_MBUS_FMT_Y12_1X12</entry>
 	      <entry>0x2013</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-20;
 	      <entry>y<subscript>11</subscript></entry>
 	      <entry>y<subscript>10</subscript></entry>
 	      <entry>y<subscript>9</subscript></entry>
@@ -2164,11 +2048,7 @@
 	      <entry>V4L2_MBUS_FMT_UYVY8_1X16</entry>
 	      <entry>0x200f</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2190,11 +2070,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2216,11 +2092,7 @@
 	      <entry>V4L2_MBUS_FMT_VYUY8_1X16</entry>
 	      <entry>0x2010</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2242,11 +2114,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2268,11 +2136,7 @@
 	      <entry>V4L2_MBUS_FMT_YUYV8_1X16</entry>
 	      <entry>0x2011</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2294,11 +2158,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2320,11 +2180,7 @@
 	      <entry>V4L2_MBUS_FMT_YVYU8_1X16</entry>
 	      <entry>0x2012</entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2346,11 +2202,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2372,10 +2224,7 @@
 	      <entry>V4L2_MBUS_FMT_YDYUYDYV8_1X16</entry>
 	      <entry>0x2014</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2397,10 +2246,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2422,10 +2268,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2447,10 +2290,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2472,7 +2312,7 @@
 	      <entry>V4L2_MBUS_FMT_YUYV10_1X20</entry>
 	      <entry>0x200d</entry>
 	      <entry></entry>
-	      &dash-ent-10;
+	      &dash-ent-12;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2498,7 +2338,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
+	      &dash-ent-12;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2524,7 +2364,7 @@
 	      <entry>V4L2_MBUS_FMT_YVYU10_1X20</entry>
 	      <entry>0x200e</entry>
 	      <entry></entry>
-	      &dash-ent-10;
+	      &dash-ent-12;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2550,7 +2390,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-10;
+	      &dash-ent-12;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2576,6 +2416,8 @@
 	      <entry>V4L2_MBUS_FMT_YUV10_1X30</entry>
 	      <entry>0x2016</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2607,6 +2449,43 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-AYUV8-1X32">
+	      <entry>V4L2_MBUS_FMT_AYUV8_1X32</entry>
+	      <entry>0x2017</entry>
+	      <entry></entry>
+	      <entry>a<subscript>7</subscript></entry>
+	      <entry>a<subscript>6</subscript></entry>
+	      <entry>a<subscript>5</subscript></entry>
+	      <entry>a<subscript>4</subscript></entry>
+	      <entry>a<subscript>3</subscript></entry>
+	      <entry>a<subscript>2</subscript></entry>
+	      <entry>a<subscript>1</subscript></entry>
+	      <entry>a<subscript>0</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
 	  </tbody>
 	</tgroup>
       </table>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 6a8b715..07e7eea 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -22,8 +22,14 @@
 
 <!-- LinuxTV v4l-dvb repository. -->
 <!ENTITY v4l-dvb		"<ulink url='http://linuxtv.org/repo/'>http://linuxtv.org/repo/</ulink>">
+<!ENTITY dash-ent-8             "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
 <!ENTITY dash-ent-10            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
+<!ENTITY dash-ent-12            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
+<!ENTITY dash-ent-14            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
 <!ENTITY dash-ent-16            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
+<!ENTITY dash-ent-20            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
+<!ENTITY dash-ent-22            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
+<!ENTITY dash-ent-24            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
 ]>
 
 <book id="media_api">
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 6ee63d0..a960125 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -37,7 +37,7 @@
 enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_FIXED = 0x0001,
 
-	/* RGB - next is 0x100d */
+	/* RGB - next is 0x100e */
 	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
 	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
@@ -50,8 +50,9 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB888_1X24 = 0x100a,
 	V4L2_MBUS_FMT_RGB888_2X12_BE = 0x100b,
 	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
+	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
 
-	/* YUV (including grey) - next is 0x2017 */
+	/* YUV (including grey) - next is 0x2018 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
 	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
@@ -74,6 +75,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
 	V4L2_MBUS_FMT_YUV10_1X30 = 0x2016,
+	V4L2_MBUS_FMT_AYUV8_1X32 = 0x2017,
 
 	/* Bayer - next is 0x3019 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
-- 
1.8.1.5

