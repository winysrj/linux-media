Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39774 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627Ab2AUHmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 02:42:47 -0500
Received: by obcva7 with SMTP id va7so1547444obc.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 23:42:46 -0800 (PST)
From: pdickeybeta@gmail.com
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 2/2] import-pctv-80e-from-devin-heitmueller-hg-repository # HG changeset patch # User Devin Heitmueller <dheitmueller@kernellabs.com> # Date 1278279731 14400 # Node ID 30c6512030acb8dea04c653b40340f6038d57367 # Parent c119f08c4dd266f6024cde6b5e660c7d32a0cbc1 drx39xyj: put under 3-clause BSD license
Date: Sat, 21 Jan 2012 01:34:51 -0600
Message-Id: <1327131291-5174-3-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1327131291-5174-1-git-send-email-pdickeybeta@gmail.com>
References: <1327131291-5174-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Patrick Dickey <pdickeybeta@gmail.com>

 From: Devin Heitmueller <dheitmueller@kernellabs.com>
         
 Relicense the drx-j driver under a standard 3-clause BSD license, which makes
 it GPL compatible.
            
 This was done explicitly with permission from Trident Microsystems.
              
 [pdickeybeta@gmail.com]
                
 Edited the location of the files to point to drivers/staging/media.
 Edited changelog
                   
 Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
 Signed-off-by: Patrick Dickey <pdickeybeta@gmail.com>

---
 .../media/dvb/frontends/drx39xyj/bsp_host.h        |   62 ++++++++---------
 .../staging/media/dvb/frontends/drx39xyj/bsp_i2c.h |   63 ++++++++---------
 .../media/dvb/frontends/drx39xyj/bsp_tuner.h       |   63 ++++++++---------
 .../media/dvb/frontends/drx39xyj/bsp_types.h       |   62 ++++++++---------
 .../media/dvb/frontends/drx39xyj/drx39xxj.c        |    2 +-
 .../media/dvb/frontends/drx39xyj/drx39xxj.h        |    2 +-
 .../media/dvb/frontends/drx39xyj/drx_dap_fasi.c    |   59 ++++++++--------
 .../media/dvb/frontends/drx39xyj/drx_dap_fasi.h    |   59 ++++++++--------
 .../media/dvb/frontends/drx39xyj/drx_driver.c      |   60 ++++++++--------
 .../media/dvb/frontends/drx39xyj/drx_driver.h      |   60 ++++++++--------
 .../dvb/frontends/drx39xyj/drx_driver_version.h    |   63 +++++++++---------
 .../staging/media/dvb/frontends/drx39xyj/drxj.c    |   63 ++++++++---------
 .../staging/media/dvb/frontends/drx39xyj/drxj.h    |   62 ++++++++---------
 .../media/dvb/frontends/drx39xyj/drxj_map.h        |   53 ++++++++-------
 .../staging/media/dvb/frontends/drx39xyj/drxj_mc.h |   70 +++++++++-----------
 .../media/dvb/frontends/drx39xyj/drxj_mc_vsb.h     |   68 ++++++++-----------
 .../media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h  |   67 ++++++++----------
 .../media/dvb/frontends/drx39xyj/drxj_options.h    |   63 ++++++++---------
 18 files changed, 484 insertions(+), 517 deletions(-)

diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/bsp_host.h b/drivers/staging/media/dvb/frontends/drx39xyj/bsp_host.h
index 30f711d..95b5232 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/bsp_host.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/bsp_host.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: bsp_host.h,v 1.3 2009/07/07 14:20:30 justin Exp $
 *
@@ -5,38 +35,6 @@
 *
 */
 
-/*
-* $(c) 2004-2005,2007-2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
-*/
 #ifndef __DRXBSP_HOST_H__
 #define __DRXBSP_HOST_H__
 /*-------------------------------------------------------------------------
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/bsp_i2c.h b/drivers/staging/media/dvb/frontends/drx39xyj/bsp_i2c.h
index c785ddf..3ac9250 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/bsp_i2c.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/bsp_i2c.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: bsp_i2c.h,v 1.5 2009/07/07 14:20:30 justin Exp $
 *
@@ -12,39 +42,6 @@
 *
 */
 
