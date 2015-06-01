Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44283 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbbFAJWT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 05:22:19 -0400
Date: Mon, 1 Jun 2015 06:22:14 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] DocBook media: xmllint/typo fixes
Message-ID: <20150601062214.667f76cd@recife.lan>
In-Reply-To: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 31 May 2015 14:59:09 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Hi Mauro,
> 
> Here are three patches that fix typos and xmllint errors.
> 
> The first patch fixes typos, the second a large number of xmllint
> errors and the last fixes a final xmllint error, but it does that by
> copying most of the v4l2 open/close text and you should check whether
> I didn't remove anything that is relevant for DVB.
> 
> Note that I use the following 'gitdocs.sh' script to build the documentation:

Patches applied. I had to add two extra patches in order to fix a few
issues (one at the open() conversion and another one that it is likely
a cut-and-past mistake that I introduced).
> 
> --------------------------------
> #!/bin/sh
> 
> make DOCBOOKS=media_api.xml htmldocs 2>&1 | grep -v "element.*: validity error : ID .* already defined"
> xmllint --noent --postvalid "$PWD/Documentation/DocBook/media_api.xml" >/tmp/x.xml 2>/dev/null
> xmllint --noent --postvalid --noout /tmp/x.xml
> xmlto html-nochunks -m ./Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/media Documentation/DocBook/media_api.xml >/dev/null 2>&1

Updated my scripts to use this more pedantic variation.
