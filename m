Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36568 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbbFBDJE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 23:09:04 -0400
Date: Tue, 2 Jun 2015 12:08:59 +0900
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 32/35] DocBook: Provide a high-level description for DVB
 frontend
Message-ID: <20150602120859.485acc77@lwn.net>
In-Reply-To: <575a0cc7bafa09eb42b50d404b93a0747135400b.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
	<575a0cc7bafa09eb42b50d404b93a0747135400b.1432844837.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 May 2015 18:49:35 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> +    Please notice that several statistics require the demodulator to be fully
> +    locked (e. g. with FE_HAS_LOCK bit set). See

s/notice/note/

jon
