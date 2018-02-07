Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33101 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754031AbeBGOjp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 09:39:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] include/(uapi/)media: add SPDX license info
Date: Wed,  7 Feb 2018 15:39:34 +0100
Message-Id: <20180207143939.29491-3-hverkuil@xs4all.nl>
In-Reply-To: <20180207143939.29491-1-hverkuil@xs4all.nl>
References: <20180207143939.29491-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Replace the old license information with the corresponding SPDX
license for those headers that I authored.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec-notifier.h    | 14 +-------------
 include/media/cec-pin.h         | 14 +-------------
 include/media/cec.h             | 14 +-------------
 include/media/i2c/ad9389b.h     | 14 +-------------
 include/media/i2c/adv7511.h     | 14 +-------------
 include/media/i2c/adv7604.h     | 15 +--------------
 include/media/i2c/adv7842.h     | 15 +--------------
 include/media/i2c/tc358743.h    | 18 ++----------------
 include/media/i2c/ths7303.h     | 10 +---------
 include/media/i2c/uda1342.h     | 15 +--------------
 include/media/tpg/v4l2-tpg.h    | 14 +-------------
 include/media/v4l2-dv-timings.h | 15 +--------------
 include/media/v4l2-rect.h       | 14 +-------------
 include/uapi/linux/cec-funcs.h  | 29 -----------------------------
 include/uapi/linux/cec.h        | 29 -----------------------------
 15 files changed, 14 insertions(+), 230 deletions(-)

diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index 57ec319a7f44..cf0add70b0e7 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -1,21 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * cec-notifier.h - notify CEC drivers of physical address changes
  *
  * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
  * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef LINUX_CEC_NOTIFIER_H
diff --git a/include/media/cec-pin.h b/include/media/cec-pin.h
index 83b3e17e0a07..ed16c6dde0ba 100644
--- a/include/media/cec-pin.h
+++ b/include/media/cec-pin.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * cec-pin.h - low-level CEC pin control
  *
  * Copyright 2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef LINUX_CEC_PIN_H
diff --git a/include/media/cec.h b/include/media/cec.h
index 7cdf71d7125a..9afba9b558df 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * cec - HDMI Consumer Electronics Control support header
  *
  * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef _MEDIA_CEC_H
diff --git a/include/media/i2c/ad9389b.h b/include/media/i2c/ad9389b.h
index 5ba9af869b8b..30f9ea9a1273 100644
--- a/include/media/i2c/ad9389b.h
+++ b/include/media/i2c/ad9389b.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Analog Devices AD9389B/AD9889B video encoder driver header
  *
  * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef AD9389B_H
diff --git a/include/media/i2c/adv7511.h b/include/media/i2c/adv7511.h
index 61c3d711cc69..1874c05f486f 100644
--- a/include/media/i2c/adv7511.h
+++ b/include/media/i2c/adv7511.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Analog Devices ADV7511 HDMI Transmitter Device Driver
  *
  * Copyright 2013 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef ADV7511_H
diff --git a/include/media/i2c/adv7604.h b/include/media/i2c/adv7604.h
index 2e6857dee0cc..77a9799128b6 100644
--- a/include/media/i2c/adv7604.h
+++ b/include/media/i2c/adv7604.h
@@ -1,21 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * adv7604 - Analog Devices ADV7604 video decoder driver
  *
  * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
  */
 
 #ifndef _ADV7604_
diff --git a/include/media/i2c/adv7842.h b/include/media/i2c/adv7842.h
index 7f53ada9bdf1..05e01f0dd3c2 100644
--- a/include/media/i2c/adv7842.h
+++ b/include/media/i2c/adv7842.h
@@ -1,21 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * adv7842 - Analog Devices ADV7842 video decoder driver
  *
  * Copyright 2013 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
  */
 
 #ifndef _ADV7842_
diff --git a/include/media/i2c/tc358743.h b/include/media/i2c/tc358743.h
index 4513f2f9cfbc..b343650c2948 100644
--- a/include/media/i2c/tc358743.h
+++ b/include/media/i2c/tc358743.h
@@ -1,22 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * tc358743 - Toshiba HDMI to CSI-2 bridge
  *
- * Copyright 2015 Cisco Systems, Inc. and/or its affiliates. All rights
- * reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
+ * Copyright 2015 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
  */
 
 /*
diff --git a/include/media/i2c/ths7303.h b/include/media/i2c/ths7303.h
index 834e2f95b630..95492d12786d 100644
--- a/include/media/i2c/ths7303.h
+++ b/include/media/i2c/ths7303.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (C) 2013 Texas Instruments Inc
  *
@@ -7,15 +8,6 @@
  *     Hans Verkuil <hans.verkuil@cisco.com>
  *     Lad, Prabhakar <prabhakar.lad@ti.com>
  *     Martin Bugge <marbugge@cisco.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 #ifndef THS7353_H
diff --git a/include/media/i2c/uda1342.h b/include/media/i2c/uda1342.h
index cd156403a368..cb412d4c1088 100644
--- a/include/media/i2c/uda1342.h
+++ b/include/media/i2c/uda1342.h
@@ -1,21 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * uda1342.h - definition for uda1342 inputs
  *
  * Copyright 2013 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
  */
 
 #ifndef _UDA1342_H_
diff --git a/include/media/tpg/v4l2-tpg.h b/include/media/tpg/v4l2-tpg.h
index 823fadede7bf..eb191e85d363 100644
--- a/include/media/tpg/v4l2-tpg.h
+++ b/include/media/tpg/v4l2-tpg.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * v4l2-tpg.h - Test Pattern Generator
  *
  * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef _V4L2_TPG_H_
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index ebf00e07a515..8778263a8f5d 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -1,21 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * v4l2-dv-timings - Internal header with dv-timings helper functions
  *
  * Copyright 2013 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
  */
 
 #ifndef __V4L2_DV_TIMINGS_H
diff --git a/include/media/v4l2-rect.h b/include/media/v4l2-rect.h
index d2125f0cc7cd..595c3ba05f23 100644
--- a/include/media/v4l2-rect.h
+++ b/include/media/v4l2-rect.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * v4l2-rect.h - v4l2_rect helper functions
  *
  * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef _V4L2_RECT_H_
diff --git a/include/uapi/linux/cec-funcs.h b/include/uapi/linux/cec-funcs.h
index 28e8a2a86e16..8997d5068c08 100644
--- a/include/uapi/linux/cec-funcs.h
+++ b/include/uapi/linux/cec-funcs.h
@@ -3,35 +3,6 @@
  * cec - HDMI Consumer Electronics Control message functions
  *
  * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * Alternatively you can redistribute this file under the terms of the
- * BSD license as stated below:
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- * 3. The names of its contributors may not be used to endorse or promote
- *    products derived from this software without specific prior written
- *    permission.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef _CEC_UAPI_FUNCS_H
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index b51fbe1941a7..20fe091b7e96 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -3,35 +3,6 @@
  * cec - HDMI Consumer Electronics Control public header
  *
  * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * Alternatively you can redistribute this file under the terms of the
- * BSD license as stated below:
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- * 3. The names of its contributors may not be used to endorse or promote
- *    products derived from this software without specific prior written
- *    permission.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #ifndef _CEC_UAPI_H
-- 
2.15.1
