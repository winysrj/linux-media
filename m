Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:20044 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932268AbdC3Lpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 07:45:31 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2 01/22] tmplcvt: make the tool more robust
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Date: Thu, 30 Mar 2017 14:45:26 +0300
Message-ID: <87vaqr2dk9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Mar 2017, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> Currently, the script just assumes to be called at
> Documentation/sphinx/. Change it to work on any directory,
> and make it abort if something gets wrong.
>
> Also, be sure that both parameters are specified.
>
> That should avoid troubles like this:
>
> $ Documentation/sphinx/tmplcvt Documentation/DocBook/writing_usb_driver.tmpl
> sed: couldn't open file convert_template.sed: No such file or directory
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/sphinx/tmplcvt | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/sphinx/tmplcvt b/Documentation/sphinx/tmplcvt
> index 909a73065e0a..31df8eb7feca 100755
> --- a/Documentation/sphinx/tmplcvt
> +++ b/Documentation/sphinx/tmplcvt
> @@ -7,13 +7,22 @@
>  # fix \_
>  # title line?
>  #
> +set -eu
> +
> +if [ "$2" == "" ]; then

if [ "$#" != "2" ]; then

otherwise with set -u you'll get unbound variable error if you don't
provide $2.

BR,
Jani.

> +	echo "$0 <docbook file> <rst file>"
> +	exit
> +fi
> +
> +DIR=$(dirname $0)
>  
>  in=$1
>  rst=$2
>  tmp=$rst.tmp
>  
>  cp $in $tmp
> -sed --in-place -f convert_template.sed $tmp
> +sed --in-place -f $DIR/convert_template.sed $tmp
>  pandoc -s -S -f docbook -t rst -o $rst $tmp
> -sed --in-place -f post_convert.sed $rst
> +sed --in-place -f $DIR/post_convert.sed $rst
>  rm $tmp
> +echo "book writen to $rst"

-- 
Jani Nikula, Intel Open Source Technology Center
