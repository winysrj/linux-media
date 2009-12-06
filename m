Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933690AbZLFLdw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 06:33:52 -0500
Message-ID: <4B1B96A1.7060708@redhat.com>
Date: Sun, 06 Dec 2009 09:33:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: linux-media@vger.kernel.org
Subject: Re: [em28xx] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000000 IP: [<ffffffffa00997be>] :ir_common:ir_input_free+0x26/0x3e
References: <255535957.20091206000510@eikelenboom.it> <4B1B0094.6080000@redhat.com> <965906892.20091206102414@eikelenboom.it>
In-Reply-To: <965906892.20091206102414@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sander Eikelenboom wrote:
> Hello Mauro,
> 
> With the patch the  NULL pointer dereference is fixed.
> 
Thank you for testing.

I've applied the patch on my tree.

Cheers,
Mauro.
