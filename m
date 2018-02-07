Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57414 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753983AbeBGOjq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 09:39:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/7] vivid: add SPDX license info
Date: Wed,  7 Feb 2018 15:39:35 +0100
Message-Id: <20180207143939.29491-4-hverkuil@xs4all.nl>
In-Reply-To: <20180207143939.29491-1-hverkuil@xs4all.nl>
References: <20180207143939.29491-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Replace the old license information with the corresponding SPDX
license.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-cec.c          | 14 +-------------
 drivers/media/platform/vivid/vivid-cec.h          | 14 +-------------
 drivers/media/platform/vivid/vivid-core.c         | 14 +-------------
 drivers/media/platform/vivid/vivid-core.h         | 14 +-------------
 drivers/media/platform/vivid/vivid-ctrls.c        | 14 +-------------
 drivers/media/platform/vivid/vivid-ctrls.h        | 14 +-------------
 drivers/media/platform/vivid/vivid-kthread-cap.c  | 14 +-------------
 drivers/media/platform/vivid/vivid-kthread-cap.h  | 14 +-------------
 drivers/media/platform/vivid/vivid-kthread-out.c  | 14 +-------------
 drivers/media/platform/vivid/vivid-kthread-out.h  | 14 +-------------
 drivers/media/platform/vivid/vivid-osd.c          | 14 +-------------
 drivers/media/platform/vivid/vivid-osd.h          | 14 +-------------
 drivers/media/platform/vivid/vivid-radio-common.c | 14 +-------------
 drivers/media/platform/vivid/vivid-radio-common.h | 14 +-------------
 drivers/media/platform/vivid/vivid-radio-rx.c     | 14 +-------------
 drivers/media/platform/vivid/vivid-radio-rx.h     | 14 +-------------
 drivers/media/platform/vivid/vivid-radio-tx.c     | 14 +-------------
 drivers/media/platform/vivid/vivid-radio-tx.h     | 14 +-------------
 drivers/media/platform/vivid/vivid-rds-gen.c      | 14 +-------------
 drivers/media/platform/vivid/vivid-rds-gen.h      | 14 +-------------
 drivers/media/platform/vivid/vivid-sdr-cap.c      | 14 +-------------
 drivers/media/platform/vivid/vivid-sdr-cap.h      | 14 +-------------
 drivers/media/platform/vivid/vivid-vbi-cap.c      | 14 +-------------
 drivers/media/platform/vivid/vivid-vbi-cap.h      | 14 +-------------
 drivers/media/platform/vivid/vivid-vbi-gen.c      | 14 +-------------
 drivers/media/platform/vivid/vivid-vbi-gen.h      | 14 +-------------
 drivers/media/platform/vivid/vivid-vbi-out.c      | 14 +-------------
 drivers/media/platform/vivid/vivid-vbi-out.h      | 14 +-------------
 drivers/media/platform/vivid/vivid-vid-cap.c      | 14 +-------------
 drivers/media/platform/vivid/vivid-vid-cap.h      | 14 +-------------
 drivers/media/platform/vivid/vivid-vid-common.c   | 14 +-------------
 drivers/media/platform/vivid/vivid-vid-common.h   | 14 +-------------
 drivers/media/platform/vivid/vivid-vid-out.c      | 14 +-------------
 drivers/media/platform/vivid/vivid-vid-out.h      | 14 +-------------
 34 files changed, 34 insertions(+), 442 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index b55d278d38a7..619bd8435b7f 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-cec.c - A Virtual Video Test Driver, cec emulation
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
 
 #include <media/cec.h>
