Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSsF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:05 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 5E0F8C0C2344
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:05 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 11/17] Fix asm compilation with cpp from gcc6
Date: Sat, 13 Feb 2016 19:47:32 +0100
Message-Id: <1455389258-13470-11-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add spaces between literal strings and macro args so that the args
are not seen as string suffixes.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 plugins/greedyh.asm                     | 46 ++++++++++----------
 plugins/greedyhmacros.h                 | 38 ++++++++---------
 plugins/tomsmocomp/SearchLoop0A.inc     |  6 +--
 plugins/tomsmocomp/SearchLoopBottom.inc | 24 +++++------
 plugins/tomsmocomp/SearchLoopEdgeA.inc  | 12 +++---
 plugins/tomsmocomp/SearchLoopEdgeA8.inc | 12 +++---
 plugins/tomsmocomp/SearchLoopOddA.inc   |  8 ++--
 plugins/tomsmocomp/SearchLoopOddA2.inc  |  4 +-
 plugins/tomsmocomp/SearchLoopOddA6.inc  | 12 +++---
 plugins/tomsmocomp/SearchLoopOddAH.inc  |  8 ++--
 plugins/tomsmocomp/SearchLoopOddAH2.inc |  4 +-
 plugins/tomsmocomp/SearchLoopTop.inc    | 66 ++++++++++++++---------------
 plugins/tomsmocomp/SearchLoopVA.inc     |  4 +-
 plugins/tomsmocomp/SearchLoopVAH.inc    |  4 +-
 plugins/tomsmocomp/StrangeBob.inc       | 74 ++++++++++++++++-----------------
 plugins/tomsmocomp/WierdBob.inc         | 34 +++++++--------
 plugins/tomsmocomp/tomsmocompmacros.h   | 66 ++++++++++++++---------------
 17 files changed, 211 insertions(+), 211 deletions(-)

