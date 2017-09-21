Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:37110 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdIUNBG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 09:01:06 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] scripts: kernel-doc: fix nexted handling
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <a788284f66d113ceec57dd6f66b1d024e7b1ddf1.1505924829.git.mchehab@s-opensource.com>
Date: Thu, 21 Sep 2017 14:44:34 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <998D6C15-4125-49F1-936E-9977C66E95A6@darmarit.de>
References: <a788284f66d113ceec57dd6f66b1d024e7b1ddf1.1505924829.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Jon,
> 
> While documenting some DVB demux  headers, I noticed the above bug.
> 
> scripts/kernel-doc | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 9d3eafea58f0..15f934a23d1d 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -2173,7 +2173,7 @@ sub dump_struct($$) {
> 	my $members = $3;
> 
> 	# ignore embedded structs or unions
> -	$members =~ s/({.*})//g;
> +	$members =~ s/({[^\}]*})//g;
> 	$nested = $1;
> 
> 	# ignore members marked private:

Hi Mauro,

I tested this patch. Feel free to add my

 Tested-by: Markus Heiser <markus.heiser@darmarit.de>

FYI: I also migrated the patch to my python kernel-doc parser:

   https://github.com/return42/linuxdoc/commit/5dbb93f

And here is the impact of this patch on the whole sources:

   https://github.com/return42/sphkerneldoc/commit/7be0fa85

In the last link, you see that your patch is a great improvement / Thanks!!

-- Markus --
