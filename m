Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:36928 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754115AbeBGOjq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 09:39:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] cobalt: add SPDX license info
Date: Wed,  7 Feb 2018 15:39:36 +0100
Message-Id: <20180207143939.29491-5-hverkuil@xs4all.nl>
In-Reply-To: <20180207143939.29491-1-hverkuil@xs4all.nl>
References: <20180207143939.29491-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Replace the old license information with the corresponding SPDX
license.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/Makefile                          |  1 +
 drivers/media/pci/cobalt/cobalt-alsa-main.c                | 14 +-------------
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c                 | 14 +-------------
 drivers/media/pci/cobalt/cobalt-alsa-pcm.h                 | 14 +-------------
 drivers/media/pci/cobalt/cobalt-alsa.h                     | 14 +-------------
 drivers/media/pci/cobalt/cobalt-cpld.c                     | 14 +-------------
 drivers/media/pci/cobalt/cobalt-cpld.h                     | 14 +-------------
 drivers/media/pci/cobalt/cobalt-driver.c                   | 14 +-------------
 drivers/media/pci/cobalt/cobalt-driver.h                   | 14 +-------------
 drivers/media/pci/cobalt/cobalt-flash.c                    | 14 +-------------
 drivers/media/pci/cobalt/cobalt-flash.h                    | 14 +-------------
 drivers/media/pci/cobalt/cobalt-i2c.c                      | 14 +-------------
 drivers/media/pci/cobalt/cobalt-i2c.h                      | 14 +-------------
 drivers/media/pci/cobalt/cobalt-irq.c                      | 14 +-------------
 drivers/media/pci/cobalt/cobalt-irq.h                      | 14 +-------------
 drivers/media/pci/cobalt/cobalt-omnitek.c                  | 14 +-------------
 drivers/media/pci/cobalt/cobalt-omnitek.h                  | 14 +-------------
 drivers/media/pci/cobalt/cobalt-v4l2.c                     | 14 +-------------
 drivers/media/pci/cobalt/cobalt-v4l2.h                     | 14 +-------------
 .../media/pci/cobalt/m00233_video_measure_memmap_package.h | 14 +-------------
 .../media/pci/cobalt/m00235_fdma_packer_memmap_package.h   | 14 +-------------
 drivers/media/pci/cobalt/m00389_cvi_memmap_package.h       | 14 +-------------
 drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h     | 14 +-------------
 drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h | 14 +-------------
 .../pci/cobalt/m00479_clk_loss_detector_memmap_package.h   | 14 +-------------
 .../pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h  | 14 +-------------
 26 files changed, 26 insertions(+), 325 deletions(-)

diff --git a/drivers/media/pci/cobalt/Makefile b/drivers/media/pci/cobalt/Makefile
index b328955abbd2..29eddff2f35f 100644
--- a/drivers/media/pci/cobalt/Makefile
+++ b/drivers/media/pci/cobalt/Makefile
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 cobalt-objs    := cobalt-driver.o cobalt-irq.o cobalt-v4l2.o \
 		  cobalt-i2c.o cobalt-omnitek.o cobalt-flash.o cobalt-cpld.o \
 		  cobalt-alsa-main.o cobalt-alsa-pcm.o
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-main.c b/drivers/media/pci/cobalt/cobalt-alsa-main.c
index 720e3ad93a9e..e5022b620856 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa-main.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-main.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  ALSA interface to cobalt PCM capture streams
  *
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <linux/init.h>
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
index b69b258d39b9..f6a7df13cd04 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
@@ -1,22 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  ALSA PCM device for the
  *  ALSA interface to cobalt PCM capture streams
  *
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <linux/init.h>
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-pcm.h b/drivers/media/pci/cobalt/cobalt-alsa-pcm.h
index 513fb1f71794..0e2e9c63a23e 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa-pcm.h
+++ b/drivers/media/pci/cobalt/cobalt-alsa-pcm.h
@@ -1,22 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  ALSA PCM device for the
  *  ALSA interface to cobalt PCM capture streams
  *
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 int snd_cobalt_pcm_create(struct snd_cobalt_card *cobsc);
diff --git a/drivers/media/pci/cobalt/cobalt-alsa.h b/drivers/media/pci/cobalt/cobalt-alsa.h
index 08db699ced37..bb7f156ad3e7 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa.h
+++ b/drivers/media/pci/cobalt/cobalt-alsa.h
@@ -1,21 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  ALSA interface to cobalt PCM capture streams
  *
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 struct snd_card;
diff --git a/drivers/media/pci/cobalt/cobalt-cpld.c b/drivers/media/pci/cobalt/cobalt-cpld.c
index bfcecef659e3..3d8026483ac3 100644
--- a/drivers/media/pci/cobalt/cobalt-cpld.c
+++ b/drivers/media/pci/cobalt/cobalt-cpld.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  Cobalt CPLD functions
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <linux/delay.h>
diff --git a/drivers/media/pci/cobalt/cobalt-cpld.h b/drivers/media/pci/cobalt/cobalt-cpld.h
index 0fc88fd5fa7b..8c880ed14cda 100644
--- a/drivers/media/pci/cobalt/cobalt-cpld.h
+++ b/drivers/media/pci/cobalt/cobalt-cpld.h
@@ -1,21 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Cobalt CPLD functions
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef COBALT_CPLD_H
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 3f16cf3f6d74..c8b1a6206c65 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  cobalt driver initialization and card probing
  *
@@ -5,19 +6,6 @@
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <linux/delay.h>
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index 00f773ec359a..429bee4ef79c 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  cobalt driver internal defines and structures
  *