diff --git a/plugins/greedyh.asm b/plugins/greedyh.asm
index 555fc0f..e73caf0 100644
--- a/plugins/greedyh.asm
+++ b/plugins/greedyh.asm
@@ -91,23 +91,23 @@ void FUNCT_NAME(TDeinterlaceInfo* pInfo)
         __asm__ __volatile__
             (
              // save ebx (-fPIC)
-	     MOVX" %%"XBX", %[oldbx]\n\t"
+	     MOVX " %%" XBX ", %[oldbx]\n\t"
 
-             MOVX"  %[L1],          %%"XAX"\n\t"
-             LEAX"  8(%%"XAX"),     %%"XBX"\n\t"    // next qword needed by DJR
-             MOVX"  %[L3],          %%"XCX"\n\t"
-             SUBX"  %%"XAX",        %%"XCX"\n\t"    // carry L3 addr as an offset
-             MOVX"  %[L2P],         %%"XDX"\n\t"
-             MOVX"  %[L2],          %%"XSI"\n\t"
-             MOVX"  %[Dest],        %%"XDI"\n\t"    // DL1 if Odd or DL2 if Even
+             MOVX "  %[L1],          %%" XAX "\n\t"
+             LEAX "  8(%%" XAX "),     %%" XBX "\n\t"    // next qword needed by DJR
+             MOVX "  %[L3],          %%" XCX "\n\t"
+             SUBX "  %%" XAX ",        %%" XCX "\n\t"    // carry L3 addr as an offset
+             MOVX "  %[L2P],         %%" XDX "\n\t"
+             MOVX "  %[L2],          %%" XSI "\n\t"
+             MOVX "  %[Dest],        %%" XDI "\n\t"    // DL1 if Odd or DL2 if Even
 
              ".align 8\n\t"
              "1:\n\t"
 
-             "movq  (%%"XSI"),      %%mm0\n\t"      // L2 - the newest weave pixel value
-             "movq  (%%"XAX"),      %%mm1\n\t"      // L1 - the top pixel
-             "movq  (%%"XDX"),      %%mm2\n\t"      // L2P - the prev weave pixel
-             "movq  (%%"XAX", %%"XCX"), %%mm3\n\t"  // L3, next odd row
+             "movq  (%%" XSI "),      %%mm0\n\t"      // L2 - the newest weave pixel value
+             "movq  (%%" XAX "),      %%mm1\n\t"      // L1 - the top pixel
+             "movq  (%%" XDX "),      %%mm2\n\t"      // L2P - the prev weave pixel
+             "movq  (%%" XAX ", %%" XCX "), %%mm3\n\t"  // L3, next odd row
              "movq  %%mm1,          %%mm6\n\t"      // L1 - get simple single pixel interp
              //	pavgb   mm6, mm3                    // use macro below
              V_PAVGB ("%%mm6", "%%mm3", "%%mm4", "%[ShiftMask]")
@@ -124,9 +124,9 @@ void FUNCT_NAME(TDeinterlaceInfo* pInfo)
              "psllq $16,            %%mm7\n\t"      // left justify 3 pixels
              "por   %%mm7,          %%mm4\n\t"      // and combine
 
-             "movq  (%%"XBX"),      %%mm5\n\t"      // next horiz qword from L1
+             "movq  (%%" XBX "),      %%mm5\n\t"      // next horiz qword from L1
              //			pavgb   mm5, qword ptr[ebx+ecx] // next horiz qword from L3, use macro below
-             V_PAVGB ("%%mm5", "(%%"XBX",%%"XCX")", "%%mm7", "%[ShiftMask]")
+             V_PAVGB ("%%mm5", "(%%" XBX ",%%" XCX ")", "%%mm7", "%[ShiftMask]")
              "psllq $48,            %%mm5\n\t"      // left just 1 pixel
              "movq  %%mm6,          %%mm7\n\t"      // another copy of simple bob pixel
              "psrlq $16,            %%mm7\n\t"      // right just 3 pixels
@@ -224,23 +224,23 @@ void FUNCT_NAME(TDeinterlaceInfo* pInfo)
              "pand    %[UVMask],    %%mm2\n\t"      // keep chroma
              "por     %%mm4,        %%mm2\n\t"      // and combine
 
-             V_MOVNTQ ("(%%"XDI")", "%%mm2")        // move in our clipped best, use macro
+             V_MOVNTQ ("(%%" XDI ")", "%%mm2")        // move in our clipped best, use macro
 
              // bump ptrs and loop
-             LEAX"    8(%%"XAX"),   %%"XAX"\n\t"
-             LEAX"    8(%%"XBX"),   %%"XBX"\n\t"
-             LEAX"    8(%%"XDX"),   %%"XDX"\n\t"
-             LEAX"    8(%%"XDI"),   %%"XDI"\n\t"
-             LEAX"    8(%%"XSI"),   %%"XSI"\n\t"
-             DECX"    %[LoopCtr]\n\t"
+             LEAX "    8(%%" XAX "),   %%" XAX "\n\t"
+             LEAX "    8(%%" XBX "),   %%" XBX "\n\t"
+             LEAX "    8(%%" XDX "),   %%" XDX "\n\t"
+             LEAX "    8(%%" XDI "),   %%" XDI "\n\t"
+             LEAX "    8(%%" XSI "),   %%" XSI "\n\t"
+             DECX "    %[LoopCtr]\n\t"
              "jg      1b\n\t"                       // loop if not to last line
                                                     // note P-III default assumes backward branches taken
              "jl      1f\n\t"                       // done
-             MOVX"    %%"XAX",      %%"XBX"\n\t"  // sharpness lookahead 1 byte only, be wrong on 1
+             MOVX "    %%" XAX ",      %%" XBX "\n\t"  // sharpness lookahead 1 byte only, be wrong on 1
              "jmp     1b\n\t"
 
              "1:\n\t"
-	     MOVX" %[oldbx], %%"XBX"\n\t"
+	     MOVX " %[oldbx], %%" XBX "\n\t"
 
              : /* no outputs */
 
diff --git a/plugins/greedyhmacros.h b/plugins/greedyhmacros.h
index 5f65959..3e27a66 100644
--- a/plugins/greedyhmacros.h
+++ b/plugins/greedyhmacros.h
@@ -27,23 +27,23 @@
 //      V_PAVGB(mmr1, mmr2, mmr work register, smask) mmr2 may = mmrw if you can trash it
 
 #define V_PAVGB_MMX(mmr1, mmr2, mmrw, smask) \
-	"movq    "mmr2",  "mmrw"\n\t"            \
-	"pand    "smask", "mmrw"\n\t"            \
-	"psrlw   $1,      "mmrw"\n\t"            \
-	"pand    "smask", "mmr1"\n\t"            \
-	"psrlw   $1,      "mmr1"\n\t"            \
-	"paddusb "mmrw",  "mmr1"\n\t"
-#define V_PAVGB_SSE(mmr1, mmr2, mmrw, smask)      "pavgb   "mmr2", "mmr1"\n\t"
-#define V_PAVGB_3DNOW(mmr1, mmr2, mmrw, smask)    "pavgusb "mmr2", "mmr1"\n\t"
+	"movq    " mmr2 ",  " mmrw "\n\t"    \
+	"pand    " smask ", " mmrw "\n\t"    \
+	"psrlw   $1,        " mmrw "\n\t"    \
+	"pand    " smask ", " mmr1 "\n\t"    \
+	"psrlw   $1,        " mmr1 "\n\t"    \
+	"paddusb " mmrw ",  " mmr1 "\n\t"
+#define V_PAVGB_SSE(mmr1, mmr2, mmrw, smask)      "pavgb   " mmr2 ", " mmr1 "\n\t"
+#define V_PAVGB_3DNOW(mmr1, mmr2, mmrw, smask)    "pavgusb " mmr2 ", " mmr1 "\n\t"
 #define V_PAVGB(mmr1, mmr2, mmrw, smask)          V_PAVGB2(mmr1, mmr2, mmrw, smask, SSE_TYPE) 
 #define V_PAVGB2(mmr1, mmr2, mmrw, smask, ssetyp) V_PAVGB3(mmr1, mmr2, mmrw, smask, ssetyp) 
 #define V_PAVGB3(mmr1, mmr2, mmrw, smask, ssetyp) V_PAVGB_##ssetyp(mmr1, mmr2, mmrw, smask) 
 
 // some macros for pmaxub instruction
 #define V_PMAXUB_MMX(mmr1, mmr2) \
-    "psubusb "mmr2", "mmr1"\n\t" \
-    "paddusb "mmr2", "mmr1"\n\t"
-#define V_PMAXUB_SSE(mmr1, mmr2)      "pmaxub "mmr2", "mmr1"\n\t"
+    "psubusb " mmr2 ", " mmr1 "\n\t" \
+    "paddusb " mmr2 ", " mmr1 "\n\t"
+#define V_PMAXUB_SSE(mmr1, mmr2)      "pmaxub " mmr2 ", " mmr1 "\n\t"
 #define V_PMAXUB_3DNOW(mmr1, mmr2)    V_PMAXUB_MMX(mmr1, mmr2)  // use MMX version
 #define V_PMAXUB(mmr1, mmr2)          V_PMAXUB2(mmr1, mmr2, SSE_TYPE) 
 #define V_PMAXUB2(mmr1, mmr2, ssetyp) V_PMAXUB3(mmr1, mmr2, ssetyp) 
@@ -52,11 +52,11 @@
 // some macros for pminub instruction
 //      V_PMINUB(mmr1, mmr2, mmr work register)     mmr2 may NOT = mmrw
 #define V_PMINUB_MMX(mmr1, mmr2, mmrw) \
-    "pcmpeqb "mmrw", "mmrw"\n\t"       \
-    "psubusb "mmr2", "mmrw"\n\t"       \
-    "paddusb "mmrw", "mmr1"\n\t"       \
-    "psubusb "mmrw", "mmr1"\n\t"
-#define V_PMINUB_SSE(mmr1, mmr2, mmrw)      "pminub "mmr2", "mmr1"\n\t"
+    "pcmpeqb " mmrw ", " mmrw "\n\t"   \
+    "psubusb " mmr2 ", " mmrw "\n\t"   \
+    "paddusb " mmrw ", " mmr1 "\n\t"   \
+    "psubusb " mmrw ", " mmr1 "\n\t"
+#define V_PMINUB_SSE(mmr1, mmr2, mmrw)      "pminub " mmr2 ", " mmr1 "\n\t"
 #define V_PMINUB_3DNOW(mmr1, mmr2, mmrw)    V_PMINUB_MMX(mmr1, mmr2, mmrw)  // use MMX version
 #define V_PMINUB(mmr1, mmr2, mmrw)          V_PMINUB2(mmr1, mmr2, mmrw, SSE_TYPE) 
 #define V_PMINUB2(mmr1, mmr2, mmrw, ssetyp) V_PMINUB3(mmr1, mmr2, mmrw, ssetyp) 
@@ -64,9 +64,9 @@
 
 // some macros for movntq instruction
 //      V_MOVNTQ(mmr1, mmr2) 
-#define V_MOVNTQ_MMX(mmr1, mmr2)      "movq   "mmr2", "mmr1"\n\t"
-#define V_MOVNTQ_3DNOW(mmr1, mmr2)    "movq   "mmr2", "mmr1"\n\t"
-#define V_MOVNTQ_SSE(mmr1, mmr2)      "movntq "mmr2", "mmr1"\n\t"
+#define V_MOVNTQ_MMX(mmr1, mmr2)      "movq   " mmr2 ", " mmr1 "\n\t"
+#define V_MOVNTQ_3DNOW(mmr1, mmr2)    "movq   " mmr2 ", " mmr1 "\n\t"
+#define V_MOVNTQ_SSE(mmr1, mmr2)      "movntq " mmr2 ", " mmr1 "\n\t"
 #define V_MOVNTQ(mmr1, mmr2)          V_MOVNTQ2(mmr1, mmr2, SSE_TYPE) 
 #define V_MOVNTQ2(mmr1, mmr2, ssetyp) V_MOVNTQ3(mmr1, mmr2, ssetyp) 
 #define V_MOVNTQ3(mmr1, mmr2, ssetyp) V_MOVNTQ_##ssetyp(mmr1, mmr2)
diff --git a/plugins/tomsmocomp/SearchLoop0A.inc b/plugins/tomsmocomp/SearchLoop0A.inc
index b1d9aec..15537f5 100644
--- a/plugins/tomsmocomp/SearchLoop0A.inc
+++ b/plugins/tomsmocomp/SearchLoop0A.inc
@@ -7,9 +7,9 @@
 // up by a little, and adjust later
 
 #ifdef IS_SSE2
-		"paddusb "_ONES", %%xmm7\n\t"				// bias toward no motion
+		"paddusb " _ONES ", %%xmm7\n\t"				// bias toward no motion
 #else
-		"paddusb "_ONES", %%mm7\n\t" 				// bias toward no motion
+		"paddusb " _ONES ", %%mm7\n\t" 				// bias toward no motion
 #endif
 
-        MERGE4PIXavg("(%%"XDI", %%"XCX")", "(%%"XSI", %%"XCX")")  // center, in old and new
+        MERGE4PIXavg("(%%" XDI ", %%" XCX ")", "(%%" XSI ", %%" XCX ")")  // center, in old and new
diff --git a/plugins/tomsmocomp/SearchLoopBottom.inc b/plugins/tomsmocomp/SearchLoopBottom.inc
index 3036e47..ba78964 100644
--- a/plugins/tomsmocomp/SearchLoopBottom.inc
+++ b/plugins/tomsmocomp/SearchLoopBottom.inc
@@ -18,7 +18,7 @@
             // Use the best weave if diffs less than 10 as that
             // means the image is still or moving cleanly
             // if there is motion we will clip which will catch anything
-            "psubusb "_FOURS", %%mm7\n\t"          // sets bits to zero if weave diff < 4
+            "psubusb " _FOURS ", %%mm7\n\t"          // sets bits to zero if weave diff < 4
             "pxor    %%mm0, %%mm0\n\t"
             "pcmpeqb %%mm0, %%mm7\n\t"            // all ff where weave better, else 00
             "pcmpeqb %%mm7, %%mm0\n\t"            // all ff where bob better, else 00
@@ -31,7 +31,7 @@
             V_PMINUB ("%%mm4", _TENS, "%%mm0")   // the most we care about
             
             "psubusb %%mm4, %%mm7\n\t"            // foregive that much from weave est?
-            "psubusb "_FOURS", %%mm7\n\t"       // bias it a bit toward weave
+            "psubusb " _FOURS ", %%mm7\n\t"       // bias it a bit toward weave
             "pxor    %%mm0, %%mm0\n\t"
             "pcmpeqb %%mm0, %%mm7\n\t"            // all ff where weave better, else 00
             "pcmpeqb %%mm7, %%mm0\n\t"            // all ff where bob better, else 00
@@ -49,31 +49,31 @@
 #endif
 
 
-            MOVX"     "_pDest", %%"XAX"\n\t"
+            MOVX "     " _pDest ", %%" XAX "\n\t"
                 
 #ifdef USE_VERTICAL_FILTER
             "movq    %%mm0, %%mm1\n\t"
             //      pavgb   mm0, qword ptr["XBX"]
-            V_PAVGB ("%%mm0", "(%%"XBX")", "%%mm2", _ShiftMask)
+            V_PAVGB ("%%mm0", "(%%" XBX ")", "%%mm2", _ShiftMask)
             //      movntq  qword ptr["XAX"+"XDX"], mm0
-            V_MOVNTQ ("(%"XAX", %%"XDX")", "%%mm0")
+            V_MOVNTQ ("(%" XAX ", %%" XDX ")", "%%mm0")
             //      pavgb   mm1, qword ptr["XBX"+"XCX"]
-            V_PAVGB ("%%mm1", "(%%"XBX", %%"XCX")", "%%mm2", _ShiftMask)
-            "addq   "_dst_pitchw", %%"XBX
+            V_PAVGB ("%%mm1", "(%%" XBX ", %%" XCX ")", "%%mm2", _ShiftMask)
+            "addq   " _dst_pitchw ", %%"XBX
             //      movntq  qword ptr["XAX"+"XDX"], mm1
-            V_MOVNTQ ("(%%"XAX", %%"XDX")", "%%mm1")
+            V_MOVNTQ ("(%%" XAX ", %%" XDX ")", "%%mm1")
 #else
                 
             //      movntq  qword ptr["XAX"+"XDX"], mm0
-                V_MOVNTQ ("(%%"XAX", %%"XDX")", "%%mm0")
+                V_MOVNTQ ("(%%" XAX ", %%" XDX ")", "%%mm0")
 #endif
                 
-           LEAX"    8(%%"XDX"), %%"XDX"\n\t"       // bump offset pointer
-           CMPX"    "_Last8", %%"XDX"\n\t"       // done with line?
+           LEAX "    8(%%" XDX "), %%" XDX "\n\t"       // bump offset pointer
+           CMPX "    " _Last8 ", %%" XDX "\n\t"       // done with line?
            "jb      1b\n\t"                    // y
 #endif
 
-           MOVX" "_oldbx", %%"XBX"\n\t"
+           MOVX " " _oldbx ", %%" XBX "\n\t"
 
         : /* no outputs */
 
diff --git a/plugins/tomsmocomp/SearchLoopEdgeA.inc b/plugins/tomsmocomp/SearchLoopEdgeA.inc
index 6208fe8..512d60e 100644
--- a/plugins/tomsmocomp/SearchLoopEdgeA.inc
+++ b/plugins/tomsmocomp/SearchLoopEdgeA.inc
@@ -3,9 +3,9 @@
 // Searches 2 pixel to the left and right, in both the old
 //  and new fields, but takes averages. These are even
 // pixel addresses. Chroma match will be used. (YUY2)
-        MERGE4PIXavg("-4(%%"XDI")", "4(%%"XSI", %%"XCX", 2)")  // up left, down right
-        MERGE4PIXavg("4(%%"XDI")", "-4(%%"XSI", %%"XCX", 2)")  // up right, down left
-        MERGE4PIXavg("-4(%%"XDI", %%"XCX")", "4(%%"XSI", %%"XCX")") // left, right
-        MERGE4PIXavg("4(%%"XDI", %%"XCX")", "-4(%%"XSI", %%"XCX")") // right, left
-        MERGE4PIXavg("-4(%%"XDI", %%"XCX", 2)", "4(%%"XSI")")   // down left, up right
-        MERGE4PIXavg("4(%%"XDI", %%"XCX", 2)", "-4(%%"XSI")")   // down right, up left
+        MERGE4PIXavg("-4(%%" XDI ")", "4(%%" XSI ", %%" XCX ", 2)")  // up left, down right
+        MERGE4PIXavg("4(%%" XDI ")", "-4(%%" XSI ", %%" XCX ", 2)")  // up right, down left
+        MERGE4PIXavg("-4(%%" XDI ", %%" XCX ")", "4(%%" XSI ", %%" XCX ")") // left, right
+        MERGE4PIXavg("4(%%" XDI ", %%" XCX ")", "-4(%%" XSI ", %%" XCX ")") // right, left
+        MERGE4PIXavg("-4(%%" XDI ", %%" XCX ", 2)", "4(%%" XSI ")")   // down left, up right
+        MERGE4PIXavg("4(%%" XDI ", %%" XCX ", 2)", "-4(%%" XSI ")")   // down right, up left
diff --git a/plugins/tomsmocomp/SearchLoopEdgeA8.inc b/plugins/tomsmocomp/SearchLoopEdgeA8.inc
index 2841c3f..3a21b7b 100644
--- a/plugins/tomsmocomp/SearchLoopEdgeA8.inc
+++ b/plugins/tomsmocomp/SearchLoopEdgeA8.inc
@@ -3,10 +3,10 @@
 // Searches 4 pixel to the left and right, in both the old
 //  and new fields, but takes averages. These are even
 // pixel addresses. Chroma match will be used. (YUY2)
-        MERGE4PIXavg("-8(%%"XDI")", "8(%%"XSI", %%"XCX", 2)")  // up left, down right
-        MERGE4PIXavg("8(%%"XDI")", "-8(%%"XSI", %%"XCX", 2)")  // up right, down left
-        MERGE4PIXavg("-8(%%"XDI", %%"XCX")", "8(%%"XSI", %%"XCX")") // left, right
-        MERGE4PIXavg("8(%%"XDI", %%"XCX")", "-8(%%"XSI", %%"XCX")") // right, left
-        MERGE4PIXavg("-8(%%"XDI", %%"XCX", 2)", "8(%%"XSI")")   // down left, up right
-        MERGE4PIXavg("8(%%"XDI", %%"XCX", 2)", "-8(%%"XSI")")   // down right, up left
+        MERGE4PIXavg("-8(%%" XDI ")", "8(%%" XSI ", %%" XCX ", 2)")  // up left, down right
+        MERGE4PIXavg("8(%%" XDI ")", "-8(%%" XSI ", %%" XCX ", 2)")  // up right, down left
+        MERGE4PIXavg("-8(%%" XDI ", %%" XCX ")", "8(%%" XSI ", %%" XCX ")") // left, right
+        MERGE4PIXavg("8(%%" XDI ", %%" XCX ")", "-8(%%" XSI ", %%" XCX ")") // right, left
+        MERGE4PIXavg("-8(%%" XDI ", %%" XCX ", 2)", "8(%%" XSI ")")   // down left, up right
+        MERGE4PIXavg("8(%%" XDI ", %%" XCX ", 2)", "-8(%%" XSI ")")   // down right, up left
 
diff --git a/plugins/tomsmocomp/SearchLoopOddA.inc b/plugins/tomsmocomp/SearchLoopOddA.inc
index ab5375f..d7ae821 100644
--- a/plugins/tomsmocomp/SearchLoopOddA.inc
+++ b/plugins/tomsmocomp/SearchLoopOddA.inc
@@ -3,8 +3,8 @@
 // Searches 1 pixel to the left and right, in both the old
 //  and new fields, but takes averages. These are odd
 // pixel addresses. Any chroma match will not be used. (YUY2)
-        MERGE4PIXavg("-2(%%"XDI")", "2(%%"XSI", %%"XCX", 2)")  // up left, down right
-        MERGE4PIXavg("2(%%"XDI")", "-2(%%"XSI", %%"XCX", 2)")  // up right, down left
-        MERGE4PIXavg("-2(%%"XDI", %%"XCX", 2)", "2(%%"XSI")")   // down left, up right
-        MERGE4PIXavg("2(%%"XDI", %%"XCX", 2)", "-2(%%"XSI")")   // down right, up left   
+        MERGE4PIXavg("-2(%%" XDI ")", "2(%%" XSI ", %%" XCX ", 2)")  // up left, down right
+        MERGE4PIXavg("2(%%" XDI ")", "-2(%%" XSI ", %%" XCX ", 2)")  // up right, down left
+        MERGE4PIXavg("-2(%%" XDI ", %%" XCX ", 2)", "2(%%" XSI ")")   // down left, up right
+        MERGE4PIXavg("2(%%" XDI ", %%" XCX ", 2)", "-2(%%" XSI ")")   // down right, up left   
 #include "SearchLoopOddA2.inc"
diff --git a/plugins/tomsmocomp/SearchLoopOddA2.inc b/plugins/tomsmocomp/SearchLoopOddA2.inc
index fd3f6fb..8882a51 100644
--- a/plugins/tomsmocomp/SearchLoopOddA2.inc
+++ b/plugins/tomsmocomp/SearchLoopOddA2.inc
@@ -1,5 +1,5 @@
 // Searches 1 pixel to the left and right, in both the old
 // and new fields, but takes averages. These are odd
 // pixel addresses. Any chroma match will not be used. (YUY2)
-        MERGE4PIXavg("-2(%%"XDI", %%"XCX")", "2(%%"XSI", %%"XCX")") // left, right
-        MERGE4PIXavg("2(%%"XDI", %%"XCX")", "-2(%%"XSI", %%"XCX")") // right, left
+        MERGE4PIXavg("-2(%%" XDI ", %%" XCX ")", "2(%%" XSI ", %%" XCX ")") // left, right
+        MERGE4PIXavg("2(%%" XDI ", %%" XCX ")", "-2(%%" XSI ", %%" XCX ")") // right, left
diff --git a/plugins/tomsmocomp/SearchLoopOddA6.inc b/plugins/tomsmocomp/SearchLoopOddA6.inc
index cbae014..c3f94e2 100644
--- a/plugins/tomsmocomp/SearchLoopOddA6.inc
+++ b/plugins/tomsmocomp/SearchLoopOddA6.inc
@@ -3,9 +3,9 @@
 // Searches 3 pixels to the left and right, in both the old
 //  and new fields, but takes averages. These are odd
 // pixel addresses. Any chroma match will not be used. (YUY2)
-        MERGE4PIXavg("-6(%%"XDI")", "6(%%"XSI", %%"XCX", 2)")  // up left, down right
-        MERGE4PIXavg("6(%%"XDI")", "-6(%%"XSI", %%"XCX", 2)")  // up right, down left
-        MERGE4PIXavg("-6(%%"XDI", %%"XCX")", "6(%%"XSI", %%"XCX")") // left, right
-        MERGE4PIXavg("6(%%"XDI", %%"XCX")", "-6(%%"XSI", %%"XCX")") // right, left
-        MERGE4PIXavg("-6(%%"XDI", %%"XCX", 2)", "6(%%"XSI")")   // down left, up right
-        MERGE4PIXavg("6(%%"XDI", %%"XCX", 2)", "-6(%%"XSI")")   // down right, up left
+        MERGE4PIXavg("-6(%%" XDI ")", "6(%%" XSI ", %%" XCX ", 2)")  // up left, down right
+        MERGE4PIXavg("6(%%" XDI ")", "-6(%%" XSI ", %%" XCX ", 2)")  // up right, down left
+        MERGE4PIXavg("-6(%%" XDI ", %%" XCX ")", "6(%%" XSI ", %%" XCX ")") // left, right
+        MERGE4PIXavg("6(%%" XDI ", %%" XCX ")", "-6(%%" XSI ", %%" XCX ")") // right, left
+        MERGE4PIXavg("-6(%%" XDI ", %%" XCX ", 2)", "6(%%" XSI ")")   // down left, up right
+        MERGE4PIXavg("6(%%" XDI ", %%" XCX ", 2)", "-6(%%" XSI ")")   // down right, up left
diff --git a/plugins/tomsmocomp/SearchLoopOddAH.inc b/plugins/tomsmocomp/SearchLoopOddAH.inc
index e59e3c7..2f451a9 100644
--- a/plugins/tomsmocomp/SearchLoopOddAH.inc
+++ b/plugins/tomsmocomp/SearchLoopOddAH.inc
@@ -3,8 +3,8 @@
 // pixel addresses. Any chroma match will not be used. (YUY2)
 		__asm
 		{
-        MERGE4PIXavgH("XDI"-2, "XDI"+"XCX"-2, "XSI"+"XCX"+2, "XSI"+2*"XCX"+2)  // up left, down right
-        MERGE4PIXavgH("XDI"+2, "XDI"+"XCX"+2, "XSI"+"XCX"-2, "XSI"+2*"XCX"-2)   // up right, down left
-        MERGE4PIXavgH("XDI"+2*"XCX"-2, "XDI"+"XCX"-2, "XSI"+"XCX"+2, "XSI"+2)   // down left, up right
-        MERGE4PIXavgH("XDI"+2*"XCX"+2, "XDI"+"XCX"+2, "XSI"+"XCX"-2, "XSI"-2)   // down right, up left   
+        MERGE4PIXavgH(" XDI "-2, " XDI "+" XCX "-2, " XSI "+" XCX "+2, " XSI "+2*" XCX "+2)  // up left, down right
+        MERGE4PIXavgH(" XDI "+2, " XDI "+" XCX "+2, " XSI "+" XCX "-2, " XSI "+2*" XCX "-2)   // up right, down left
+        MERGE4PIXavgH(" XDI "+2*" XCX "-2, " XDI "+" XCX "-2, " XSI "+" XCX "+2, " XSI "+2)   // down left, up right
+        MERGE4PIXavgH(" XDI "+2*" XCX "+2, " XDI "+" XCX "+2, " XSI "+" XCX "-2, " XSI "-2)   // down right, up left   
 		}
diff --git a/plugins/tomsmocomp/SearchLoopOddAH2.inc b/plugins/tomsmocomp/SearchLoopOddAH2.inc
index cd7d812..b7cf2d3 100644
--- a/plugins/tomsmocomp/SearchLoopOddAH2.inc
+++ b/plugins/tomsmocomp/SearchLoopOddAH2.inc
@@ -1,5 +1,5 @@
 // Searches 1 pixel to the left and right, in both the old
 //  and new fields, but takes vertical averages. These are odd
 // pixel addresses. Any chroma match will not be used. (YUY2)
-     MERGE4PIXavgH("-2(%%"XDI", %%"XCX")", "(%%"XDI", %%"XCX")", "(%%"XSI", %%"XCX")", "2(%%"XSI", %%"XCX")") // left, right
-     MERGE4PIXavgH("2(%%"XDI", %%"XCX")", "(%%"XDI", %%"XCX")", "(%%"XSI", %%"XCX")", "-2(%%"XSI", %%"XCX")") // right, left
+     MERGE4PIXavgH("-2(%%" XDI ", %%" XCX ")", "(%%" XDI ", %%" XCX ")", "(%%" XSI ", %%" XCX ")", "2(%%" XSI ", %%" XCX ")") // left, right
+     MERGE4PIXavgH("2(%%" XDI ", %%" XCX ")", "(%%" XDI ", %%" XCX ")", "(%%" XSI ", %%" XCX ")", "-2(%%" XSI ", %%" XCX ")") // right, left
diff --git a/plugins/tomsmocomp/SearchLoopTop.inc b/plugins/tomsmocomp/SearchLoopTop.inc
index 2d7a463..905172e 100644
--- a/plugins/tomsmocomp/SearchLoopTop.inc
+++ b/plugins/tomsmocomp/SearchLoopTop.inc
@@ -107,7 +107,7 @@ long		dst_pitchw = dst_pitch; // local stor so asm can ref
              // XSI - next weave pixels, 1 line up
 
              // Save "XBX" (-fPIC)
-	     MOVX" %%"XBX", "_oldbx"\n\t"
+	     MOVX " %%" XBX ", " _oldbx "\n\t"
              
 #ifdef IS_SSE2
              
@@ -115,60 +115,60 @@ long		dst_pitchw = dst_pitch; // local stor so asm can ref
 
 #else
              // simple bob first 8 bytes
-             MOVX"	"_pBob",        %%"XBX"\n\t"
-             MOVX"	"_src_pitch2",  %%"XCX"\n\t"
+             MOVX "	" _pBob ",        %%" XBX "\n\t"
+             MOVX "	" _src_pitch2 ",  %%" XCX "\n\t"
 
 #ifdef USE_VERTICAL_FILTER
-             "movq	    (%%"XBX"),        %%mm0\n\t"
-             "movq	    (%%"XBX", %%"XCX"), %%mm1\n\t" //, qword ptr["XBX"+"XCX"]
+             "movq	    (%%" XBX "),        %%mm0\n\t"
+             "movq	    (%%" XBX ", %%" XCX "), %%mm1\n\t" //, qword ptr["XBX"+"XCX"]
              "movq	    %%mm0,          %%mm2\n\t"
              V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)		// halfway between
              V_PAVGB ("%%mm0", "%%mm2", "%%mm3", _ShiftMask)		// 1/4 way
              V_PAVGB ("%%mm1", "%%mm2", "%%mm3", _ShiftMask)		// 3/4 way
