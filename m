Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbcANLBQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 06:01:16 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: feinerer@openbsd.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: [PATCH 1/1] media: v4l: Dual license v4l2-common.h under GPL v2 and BSD licenses
Date: Thu, 14 Jan 2016 12:59:42 +0200
Message-Id: <1452769182-5102-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2-common.h user space header was split off from videodev2.h, but
the dual licensing of the videodev2.h (as well as other V4L2 headers) was
missed. Change the license of the v4l2-common.h from GNU GPL v2 to both
GNU GPL v2 and BSD.

Sakari Ailus <sakari.ailus@iki.fi>:
> Would you approve a license change of the patches to
> include/uapi/linux/v4l2-common.h (formerly include/linux/v4l2-common.h) you
> or your company have contributed from GNU GPL v2 to dual GNU GPL v2 and BSD
> licenses, changing the copyright notice in the file as below (from
> videodev2.h):
>
> -------------8<------------
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
>   *  the Free Software Foundation; either version 2 of the License, or
>   *  (at your option) any later version.
>   *
>   *  This program is distributed in the hope that it will be useful,
>   *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   *  GNU General Public License for more details.
>   *
>   *  Alternatively you can redistribute this file under the terms of the
>   *  BSD license as stated below:
>   *
>   *  Redistribution and use in source and binary forms, with or without
>   *  modification, are permitted provided that the following conditions
>   *  are met:
>   *  1. Redistributions of source code must retain the above copyright
>   *     notice, this list of conditions and the following disclaimer.
>   *  2. Redistributions in binary form must reproduce the above copyright
>   *     notice, this list of conditions and the following disclaimer in
>   *     the documentation and/or other materials provided with the
>   *     distribution.
>   *  3. The names of its contributors may not be used to endorse or promote
>   *     products derived from this software without specific prior written
>   *     permission.
>   *
>   *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
>   *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
>   *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
>   *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
>   *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
>   *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
>   *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
>   *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
>   *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
>   *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
>   *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> -------------8<------------

Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> No problem from my side.

Hans Verkuil <hans.verkuil@cisco.com>:
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Aaro Koskinen <aaro.koskinen@nokia.com>:
> This fine also for us.
>
> Acked-by: Aaro Koskinen <aaro.koskinen@nokia.com>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 include/uapi/linux/v4l2-common.h | 46 ++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/v4l2-common.h b/include/uapi/linux/v4l2-common.h
index 1527398..5b3f685 100644
--- a/include/uapi/linux/v4l2-common.h
+++ b/include/uapi/linux/v4l2-common.h
@@ -10,19 +10,43 @@
  * Copyright (C) 2012 Nokia Corporation
  * Contact: Sakari Ailus <sakari.ailus@iki.fi>
  *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
  *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
+ *  Alternatively you can redistribute this file under the terms of the
+ *  BSD license as stated below:
+ *
+ *  Redistribution and use in source and binary forms, with or without
+ *  modification, are permitted provided that the following conditions
+ *  are met:
+ *  1. Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *  2. Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *  3. The names of its contributors may not be used to endorse or promote
+ *     products derived from this software without specific prior written
+ *     permission.
+ *
+ *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
+ *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+ *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  */
 
-- 
2.1.0.231.g7484e3b

