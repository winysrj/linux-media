Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36500 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbbFBC4K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 22:56:10 -0400
Date: Tue, 2 Jun 2015 11:56:04 +0900
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 04/35] DocBook: fix emphasis at the DVB documentation
Message-ID: <20150602115604.54302981@lwn.net>
In-Reply-To: <6674a17160ba2f80a4537d4dc9e501149c308706.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
	<6674a17160ba2f80a4537d4dc9e501149c308706.1432844837.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 May 2015 18:49:07 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> Currently, it is using 'role="tt"', but this is not defined at
> the DocBook 4.5 spec. The net result is that no emphasis happens.
> 
> So, replace them to bold emphasis.

Nit: I suspect the intent of the "emphasis" here was to get the code in a
monospace font, which "bold" is unlikely to do.  Isn't there a
role="code" or something useful like that to use?  I'd have to go look.

jon