-/*
-* $(c) 2004-2005,2008-2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
-*/
-
 #ifndef __BSPI2C_H__
 #define __BSPI2C_H__
 /*------------------------------------------------------------------------------
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/bsp_tuner.h b/drivers/staging/media/dvb/frontends/drx39xyj/bsp_tuner.h
index e5693d0..668f988 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/bsp_tuner.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/bsp_tuner.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: bsp_tuner.h,v 1.5 2009/10/19 22:15:13 dingtao Exp $
 *
@@ -5,39 +35,6 @@
 *
 */
 
-/*
-* $(c) 2004-2006,2008-2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
-*/
-
 #ifndef __DRXBSP_TUNER_H__
 #define __DRXBSP_TUNER_H__
 /*------------------------------------------------------------------------------
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/bsp_types.h b/drivers/staging/media/dvb/frontends/drx39xyj/bsp_types.h
index 73ef42d..146694a 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/bsp_types.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/bsp_types.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: bsp_types.h,v 1.5 2009/08/06 12:55:57 carlo Exp $
 *
@@ -9,38 +39,6 @@
 *
 */
 
-/*
-* $(c) 2004-2006,2008-2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
-*/
 #ifndef __BSP_TYPES_H__
 #define __BSP_TYPES_H__
 /*-------------------------------------------------------------------------
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.c b/drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.c
index cc399a9..1ba6918 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.c
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for Micronas DRX39xx family (drx3933j)
  *
- *  Written by Devin Heitmueller <devin.heitmueller@gmail.com>
+ *  Written by Devin Heitmueller <devin.heitmueller@kernellabs.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.h b/drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.h
index eea6a01a..c29cd43 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.h
@@ -1,7 +1,7 @@
 /*
  *  Driver for Micronas DRX39xx family (drx3933j)
  *
- *  Written by Devin Heitmueller <devin.heitmueller@gmail.com>
+ *  Written by Devin Heitmueller <devin.heitmueller@kernellabs.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.c b/drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.c
index cc10dae..8289b90 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.c
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /*******************************************************************************
 * FILENAME: $Id: drx_dap_fasi.c,v 1.7 2009/12/28 14:36:21 carlo Exp $
 *
@@ -15,35 +45,6 @@
 * -
 *
 * NOTES:
-* $(c) 2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
 *
 *
 *******************************************************************************/
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.h b/drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.h
index 77ff371..4429ef7 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /*******************************************************************************
 * FILENAME: $Id: drx_dap_fasi.h,v 1.5 2009/07/07 14:21:40 justin Exp $
 *
@@ -11,35 +41,6 @@
 * Include.
 *
 * NOTES:
-* $(c) 2008-2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
 *
 *
 *******************************************************************************/
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.c b/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.c
index 7b02841..84c7dd4 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.c
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.c
@@ -1,38 +1,38 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: drx_driver.c,v 1.40 2010/01/12 01:24:56 lfeng Exp $
 *
 * \brief Generic DRX functionality, DRX driver core.
 *
-* $(c) 2004-2010 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
 */
 
 /*------------------------------------------------------------------------------
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.h b/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.h
index d3bfe06..0533344 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.h
@@ -1,38 +1,38 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: drx_driver.h,v 1.84 2010/01/14 22:47:50 dingtao Exp $
 *
 * \brief DRX driver API
 *
-* $(c) 2004-2010 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
 */
 #ifndef __DRXDRIVER_H__
 #define __DRXDRIVER_H__
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver_version.h b/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver_version.h
index f478514..77d596c 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver_version.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drx_driver_version.h
@@ -9,40 +9,39 @@
  * Output start:    [entry point]
  * 
  * filename         last modified               re-use  
