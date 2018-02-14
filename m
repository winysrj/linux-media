Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36551 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161664AbeBNSM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 13:12:29 -0500
Date: Wed, 14 Feb 2018 16:12:23 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/7] include/(uapi/)media: add SPDX license info
Message-ID: <20180214161223.16072dc6@vento.lan>
In-Reply-To: <20180207143939.29491-3-hverkuil@xs4all.nl>
References: <20180207143939.29491-1-hverkuil@xs4all.nl>
        <20180207143939.29491-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  7 Feb 2018 15:39:34 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hansverk@cisco.com>
> 
> Replace the old license information with the corresponding SPDX
> license for those headers that I authored.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

...

> diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
> index b51fbe1941a7..20fe091b7e96 100644
> --- a/include/uapi/linux/cec.h
> +++ b/include/uapi/linux/cec.h
> @@ -3,35 +3,6 @@
>   * cec - HDMI Consumer Electronics Control public header
>   *
>   * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> - *
> - * This program is free software; you may redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; version 2 of the License.
> - *
> - * Alternatively you can redistribute this file under the terms of the
> - * BSD license as stated below:
> - *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - * 1. Redistributions of source code must retain the above copyright
> - *    notice, this list of conditions and the following disclaimer.
> - * 2. Redistributions in binary form must reproduce the above copyright
> - *    notice, this list of conditions and the following disclaimer in
> - *    the documentation and/or other materials provided with the
> - *    distribution.
> - * 3. The names of its contributors may not be used to endorse or promote
> - *    products derived from this software without specific prior written
> - *    permission.
> - *
> - * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> - * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> - * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> - * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> - * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> - * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> - * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> - * SOFTWARE.
>   */

You forgot to add an SPDX licence for this file.

Thanks,
Mauro
