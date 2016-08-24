Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:57177 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756472AbcHXVZk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 17:25:40 -0400
Date: Wed, 24 Aug 2016 15:25:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] docs-rst: kernel-doc: better output struct members
Message-ID: <20160824152508.34ba3aa7@lwn.net>
In-Reply-To: <ceda73b9b2e626b2e78cc8c0061b2d7639c70def.1471914176.git.mchehab@s-opensource.com>
References: <ceda73b9b2e626b2e78cc8c0061b2d7639c70def.1471914176.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Aug 2016 22:02:57 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> So, change kernel-doc, for it to produce the output on a different way:
> 
> 	**Members**
> 
> 	``prios[4]``
> 
> 	  array with elements to store the array priorities
> 
> Also, as the type is not part of LaTeX "item[]", LaTeX will split it into
> multiple lines, if needed.
> 
> So, both LaTeX/PDF and HTML outputs will look good.

OK, I've applied this; let's see if anybody screams :)

Thanks,

jon
