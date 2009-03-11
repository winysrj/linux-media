Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:43093 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZCKSUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 14:20:08 -0400
Message-ID: <49B80140.5000304@oracle.com>
Date: Wed, 11 Mar 2009 11:21:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 11 (staging/multimedia)
References: <20090311225913.51589223.sfr@canb.auug.org.au> <49B7F107.7030303@oracle.com> <20090311181153.GA11088@suse.de>
In-Reply-To: <20090311181153.GA11088@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg KH wrote:
> On Wed, Mar 11, 2009 at 10:12:39AM -0700, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20090310:
>>
>> drivers/staging/go7007/go7007-v4l2.c:1830: error: 'VID_TYPE_CAPTURE' undeclared here (not in a function)
> 
> Odd, nothing has changed in this driver, is this a v4l api change?

I don't know if the vl4 API changed, but this error has been around
for some time now.  Just because it's just now being reported is one
change.  Surely other people build these drivers.  ???


I do know that other video drivers (with one exception) don't set:
	.vfl_type	= VID_TYPE_CAPTURE,
at all, so maybe it's not needed (?).


-- 
~Randy
