Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36407 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752605AbcHXXJb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 19:09:31 -0400
Received: by mail-lf0-f45.google.com with SMTP id g62so22560836lfe.3
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2016 16:08:46 -0700 (PDT)
Date: Thu, 25 Aug 2016 02:07:17 +0300
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 2/2] [media] tw5864: remove two unused vars
Message-ID: <20160824230717.gt2ze44gdjwtkuyt@acer>
References: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
 <06dccc17cd84bae893a347be3191a5d43ec019d1.1472056235.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06dccc17cd84bae893a347be3191a5d43ec019d1.1472056235.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 24, 2016 at 01:30:40PM -0300, Mauro Carvalho Chehab wrote:
> Remove those two vars that aren't used, as reported by smatch:

Acked-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>

Sorry for missing this.
Thanks a lot.