- * -----------------------------------------------------
+ *
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
+/* -----------------------------------------------------
  * version.idf      Mon Jan 18 11:56:10 2010    -       
  * 
- * $(c) 2010 Trident Microsystems, Inc. - All rights reserved.
- * 
- * This software and related documentation (the 'Software') are intellectual 
- * property owned by Trident and are copyright of Trident, unless specifically 
- * noted otherwise.
- * 
- * Any use of the Software is permitted only pursuant to the terms of the 
- * license agreement, if any, which accompanies, is included with or applicable 
- * to the Software ('License Agreement') or upon express written consent of 
- * Trident. Any copying, reproduction or redistribution of the Software in 
- * whole or in part by any means not in accordance with the License Agreement 
- * or as agreed in writing by Trident is expressly prohibited.
- * 
- * THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE 
- * LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE 
- * IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND 
- * CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES AND 
- * CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT 
- * ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL 
- * PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY TO 
- * USE THE SOFTWARE.
- * 
- * IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL, 
- * PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION, 
- * DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF 
- * BUSINESS INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF 
- * OR THE INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF 
- * THE POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING 
- * FROM TRIDENT'S NEGLIGENCE. $
- * 
- *******************************************************************************
  */
 
 #ifndef __DRX_DRIVER_VERSION__H__
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drxj.c b/drivers/staging/media/dvb/frontends/drx39xyj/drxj.c
index 1e3454c..61042f11 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drxj.c
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drxj.c
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: drxj.c,v 1.637 2010/01/18 17:21:10 dingtao Exp $
 *
@@ -6,39 +36,6 @@
 * \author Dragan Savic, Milos Nikolic, Mihajlo Katona, Tao Ding, Paul Janssen
 */
 
-/*
-* $(c) 2006-2010 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
-*/
-
 /*-----------------------------------------------------------------------------
 INCLUDE FILES
 ----------------------------------------------------------------------------*/
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drxj.h b/drivers/staging/media/dvb/frontends/drx39xyj/drxj.h
index ee7aa6a..cb6cc3f 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drxj.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drxj.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: drxj.h,v 1.132 2009/12/22 12:13:48 danielg Exp $
 *
@@ -6,38 +36,6 @@
 * \author Dragan Savic, Milos Nikolic, Mihajlo Katona, Tao Ding, Paul Janssen
 */
 
-/*
-* $(c) 2006-2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
-*/
 #ifndef __DRXJ_H__
 #define __DRXJ_H__
 /*-------------------------------------------------------------------------
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_map.h b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_map.h
index 27530a5..44a081a 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_map.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_map.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /* 
  ***********************************************************************************************************************
  * WARNING - THIS FILE HAS BEEN GENERATED - DO NOT CHANGE
@@ -12,29 +42,6 @@
  * -----------------------------------------------------
  * reg_map.1.tmp    Mon Jan 18 12:09:24 2010    -       
  * 
- * $(c) 2010 Trident Microsystems, Inc. - All rights reserved.
- * 
- * This software and related documentation (the 'Software') are intellectual property owned by Trident and are 
- * copyright of Trident, unless specifically noted otherwise.
- * 
- * Any use of the Software is permitted only pursuant to the terms of the license agreement, if any, which accompanies, 
- * is included with or applicable to the Software ('License Agreement') or upon express written consent of Trident. Any 
- * copying, reproduction or redistribution of the Software in whole or in part by any means not in accordance with the 
- * License Agreement or as agreed in writing by Trident is expressly prohibited.
- * 
- * THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE LICENSE AGREEMENT. EXCEPT AS WARRANTED IN 
- * THE LICENSE AGREEMENT THE SOFTWARE IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS 
- * WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A 
- * PARTICULAR PURPOSE, QUIT ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL PROPERTY OR OTHER 
- * RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY TO USE THE SOFTWARE.
- * 
- * IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL, PUNITIVE, SPECIAL OR OTHER DAMAGES 
- * WHATSOEVER INCLUDING WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF 
- * BUSINESS INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE INABILITY TO USE THE SOFTWARE, 
- * EVEN IF TRIDENT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM 
- * TRIDENT'S NEGLIGENCE. $
- * 
- ***********************************************************************************************************************
  */
 
 #ifndef __DRXJ_MAP__H__
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc.h b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc.h
index 8be8272..cecc31d 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /*-----------------------------------------------------------------------------
 * DESCRIPTION:
 * Contains firmware version: 1.0.8
@@ -6,45 +36,7 @@
 * Include.
 *
 * NOTES:
-* (c) 2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.
-*
-* IN NO EVENT SHALL MICRONAS BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF MICRONAS HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* MICRONAS' NEGLIGENCE.
-*
-----------------------------------------------------------------------------*/
+*/
 
 #ifndef __DRXJ_MC_MAIN_H__
 #define __DRXJ_MC_MAIN_H__
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsb.h b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsb.h
index a117ec1..9c24d3e 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsb.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsb.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /*-----------------------------------------------------------------------------
 * DESCRIPTION:
 * Contains firmware version: 1.0.8
@@ -6,44 +36,6 @@
 * Include.
 *
 * NOTES:
-* (c) 2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.
-*
-* IN NO EVENT SHALL MICRONAS BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF MICRONAS HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* MICRONAS' NEGLIGENCE.
-*
 ----------------------------------------------------------------------------*/
 
 #ifndef __DRXJ_MC_VSB_H__
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h
index 4ef0a07..2eda7b8 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /*-----------------------------------------------------------------------------
 * DESCRIPTION:
 * Contains firmware version: 1.0.8
@@ -6,43 +36,6 @@
 * Include.
 *
 * NOTES:
-* (c) 2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.
-*
-* IN NO EVENT SHALL MICRONAS BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF MICRONAS HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* MICRONAS' NEGLIGENCE.
 *
 ----------------------------------------------------------------------------*/
 
