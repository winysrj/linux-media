Return-path: <mchehab@pedra>
Received: from smtp-out003.kontent.com ([81.88.40.217]:40859 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1CFMLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 07:11:43 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH] [media] dib0700: get rid of on-stack dma buffers
Date: Sun, 6 Mar 2011 13:06:09 +0100
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Greg Kroah-Hartman" <greg@kroah.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
References: <1299410212-24897-1-git-send-email-florian@mickler.org>
In-Reply-To: <1299410212-24897-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103061306.10045.oliver@neukum.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Sonntag, 6. März 2011, 12:16:52 schrieb Florian Mickler:
> This should fix warnings seen by some:
> 	WARNING: at lib/dma-debug.c:866 check_for_stack
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=15977.
> Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Signed-off-by: Florian Mickler <florian@mickler.org>
> CC: Mauro Carvalho Chehab <mchehab@infradead.org>
> CC: linux-media@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: Greg Kroah-Hartman <greg@kroah.com>
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Maciej Rutecki <maciej.rutecki@gmail.com>
> ---
> 
> Please take a look at it, as I do not do that much kernel hacking
> and don't wanna brake anybodys computer... :)
> 
> From my point of view this should _not_ go to stable even though it would
> be applicable. But if someone feels strongly about that and can
> take responsibility for that change...

The patch looks good and is needed in stable.
It could be improved by using a buffer allocated once in the places
you hold a mutex anyway.

	Regards
		Oliver