-             MOVX"		"_pDest",       %%"XDI"\n\t"
-             MOVX"		"_dst_pitchw",  %%"XAX"\n\t"
-             V_MOVNTQ	("(%%"XDI")", "%%mm0")
-             V_MOVNTQ	("(%%"XDI", %%"XAX")", "%%mm1") // qword ptr["XDI"+"XAX"], mm1
+             MOVX "		" _pDest ",       %%" XDI "\n\t"
+             MOVX "		" _dst_pitchw ",  %%" XAX "\n\t"
+             V_MOVNTQ	("(%%" XDI ")", "%%mm0")
+             V_MOVNTQ	("(%%" XDI ", %%" XAX ")", "%%mm1") // qword ptr["XDI"+"XAX"], mm1
 
              // simple bob last 8 bytes
-             MOVX"		"_Last8", %%"XDX"\n\t"
-             LEAX"		(%%"XBX", %%"XDX"), %%"XSI"\n\t"  // ["XBX"+"XDX"]
-             "movq	    (%%"XSI"), %%mm0\n\t"
-             "movq	    (%%"XSI", %%"XCX"), %%mm1\n\t"    // qword ptr["XSI"+"XCX"]
+             MOVX "		" _Last8 ", %%" XDX "\n\t"
+             LEAX "		(%%" XBX ", %%" XDX "), %%" XSI "\n\t"  // ["XBX"+"XDX"]
+             "movq	    (%%" XSI "), %%mm0\n\t"
+             "movq	    (%%" XSI ", %%" XCX "), %%mm1\n\t"    // qword ptr["XSI"+"XCX"]
              "movq	    %%mm0, %%mm2\n\t"
              V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)		// halfway between
              V_PAVGB ("%%mm0", "%%mm2", "%%mm3", _ShiftMask)		// 1/4 way
              V_PAVGB ("%%mm1", "%%mm2", "%%mm3", _ShiftMask)		// 3/4 way
