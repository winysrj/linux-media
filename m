Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:51868 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbcHOMrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 08:47:24 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] doc-rst: kernel-doc: fix handling of address_space tags
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <263bbae9c1bf6ea7c14dad8c29f9b3148b2b5de7.1469198779.git.mchehab@s-opensource.com>
Date: Mon, 15 Aug 2016 14:47:08 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <69B89C91-584C-425D-A722-F609A1FB4562@darmarit.de>
References: <263bbae9c1bf6ea7c14dad8c29f9b3148b2b5de7.1469198779.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 22.07.2016 um 16:46 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> The RST cpp:function handler is very pedantic: it doesn't allow any
> macros like __user on it:
> 
> 	Documentation/media/kapi/dtv-core.rst:28: WARNING: Error when parsing function declaration.
> 	If the function has no return type:
> 	  Error in declarator or parameters and qualifiers
> 	  Invalid definition: Expecting "(" in parameters_and_qualifiers. [error at 8]
> 	    ssize_t dvb_ringbuffer_pkt_read_user (struct dvb_ringbuffer * rbuf, size_t idx, int offset, u8 __user * buf, size_t len)
> 	    --------^
> 	If the function has a return type:
> 	  Error in declarator or parameters and qualifiers
> 	  If pointer to member declarator:
> 	    Invalid definition: Expected '::' in pointer to member (function). [error at 37]
> 	      ssize_t dvb_ringbuffer_pkt_read_user (struct dvb_ringbuffer * rbuf, size_t idx, int offset, u8 __user * buf, size_t len)
> 	      -------------------------------------^
> 	  If declarator-id:
> 	    Invalid definition: Expecting "," or ")" in parameters_and_qualifiers, got "*". [error at 102]
> 	      ssize_t dvb_ringbuffer_pkt_read_user (struct dvb_ringbuffer * rbuf, size_t idx, int offset, u8 __user * buf, size_t len)
> 	      ------------------------------------------------------------------------------------------------------^
> 

May I'am wrong, but as far as I know, we get this error only 
if we are using the CPP-domain. Since the kernel-doc parser
uses the C-domain, we should not have those error messages
(tested here with sphinx 1.4).

That said, I don't see the need to change the kernel-doc parser
eleminating the address_space tags.

Or did I missed some point?

-- Markus --

> So, we have to remove it from the function prototype.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
> scripts/kernel-doc | 4 ++++
> 1 file changed, 4 insertions(+)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 41eade332307..4394746cc1aa 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1848,6 +1848,10 @@ sub output_function_rst(%) {
> 	}
> 	$count++;
> 	$type = $args{'parametertypes'}{$parameter};
> +
> +	# RST doesn't like address_space tags at function prototypes
> +	$type =~ s/__(user|kernel|iomem|percpu|pmem|rcu)\s*//;
> +
> 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
> 	    # pointer-to-function
> 	    print $1 . $parameter . ") (" . $2;
> -- 
> 2.7.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

