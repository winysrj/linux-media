Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:37374 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752474AbdIXPN4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 11:13:56 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] scripts: kernel-doc: fix nexted handling
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <3d54014d786733715a94fa783a479a498aaca1ea.1506248420.git.mchehab@s-opensource.com>
Date: Sun, 24 Sep 2017 17:13:13 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4F0B529A-AF0A-48F9-808A-594BF07D035B@darmarit.de>
References: <3d54014d786733715a94fa783a479a498aaca1ea.1506248420.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 24.09.2017 um 12:23 schrieb Mauro Carvalho Che
> 
> v2:  handle embedded structs/unions from inner to outer
> 
> When we have multiple levels of embedded structs,
> 
> we need a smarter rule that will be removing nested structs
> from the inner to the outer ones. So, changed the parsing rule to
> remove nested structs/unions from the inner ones to the outer
> ones, while it matches.

argh, sub-nested I forgot.

> scripts/kernel-doc | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 9d3eafea58f0..443e1bcc78db 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -2173,7 +2173,7 @@ sub dump_struct($$) {
> 	my $members = $3;
> 
> 	# ignore embedded structs or unions
> -	$members =~ s/({.*})//g;
> +	while ($members =~ s/({[^\{\}]*})//g) {};
> 	$nested = $1;

I haven't tested this patch, but I guess with you might get
some "excess struct member" warnings, since the value of
'nested' is just the content of the last match.

Here is what I have done in the python version:

 https://github.com/return42/linuxdoc/commit/8d9394

and here is the impact:

 https://github.com/return42/sphkerneldoc/commit/2ff22cf82de3236c1ec7616bd4b65ce2aedd2a90

As you can see in my linked patch above, I implemented it by
hand and collected all the 'nested' stuff. I guess this
is impossible with regexpr.

I recommend to do something similar with the perl script.

Since your perl is better than my; could you please prepare such a v3 patch?

Thanks!

-- Markus --




> 
> 	# ignore members marked private:
> -- 
> 2.13.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
