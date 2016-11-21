Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10402 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753934AbcKUPrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 10:47:24 -0500
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
In-Reply-To: <1479743068.4391.4.camel@sipsolutions.net>
References: <20161107075524.49d83697@vento.lan> <11020459.EheIgy38UF@wuerfel> <20161116182633.74559ffd@vento.lan> <2923918.nyphv1Ma7d@wuerfel> <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com> <20161119101543.12b89563@lwn.net> <1479724781.8662.18.camel@sipsolutions.net> <20161121120657.31eaeca4@vento.lan> <1479742905.2309.16.camel@HansenPartnership.com> <1479743068.4391.4.camel@sipsolutions.net>
Date: Mon, 21 Nov 2016 17:47:13 +0200
Message-ID: <87oa18q1ha.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 21 Nov 2016, Johannes Berg <johannes@sipsolutions.net> wrote:
> I had a hack elsewhere that would embed the fixed-width text if the
> plugin isn't present, which seemed like a decent compromise, but nobody
> is willing to let plugins be used in general to start with, it seems :)

FWIW I'm all for doing this stuff in Sphinx, with Sphinx extensions. And
to me it sounds like what you describe is interesting outside of kernel
too.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
