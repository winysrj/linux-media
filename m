Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42024 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbdJALTY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Oct 2017 07:19:24 -0400
Date: Sun, 1 Oct 2017 08:18:57 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 12/13] scripts: kernel-doc: handle nested struct
 function arguments
Message-ID: <20171001081857.7c5fadc3@vento.lan>
In-Reply-To: <F4774F51-B099-46E2-BE6F-8293642494DD@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
        <cover.1506546492.git.mchehab@s-opensource.com>
        <8cab7bd29fa6fbf8e54d1478a5be2a709cf35ea4.1506546492.git.mchehab@s-opensource.com>
        <F4774F51-B099-46E2-BE6F-8293642494DD@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Sep 2017 18:32:30 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi Mauro,
> 
> this 'else' addition seems a bit spooky to me. As I commented in patch 09/13
> may it helps when you look at 
> 
>   https://github.com/return42/linuxdoc/blob/master/linuxdoc/kernel_doc.py#L2499
> 
> which is IMO a bit more clear.

Please don't top post. It makes really hard to understand what you meant.

Anyway, as I answered to patc 9/13, I opted to add a separate patch in
order to solve the remaining issues.

If Jon prefers, I can just fold the three patches into one, although
IMHO it is better to keep them in separate.

Regards,
Mauro
