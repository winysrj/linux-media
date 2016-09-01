Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:39816 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752985AbcIAOVs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 10:21:48 -0400
Date: Thu, 1 Sep 2016 08:21:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] doc-rst:sphinx-extensions: add metadata parallel-safe
Message-ID: <20160901082136.597c37bf@lwn.net>
In-Reply-To: <1472045724-14559-1-git-send-email-markus.heiser@darmarit.de>
References: <1472045724-14559-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 24 Aug 2016 15:35:24 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> With metadata "parallel_read_safe = True" a extension is marked as
> save for "parallel reading of source". This is needed if you want
> build in parallel with N processes. E.g.:
> 
>   make SPHINXOPTS=-j4 htmldocs

A definite improvement; applied to the docs tree, thanks.

jon