diff --git a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_options.h b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_options.h
index 11975cc..0969817 100644
--- a/drivers/staging/media/dvb/frontends/drx39xyj/drxj_options.h
+++ b/drivers/staging/media/dvb/frontends/drx39xyj/drxj_options.h
@@ -1,3 +1,33 @@
+/*
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
 /**
 * \file $Id: drxj_options.h,v 1.5 2009/10/05 21:32:49 dingtao Exp $
 *
@@ -6,39 +36,6 @@
 * \author Tao Ding
 */
 
-/*
-* $(c) 2006-2007,2009 Trident Microsystems, Inc. - All rights reserved.
-*
-* This software and related documentation (the 'Software') are intellectual
-* property owned by Trident and are copyright of Trident, unless specifically
-* noted otherwise.
-*
-* Any use of the Software is permitted only pursuant to the terms of the
-* license agreement, if any, which accompanies, is included with or applicable
-* to the Software ('License Agreement') or upon express written consent of
-* Trident. Any copying, reproduction or redistribution of the Software in
-* whole or in part by any means not in accordance with the License Agreement
-* or as agreed in writing by Trident is expressly prohibited.
-*
-* THE SOFTWARE IS WARRANTED, IF AT ALL, ONLY ACCORDING TO THE TERMS OF THE
-* LICENSE AGREEMENT. EXCEPT AS WARRANTED IN THE LICENSE AGREEMENT THE SOFTWARE
-* IS DELIVERED 'AS IS' AND TRIDENT HEREBY DISCLAIMS ALL WARRANTIES AND
-* CONDITIONS WITH REGARD TO THE SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
-* AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIT
-* ENJOYMENT, TITLE AND NON-INFRINGEMENT OF ANY THIRD PARTY INTELLECTUAL
-* PROPERTY OR OTHER RIGHTS WHICH MAY RESULT FROM THE USE OR THE INABILITY
-* TO USE THE SOFTWARE.
-*
-* IN NO EVENT SHALL TRIDENT BE LIABLE FOR INDIRECT, INCIDENTAL, CONSEQUENTIAL,
-* PUNITIVE, SPECIAL OR OTHER DAMAGES WHATSOEVER INCLUDING WITHOUT LIMITATION,
-* DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS
-* INFORMATION, AND THE LIKE, ARISING OUT OF OR RELATING TO THE USE OF OR THE
-* INABILITY TO USE THE SOFTWARE, EVEN IF TRIDENT HAS BEEN ADVISED OF THE
-* POSSIBILITY OF SUCH DAMAGES, EXCEPT PERSONAL INJURY OR DEATH RESULTING FROM
-* TRIDENT'S NEGLIGENCE.                                                        $
-*
-*/
-
 /* Note: Please add preprocessor DRXJ_OPTIONS_H for drxj.c to include this file */
 #ifndef __DRXJ_OPTIONS_H__
 #define __DRXJ_OPTIONS_H__
-- 
1.7.7.6

