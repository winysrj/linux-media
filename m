Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56335 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0GEQsN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 12:48:13 -0400
Received: by wwb24 with SMTP id 24so1925855wwb.1
        for <linux-media@vger.kernel.org>; Mon, 05 Jul 2010 09:48:12 -0700 (PDT)
Date: Mon, 5 Jul 2010 19:48:08 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: eduardo.valentin@nokia.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] si4713: Fix oops when si4713_platform_data is marked as
 __initdata
Message-Id: <20100705194808.cd12018a.jhnikula@gmail.com>
In-Reply-To: <4C3203B2.9050401@redhat.com>
References: <1274029466-17456-1-git-send-email-jhnikula@gmail.com>
	<20100518125527.GB4265@besouro.research.nokia.com>
	<20100518162445.5399d077.jhnikula@gmail.com>
	<4C3203B2.9050401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 05 Jul 2010 13:09:22 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Hi Eduardo,
> 
> This patch is still on my queue. It is not clear to me what "proably fine" means...
> Please ack or nack on it for me to move ahead ;)
> 
Ah, sorry, I should have nacked this myself after I sent the regulator
framework conversion patch [1] which removes the set_power callback and
thus null check need for it.


-- 
Jarkko
1. http://www.spinics.net/lists/linux-media/msg20200.html
