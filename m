Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:46578 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3EFMzb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 08:55:31 -0400
Date: Mon, 6 May 2013 09:55:26 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] saa7115: add detection code for gm7113c
Message-ID: <20130506125525.GB2272@localhost>
References: <366980557-23077-1-git-send-email-mchehab@redhat.com>
 <1366986168-27756-1-git-send-email-mchehab@redhat.com>
 <1366986168-27756-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366986168-27756-2-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 26, 2013 at 11:22:48AM -0300, Mauro Carvalho Chehab wrote:
> Adds a code that (auto)detects gm7113c clones. The auto-detection
> here is not perfect, as, on contrary to what it would be expected
> by looking into its datasheets some devices would return, instead:
> 
> 	saa7115 0-0025: chip 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 @ 0x4a is unknown
> 
> (found on a device labeled as GM7113C 1145 by Ezequiel Garcia)
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
