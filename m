Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39569 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbZIGGhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 02:37:05 -0400
Received: from 200-158-183-225.dsl.telesp.net.br ([200.158.183.225] helo=caramujo.chehab.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1MkXqc-0002Zo-H2
	for linux-media@vger.kernel.org; Mon, 07 Sep 2009 06:37:07 +0000
Date: Mon, 7 Sep 2009 03:36:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH] DVB API conversion to DocBook XML 4.1.2 format
Message-ID: <20090907033638.1524f2bf@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've sent a patch earlier today with the DocBook conversion of the DVB API
specs.

However, it seems that the size is just too big for it to be accepted 
by vger.

So, instead of a patch, I'm creating a dvb-specs temporary tree with the 4
conversion patches from LaTex do DocBook:
	http://linuxtv.org/hg/~mchehab/dvb-specs

The description of the resulting changeset is given bellow.

Please review.

Have fun!
Mauro

---

Converts DVB Version 3 API specification to DocBook XML 4.1.2 format

As kernel documentation and V4L2 API docs are using DocBook XML 4.1.2,
convert also the DVB spec into DocBook.

There are some advantages of using DocBook format over LaTex:

1) The Makefile can generate not only pdf, but also single and a multiple files
html, being easier to integrate it on websites;

2) In the future, it can be used to also generate man pages;

3) It is possible to share parts of the book with kernel and between V4L2 and
DVB API's;

4) Developers now can use just one language for working with DVB API, V4L2 API
and other kernel documents;

5) With the docbook version, just one set of documentation application sets is needed
to generate both DVB and V4L2 API's;

6) By using some easy scripts (like what is present at v4l2-spec/Makefile), it
will be possible to include some example files from the development tree
directly from a c file;

7) It will be possible to add some scripts to validate if API changes done at the
DVB core code weren't integrated at the API spec (like what's already done with V4L2
controls and formats).

For now, this patchset doesn't remove the LaTex docs, nor brings any
improvement at the spec or at its format. It 

It is just a conversion done by using
htlatex, several perl parsing scripts and some manual work to fix some conflicts and to
make DocBook compile. There are spaces for more improvements to be done.

Comments?

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>






Cheers,
Mauro
