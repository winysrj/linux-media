Return-Path: <SRS0=4xye=PD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36219C43387
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 11:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07828214C6
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 11:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545824651;
	bh=utkn1HW2Qr9QiYu8jfVXpKJDGr53KWTF4eFVRCLLa7U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=mBEd9z9Te4oUgq4n2jWKuiIO15OjdX0Pj3w8YulJBy2I7N5Y/T3jzaNDg8slxoX8T
	 jTMNQOF3GvWhD7sjVnZi/9AncNaUFJE9qrp0HMTlDT6GTnu+vDvB1GW/v2FJV4RVCl
	 d1Dfc1cNRzYAmsaZ0NPKJYXrPaSKNETlcQEbU3Gc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbeLZLoG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 06:44:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:44848 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLZLoG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 06:44:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EooV2cAZ15bFoWJtG+86LBUlp1H6fg8CN4reh6/6GJE=; b=kbNjwIWoBUg0dEnH7kW0eb3vz8
        7Ev07m6xosB65ke+6pQwIip+piqiXGWdQZUdtKhNlmCwORii+lbM3tRFS2vsG8ooyQhs4ZBZbuAVX
        nugVfZjJTaExLWAQHykhBfyX0CPehKZcUapTe1dCmoDG9Z4vRmdIdr1dowmrZfqpKGwVjnjfo2N3S
        eCU1XpouPrW2wUTQDxckWZEVhyB/4FOhSHzhAQnhLD2CFKwmIMze8m1N2ofDO6JGE0DVhLTbJl384
        Vrhzqg9C35FO0M805hzOFOce9/CDxshnHTlA7OBNuS2MJj2ubcG4dVR8GV4NDGyyGOxP+KILg+nOr
        q15fvb+g==;
Received: from [179.179.34.18] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gc7bX-00084F-3c; Wed, 26 Dec 2018 11:44:03 +0000
Date:   Wed, 26 Dec 2018 09:43:57 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [GIT PULL for v4.21] second set of media patches: ipu3 driver
Message-ID: <20181226094357.293fdd97@coco.lan>
In-Reply-To: <CAHk-=wiqS_ShU4th7mKd4kLEXaKKyrnK5FkyJgdy=_=_wy1KGg@mail.gmail.com>
References: <20181220104544.72ee9203@coco.lan>
        <CAHk-=wiqS_ShU4th7mKd4kLEXaKKyrnK5FkyJgdy=_=_wy1KGg@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 25 Dec 2018 13:12:58 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Thu, Dec 20, 2018 at 4:45 AM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> >
> > Also, it would be good if you merge first the docs-next pull request from
> > Jon, as otherwise, you'll see some warnings when building documentation,
> > due to an issue at scripts/kernel-doc, whose fix is at documentation tree.  
> 
> I don't seem to have that in my pile of pull requests, so docs
> creation will warn for a bit. Not a huge deal.

Yeah, we can live without that for a while. In any case, the patch that
fixes it is this one:

	3d9bfb19bd70 ("scripts/kernel-doc: Fix struct and struct field attribute processing")

I'm enclosing it as a reference (as seen at Jon's docs-next tree). It is
probably worth to just wait for Jon's pull request.

Thanks,
Mauro

From: Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Thu, 22 Nov 2018 13:06:04 +0200
Subject: [PATCH] scripts/kernel-doc: Fix struct and struct field attribute
 processing

The kernel-doc attempts to clear the struct and struct member attributes
from the API documentation it produces. It falls short of the job in the
following respects:

- extra whitespaces are left where __attribute__((...)) was removed,

- only a single attribute is removed per struct,

- attributes (such as aligned) containing numbers were not removed,

- attributes are only cleared from struct fields, not structs themselves.

This patch addresses these issues by removing the attributes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index f9f143145c4b..c5333d251985 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1062,7 +1062,7 @@ sub dump_struct($$) {
     my $x = shift;
     my $file = shift;
 
-    if ($x =~ /(struct|union)\s+(\w+)\s*\{(.*)\}/) {
+    if ($x =~ /(struct|union)\s+(\w+)\s*\{(.*)\}(\s*(__packed|__aligned|__attribute__\s*\(\([a-z0-9,_\s\(\)]*\)\)))*/) {
 	my $decl_type = $1;
 	$declaration_name = $2;
 	my $members = $3;
@@ -1073,8 +1073,9 @@ sub dump_struct($$) {
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
 	# strip attributes
-	$members =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//i;
-	$members =~ s/__aligned\s*\([^;]*\)//gos;
+	$members =~ s/\s*__attribute__\s*\(\([a-z0-9,_\*\s\(\)]*\)\)//gi;
+	$members =~ s/\s*__aligned\s*\([^;]*\)//gos;
+	$members =~ s/\s*__packed\s*//gos;
 	$members =~ s/\s*CRYPTO_MINALIGN_ATTR//gos;
 	# replace DECLARE_BITMAP
 	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;

