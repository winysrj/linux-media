Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:37782 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752347AbdK2N7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 08:59:01 -0500
Date: Wed, 29 Nov 2017 13:58:50 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] media: staging: atomisp: fix for sparse "using
 plain integer as NULL pointer" warnings.
Message-ID: <20171129135850.5ec2b70f@alans-desktop>
In-Reply-To: <20171129083835.tam3avqz5vishwqw@azazel.net>
References: <20171127122125.GB8561@kroah.com>
        <20171127124450.28799-1-jeremy@azazel.net>
        <20171127124450.28799-2-jeremy@azazel.net>
        <20171128141524.kpvqbowgmpkzwfuz@mwanda>
        <20171128233337.nwelcxvgaqtpgv5o@azazel.net>
        <20171129000452.5mcbijzedww34ojc@mwanda>
        <20171129083835.tam3avqz5vishwqw@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> There are 35 defaults defined by macros like this, most of them much
> more complicated that IA_CSS_DEFAULT_ISP_MEM_PARAMS, and a few members
> are initialized to non-zero values.  My plan, therefore, is to convert
> everything to use designated initializers, and then start removing the
> zeroes afterwards.

Where they are only used once in the tree it might be even cleaner to
just do


static struct foo = FOO_DEFAULT_BAR;

foo.x = 12;
foo.bar = &foo;

etc in the code.


Alan
