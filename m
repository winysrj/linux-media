Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:56248 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab2CPLfp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 07:35:45 -0400
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id C3C8FDEBAE
	for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 11:35:43 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id qpwlPCgkTvfN for <linux-media@vger.kernel.org>;
	Fri, 16 Mar 2012 11:35:43 +0000 (GMT)
Received: from [192.168.0.3] (unknown [78.32.18.90])
	by mail.ukfsn.org (Postfix) with ESMTP id 978C5DEBA5
	for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 11:35:43 +0000 (GMT)
Message-ID: <4F63258E.4030508@ukfsn.org>
Date: Fri, 16 Mar 2012 11:35:42 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: media_build fail 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Building on an old 32bit PC with gcc 4.0.3, though I did manage to build 
some weeks ago.

Today I get -

C [M]  /home/andy/Src/media_build/v4l/radio-isa.o
/home/andy/Src/media_build/v4l/radio-isa.c: In function 'radio_isa_probe':
/home/andy/Src/media_build/v4l/radio-isa.c:246: error: implicit 
declaration of function 'kfree'
make[3]: *** [/home/andy/Src/media_build/v4l/radio-isa.o] Error 1
make[2]: *** [_module_/home/andy/Src/media_build/v4l] Error 2
make[2]: Leaving directory `/home/andy/Src/Kernels/linux-3.3-rc4'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/andy/Src/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 410.