-             ADDX"		%%"XDX", %%"XDI"\n\t"						// last 8 bytes of dest
-             V_MOVNTQ	("%%"XDI"", "%%mm0")
-             V_MOVNTQ	("(%%"XDI", %%"XAX")", "%%mm1") // qword ptr["XDI"+"XAX"], mm1)
+             ADDX "		%%" XDX ", %%" XDI "\n\t"						// last 8 bytes of dest
+             V_MOVNTQ	("%%" XDI "", "%%mm0")
+             V_MOVNTQ	("(%%" XDI ", %%" XAX ")", "%%mm1") // qword ptr["XDI"+"XAX"], mm1)
 
 #else
-             "movq	(%%"XBX"), %%mm0\n\t"
+             "movq	(%%" XBX "), %%mm0\n\t"
              //		pavgb	mm0, qword ptr["XBX"+"XCX"]
-             V_PAVGB ("%%mm0", "(%%"XBX", %%"XCX")", "%%mm2", _ShiftMask) // qword ptr["XBX"+"XCX"], mm2, ShiftMask)
-             MOVX"		"_pDest", %%"XDI"\n\t"
-             V_MOVNTQ	("(%%"XDI")", "%%mm0")
+             V_PAVGB ("%%mm0", "(%%" XBX ", %%" XCX ")", "%%mm2", _ShiftMask) // qword ptr["XBX"+"XCX"], mm2, ShiftMask)
+             MOVX "		" _pDest ", %%" XDI "\n\t"
+             V_MOVNTQ	("(%%" XDI ")", "%%mm0")
 
              // simple bob last 8 bytes
