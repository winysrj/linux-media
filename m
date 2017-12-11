Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:55652 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbdLKVU4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 16:20:56 -0500
Date: Mon, 11 Dec 2017 14:20:55 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] kernel-doc: parse DECLARE_KFIFO and
 DECLARE_KFIFO_PTR()
Message-ID: <20171211142055.2b26175c@lwn.net>
In-Reply-To: <37a81ae259c9d3a90fbdbe1532f904946139bfdd.1512741889.git.mchehab@s-opensource.com>
References: <37a81ae259c9d3a90fbdbe1532f904946139bfdd.1512741889.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  8 Dec 2017 09:05:12 -0500
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> So, teach kernel-doc how to parse DECLARE_KFIFO() and DECLARE_KFIFO_PTR().
> 
> While here, relax at the past DECLARE_foo() macros, accepting a random
> number of spaces after comma.

Applied, thanks.

jon