diff --git a/drivers/media/platform/vivid/vivid-cec.h b/drivers/media/platform/vivid/vivid-cec.h
index 3926b1422777..7524ed48a914 100644
--- a/drivers/media/platform/vivid/vivid-cec.h
+++ b/drivers/media/platform/vivid/vivid-cec.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-cec.h - A Virtual Video Test Driver, cec emulation
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
 
 #ifdef CONFIG_VIDEO_VIVID_CEC
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index a091cfd93164..fa16b7b200c5 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-core.c - A Virtual Video Test Driver, core initialization
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
 
 #include <linux/module.h>
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index c90e4a0ab94e..477c80a4d44c 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-core.h - core datastructures
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
 
 #ifndef _VIVID_CORE_H_
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 3f9d354827af..4b6b5d715031 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-ctrls.c - control support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-ctrls.h b/drivers/media/platform/vivid/vivid-ctrls.h
index 9bcca9d56359..6fad5f5d0054 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.h
+++ b/drivers/media/platform/vivid/vivid-ctrls.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-ctrls.h - control support functions.
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
 
 #ifndef _VIVID_CTRLS_H_
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 6ca71aabb576..3fdb280c36ca 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-kthread-cap.h - video/vbi capture thread support functions.
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
 
 #include <linux/module.h>
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.h b/drivers/media/platform/vivid/vivid-kthread-cap.h
index 5b92fc9a0d04..0f43015306d6 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.h
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-kthread-cap.h - video/vbi capture thread support functions.
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
 
 #ifndef _VIVID_KTHREAD_CAP_H_
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index 98eed5889bc1..9981e7548019 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-kthread-out.h - video/vbi output thread support functions.
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
 
 #include <linux/module.h>
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.h b/drivers/media/platform/vivid/vivid-kthread-out.h
index 2bf04a17b05d..d5bcf44bbaca 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.h
+++ b/drivers/media/platform/vivid/vivid-kthread-out.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-kthread-out.h - video/vbi output thread support functions.
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
 
 #ifndef _VIVID_KTHREAD_OUT_H_
diff --git a/drivers/media/platform/vivid/vivid-osd.c b/drivers/media/platform/vivid/vivid-osd.c
index bdc380b14e0c..bbbc1b6938a5 100644
--- a/drivers/media/platform/vivid/vivid-osd.c
+++ b/drivers/media/platform/vivid/vivid-osd.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-osd.c - osd support for testing overlays.
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
 
 #include <linux/module.h>
diff --git a/drivers/media/platform/vivid/vivid-osd.h b/drivers/media/platform/vivid/vivid-osd.h
index 57c9daa5940a..f9ac1af25dd3 100644
--- a/drivers/media/platform/vivid/vivid-osd.h
+++ b/drivers/media/platform/vivid/vivid-osd.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-osd.h - output overlay support functions.
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
 
 #ifndef _VIVID_OSD_H_
diff --git a/drivers/media/platform/vivid/vivid-radio-common.c b/drivers/media/platform/vivid/vivid-radio-common.c
index 78c1e920670a..7c8efe38ff5b 100644
--- a/drivers/media/platform/vivid/vivid-radio-common.c
+++ b/drivers/media/platform/vivid/vivid-radio-common.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-radio-common.c - common radio rx/tx support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-radio-common.h b/drivers/media/platform/vivid/vivid-radio-common.h
index 92fe589141b7..30a9900e5b2b 100644
--- a/drivers/media/platform/vivid/vivid-radio-common.h
+++ b/drivers/media/platform/vivid/vivid-radio-common.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-radio-common.h - common radio rx/tx support functions.
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
 
 #ifndef _VIVID_RADIO_COMMON_H_
diff --git a/drivers/media/platform/vivid/vivid-radio-rx.c b/drivers/media/platform/vivid/vivid-radio-rx.c
index 35fbff490535..ecff04e4be3e 100644
--- a/drivers/media/platform/vivid/vivid-radio-rx.c
+++ b/drivers/media/platform/vivid/vivid-radio-rx.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-radio-rx.c - radio receiver support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-radio-rx.h b/drivers/media/platform/vivid/vivid-radio-rx.h
index 1077d8f061eb..bff94e67bf75 100644
--- a/drivers/media/platform/vivid/vivid-radio-rx.h
+++ b/drivers/media/platform/vivid/vivid-radio-rx.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-radio-rx.h - radio receiver support functions.
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
 
 #ifndef _VIVID_RADIO_RX_H_
diff --git a/drivers/media/platform/vivid/vivid-radio-tx.c b/drivers/media/platform/vivid/vivid-radio-tx.c
index 897b56195ca7..0b90cfa4bfe8 100644
--- a/drivers/media/platform/vivid/vivid-radio-tx.c
+++ b/drivers/media/platform/vivid/vivid-radio-tx.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-radio-tx.c - radio transmitter support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-radio-tx.h b/drivers/media/platform/vivid/vivid-radio-tx.h
index 7f8ff7547119..7a5225abbc67 100644
--- a/drivers/media/platform/vivid/vivid-radio-tx.h
+++ b/drivers/media/platform/vivid/vivid-radio-tx.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-radio-tx.h - radio transmitter support functions.
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
 
 #ifndef _VIVID_RADIO_TX_H_