-             MOVX"		"_Last8", %%"XDX"\n\t"
-             LEAX"		(%%"XBX", %%"XDX"), %%"XSI"\n\t" //"XSI", ["XBX"+"XDX"]
-             "movq	    (%%"XSI"), %%mm0\n\t"
+             MOVX "		" _Last8 ", %%" XDX "\n\t"
+             LEAX "		(%%" XBX ", %%" XDX "), %%" XSI "\n\t" //"XSI", ["XBX"+"XDX"]
+             "movq	    (%%" XSI "), %%mm0\n\t"
              //		pavgb	mm0, qword ptr["XSI"+"XCX"]
-             V_PAVGB	("%%mm0", "(%%"XSI", %%"XCX")", "%%mm2", _ShiftMask) // qword ptr["XSI"+"XCX"], mm2, ShiftMask)
-             V_MOVNTQ	("(%%"XDI", %%"XDX")", "%%mm0") // qword ptr["XDI"+"XDX"], mm0)
+             V_PAVGB	("%%mm0", "(%%" XSI ", %%" XCX ")", "%%mm2", _ShiftMask) // qword ptr["XSI"+"XCX"], mm2, ShiftMask)
+             V_MOVNTQ	("(%%" XDI ", %%" XDX ")", "%%mm0") // qword ptr["XDI"+"XDX"], mm0)
 #endif
              // now loop and get the middle qwords
-             MOVX"		"_pSrc", %%"XSI"\n\t"
-             MOVX"		"_pSrcP", %%"XDI"\n\t"
-             MOVX"		$8, %%"XDX"\n\t"				// curr offset longo all lines
+             MOVX "		" _pSrc ", %%" XSI "\n\t"
+             MOVX "		" _pSrcP ", %%" XDI "\n\t"
+             MOVX "		$8, %%" XDX "\n\t"				// curr offset longo all lines
 
              "1:\n\t"	
-             MOVX"		"_pBobP", %%"XAX"\n\t"
-             ADDX"		$8, %%"XDI"\n\t"
-             ADDX"		$8, %%"XSI"\n\t"
-             ADDX"		$8, %%"XBX"\n\t"
-             ADDX"		%%"XDX", %%"XAX"\n\t"
+             MOVX "		" _pBobP ", %%" XAX "\n\t"
+             ADDX "		$8, %%" XDI "\n\t"
+             ADDX "		$8, %%" XSI "\n\t"
+             ADDX "		$8, %%" XBX "\n\t"
+             ADDX "		%%" XDX ", %%" XAX "\n\t"
 
 #ifdef USE_STRANGE_BOB
 #include "StrangeBob.inc"
diff --git a/plugins/tomsmocomp/SearchLoopVA.inc b/plugins/tomsmocomp/SearchLoopVA.inc
index 3e3d19b..1ad3f18 100644
--- a/plugins/tomsmocomp/SearchLoopVA.inc
+++ b/plugins/tomsmocomp/SearchLoopVA.inc
@@ -2,5 +2,5 @@
 
 // Searches the center vertical line above center and below, in both the old 
 // and new fields, but takes averages.  These are even pixel addresses.
-        MERGE4PIXavg("(%%"XDI", %%"XCX", 2)", "(%%"XSI")")	// down, up
-        MERGE4PIXavg("(%%"XDI")", "(%%"XSI", %%"XCX", 2)")	// up, down
+        MERGE4PIXavg("(%%" XDI ", %%" XCX ", 2)", "(%%" XSI ")")	// down, up
+        MERGE4PIXavg("(%%" XDI ")", "(%%" XSI ", %%" XCX ", 2)")	// up, down
diff --git a/plugins/tomsmocomp/SearchLoopVAH.inc b/plugins/tomsmocomp/SearchLoopVAH.inc
index 33155bc..d138cf9 100644
--- a/plugins/tomsmocomp/SearchLoopVAH.inc
+++ b/plugins/tomsmocomp/SearchLoopVAH.inc
@@ -2,5 +2,5 @@
 
 // Searches the center vertical line above center and below, in both the old 
 // and new fields, but takes averages.  These are even pixel addresses.
-        MERGE4PIXavgH("(%%"XDI", %%"XCX", 2)", "(%%"XDI", %%"XCX")", "(%%"XSI", %%"XCX")", "(%%"XSI")")	// down, up
-        MERGE4PIXavgH("(%%"XDI")", "(%%"XDI", %%"XCX")", "(%%"XSI", %%"XCX")", "(%%"XSI", %%"XCX", 2)")	// up, down
+        MERGE4PIXavgH("(%%" XDI ", %%" XCX ", 2)", "(%%" XDI ", %%" XCX ")", "(%%" XSI ", %%" XCX ")", "(%%" XSI ")")	// down, up
+        MERGE4PIXavgH("(%%" XDI ")", "(%%" XDI ", %%" XCX ")", "(%%" XSI ", %%" XCX ")", "(%%" XSI ", %%" XCX ", 2)")	// up, down
diff --git a/plugins/tomsmocomp/StrangeBob.inc b/plugins/tomsmocomp/StrangeBob.inc
index c1d2b5b..0e43a21 100644
--- a/plugins/tomsmocomp/StrangeBob.inc
+++ b/plugins/tomsmocomp/StrangeBob.inc
@@ -31,22 +31,22 @@
         "pxor %%mm6, %%mm6\n\t"
         "pxor %%mm7, %%mm7\n\t"
 
-		"movq    -2(%%"XBX"), %%mm0\n\t"		// value a from top left		
-		"movq    -4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value m from bottom right			
+		"movq    -2(%%" XBX "), %%mm0\n\t"		// value a from top left		
+		"movq    -4(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value m from bottom right			
         
 		"movq	%%mm0, %%mm3\n\t"
 		"psubusb	%%mm1, %%mm3\n\t"
 		"psubusb %%mm0, %%mm1\n\t"
 		"por		%%mm1, %%mm3\n\t"					// abs(a,m)
 
-		"psubusb "_DiffThres", %%mm3\n\t"		// nonzero where abs(a,m) > Thres else 0
+		"psubusb " _DiffThres ", %%mm3\n\t"		// nonzero where abs(a,m) > Thres else 0
 		"pxor	%%mm4, %%mm4\n\t"
 		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where abs(a,m) < Thres, else 00	
 		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where abs(a,m) > Thres, else 00
 
 
-		"movq    -4(%%"XBX"), %%mm0\n\t"		// value j
-		"movq    4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value n
+		"movq    -4(%%" XBX "), %%mm0\n\t"		// value j
+		"movq    4(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value n
 		"movq	%%mm0, %%mm2\n\t"					
 		"pavgb	%%mm1, %%mm2\n\t"					// avg(j,n)
         "movq	%%mm0, %%mm3\n\t"
@@ -55,7 +55,7 @@
 		"por		%%mm1, %%mm0\n\t"					// abs(j,n)
 
         "movq    %%mm0, %%mm1\n\t"
-		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(j,n) > Thres else 0
+		"psubusb " _DiffThres ", %%mm1\n\t"		// nonzero where abs(j,n) > Thres else 0
 		"pxor	%%mm3, %%mm3\n\t"
 		"pcmpeqb %%mm3, %%mm1\n\t"			// now ff where abs(j,n) < Thres, else 00	
 
@@ -75,22 +75,22 @@
         "por     %%mm0, %%mm7\n\t"
         
         // k & m
-		"movq    2(%%"XBX"), %%mm0\n\t"		// value c from top left		
-		"movq    4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value n from bottom right			
+		"movq    2(%%" XBX "), %%mm0\n\t"		// value c from top left		
+		"movq    4(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value n from bottom right			
 
 		"movq	%%mm0, %%mm3\n\t"
 		"psubusb	%%mm1, %%mm3\n\t"
 		"psubusb %%mm0, %%mm1\n\t"
 		"por		%%mm1, %%mm3\n\t"					// abs(c,n)
 
