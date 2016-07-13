Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:59640 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbcGMWYg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 18:24:36 -0400
Subject: Re: [PATCH 14/28] gpu: ipu-ic: Add complete image conversion support
 with tiling
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Steve Longerbeam <slongerbeam@gmail.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-15-git-send-email-steve_longerbeam@mentor.com>
 <20160713155831.696f202f@recife.lan>
CC: <linux-media@vger.kernel.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <5786BFA2.1060003@mentor.com>
Date: Wed, 13 Jul 2016 15:24:34 -0700
MIME-Version: 1.0
In-Reply-To: <20160713155831.696f202f@recife.lan>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2016 11:58 AM, Mauro Carvalho Chehab wrote:
>
> We don't do image rotation in software inside the Kernel! This is
> something that should be done either by some hardware block or
> in userspace.

Hi Mauro, I'm not sure I follow you. This is all hardware conversions.

>
> We also don't do image conversions inside the Kernel. Same applies
> to other similar codes on this patch.

Again, I don't follow you. Of course the kernel can do image conversion!
Again this is all hardware based image conversion, using the i.MX6 IPU
Image Converter unit.

Steve

