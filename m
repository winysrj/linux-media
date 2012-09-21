Return-path: <linux-media-owner@vger.kernel.org>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:37108 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754579Ab2IUTMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 15:12:44 -0400
Received: from his10.thuis.hoogenraad.info (localhost.localdomain [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by his10.thuis.hoogenraad.info (Postfix) with ESMTPS id 0C90B34E0418
	for <linux-media@vger.kernel.org>; Fri, 21 Sep 2012 21:12:43 +0200 (CEST)
Message-ID: <505CBC2A.4010808@hoogenraad.net>
Date: Fri, 21 Sep 2012 21:12:42 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: media_build error on header file not present in old linux in ivtv-alsa-pcm.c
References: <20120819195423.8011935E0224@alastor.dyndns.org> <CAJL_dMuF1iDZ8vAXu7a0OFfozzKj31UOc-n6ZWWQGBxjTciTXQ@mail.gmail.com> <503149FC.5030501@iki.fi> <505C9388.8090500@hoogenraad.net>
In-Reply-To: <505C9388.8090500@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I try to compile the media_build on an old Ubuntu Lucid system.
2.6.32-42-generic-pae #96-Ubuntu SMP Wed Aug 15 19:12:17 UTC 2012 i686
GNU/Linux

The make job stops with

/home/jhh/dvb/media_build/v4l/ivtv-alsa-pcm.c:29:26: error:
linux/printk.h: No such file or directory
make[3]: *** [/home/jhh/dvb/media_build/v4l/ivtv-alsa-pcm.o] Error 1

Apparently, this header file was not yet present in this version of
linux. It is the only driver requesting this header file.
Removing line 29

#include <linux/printk.h>

fixes the problem. All compiles well then.



-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