-		"psubusb "_DiffThres", %%mm3\n\t"		// nonzero where abs(c,n) > Thres else 0
+		"psubusb " _DiffThres ", %%mm3\n\t"		// nonzero where abs(c,n) > Thres else 0
 		"pxor	%%mm4, %%mm4\n\t"
 		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where abs(c,n) < Thres, else 00	
 		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where abs(c,n) > Thres, else 00
 
 
-		"movq    4(%%"XBX"), %%mm0\n\t"		// value k
-		"movq    -4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value m
+		"movq    4(%%" XBX "), %%mm0\n\t"		// value k
+		"movq    -4(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value m
 		"movq	%%mm0, %%mm2\n\t"					
 		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(k,m)
         "movq	%%mm0, %%mm3\n\t"
@@ -99,7 +99,7 @@
 		"por		%%mm1, %%mm0\n\t"					// abs(k,m)
 
         "movq    %%mm0, %%mm1\n\t"
-		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(k,m) > Thres else 0
+		"psubusb " _DiffThres ", %%mm1\n\t"		// nonzero where abs(k,m) > Thres else 0
 		"pxor	%%mm3, %%mm3\n\t"
 		"pcmpeqb %%mm3, %%mm1\n\t"			// now ff where abs(k,m) < Thres, else 00	
 
@@ -120,21 +120,21 @@
 
 
         // c & d
-		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top left		
-		"movq    2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value f from bottom right			
+		"movq    (%%" XBX "), %%mm0\n\t"		// value b from top left		
+		"movq    2(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value f from bottom right			
 
 		"movq	%%mm0, %%mm3\n\t"
 		"psubusb	%%mm1, %%mm3\n\t"
 		"psubusb %%mm0, %%mm1\n\t"
 		"por		%%mm1, %%mm3\n\t"					// abs(b,f)
 
-		"psubusb "_DiffThres", %%mm3\n\t"		// nonzero where abs(b,f) > Thres else 0
+		"psubusb " _DiffThres ", %%mm3\n\t"		// nonzero where abs(b,f) > Thres else 0
 		"pxor	%%mm4, %%mm4\n\t"
 		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where abs(b,f) < Thres, else 00	
 		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where abs(b,f) > Thres, else 00
 
-		"movq    2(%%"XBX"), %%mm0\n\t"		// value c
-		"movq    -2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value d
+		"movq    2(%%" XBX "), %%mm0\n\t"		// value c
+		"movq    -2(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value d
 		"movq	%%mm0, %%mm2\n\t"					
 		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(c,d)
         "movq	%%mm0, %%mm3\n\t"
@@ -143,7 +143,7 @@
 		"por		%%mm1, %%mm0\n\t"					// abs(c,d)
 
         "movq    %%mm0, %%mm1\n\t"
-		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(c,d) > Thres else 0
+		"psubusb " _DiffThres ", %%mm1\n\t"		// nonzero where abs(c,d) > Thres else 0
 		"pxor	%%mm3, %%mm3\n\t"
         "pcmpeqb %%mm3, %%mm1\n\t"			// now ff where abs(c,d) < Thres, else 00	
 
@@ -163,21 +163,21 @@
         "por     %%mm0, %%mm7\n\t"
 
         // a & f
-		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top left		
-		"movq    -2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value d from bottom right			
+		"movq    (%%" XBX "), %%mm0\n\t"		// value b from top left		
+		"movq    -2(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value d from bottom right			
 
 		"movq	%%mm0, %%mm3\n\t"
 		"psubusb	%%mm1, %%mm3\n\t"
 		"psubusb %%mm0, %%mm1\n\t"
 		"por		%%mm1, %%mm3\n\t"					// abs(b,d)
 
-		"psubusb "_DiffThres", %%mm3\n\t"	// nonzero where abs(b,d) > Thres else 0
+		"psubusb " _DiffThres ", %%mm3\n\t"	// nonzero where abs(b,d) > Thres else 0
 		"pxor	%%mm4, %%mm4\n\t"
 		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where abs(b,d) < Thres, else 00	
 		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where abs(b,d) > Thres, else 00
 
-		"movq    -2(%%"XBX"), %%mm0\n\t"		// value a
-		"movq    2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value f
+		"movq    -2(%%" XBX "), %%mm0\n\t"		// value a
+		"movq    2(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value f
 		"movq	%%mm0, %%mm2\n\t"					
 		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(a,f)
         "movq	%%mm0, %%mm3\n\t"
@@ -186,7 +186,7 @@
 		"por		%%mm1, %%mm0\n\t"					// abs(a,f)
 
         "movq    %%mm0, %%mm1\n\t"
-		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(a,f) > Thres else 0
+		"psubusb " _DiffThres ", %%mm1\n\t"		// nonzero where abs(a,f) > Thres else 0
 		"pxor	%%mm3, %%mm3\n\t"
 		"pcmpeqb %%mm3, %%mm1\n\t"			// now ff where abs(a,f) < Thres, else 00	
 
@@ -205,13 +205,13 @@
         "por     %%mm2, %%mm6\n\t"
         "por     %%mm0, %%mm7\n\t"
            
- 		"pand	"_YMask", %%mm5\n\t"		// mask out chroma from here
- 		"pand	"_YMask", %%mm6\n\t"			// mask out chroma from here
- 		"pand	"_YMask", %%mm7\n\t"			// mask out chroma from here
+ 		"pand	" _YMask ", %%mm5\n\t"		// mask out chroma from here
+ 		"pand	" _YMask ", %%mm6\n\t"			// mask out chroma from here
+ 		"pand	" _YMask ", %%mm7\n\t"			// mask out chroma from here
 
 		// b,e
-		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top 		
-		"movq    (%%"XBX", %%"XCX"), %%mm1\n\t"	// value e from bottom 
+		"movq    (%%" XBX "), %%mm0\n\t"		// value b from top 		
+		"movq    (%%" XBX ", %%" XCX "), %%mm1\n\t"	// value e from bottom 
 		"movq	%%mm0, %%mm2\n\t"					
 		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(b,e)
         "movq	%%mm0, %%mm3\n\t"
@@ -220,7 +220,7 @@
 		"por		%%mm1, %%mm0\n\t"					// abs(b,e)
 
         "movq    %%mm0, %%mm1\n\t"
-		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(b,e) > Thres else 0
+		"psubusb " _DiffThres ", %%mm1\n\t"		// nonzero where abs(b,e) > Thres else 0
 		"pxor	%%mm3, %%mm3\n\t"
 		"pcmpeqb %%mm3, %%mm1\n\t"		// now ff where abs(b,e) < Thres, else 00	
 
@@ -238,8 +238,8 @@
         "por     %%mm0, %%mm7\n\t"
 
 		// bob in any leftovers
-		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top 		
-		"movq    (%%"XBX", %%"XCX"), %%mm1\n\t"	// value e from bottom 
+		"movq    (%%" XBX "), %%mm0\n\t"		// value b from top 		
+		"movq    (%%" XBX ", %%" XCX "), %%mm1\n\t"	// value e from bottom 
 
 
 // We will also calc here the max/min values to later limit comb
@@ -259,19 +259,19 @@
 
 #else
         "movq	%%mm0, %%mm2\n\t"
-		"movq	(%%"XAX"), %%mm4\n\t"
+		"movq	(%%" XAX "), %%mm4\n\t"
 		"psubusb %%mm4, %%mm2\n\t"
 		"psubusb %%mm0, %%mm4\n\t"
 		"por		%%mm2, %%mm4\n\t"			// abs diff
 		
 		"movq	%%mm1, %%mm2\n\t"
-		"movq	(%%"XAX", %%"XCX"), %%mm3\n\t"
+		"movq	(%%" XAX ", %%" XCX "), %%mm3\n\t"
 		"psubusb %%mm3, %%mm2\n\t"
 		"psubusb %%mm1, %%mm3\n\t"
 		"por		%%mm2, %%mm3\n\t"			// abs diff
 //		pmaxub  %%mm3, %%mm4			// top or bottom pixel moved most
 		V_PMAXUB ("%%mm3", "%%mm4")			// top or bottom pixel moved most
-        "psubusb "_DiffThres", %%mm3\n\t"		// moved more than allowed? or goes to 0?
+        "psubusb " _DiffThres ", %%mm3\n\t"		// moved more than allowed? or goes to 0?
 		"pxor	%%mm4, %%mm4\n\t"
 		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where low motion, else high motion
 		
@@ -283,14 +283,14 @@
 		V_PMAXUB ("%%mm6", "%%mm2")
 
         "psubusb %%mm3, %%mm2\n\t"			// maybe decrease it to 0000.. if no surround motion
-		"movq	%%mm2, "_Min_Vals"\n\t"
+		"movq	%%mm2, " _Min_Vals "\n\t"
 
 		"movq	%%mm0, %%mm2\n\t"
 		V_PMAXUB ("%%mm2", "%%mm1")
 //		pminub	%%mm6, %%mm2			// clip our current results so far to be below this
 		V_PMINUB ("%%mm6", "%%mm2", "%%mm4")
         "paddusb %%mm3, %%mm2\n\t"			// maybe increase it to ffffff if no surround motion
