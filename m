Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaCCKHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:54 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 02/79] [media] drx-j: put under 3-clause BSD license
Date: Mon,  3 Mar 2014 07:05:56 -0300
Message-Id: <1393841233-24840-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Relicense the drx-j driver under a standard 3-clause BSD license, which makes
it GPL compatible.

This was done explicitly with permission from Trident Microsystems.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_host.h    | 62 ++++++++++---------
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h     | 63 ++++++++++---------
 drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h   | 63 ++++++++++---------
 drivers/media/dvb-frontends/drx39xyj/bsp_types.h   | 62 ++++++++++---------
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c    |  2 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |  2 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    | 59 +++++++++---------
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.h    | 59 +++++++++---------
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  | 60 +++++++++----------
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  | 60 +++++++++----------
 .../dvb-frontends/drx39xyj/drx_driver_version.h    | 63 ++++++++++---------
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 63 ++++++++++---------
 drivers/media/dvb-frontends/drx39xyj/drxj.h        | 62 ++++++++++---------
 drivers/media/dvb-frontends/drx39xyj/drxj_map.h    | 53 +++++++++-------
 drivers/media/dvb-frontends/drx39xyj/drxj_mc.h     | 70 ++++++++++------------
 drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h | 68 ++++++++++-----------
 .../media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h  | 67 ++++++++++-----------
 .../media/dvb-frontends/drx39xyj/drxj_options.h    | 63 ++++++++++---------
 18 files changed, 484 insertions(+), 517 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_host.h b/drivers/media/dvb-frontends/drx39xyj/bsp_host.h
index 30f711d5cd21..95b5232b0c67 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_host.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_host.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
index 6f4e69fb96af..25207c80a6b8 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
index e5693d0d5e9b..668f988e8687 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_types.h b/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
index 4a0dc0ba83bd..15a483d64ab0 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 524c07d9d451..36db20a8e0b8 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for Micronas DRX39xx family (drx3933j)
  *
- *  Written by Devin Heitmueller <devin.heitmueller@gmail.com>
+ *  Written by Devin Heitmueller <devin.heitmueller@kernellabs.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
index eea6a01afa78..c29cd43f2b00 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
@@ -1,7 +1,7 @@
 /*
  *  Driver for Micronas DRX39xx family (drx3933j)
  *
- *  Written by Devin Heitmueller <devin.heitmueller@gmail.com>
+ *  Written by Devin Heitmueller <devin.heitmueller@kernellabs.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index cc10daec3770..8289b901ff68 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
index 77ff3717c514..4429ef7c21e4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 7b0284195948..84c7dd42eb91 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index d3bfe0676581..053334455831 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h
index e6c777c13cf1..fd2b2780f8c4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h
@@ -9,40 +9,39 @@
  * Output start:    [entry point]
  *
  * filename         last modified               re-use
- * -----------------------------------------------------
- * version.idf      Mon Jan 18 11:56:10 2010    -
- *
- * $(c) 2010 Trident Microsystems, Inc. - All rights reserved.
- *
- * This software and related documentation (the 'Software') are intellectual
- * property owned by Trident and are copyright of Trident, unless specifically
- * noted otherwise.
  *
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
+ * version.idf      Mon Jan 18 11:56:10 2010    -
  *
- *******************************************************************************
  */
 
 #ifndef __DRX_DRIVER_VERSION__H__
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index a83f2ad67e7f..b4c70ac4029f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index ee7aa6aeac51..cb6cc3f4309e 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_map.h b/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
index 941aa14ca06e..35ecaae298e4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
@@ -1,4 +1,34 @@
 /*
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
+/*
  ***********************************************************************************************************************
  * WARNING - THIS FILE HAS BEEN GENERATED - DO NOT CHANGE
  *
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
index 8be827276a33..cecc31df2ba4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
index a117ec1f3ab1..9c24d3ee62cb 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
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
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
index 4ef0a07b4d3d..2eda7b88666c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
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
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_options.h b/drivers/media/dvb-frontends/drx39xyj/drxj_options.h
index 9299551a63a1..64ed1702d524 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_options.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_options.h
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
1.8.5.3

