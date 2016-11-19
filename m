Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([178.209.37.122]:45838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752380AbcKSRix (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 12:38:53 -0500
Date: Sat, 19 Nov 2016 18:38:46 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        ksummit-discuss@lists.linuxfoundation.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161119173846.GB25398@lunn.ch>
References: <20161107075524.49d83697@vento.lan>
 <11020459.EheIgy38UF@wuerfel>
 <20161116182633.74559ffd@vento.lan>
 <2923918.nyphv1Ma7d@wuerfel>
 <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
 <20161119101543.12b89563@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161119101543.12b89563@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Rather than beating our heads against the wall trying to convert between
> various image formats, maybe we need to take a step back.  We're trying
> to build better documentation, and there is certainly a place for
> diagrams and such in that documentation.  Johannes was asking about it
> for the 802.11 docs, and I know Paul has run into these issues with the
> RCU docs as well.  Might there be a tool or an extension out there that
> would allow us to express these diagrams in a text-friendly, editable
> form?

Hi Jonathan

A lot depends on what the diagram is supposed to show. I've used
graphviz dot in documents which get processes with Sphinx. That works
well for state machine, linked lists, etc. It uses a mainline Sphinx
extension.

It does however increase the size of your documents toolchain, you
need graphviz. But i doubt there is a distribution which does not have
it.

If you are worried about getting all these needed tools installed, i
think tools/perf might be a useful guide. When you compile it, it
gives helpful hints:

No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158
No sys/sdt.h found, no SDT events are defined, please install systemtap-sdt-devel or systemtap-sdt-dev

     Andrew
