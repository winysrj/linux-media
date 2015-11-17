Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57596 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbbKQKk4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 05:40:56 -0500
Date: Tue, 17 Nov 2015 08:40:46 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	LMML <linux-media@vger.kernel.org>
Cc: linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2 2/4] scripts/kernel-doc: Replacing highlights hash by
 an array
Message-ID: <20151117084046.5c911c6a@recife.lan>
In-Reply-To: <1438112718-12168-3-git-send-email-danilo.cesar@collabora.co.uk>
References: <1438112718-12168-1-git-send-email-danilo.cesar@collabora.co.uk>
	<1438112718-12168-3-git-send-email-danilo.cesar@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Danilo,

Em Tue, 28 Jul 2015 16:45:16 -0300
Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk> escreveu:

> The "highlight" code is very sensible to the order of the hash keys,
> but the order of the keys cannot be predicted on Perl. It generates
> faulty DocBook entries like:
> 	- @<function>device_for_each_child</function>
> 
> We should use an array for that job, so we can guarantee that the order
> of the regex execution on dohighlight won't change.

...

> @@ -2587,9 +2601,11 @@ $kernelversion = get_kernel_version();
>  
>  # generate a sequence of code that will splice in highlighting information
>  # using the s// operator.
> -foreach my $pattern (keys %highlights) {
> -#   print STDERR "scanning pattern:$pattern, highlight:($highlights{$pattern})\n";
> -    $dohighlight .=  "\$contents =~ s:$pattern:$highlights{$pattern}:gs;\n";
> +foreach my $k (keys @highlights) {

The above causes some versions of perl to fail, as keys expect a
hash argument:

Execution of .//scripts/kernel-doc aborted due to compilation errors.
Type of arg 1 to keys must be hash (not private array) at .//scripts/kernel-doc line 2714, near "@highlights) "

This is happening at linuxtv.org server, with runs perl version 5.10.1.

I had to revert this patch in order to be able to keep building the
documentation of the media kABI on our server.

Regards,
Mauro
