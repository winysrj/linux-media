Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43287 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaPCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:02:40 -0400
Received: by mail-pd0-f170.google.com with SMTP id z10so7453526pdj.29
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 08:02:40 -0700 (PDT)
Message-ID: <5453A48C.5000804@gmail.com>
Date: Sat, 01 Nov 2014 00:02:36 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 5/7] v4l-utils/libdvbv5: add gconv module for the text
 translation of ISDB-S/T.
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com> <1414323983-15996-6-git-send-email-tskd08@gmail.com> <20141027150805.4fbd495c.m.chehab@samsung.com>
In-Reply-To: <20141027150805.4fbd495c.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Using my Fedora package maintainer's hat, I would only enable this
> on a patch that would also be packaging the gconf module as a
> separate subpackage, as this would make easier to deprecate it
> if/when this gets merged at gconv's upstream.

I'm afraid that gconv upstream won't merge those application
domain specific encodings,
as I posted an inquiry about the acceptance of such gconv modules
to the glibc ML's, but got no response until now.
(and it seems that the current glibc does not include
 app specific char-encodings).
--
Akihiro
