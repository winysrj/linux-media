Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:57448 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753617AbcIFM2S (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 08:28:18 -0400
Date: Tue, 6 Sep 2016 06:27:23 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/3] doc-rst:c-domain: function-like macros arguments
Message-ID: <20160906062723.5125b89b@lwn.net>
In-Reply-To: <1472657372-21039-3-git-send-email-markus.heiser@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de>
        <1472657372-21039-3-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So I'm going into total nit-picking territory here, but since I'm looking
at it and I think the series needs a respin anyway...

On Wed, 31 Aug 2016 17:29:31 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> +        m = c_funcptr_sig_re.match(sig)
> +        if m is None:
> +            m = c_sig_re.match(sig)
> +        if m is None:
> +            raise ValueError('no match')

How about we put that second test inside the first if block and avoid the
redundant None test if the first match works?  The energy saved may
prevent a hurricane someday :)

> +
> +        rettype, fullname, arglist, _const = m.groups()
> +        if rettype or not arglist.strip():
> +            return False
> +
> +        arglist = arglist.replace('`', '').replace('\\ ', '').strip()  # remove markup
> +        arglist = [a.strip() for a in arglist.split(",")]

Similarly, stripping the args three times seems a bit much.  The middle
one is totally redundant and could go at a minimum.

Thanks,

jon
