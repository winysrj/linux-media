Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36456 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbbFBCvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 22:51:00 -0400
Date: Tue, 2 Jun 2015 11:50:53 +0900
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 02/35] DocBook: add a note about the ALSA API
Message-ID: <20150602115053.00979df3@lwn.net>
In-Reply-To: <d36805dafed09c888475beb0964ba4e08044063a.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
	<d36805dafed09c888475beb0964ba4e08044063a.1432844837.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 May 2015 18:49:05 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> +	<para>It should also be noticed that a media device may also have audio
> +	      components, like mixers, PCM capture, PCM playback, etc, with
> +	      are controlled via ALSA API.</para>

How about s/noticed/noted/ and s/with/which/ ?

jon
