Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:12056 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161763AbeBNSU3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 13:20:29 -0500
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "chris\@chris-wilson.co.uk" <chris@chris-wilson.co.uk>
Subject: Re: [PATCH v4 16/18] scripts: kernel-doc: improve nested logic to handle multiple identifiers
In-Reply-To: <20180214155314.1be00577@vento.lan>
References: <cover.1513599193.git.mchehab@s-opensource.com> <b89b7c5400afd8c03d88ccccd2b5edd3625a1997.1513599193.git.mchehab@s-opensource.com> <874lmjlfmg.fsf@intel.com> <20180214155314.1be00577@vento.lan>
Date: Wed, 14 Feb 2018 20:20:21 +0200
Message-ID: <87eflnjuvu.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 14 Feb 2018, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> There is a simple fix, though. Make inline comments to accept a dot:
>
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index fee8952037b1..06d7f3f2c094 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -363,7 +363,7 @@ my $doc_sect = $doc_com .
>  my $doc_content = $doc_com_body . '(.*)';
>  my $doc_block = $doc_com . 'DOC:\s*(.*)?';
>  my $doc_inline_start = '^\s*/\*\*\s*$';
> -my $doc_inline_sect = '\s*\*\s*(@[\w\s]+):(.*)';
> +my $doc_inline_sect = '\s*\*\s*(@\s*[\w][\w\.]*\s*):(.*)';
>  my $doc_inline_end = '^\s*\*/\s*$';
>  my $doc_inline_oneline = '^\s*/\*\*\s*(@[\w\s]+):\s*(.*)\s*\*/\s*$';
>  my $export_symbol = '^\s*EXPORT_SYMBOL(_GPL)?\s*\(\s*(\w+)\s*\)\s*;';
>
> That requires a small change at the inline parameters, though:
>
> diff --git a/drivers/gpu/drm/i915/intel_dpio_phy.c b/drivers/gpu/drm/i915/intel_dpio_phy.c
> index 76473e9836c6..c8e9e44e5981 100644
> --- a/drivers/gpu/drm/i915/intel_dpio_phy.c
> +++ b/drivers/gpu/drm/i915/intel_dpio_phy.c
> @@ -147,7 +147,7 @@ struct bxt_ddi_phy_info {
>  	 */
>  	struct {
>  		/**
> -		 * @port: which port maps to this channel.
> +		 * @channel.port: which port maps to this channel.
>  		 */
>  		enum port port;
>  	} channel[2];

Perhaps it would be slightly more elegant to be able to leave out
"channel." here and deduce that from the context... but the above
matches what you'd write in the higher level struct comment, and
produces the same output. It works and it's really simple. I like it.

Please submit this as a proper patch, with

Tested-by: Jani Nikula <jani.nikula@intel.com>

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