diff --git a/drivers/media/platform/vivid/vivid-rds-gen.c b/drivers/media/platform/vivid/vivid-rds-gen.c
index 996e35e28d37..39ca9a56448c 100644
--- a/drivers/media/platform/vivid/vivid-rds-gen.c
+++ b/drivers/media/platform/vivid/vivid-rds-gen.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-rds-gen.c - rds (radio data system) generator support functions.
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
 
 #include <linux/kernel.h>
diff --git a/drivers/media/platform/vivid/vivid-rds-gen.h b/drivers/media/platform/vivid/vivid-rds-gen.h
index e55e3b22b7ca..35ac5742302b 100644
--- a/drivers/media/platform/vivid/vivid-rds-gen.h
+++ b/drivers/media/platform/vivid/vivid-rds-gen.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-rds-gen.h - rds (radio data system) generator support functions.
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
 
 #ifndef _VIVID_RDS_GEN_H_
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index ebd7b9c4dd83..cfb7cb4d37a8 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-sdr-cap.c - software defined radio support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.h b/drivers/media/platform/vivid/vivid-sdr-cap.h
index 43014b2733db..813c9248e5a7 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.h
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-sdr-cap.h - software defined radio support functions.
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
 
 #ifndef _VIVID_SDR_CAP_H_
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index d66ef95dd2b5..92a852955173 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-vbi-cap.c - vbi capture support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.h b/drivers/media/platform/vivid/vivid-vbi-cap.h
index 2d8ea0bac743..91d2de01381c 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.h
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-vbi-cap.h - vbi capture support functions.
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
 
 #ifndef _VIVID_VBI_CAP_H_
diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.c b/drivers/media/platform/vivid/vivid-vbi-gen.c
index 02c79d7cedab..acc98445a1fa 100644
--- a/drivers/media/platform/vivid/vivid-vbi-gen.c
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-vbi-gen.c - vbi generator support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.h b/drivers/media/platform/vivid/vivid-vbi-gen.h
index 8444abe905ea..2657a7f5571c 100644
--- a/drivers/media/platform/vivid/vivid-vbi-gen.h
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-vbi-gen.h - vbi generator support functions.
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
 
 #ifndef _VIVID_VBI_GEN_H_
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index d2989195cf03..69486c130a7e 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-vbi-out.c - vbi output support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.h b/drivers/media/platform/vivid/vivid-vbi-out.h
index 6555ba9d2860..76584940cdaf 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.h
+++ b/drivers/media/platform/vivid/vivid-vbi-out.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-vbi-out.h - vbi output support functions.
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
 
 #ifndef _VIVID_VBI_OUT_H_
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 0fbbcde19f0d..808967c7b0ab 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-vid-cap.c - video capture support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.h b/drivers/media/platform/vivid/vivid-vid-cap.h
index 94079815dbc2..47d8b48820df 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.h
+++ b/drivers/media/platform/vivid/vivid-vid-cap.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-vid-cap.h - video capture support functions.
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
 
 #ifndef _VIVID_VID_CAP_H_
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index a651527d80db..cc67f403a808 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-vid-common.c - common video support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-vid-common.h b/drivers/media/platform/vivid/vivid-vid-common.h
index 4b6175eab8a2..29b6c0b40a1b 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.h
+++ b/drivers/media/platform/vivid/vivid-vid-common.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-vid-common.h - common video support functions.
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
 
 #ifndef _VIVID_VID_COMMON_H_
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 0b1b6218ede8..51fec66d8d45 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * vivid-vid-out.c - video output support functions.
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
 
 #include <linux/errno.h>
diff --git a/drivers/media/platform/vivid/vivid-vid-out.h b/drivers/media/platform/vivid/vivid-vid-out.h
index dfa84db184ed..e87aacf843c5 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.h
+++ b/drivers/media/platform/vivid/vivid-vid-out.h
@@ -1,20 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * vivid-vid-out.h - video output support functions.
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
 
 #ifndef _VIVID_VID_OUT_H_
-- 
2.15.1
