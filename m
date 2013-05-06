Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:46532 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3EFMr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 08:47:29 -0400
Date: Mon, 6 May 2013 09:47:19 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] saa7115: move the autodetection code out of the
 probe function
Message-ID: <20130506124718.GA2272@localhost>
References: <366980557-23077-1-git-send-email-mchehab@redhat.com>
 <1366986168-27756-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366986168-27756-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 26, 2013 at 11:22:47AM -0300, Mauro Carvalho Chehab wrote:
> As we're now seeing other variants from chinese clones, like
> gm1113c, we'll need to add more bits at the detection code.
> 
> So, move it into a separate function.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
