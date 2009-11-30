Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:39134 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZK3SH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 13:07:27 -0500
Message-ID: <4B1409D9.1050901@oracle.com>
Date: Mon, 30 Nov 2009 10:07:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for November 30 (media/common/tuners/max2165)
References: <20091130175346.3f3345ed.sfr@canb.auug.org.au>
In-Reply-To: <20091130175346.3f3345ed.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20091127:
> 
> The v4l-dvb tree lost its conflict.


on i386 (X86_32):

a 'double' variable is used, causing:

ERROR: "__floatunsidf" [drivers/media/common/tuners/max2165.ko] undefined!
ERROR: "__adddf3" [drivers/media/common/tuners/max2165.ko] undefined!
ERROR: "__fixunsdfsi" [drivers/media/common/tuners/max2165.ko] undefined!


-- 
~Randy
