Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaIZRBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 13:01:51 -0400
Message-ID: <54259BFB.6010301@infradead.org>
Date: Fri, 26 Sep 2014 10:01:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: Re: linux-next: Tree for Sep 26 (media/pci/pt3)
References: <20140926211014.6491e1ee@canb.auug.org.au>
In-Reply-To: <20140926211014.6491e1ee@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/14 04:10, Stephen Rothwell wrote:
> Hi all,
> 
> There will be no linux-next release on Monday.
> 
> This has not been a good day :-(
> 
> Changes since 20140925:


on x86_64:
when CONFIG_MODULES is not enabled:

../drivers/media/pci/pt3/pt3.c: In function 'pt3_attach_fe':
../drivers/media/pci/pt3/pt3.c:433:6: error: implicit declaration of function 'module_is_live' [-Werror=implicit-function-declaration]



-- 
~Randy
