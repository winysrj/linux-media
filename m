Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbbHXOgr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 10:36:47 -0400
Subject: Re: linux-next: Tree for Aug 24 (media/i2c/tc358743.c)
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
References: <20150824215249.41824451@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Ramakrishnan Muthukrishnan <ram@rkrishnan.org>,
	Mikhail Khelik <mkhelik@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <55DB2BFD.9090309@infradead.org>
Date: Mon, 24 Aug 2015 07:36:45 -0700
MIME-Version: 1.0
In-Reply-To: <20150824215249.41824451@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/15 04:52, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150821:
> 


on x86_64:

drivers/built-in.o: In function `print_avi_infoframe':
tc358743.c:(.text.unlikely+0x7849): undefined reference to `hdmi_infoframe_unpack'
tc358743.c:(.text.unlikely+0x787e): undefined reference to `hdmi_infoframe_log'


Needs to select HDMI ?


-- 
~Randy
