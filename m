Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:24380 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZCKRK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 13:10:57 -0400
Message-ID: <49B7F107.7030303@oracle.com>
Date: Wed, 11 Mar 2009 10:12:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Greg KH <gregkh@suse.de>, linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 11 (staging/multimedia)
References: <20090311225913.51589223.sfr@canb.auug.org.au>
In-Reply-To: <20090311225913.51589223.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090310:


drivers/staging/go7007/go7007-v4l2.c:1830: error: 'VID_TYPE_CAPTURE' undeclared here (not in a function)


-- 
~Randy
