Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:38560 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751349AbdI2NHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 09:07:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20170929090853.469ea73b@recife.lan>
Date: Fri, 29 Sep 2017 15:07:05 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Transfer-Encoding: 8BIT
Message-Id: <768B7EAA-53EB-4D43-95C3-D4710E6DCB41@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
 <cover.1506546492.git.mchehab@s-opensource.com>
 <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
 <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
 <20170929090853.469ea73b@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 29.09.2017 um 14:08 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> Em Thu, 28 Sep 2017 18:28:32 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> Hi Mauro,
>> 
>>> Am 27.09.2017 um 23:10 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>>> 
>> I also untabified the example since tabs in reST are
>> a nightmare, especially in code blocks ... tabulators are the source
>> of all evil [1] ...
>> 
>>  Please, never use tabs in markups or programming languages
>>  where indentation is a part of the markup respectively the 
>>  language!!
> 
> Tabs will exist at the sources, as Kernel coding style recommends its
> usage. There's nothing that can be done to avoid. So, whatever scripts
> we use, it should handle it.

Sorry if I was unclear. I mean we should not use tabs in reST or in py.
In python the indentation is a part of the language syntax, same in
reST; the indentation is the markup. It's not only me who recommend to
avoid tabs:

- reST: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#whitespace
- python: https://www.python.org/dev/peps/pep-0008/#tabs-or-spaces

both can handle tabs well (with the cost of confusing when I look at a diff), but
in python 3 it gets worse ...

  """Python 3 disallows mixing the use of tabs and spaces for indentation."""
 
If we are looking at C sources, there are no such problems since the
indentation is not a part of the syntax, so what the Kernel coding style
recommends is also correct.

  """Outside of comments, documentation and except in Kconfig, spaces are
     never used for indentation"""

Anyway, as long as it works with tabs I can't stop you ;)

> 
> Thankfully, solving this issue is a one line perl patch, as explained at:
> 	http://perldoc.perl.org/perlfaq4.html#How-do-I-expand-tabs-in-a-string?
> 
> Something like the enclosed (untested) patch.

Hm, as far as I see, this will make no sense, since the kernel-doc
parser flats prototypes to a one-liner and the reST output is independent
(e.g. output_struct_rst) from the origin source code.

-- Markus --

> 
> Thanks,
> Mauro
> 
> [PATCH] kernel-doc: replace tabs by spaces

As I said, you misunderstood me, do not apply this
patch. Replacing tabs when reading source-code is
not needed / even since we flatten  

> 
> Sphinx has a hard time dealing with tabs, causing it to
> misinterpret paragraph continuation.
> 
> As we're now mainly focused on supporting ReST output,
> replace tabs by spaces, in order to avoid troubles when
> the output is parsed by Sphinx.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 69757ee9db4c..7bc139184177 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1544,7 +1544,7 @@ sub tracepoint_munge($) {
> sub syscall_munge() {
> 	my $void = 0;
> 
> -	$prototype =~ s@[\r\n\t]+@ @gos; # strip newlines/CR's/tabs
> +	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/CR's
> ##	if ($prototype =~ m/SYSCALL_DEFINE0\s*\(\s*(a-zA-Z0-9_)*\s*\)/) {
> 	if ($prototype =~ m/SYSCALL_DEFINE0/) {
> 		$void = 1;
> @@ -1743,6 +1743,8 @@ sub process_file($) {
> 	while (s/\\\s*$//) {
> 	    $_ .= <IN>;
> 	}
> +	# Replace tabs by spaces
> +        while ($_ =~ s/\t+/' ' x (length($&) * 8 - length($`) % 8)/e) {};
> 	if ($state == STATE_NORMAL) {
> 	    if (/$doc_start/o) {
> 		$state = STATE_NAME;	# next line is always the function name
> @@ -1842,8 +1844,7 @@ sub process_file($) {
> 		$in_purpose = 0;
> 		$contents = $newcontents;
>                 $new_start_line = $.;
> -		while ((substr($contents, 0, 1) eq " ") ||
> -		       substr($contents, 0, 1) eq "\t") {
> +		while (substr($contents, 0, 1) eq " ") {
> 		    $contents = substr($contents, 1);
> 		}
> 		if ($contents ne "") {
> @@ -1912,8 +1913,7 @@ sub process_file($) {
> 		$contents = $2;
>                 $new_start_line = $.;
> 		if ($contents ne "") {
> -		    while ((substr($contents, 0, 1) eq " ") ||
> -		           substr($contents, 0, 1) eq "\t") {
> +		    while (substr($contents, 0, 1) eq " ") {
> 			$contents = substr($contents, 1);
> 		    }
> 		    $contents .= "\n";
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