-		"movq	%%mm2, "_Max_Vals"\n\t"
+		"movq	%%mm2, " _Max_Vals "\n\t"
 #endif
 			
 		"movq	%%mm0, %%mm2\n\t"						
diff --git a/plugins/tomsmocomp/WierdBob.inc b/plugins/tomsmocomp/WierdBob.inc
index b6a8e61..dfdfe61 100644
--- a/plugins/tomsmocomp/WierdBob.inc
+++ b/plugins/tomsmocomp/WierdBob.inc
@@ -14,8 +14,8 @@
 		// selected for the	smallest of abs(a,f), abs(c,d), or abs(b,e), etc.
 
 		// a,f
-		"movq    -2(%%"XBX"), %%mm0\n\t"		// value a from top left		
-		"movq    2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value f from bottom right			
+		"movq    -2(%%" XBX "), %%mm0\n\t"		// value a from top left		
+		"movq    2(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value f from bottom right			
 		"movq	%%mm0, %%mm6\n\t"					
 //		pavgb	%%mm6, %%mm1					// avg(a,f), also best so far
 		V_PAVGB ("%%mm6", "%%mm1", "%%mm7", _ShiftMask)	// avg(a,f), also best so far
@@ -25,8 +25,8 @@
 		"por		%%mm1, %%mm7\n\t"					// abs diff, also best so far
 
 		// c,d
-		"movq    2(%%"XBX"), %%mm0\n\t"		// value a from top left		
-		"movq    -2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value f from bottom right			
+		"movq    2(%%" XBX "), %%mm0\n\t"		// value a from top left		
+		"movq    -2(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value f from bottom right			
 		"movq	%%mm0, %%mm2\n\t"						
 //		pavgb	%%mm2, %%mm1					// avg(c,d)
 		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(c,d)
@@ -49,12 +49,12 @@
 
 		"por		%%mm2, %%mm6\n\t"			// and merge new & old vals keeping best
 		"por		%%mm1, %%mm7\n\t"
-		"por		"_UVMask", %%mm7\n\t"			// but we know chroma is worthless so far
-		"pand	"_YMask", %%mm5\n\t"			// mask out chroma from here also
+		"por		" _UVMask ", %%mm7\n\t"			// but we know chroma is worthless so far
+		"pand	" _YMask ", %%mm5\n\t"			// mask out chroma from here also
 
 		// j,n
-		"movq    -4(%%"XBX"), %%mm0\n\t"		// value j from top left		
-		"movq    4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value n from bottom right			
+		"movq    -4(%%" XBX "), %%mm0\n\t"		// value j from top left		
+		"movq    4(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value n from bottom right			
 		"movq	%%mm0, %%mm2\n\t"						
 //		pavgb	%%mm2, %%mm1					// avg(j,n)
 		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(j,n)
@@ -79,8 +79,8 @@
 		"por		%%mm1, %%mm7\n\t"			// "
 
 		// k, m
-		"movq    4(%%"XBX"), %%mm0\n\t"		// value k from top right		
-		"movq    -4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value n from bottom left			
+		"movq    4(%%" XBX "), %%mm0\n\t"		// value k from top right		
+		"movq    -4(%%" XBX ", %%" XCX "), %%mm1\n\t"	// value n from bottom left			
 		"movq	%%mm0, %%mm4\n\t"						
 //		pavgb	%%mm4, %%mm1					// avg(k,m)
 		V_PAVGB ("%%mm4", "%%mm1", "%%mm3", _ShiftMask)	// avg(k,m)
@@ -108,8 +108,8 @@
 		"por		%%mm1, %%mm7\n\t"			// "
 
 		// b,e
-		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top 		
-		"movq    (%%"XBX", %%"XCX"), %%mm1\n\t"	// value e from bottom 
+		"movq    (%%" XBX "), %%mm0\n\t"		// value b from top 		
+		"movq    (%%" XBX ", %%" XCX "), %%mm1\n\t"	// value e from bottom 
 
 // We will also calc here the max/min values to later limit comb
 // so the max excursion will not exceed the Max_Comb constant
@@ -128,19 +128,19 @@
 
 #else
         "movq	%%mm0, %%mm2\n\t"
-		"movq	(%%"XAX"), %%mm4\n\t"
+		"movq	(%%" XAX "), %%mm4\n\t"
 		"psubusb %%mm4, %%mm2\n\t"
 		"psubusb %%mm0, %%mm4\n\t"
 		"por		%%mm2, %%mm4\n\t"			// abs diff
 		
 		"movq	%%mm1, %%mm2\n\t"
-		"movq	(%%"XAX", %%"XCX"), %%mm3\n\t"
+		"movq	(%%" XAX ", %%" XCX "), %%mm3\n\t"
 		"psubusb %%mm3, %%mm2\n\t"
 		"psubusb %%mm1, %%mm3\n\t"
 		"por		%%mm2, %%mm3\n\t"			// abs diff
 //		pmaxub  %%mm3, %%mm4			// top or bottom pixel moved most
 		V_PMAXUB ("%%mm3", "%%mm4")			// top or bottom pixel moved most
-        "psubusb "_Max_Mov", %%mm3\n\t"		// moved more than allowed? or goes to 0?
+        "psubusb " _Max_Mov ", %%mm3\n\t"		// moved more than allowed? or goes to 0?
 		"pxor	%%mm4, %%mm4\n\t"
 		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where low motion, else high motion
 		
@@ -152,14 +152,14 @@
 		V_PMAXUB ("%%mm6", "%%mm2")
 
 		"psubusb %%mm3, %%mm2\n\t"			// maybe decrease it to 0000.. if no surround motion
-		"movq	%%mm2, "_Min_Vals"\n\t"
+		"movq	%%mm2, " _Min_Vals "\n\t"
 
 		"movq	%%mm0, %%mm2\n\t"
 		V_PMAXUB ("%%mm2", "%%mm1")
 //		pminub	%%mm6, %%mm2			// clip our current results so far to be below this
 		V_PMINUB ("%%mm6", "%%mm2", "%%mm4")
         "paddusb %%mm3, %%mm2\n\t"			// maybe increase it to ffffff if no surround motion
-		"movq	%%mm2, "_Max_Vals"\n\t"
+		"movq	%%mm2, " _Max_Vals "\n\t"
 #endif
         
 		"movq	%%mm0, %%mm2\n\t"						
diff --git a/plugins/tomsmocomp/tomsmocompmacros.h b/plugins/tomsmocomp/tomsmocompmacros.h
index 03ecf69..21cc956 100644
--- a/plugins/tomsmocomp/tomsmocompmacros.h
+++ b/plugins/tomsmocomp/tomsmocompmacros.h
@@ -19,23 +19,23 @@
 //      V_PAVGB(mmr1, mmr2, mmr work register, smask) mmr2 may = mmrw if you can trash it
 
 #define V_PAVGB_MMX(mmr1, mmr2, mmrw, smask) \
-	"movq    "mmr2",  "mmrw"\n\t"            \
-	"pand    "smask", "mmrw"\n\t"            \
-	"psrlw   $1,      "mmrw"\n\t"            \
-	"pand    "smask", "mmr1"\n\t"            \
-	"psrlw   $1,      "mmr1"\n\t"            \
-	"paddusb "mmrw",  "mmr1"\n\t"
-#define V_PAVGB_SSE(mmr1, mmr2, mmrw, smask)      "pavgb   "mmr2", "mmr1"\n\t"
-#define V_PAVGB_3DNOW(mmr1, mmr2, mmrw, smask)    "pavgusb "mmr2", "mmr1"\n\t"
+	"movq    " mmr2 ",  " mmrw "\n\t"    \
+	"pand    " smask ", " mmrw "\n\t"    \
+	"psrlw   $1,        " mmrw "\n\t"    \
+	"pand    " smask ", " mmr1 "\n\t"    \
+	"psrlw   $1,        " mmr1 "\n\t"    \
+	"paddusb " mmrw ",  " mmr1 "\n\t"
+#define V_PAVGB_SSE(mmr1, mmr2, mmrw, smask)      "pavgb   " mmr2 ", " mmr1 "\n\t"
+#define V_PAVGB_3DNOW(mmr1, mmr2, mmrw, smask)    "pavgusb " mmr2 ", " mmr1 "\n\t"
 #define V_PAVGB(mmr1, mmr2, mmrw, smask)          V_PAVGB2(mmr1, mmr2, mmrw, smask, SSE_TYPE) 
 #define V_PAVGB2(mmr1, mmr2, mmrw, smask, ssetyp) V_PAVGB3(mmr1, mmr2, mmrw, smask, ssetyp) 
 #define V_PAVGB3(mmr1, mmr2, mmrw, smask, ssetyp) V_PAVGB_##ssetyp(mmr1, mmr2, mmrw, smask) 
 
 // some macros for pmaxub instruction
 #define V_PMAXUB_MMX(mmr1, mmr2) \
