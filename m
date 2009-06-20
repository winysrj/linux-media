Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f203.google.com ([209.85.210.203]:51797 "EHLO
	mail-yx0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZFTRbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 13:31:37 -0400
Received: by yxe41 with SMTP id 41so23935yxe.33
        for <linux-media@vger.kernel.org>; Sat, 20 Jun 2009 10:31:40 -0700 (PDT)
Subject: Re: [Patch] dvb-apps: code cleanup and bug fix.
From: Yufei Yuan <yfyuan@gmail.com>
Reply-To: yfyuan@gmail.com
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <1245518159.15347.38.camel@core2duo.localdomain>
References: <ccdf9f470906171618r26518ce7pa97d747e301009ca@mail.gmail.com>
	 <1a297b360906180132l49aa7be4j8a1e238aa9bac65@mail.gmail.com>
	 <1a297b360906180148lefc2d8fp972647ad0df64320@mail.gmail.com>
	 <ccdf9f470906180606w1046ee88nda933b4e6638357a@mail.gmail.com>
	 <ccdf9f470906181752u65c8d7f1nce46e3d46991b70c@mail.gmail.com>
	 <ccdf9f470906181839h4047acc1t1d537300a0b4b581@mail.gmail.com>
	 <ccdf9f470906181855m2d6c471cm12afea3f228fd57c@mail.gmail.com>
	 <1a297b360906200030y1322de83j296ced63e713ef66@mail.gmail.com>
	 <1245518159.15347.38.camel@core2duo.localdomain>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 12:31:38 -0500
Message-Id: <1245519098.15347.40.camel@core2duo.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Makefile part of the last patch was not correct. Please use this one, sorry.

--- dvb-apps/util/scan/Makefile	2009-06-20 12:28:52.544986677 -0500
+++ dvb-apps_local/util/scan/Makefile	2009-06-20 12:27:08.597924784 -0500
@@ -14,7 +14,7 @@ inst_bin = $(binaries)
 
 removing = atsc_psip_section.c atsc_psip_section.h
 
-CPPFLAGS += -DDATADIR=\"$(prefix)/share\"
+CPPFLAGS += -Wno-packed-bitfield-compat -D__KERNEL_STRICT_NAMES -DDATADIR=\"$(prefix)/share\"
 
 .PHONY: all
 

On Sat, 2009-06-20 at 12:16 -0500, Yufei Yuan wrote:
> This patch is against dvb-apps 1281. Following is what has been done:
> 
> 1. atsc_epg bug fix: when ETM message gets longer than 256 characters, the last
> character was chopped, due to incorrect calling to snprintf().
> 2. atsc_epg code cleanup:
>   - white space added after keywords;
>   - hard wrap around column 80 removed;
>   - one-line conditional statement now w/o brackets.
> 3. scan Makefile workaround for building in gcc4.4/kernel 2.6.30 was not picked up in 1279, include again.
> 
> Regards,
> 
> Signed-off-by: Yufei Yuan <yfyuan@gmail.com>
> 


