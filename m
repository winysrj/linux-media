Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50669 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab1CZBtk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 21:49:40 -0400
Date: Sat, 26 Mar 2011 04:49:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/6] [media] pvrusb2: white space changes
Message-ID: <20110326014918.GF2008@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* Broke up if statements so that the condition and the body are on
  separate lines.
* Added spaces around commas and other operator characters.
* Removed extra blank lines.
* Added blank lines after declarations.
* Changed C99 comments into kernel style.
* Fixed checkpatch complaints where "{" char was on its own line but it
  wasn't the start of a function.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c b/drivers/media/video/pvrusb2/pvrusb2-std.c
index ca9f83a..a5d4867 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-std.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
@@ -28,39 +28,38 @@ struct std_name {
 	v4l2_std_id id;
 };
 
-
 #define CSTD_PAL \
-	(V4L2_STD_PAL_B| \
-	 V4L2_STD_PAL_B1| \
-	 V4L2_STD_PAL_G| \
-	 V4L2_STD_PAL_H| \
-	 V4L2_STD_PAL_I| \
-	 V4L2_STD_PAL_D| \
-	 V4L2_STD_PAL_D1| \
-	 V4L2_STD_PAL_K| \
-	 V4L2_STD_PAL_M| \
-	 V4L2_STD_PAL_N| \
-	 V4L2_STD_PAL_Nc| \
+	(V4L2_STD_PAL_B  | \
+	 V4L2_STD_PAL_B1 | \
+	 V4L2_STD_PAL_G  | \
+	 V4L2_STD_PAL_H  | \
+	 V4L2_STD_PAL_I  | \
+	 V4L2_STD_PAL_D  | \
+	 V4L2_STD_PAL_D1 | \
+	 V4L2_STD_PAL_K  | \
+	 V4L2_STD_PAL_M  | \
+	 V4L2_STD_PAL_N  | \
+	 V4L2_STD_PAL_Nc | \
 	 V4L2_STD_PAL_60)
 
 #define CSTD_NTSC \
-	(V4L2_STD_NTSC_M| \
-	 V4L2_STD_NTSC_M_JP| \
-	 V4L2_STD_NTSC_M_KR| \
+	(V4L2_STD_NTSC_M    | \
+	 V4L2_STD_NTSC_M_JP | \
+	 V4L2_STD_NTSC_M_KR | \
 	 V4L2_STD_NTSC_443)
 
 #define CSTD_ATSC \
-	(V4L2_STD_ATSC_8_VSB| \
+	(V4L2_STD_ATSC_8_VSB | \
 	 V4L2_STD_ATSC_16_VSB)
 
 #define CSTD_SECAM \
-	(V4L2_STD_SECAM_B| \
-	 V4L2_STD_SECAM_D| \
-	 V4L2_STD_SECAM_G| \
-	 V4L2_STD_SECAM_H| \
-	 V4L2_STD_SECAM_K| \
-	 V4L2_STD_SECAM_K1| \
-	 V4L2_STD_SECAM_L| \
+	(V4L2_STD_SECAM_B  | \
+	 V4L2_STD_SECAM_D  | \
+	 V4L2_STD_SECAM_G  | \
+	 V4L2_STD_SECAM_H  | \
+	 V4L2_STD_SECAM_K  | \
+	 V4L2_STD_SECAM_K1 | \
+	 V4L2_STD_SECAM_L  | \
 	 V4L2_STD_SECAM_LC)
 
 #define TSTD_B   (V4L2_STD_PAL_B|V4L2_STD_SECAM_B)
@@ -82,39 +81,40 @@ struct std_name {
 
 /* Mapping of standard bits to color system */
 static const struct std_name std_groups[] = {
-	{"PAL",CSTD_PAL},
-	{"NTSC",CSTD_NTSC},
-	{"SECAM",CSTD_SECAM},
-	{"ATSC",CSTD_ATSC},
+	{"PAL",   CSTD_PAL},
+	{"NTSC",  CSTD_NTSC},
+	{"SECAM", CSTD_SECAM},
+	{"ATSC",  CSTD_ATSC},
 };
 
 /* Mapping of standard bits to modulation system */
 static const struct std_name std_items[] = {
-	{"B",TSTD_B},
-	{"B1",TSTD_B1},
-	{"D",TSTD_D},
-	{"D1",TSTD_D1},
-	{"G",TSTD_G},
-	{"H",TSTD_H},
-	{"I",TSTD_I},
-	{"K",TSTD_K},
-	{"K1",TSTD_K1},
-	{"L",TSTD_L},
-	{"LC",V4L2_STD_SECAM_LC},
-	{"M",TSTD_M},
-	{"Mj",V4L2_STD_NTSC_M_JP},
-	{"443",V4L2_STD_NTSC_443},
-	{"Mk",V4L2_STD_NTSC_M_KR},
-	{"N",TSTD_N},
-	{"Nc",TSTD_Nc},
-	{"60",TSTD_60},
-	{"8VSB",V4L2_STD_ATSC_8_VSB},
-	{"16VSB",V4L2_STD_ATSC_16_VSB},
+	{"B",     TSTD_B},
+	{"B1",    TSTD_B1},
+	{"D",     TSTD_D},
+	{"D1",    TSTD_D1},
+	{"G",     TSTD_G},
+	{"H",     TSTD_H},
+	{"I",     TSTD_I},
+	{"K",     TSTD_K},
+	{"K1",    TSTD_K1},
+	{"L",     TSTD_L},
+	{"LC",    V4L2_STD_SECAM_LC},
+	{"M",     TSTD_M},
+	{"Mj",    V4L2_STD_NTSC_M_JP},
+	{"443",   V4L2_STD_NTSC_443},
+	{"Mk",    V4L2_STD_NTSC_M_KR},
+	{"N",     TSTD_N},
+	{"Nc",    TSTD_Nc},
+	{"60",    TSTD_60},
+	{"8VSB",  V4L2_STD_ATSC_8_VSB},
+	{"16VSB", V4L2_STD_ATSC_16_VSB},
 };
 
-
-// Search an array of std_name structures and return a pointer to the
-// element with the matching name.
+/*
+ * Search an array of std_name structures and return a pointer to the
+ * element with the matching name.
+ */
 static const struct std_name *find_std_name(const struct std_name *arrPtr,
 					    unsigned int arrSize,
 					    const char *bufPtr,
@@ -122,16 +122,18 @@ static const struct std_name *find_std_name(const struct std_name *arrPtr,
 {
 	unsigned int idx;
 	const struct std_name *p;
+
 	for (idx = 0; idx < arrSize; idx++) {
 		p = arrPtr + idx;
-		if (strlen(p->name) != bufSize) continue;
-		if (!memcmp(bufPtr,p->name,bufSize)) return p;
+		if (strlen(p->name) != bufSize)
+			continue;
+		if (!memcmp(bufPtr, p->name, bufSize))
+			return p;
 	}
 	return NULL;
 }
 
-
-int pvr2_std_str_to_id(v4l2_std_id *idPtr,const char *bufPtr,
+int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *bufPtr,
 		       unsigned int bufSize)
 {
 	v4l2_std_id id = 0;
@@ -145,11 +147,14 @@ int pvr2_std_str_to_id(v4l2_std_id *idPtr,const char *bufPtr,
 	while (bufSize) {
 		if (!mMode) {
 			cnt = 0;
-			while ((cnt < bufSize) && (bufPtr[cnt] != '-')) cnt++;
-			if (cnt >= bufSize) return 0; // No more characters
+			while ((cnt < bufSize) && (bufPtr[cnt] != '-'))
+				cnt++;
+			if (cnt >= bufSize)
+				return 0; /* No more characters */
 			sp = find_std_name(std_groups, ARRAY_SIZE(std_groups),
-					   bufPtr,cnt);
-			if (!sp) return 0; // Illegal color system name
+					   bufPtr, cnt);
+			if (!sp)
+				return 0; /* Illegal color system name */
 			cnt++;
 			bufPtr += cnt;
 			bufSize -= cnt;
@@ -164,58 +169,65 @@ int pvr2_std_str_to_id(v4l2_std_id *idPtr,const char *bufPtr,
 				mMode = 0;
 				break;
 			}
-			if (ch == '/') break;
+			if (ch == '/')
+				break;
 			cnt++;
 		}
 		sp = find_std_name(std_items, ARRAY_SIZE(std_items),
-				   bufPtr,cnt);
-		if (!sp) return 0; // Illegal modulation system ID
+				   bufPtr, cnt);
+		if (!sp)
+			return 0; /* Illegal modulation system ID */
 		t = sp->id & cmsk;
-		if (!t) return 0; // Specific color + modulation system illegal
+		if (!t)
+			return 0; /* Specific color + modulation system
+				     illegal */
 		id |= t;
-		if (cnt < bufSize) cnt++;
+		if (cnt < bufSize)
+			cnt++;
 		bufPtr += cnt;
 		bufSize -= cnt;
 	}
 
-	if (idPtr) *idPtr = id;
+	if (idPtr)
+		*idPtr = id;
 	return !0;
 }
 
-
 unsigned int pvr2_std_id_to_str(char *bufPtr, unsigned int bufSize,
 				v4l2_std_id id)
 {
-	unsigned int idx1,idx2;
-	const struct std_name *ip,*gp;
-	int gfl,cfl;
-	unsigned int c1,c2;
+	unsigned int idx1, idx2;
+	const struct std_name *ip, *gp;
+	int gfl, cfl;
+	unsigned int c1, c2;
 	cfl = 0;
 	c1 = 0;
+
 	for (idx1 = 0; idx1 < ARRAY_SIZE(std_groups); idx1++) {
 		gp = std_groups + idx1;
 		gfl = 0;
 		for (idx2 = 0; idx2 < ARRAY_SIZE(std_items); idx2++) {
 			ip = std_items + idx2;
-			if (!(gp->id & ip->id & id)) continue;
+			if (!(gp->id & ip->id & id))
+				continue;
 			if (!gfl) {
 				if (cfl) {
-					c2 = scnprintf(bufPtr,bufSize,";");
+					c2 = scnprintf(bufPtr, bufSize, ";");
 					c1 += c2;
 					bufSize -= c2;
 					bufPtr += c2;
 				}
 				cfl = !0;
-				c2 = scnprintf(bufPtr,bufSize,
-					       "%s-",gp->name);
+				c2 = scnprintf(bufPtr, bufSize,
+					       "%s-", gp->name);
 				gfl = !0;
 			} else {
-				c2 = scnprintf(bufPtr,bufSize,"/");
+				c2 = scnprintf(bufPtr, bufSize, "/");
 			}
 			c1 += c2;
 			bufSize -= c2;
 			bufPtr += c2;
-			c2 = scnprintf(bufPtr,bufSize,
+			c2 = scnprintf(bufPtr, bufSize,
 				       ip->name);
 			c1 += c2;
 			bufSize -= c2;
@@ -225,9 +237,10 @@ unsigned int pvr2_std_id_to_str(char *bufPtr, unsigned int bufSize,
 	return c1;
 }
 
-
-// Template data for possible enumerated video standards.  Here we group
-// standards which share common frame rates and resolution.
+/*
+ * Template data for possible enumerated video standards.  Here we group
+ * standards which share common frame rates and resolution.
+ */
 static struct v4l2_standard generic_standards[] = {
 	{
 		.id             = (TSTD_B|TSTD_B1|
@@ -239,42 +252,38 @@ static struct v4l2_standard generic_standards[] = {
 				   TSTD_L|
 				   V4L2_STD_SECAM_LC |
 				   TSTD_N|TSTD_Nc),
-		.frameperiod    =
-		{
-			.numerator  = 1,
-			.denominator= 25
+		.frameperiod    = {
+			.numerator   = 1,
+			.denominator = 25
 		},
 		.framelines     = 625,
-		.reserved       = {0,0,0,0}
+		.reserved       = {0, 0, 0, 0}
 	}, {
 		.id             = (TSTD_M|
 				   V4L2_STD_NTSC_M_JP|
 				   V4L2_STD_NTSC_M_KR),
-		.frameperiod    =
-		{
-			.numerator  = 1001,
-			.denominator= 30000
+		.frameperiod    = {
+			.numerator   = 1001,
+			.denominator = 30000
 		},
 		.framelines     = 525,
-		.reserved       = {0,0,0,0}
-	}, { // This is a total wild guess
+		.reserved       = {0, 0, 0, 0}
+	}, { /* This is a total wild guess */
 		.id             = (TSTD_60),
-		.frameperiod    =
-		{
-			.numerator  = 1001,
-			.denominator= 30000
+		.frameperiod    = {
+			.numerator   = 1001,
+			.denominator = 30000
 		},
 		.framelines     = 525,
-		.reserved       = {0,0,0,0}
-	}, { // This is total wild guess
+		.reserved       = {0, 0, 0, 0}
+	}, { /* This is total wild guess */
 		.id             = V4L2_STD_NTSC_443,
-		.frameperiod    =
-		{
-			.numerator  = 1001,
-			.denominator= 30000
+		.frameperiod    = {
+			.numerator   = 1001,
+			.denominator = 30000
 		},
 		.framelines     = 525,
-		.reserved       = {0,0,0,0}
+		.reserved       = {0, 0, 0, 0}
 	}
 };
 
@@ -283,6 +292,7 @@ static struct v4l2_standard generic_standards[] = {
 static struct v4l2_standard *match_std(v4l2_std_id id)
 {
 	unsigned int idx;
+
 	for (idx = 0; idx < generic_standards_cnt; idx++) {
 		if (generic_standards[idx].id & id) {
 			return generic_standards + idx;
@@ -291,26 +301,30 @@ static struct v4l2_standard *match_std(v4l2_std_id id)
 	return NULL;
 }
 
-static int pvr2_std_fill(struct v4l2_standard *std,v4l2_std_id id)
+static int pvr2_std_fill(struct v4l2_standard *std, v4l2_std_id id)
 {
 	struct v4l2_standard *template;
 	int idx;
 	unsigned int bcnt;
+
 	template = match_std(id);
-	if (!template) return 0;
+	if (!template)
+		return 0;
 	idx = std->index;
-	memcpy(std,template,sizeof(*template));
+	memcpy(std, template, sizeof(*template));
 	std->index = idx;
 	std->id = id;
-	bcnt = pvr2_std_id_to_str(std->name,sizeof(std->name)-1,id);
+	bcnt = pvr2_std_id_to_str(std->name, sizeof(std->name) - 1, id);
 	std->name[bcnt] = 0;
-	pvr2_trace(PVR2_TRACE_STD,"Set up standard idx=%u name=%s",
-		   std->index,std->name);
+	pvr2_trace(PVR2_TRACE_STD, "Set up standard idx=%u name=%s",
+		   std->index, std->name);
 	return !0;
 }
 
-/* These are special cases of combined standards that we should enumerate
-   separately if the component pieces are present. */
+/*
+ * These are special cases of combined standards that we should enumerate
+ * separately if the component pieces are present.
+ */
 static v4l2_std_id std_mixes[] = {
 	V4L2_STD_PAL_B | V4L2_STD_PAL_G,
 	V4L2_STD_PAL_D | V4L2_STD_PAL_K,
@@ -322,23 +336,25 @@ struct v4l2_standard *pvr2_std_create_enum(unsigned int *countptr,
 					   v4l2_std_id id)
 {
 	unsigned int std_cnt = 0;
-	unsigned int idx,bcnt,idx2;
-	v4l2_std_id idmsk,cmsk,fmsk;
+	unsigned int idx, bcnt, idx2;
+	v4l2_std_id idmsk, cmsk, fmsk;
 	struct v4l2_standard *stddefs;
 
 	if (pvrusb2_debug & PVR2_TRACE_STD) {
 		char buf[100];
-		bcnt = pvr2_std_id_to_str(buf,sizeof(buf),id);
+
+		bcnt = pvr2_std_id_to_str(buf, sizeof(buf), id);
 		pvr2_trace(
-			PVR2_TRACE_STD,"Mapping standards mask=0x%x (%.*s)",
-			(int)id,bcnt,buf);
+			PVR2_TRACE_STD, "Mapping standards mask=0x%x (%.*s)",
+			(int)id, bcnt, buf);
 	}
 
 	*countptr = 0;
 	std_cnt = 0;
 	fmsk = 0;
 	for (idmsk = 1, cmsk = id; cmsk; idmsk <<= 1) {
-		if (!(idmsk & cmsk)) continue;
+		if (!(idmsk & cmsk))
+			continue;
 		cmsk &= ~idmsk;
 		if (match_std(idmsk)) {
 			std_cnt++;
@@ -348,7 +364,8 @@ struct v4l2_standard *pvr2_std_create_enum(unsigned int *countptr,
 	}
 
 	for (idx2 = 0; idx2 < ARRAY_SIZE(std_mixes); idx2++) {
-		if ((id & std_mixes[idx2]) == std_mixes[idx2]) std_cnt++;
+		if ((id & std_mixes[idx2]) == std_mixes[idx2])
+			std_cnt++;
 	}
 
 	/* Don't complain about ATSC standard values */
@@ -356,35 +373,42 @@ struct v4l2_standard *pvr2_std_create_enum(unsigned int *countptr,
 
 	if (fmsk) {
 		char buf[100];
-		bcnt = pvr2_std_id_to_str(buf,sizeof(buf),fmsk);
+
+		bcnt = pvr2_std_id_to_str(buf, sizeof(buf), fmsk);
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
 			"WARNING:"
 			" Failed to classify the following standard(s): %.*s",
-			bcnt,buf);
+			bcnt, buf);
 	}
 
-	pvr2_trace(PVR2_TRACE_STD,"Setting up %u unique standard(s)",
+	pvr2_trace(PVR2_TRACE_STD, "Setting up %u unique standard(s)",
 		   std_cnt);
-	if (!std_cnt) return NULL; // paranoia
+	if (!std_cnt)
+		return NULL; /* paranoia */
 
 	stddefs = kzalloc(sizeof(struct v4l2_standard) * std_cnt,
 			  GFP_KERNEL);
-	for (idx = 0; idx < std_cnt; idx++) stddefs[idx].index = idx;
+	for (idx = 0; idx < std_cnt; idx++)
+		stddefs[idx].index = idx;
 
 	idx = 0;
 
 	/* Enumerate potential special cases */
 	for (idx2 = 0; (idx2 < ARRAY_SIZE(std_mixes)) && (idx < std_cnt);
 	     idx2++) {
-		if (!(id & std_mixes[idx2])) continue;
-		if (pvr2_std_fill(stddefs+idx,std_mixes[idx2])) idx++;
+		if (!(id & std_mixes[idx2]))
+			continue;
+		if (pvr2_std_fill(stddefs + idx, std_mixes[idx2]))
+			idx++;
 	}
 	/* Now enumerate individual pieces */
 	for (idmsk = 1, cmsk = id; cmsk && (idx < std_cnt); idmsk <<= 1) {
-		if (!(idmsk & cmsk)) continue;
+		if (!(idmsk & cmsk))
+			continue;
 		cmsk &= ~idmsk;
-		if (!pvr2_std_fill(stddefs+idx,idmsk)) continue;
+		if (!pvr2_std_fill(stddefs + idx, idmsk))
+			continue;
 		idx++;
 	}
 
@@ -397,7 +421,6 @@ v4l2_std_id pvr2_std_get_usable(void)
 	return CSTD_ALL;
 }
 
-
 /*
   Stuff for Emacs to see, in order to encourage consistent editing style:
   *** Local Variables: ***
