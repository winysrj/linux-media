Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:53564 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765234AbZLQR5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 12:57:49 -0500
Date: Thu, 17 Dec 2009 09:57:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 17 (media/dvb)
Message-Id: <20091217095725.d7109149.randy.dunlap@oracle.com>
In-Reply-To: <20091217165840.e11fc719.sfr@canb.auug.org.au>
References: <20091217165840.e11fc719.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 17 Dec 2009 16:58:40 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091216:


(repeating:)

drivers/media/dvb/frontends/dib8000.h:104: error: expected expression before '}' token
drivers/media/dvb/frontends/dib8000.h:104: warning: left-hand operand of comma expression has no effect

    return CT_SHUTDOWN,


s/,/;/ and fix indentation.

---
~Randy
