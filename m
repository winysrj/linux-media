Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758793AbcLAO77 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Dec 2016 09:59:59 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20161201125420.5b397933@vento.lan>
References: <20161201125420.5b397933@vento.lan> <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk> <148059561006.31612.6396069416948435055.stgit@warthog.procyon.org.uk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: dhowells@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gnomes@lxorguk.ukuu.org.uk, minyard@acm.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 29/39] Annotate hardware config module parameters in drivers/staging/media/
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18434.1480604396.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Dec 2016 14:59:56 +0000
Message-ID: <18435.1480604396@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> drivers/staging/media/lirc/lirc_parallel.c:728:19: error: Expected ) in function declarator

Did you apply patch 1 first?  That defines module_param_hw*.

David