-    "psubusb "mmr2", "mmr1"\n\t" \
-    "paddusb "mmr2", "mmr1"\n\t"
-#define V_PMAXUB_SSE(mmr1, mmr2)      "pmaxub "mmr2", "mmr1"\n\t"
+    "psubusb " mmr2 ", " mmr1 "\n\t" \
+    "paddusb " mmr2 ", " mmr1 "\n\t"
+#define V_PMAXUB_SSE(mmr1, mmr2)      "pmaxub " mmr2 ", " mmr1 "\n\t"
 #define V_PMAXUB_3DNOW(mmr1, mmr2)    V_PMAXUB_MMX(mmr1, mmr2)  // use MMX version
 #define V_PMAXUB(mmr1, mmr2)          V_PMAXUB2(mmr1, mmr2, SSE_TYPE) 
 #define V_PMAXUB2(mmr1, mmr2, ssetyp) V_PMAXUB3(mmr1, mmr2, ssetyp) 
@@ -44,11 +44,11 @@
 // some macros for pminub instruction
 //      V_PMINUB(mmr1, mmr2, mmr work register)     mmr2 may NOT = mmrw
 #define V_PMINUB_MMX(mmr1, mmr2, mmrw) \
-    "pcmpeqb "mmrw", "mmrw"\n\t"       \
-    "psubusb "mmr2", "mmrw"\n\t"       \
-    "paddusb "mmrw", "mmr1"\n\t"       \
-    "psubusb "mmrw", "mmr1"\n\t"
-#define V_PMINUB_SSE(mmr1, mmr2, mmrw)      "pminub "mmr2", "mmr1"\n\t"
+    "pcmpeqb " mmrw ", " mmrw "\n\t"   \
+    "psubusb " mmr2 ", " mmrw "\n\t"   \
+    "paddusb " mmrw ", " mmr1 "\n\t"   \
+    "psubusb " mmrw ", " mmr1 "\n\t"
+#define V_PMINUB_SSE(mmr1, mmr2, mmrw)      "pminub " mmr2 ", " mmr1 "\n\t"
 #define V_PMINUB_3DNOW(mmr1, mmr2, mmrw)    V_PMINUB_MMX(mmr1, mmr2, mmrw)  // use MMX version
 #define V_PMINUB(mmr1, mmr2, mmrw)          V_PMINUB2(mmr1, mmr2, mmrw, SSE_TYPE) 
 #define V_PMINUB2(mmr1, mmr2, mmrw, ssetyp) V_PMINUB3(mmr1, mmr2, mmrw, ssetyp) 
@@ -56,9 +56,9 @@
 
 // some macros for movntq instruction
 //      V_MOVNTQ(mmr1, mmr2) 
-#define V_MOVNTQ_MMX(mmr1, mmr2)      "movq   "mmr2", "mmr1"\n\t"
-#define V_MOVNTQ_3DNOW(mmr1, mmr2)    "movq   "mmr2", "mmr1"\n\t"
-#define V_MOVNTQ_SSE(mmr1, mmr2)      "movntq "mmr2", "mmr1"\n\t"
+#define V_MOVNTQ_MMX(mmr1, mmr2)      "movq   " mmr2 ", " mmr1 "\n\t"
+#define V_MOVNTQ_3DNOW(mmr1, mmr2)    "movq   " mmr2 ", " mmr1 "\n\t"
+#define V_MOVNTQ_SSE(mmr1, mmr2)      "movntq " mmr2 ", " mmr1 "\n\t"
 #define V_MOVNTQ(mmr1, mmr2)          V_MOVNTQ2(mmr1, mmr2, SSE_TYPE) 
 #define V_MOVNTQ2(mmr1, mmr2, ssetyp) V_MOVNTQ3(mmr1, mmr2, ssetyp) 
 #define V_MOVNTQ3(mmr1, mmr2, ssetyp) V_MOVNTQ_##ssetyp(mmr1, mmr2)
@@ -68,8 +68,8 @@
 #ifdef IS_SSE2
 
 #define MERGE4PIXavg(PADDR1, PADDR2)                                                     \
-    "movdqu  "PADDR1",   %%xmm0\n\t"       /* our 4 pixels */                            \
-    "movdqu  "PADDR2",   %%xmm1\n\t"       /* our pixel2 value */                        \
+    "movdqu  " PADDR1 ", %%xmm0\n\t"       /* our 4 pixels */                            \
+    "movdqu  " PADDR2 ", %%xmm1\n\t"       /* our pixel2 value */                        \
     "movdqa  %%xmm0,     %%xmm2\n\t"       /* another copy of our pixel1 value */        \
     "movdqa  %%xmm1,     %%xmm3\n\t"       /* another copy of our pixel1 value */        \
     "psubusb %%xmm1,     %%xmm2\n\t"                                                     \
@@ -89,10 +89,10 @@
     "por     %%xmm2,     %%xmm7\n\t"
 
 #define MERGE4PIXavgH(PADDR1A, PADDR1B, PADDR2A, PADDR2B)                                \
-    "movdqu  "PADDR1A",   %%xmm0\n\t"      /* our 4 pixels */                            \
-    "movdqu  "PADDR2A",   %%xmm1\n\t"      /* our pixel2 value */                        \
-    "movdqu  "PADDR1B",   %%xmm2\n\t"      /* our 4 pixels */                            \
-    "movdqu  "PADDR2B",   %%xmm3\n\t"      /* our pixel2 value */                        \
+    "movdqu  " PADDR1A ", %%xmm0\n\t"      /* our 4 pixels */                            \
+    "movdqu  " PADDR2A ", %%xmm1\n\t"      /* our pixel2 value */                        \
+    "movdqu  " PADDR1B ", %%xmm2\n\t"      /* our 4 pixels */                            \
+    "movdqu  " PADDR2B ", %%xmm3\n\t"      /* our pixel2 value */                        \
     "pavgb   %%xmm2,      %%xmm0\n\t"                                                    \
     "pavgb   %%xmm3,      %%xmm1\n\t"                                                    \
     "movdqa  %%xmm0,      %%xmm2\n\t"      /* another copy of our pixel1 value */        \
@@ -113,13 +113,13 @@
     "por     %%xmm0,      %%xmm5\n\t"      /* and merge new & old vals */                \
     "por     %%xmm2,      %%xmm7\n\t"
 
-#define RESET_CHROMA "por "_UVMask", %%xmm7\n\t"
+#define RESET_CHROMA "por " _UVMask ", %%xmm7\n\t"
 
 #else // ifdef IS_SSE2
 
 #define MERGE4PIXavg(PADDR1, PADDR2)                                                    \
-    "movq    "PADDR1",   %%mm0\n\t"       /* our 4 pixels */                            \
-    "movq    "PADDR2",   %%mm1\n\t"       /* our pixel2 value */                        \
+    "movq    " PADDR1 ", %%mm0\n\t"       /* our 4 pixels */                            \
+    "movq    " PADDR2 ", %%mm1\n\t"       /* our pixel2 value */                        \
     "movq    %%mm0,      %%mm2\n\t"       /* another copy of our pixel1 value */        \
     "movq    %%mm1,      %%mm3\n\t"       /* another copy of our pixel1 value */        \
     "psubusb %%mm1,      %%mm2\n\t"                                                     \
@@ -139,10 +139,10 @@
     "por     %%mm2,      %%mm7\n\t"
 
 #define MERGE4PIXavgH(PADDR1A, PADDR1B, PADDR2A, PADDR2B)                               \
-    "movq    "PADDR1A",   %%mm0\n\t"      /* our 4 pixels */                            \
-    "movq    "PADDR2A",   %%mm1\n\t"      /* our pixel2 value */                        \
-    "movq    "PADDR1B",   %%mm2\n\t"      /* our 4 pixels */                            \
-    "movq    "PADDR2B",   %%mm3\n\t"      /* our pixel2 value */                        \
+    "movq    " PADDR1A ", %%mm0\n\t"      /* our 4 pixels */                            \
+    "movq    " PADDR2A ", %%mm1\n\t"      /* our pixel2 value */                        \
+    "movq    " PADDR1B ", %%mm2\n\t"      /* our 4 pixels */                            \
+    "movq    " PADDR2B ", %%mm3\n\t"      /* our pixel2 value */                        \
     V_PAVGB("%%mm0", "%%mm2", "%%mm2", _ShiftMask)                                      \
     V_PAVGB("%%mm1", "%%mm3", "%%mm3", _ShiftMask)                                      \
     "movq    %%mm0,       %%mm2\n\t"      /* another copy of our pixel1 value */        \
@@ -163,7 +163,7 @@
     "por     %%mm0,       %%mm5\n\t"      /* and merge new & old vals */                \
     "por     %%mm2,       %%mm7\n\t"
 
-#define RESET_CHROMA "por "_UVMask", %%mm7\n\t"
+#define RESET_CHROMA "por " _UVMask ", %%mm7\n\t"
 
 #endif
 
-- 
2.5.0

