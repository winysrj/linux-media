Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:34284 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751811AbdI1QdN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 12:33:13 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 12/13] scripts: kernel-doc: handle nested struct
 function arguments
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <8cab7bd29fa6fbf8e54d1478a5be2a709cf35ea4.1506546492.git.mchehab@s-opensource.com>
Date: Thu, 28 Sep 2017 18:32:30 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F4774F51-B099-46E2-BE6F-8293642494DD@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
 <cover.1506546492.git.mchehab@s-opensource.com>
 <8cab7bd29fa6fbf8e54d1478a5be2a709cf35ea4.1506546492.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

this 'else' addition seems a bit spooky to me. As I commented in patch 09/13
may it helps when you look at 

  https://github.com/return42/linuxdoc/blob/master/linuxdoc/kernel_doc.py#L2499

which is IMO a bit more clear.

-- Markus --

> Am 27.09.2017 um 23:10 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> Function arguments are different than usual ones. So, an
> special logic is needed in order to handle such arguments
> on nested structs.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
> scripts/kernel-doc | 38 ++++++++++++++++++++++++++------------
> 1 file changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 713608046d3a..376365d41718 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1015,18 +1015,32 @@ sub dump_struct($$) {
> 			$id =~ s/^\*+//;
> 			foreach my $arg (split /;/, $content) {
> 				next if ($arg =~ m/^\s*$/);
> -				my $type = $arg;
> -				my $name = $arg;
> -				$type =~ s/\s\S+$//;
> -				$name =~ s/.*\s//;
> -				$name =~ s/[:\[].*//;
> -				$name =~ s/^\*+//;
> -				next if (($name =~ m/^\s*$/));
> -				if ($id =~ m/^\s*$/) {
> -					# anonymous struct/union
> -					$newmember .= "$type $name;";
> +				if ($arg =~ m/^([^\(]+\(\*?\s*)([\w\.]*)(\s*\).*)/) {
> +					# pointer-to-function
> +					my $type = $1;
> +					my $name = $2;
> +					my $extra = $3;
> +					next if (!$name);
> +					if ($id =~ m/^\s*$/) {
> +						# anonymous struct/union
> +						$newmember .= "$type$name$extra;";
> +					} else {
> +						$newmember .= "$type$id.$name$extra;";
> +					}
> 				} else {
> -					$newmember .= "$type $id.$name;";
> +					my $type = $arg;
> +					my $name = $arg;
> +					$type =~ s/\s\S+$//;
> +					$name =~ s/.*\s+//;
> +					$name =~ s/[:\[].*//;
> +					$name =~ s/^\*+//;
> +					next if (($name =~ m/^\s*$/));
> +					if ($id =~ m/^\s*$/) {
> +						# anonymous struct/union
> +						$newmember .= "$type $name;";
> +					} else {
> +						$newmember .= "$type $id.$name;";
> +					}
> 				}
> 			}
> 			$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/;
> @@ -1215,7 +1229,7 @@ sub create_parameterlist($$$$) {
> 	} elsif ($arg =~ m/\(.+\)\s*\(/) {
> 	    # pointer-to-function
> 	    $arg =~ tr/#/,/;
> -	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
> +	    $arg =~ m/[^\(]+\(\*?\s*([\w\.]*)\s*\)/;
> 	    $param = $1;
> 	    $type = $arg;
> 	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