@@ -5,19 +6,6 @@
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef COBALT_DRIVER_H
diff --git a/drivers/media/pci/cobalt/cobalt-flash.c b/drivers/media/pci/cobalt/cobalt-flash.c
index 04dcaf9198d2..ef96e0f956d2 100644
--- a/drivers/media/pci/cobalt/cobalt-flash.c
+++ b/drivers/media/pci/cobalt/cobalt-flash.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  Cobalt NOR flash functions
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <linux/mtd/mtd.h>
diff --git a/drivers/media/pci/cobalt/cobalt-flash.h b/drivers/media/pci/cobalt/cobalt-flash.h
index 8077daea51cd..605ce3d37ca3 100644
--- a/drivers/media/pci/cobalt/cobalt-flash.h
+++ b/drivers/media/pci/cobalt/cobalt-flash.h
@@ -1,21 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Cobalt NOR flash functions
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef COBALT_FLASH_H
diff --git a/drivers/media/pci/cobalt/cobalt-i2c.c b/drivers/media/pci/cobalt/cobalt-i2c.c
index 1a5c55673ea8..c374dae78bf7 100644
--- a/drivers/media/pci/cobalt/cobalt-i2c.c
+++ b/drivers/media/pci/cobalt/cobalt-i2c.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  cobalt I2C functions
  *
@@ -5,19 +6,6 @@
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include "cobalt-driver.h"
diff --git a/drivers/media/pci/cobalt/cobalt-i2c.h b/drivers/media/pci/cobalt/cobalt-i2c.h
index a4c1cfaacf95..7a9057c8bff6 100644
--- a/drivers/media/pci/cobalt/cobalt-i2c.h
+++ b/drivers/media/pci/cobalt/cobalt-i2c.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  cobalt I2C functions
  *
@@ -5,19 +6,6 @@
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 /* init + register i2c algo-bit adapter */
diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index b190d4f81c6e..04783e78cc12 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  cobalt interrupt handling
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <media/i2c/adv7604.h>
diff --git a/drivers/media/pci/cobalt/cobalt-irq.h b/drivers/media/pci/cobalt/cobalt-irq.h
index 5119484a24d9..0b4078ce6555 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.h
+++ b/drivers/media/pci/cobalt/cobalt-irq.h
@@ -1,21 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  cobalt interrupt handling
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <linux/interrupt.h>
diff --git a/drivers/media/pci/cobalt/cobalt-omnitek.c b/drivers/media/pci/cobalt/cobalt-omnitek.c
index a28a8482c1d4..4c137453e679 100644
--- a/drivers/media/pci/cobalt/cobalt-omnitek.c
+++ b/drivers/media/pci/cobalt/cobalt-omnitek.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  Omnitek Scatter-Gather DMA Controller
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <linux/string.h>
diff --git a/drivers/media/pci/cobalt/cobalt-omnitek.h b/drivers/media/pci/cobalt/cobalt-omnitek.h
index e5c6d032c6f2..129c5fccbe39 100644
--- a/drivers/media/pci/cobalt/cobalt-omnitek.h
+++ b/drivers/media/pci/cobalt/cobalt-omnitek.h
@@ -1,21 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Omnitek Scatter-Gather DMA Controller
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef COBALT_OMNITEK_H
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index def4a3b37084..e2a4c705d353 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  *  cobalt V4L2 API
  *
@@ -5,19 +6,6 @@
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #include <linux/dma-mapping.h>
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.h b/drivers/media/pci/cobalt/cobalt-v4l2.h
index 62be553cd8e2..dc43974b2d86 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.h
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.h
@@ -1,21 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  cobalt V4L2 API
  *
  *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 int cobalt_nodes_register(struct cobalt *cobalt);
diff --git a/drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h b/drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
index 9bc9ef1fd3a8..4c6ad1cee87e 100644
--- a/drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
+++ b/drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
@@ -1,19 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef M00233_VIDEO_MEASURE_MEMMAP_PACKAGE_H
diff --git a/drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h b/drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
index a480529f561e..6cc1ad7d98c9 100644
--- a/drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
+++ b/drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
@@ -1,19 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef M00235_FDMA_PACKER_MEMMAP_PACKAGE_H
diff --git a/drivers/media/pci/cobalt/m00389_cvi_memmap_package.h b/drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
index 602419e589d3..f0c6fe304247 100644
--- a/drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
+++ b/drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
@@ -1,19 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef M00389_CVI_MEMMAP_PACKAGE_H
diff --git a/drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h b/drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
index 95471c995067..27f05aca632f 100644
--- a/drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
+++ b/drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
@@ -1,19 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef M00460_EVCNT_MEMMAP_PACKAGE_H
diff --git a/drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h b/drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
index 384a3e156301..8a5bf008750a 100644
--- a/drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
+++ b/drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
@@ -1,19 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef M00473_FREEWHEEL_MEMMAP_PACKAGE_H
diff --git a/drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h b/drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
index 2a029026bf82..18bd4fcd2db8 100644
--- a/drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
+++ b/drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
@@ -1,19 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef M00479_CLK_LOSS_DETECTOR_MEMMAP_PACKAGE_H
diff --git a/drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h b/drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h
index bdef2df5d689..86da49033cd8 100644
--- a/drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h
+++ b/drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h
@@ -1,19 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
  *  All rights reserved.
- *
- *  This program is free software; you may redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- *
- *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- *  SOFTWARE.
  */
 
 #ifndef M00514_SYNCGEN_FLOW_EVCNT_MEMMAP_PACKAGE_H
-- 
2.15.1
