Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0083.outbound.protection.outlook.com ([104.47.40.83]:44000
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752446AbcKSSYy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 13:24:54 -0500
From: Bart Van Assche <Bart.VanAssche@sandisk.com>
To: Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        "ksummit-discuss@lists.linuxfoundation.org"
        <ksummit-discuss@lists.linuxfoundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Date: Sat, 19 Nov 2016 17:50:25 +0000
Message-ID: <BLUPR02MB16835F79106D7369139069DC81B30@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <20161107075524.49d83697@vento.lan> <11020459.EheIgy38UF@wuerfel>
 <20161116182633.74559ffd@vento.lan> <2923918.nyphv1Ma7d@wuerfel>
 <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
 <20161119101543.12b89563@lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/19/16 09:15, Jonathan Corbet wrote:=0A=
> Might there be a tool or an extension out there that would allow us=0A=
 > to express these diagrams in a text-friendly, editable form?=0A=
=0A=
How about using the graphviz languages for generating diagrams that can =0A=
be described easily in one of the graphviz languages? The graphviz =0A=
programming languages are well suited for version control. And the =0A=
graphviz software includes a tool for converting diagrams described in a =
=0A=
graphviz language into many formats, including png, svg and pdf. =0A=
Examples of diagrams generated with graphviz are available at =0A=
http://www.graphviz.org/Gallery.php.=0A=
=0A=
Bart.=0A=
=0A=
