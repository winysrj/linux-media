Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47329 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753553AbcHVV1O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 17:27:14 -0400
Date: Mon, 22 Aug 2016 15:27:12 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs-rst: conf.py: adjust the size of .. note:: tag
Message-ID: <20160822152712.66660b0d@lwn.net>
In-Reply-To: <88add40cfcfc49955f4e4b6c98c6662b9ac55044.1471610976.git.mchehab@s-opensource.com>
References: <88add40cfcfc49955f4e4b6c98c6662b9ac55044.1471610976.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 19 Aug 2016 09:49:38 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> While the current implementation works well when using as a
> paragraph, it doesn't work properly if inside a table. As we
> have quite a few such cases, fix the logic to take the column
> size into account.

Applied to the docs tree, thanks.

jon
