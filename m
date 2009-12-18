Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZLRKuX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 05:50:23 -0500
Message-ID: <4B2B5E61.1030207@redhat.com>
Date: Fri, 18 Dec 2009 08:50:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 17 (media/dvb)
References: <20091217165840.e11fc719.sfr@canb.auug.org.au> <20091217095725.d7109149.randy.dunlap@oracle.com>
In-Reply-To: <20091217095725.d7109149.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy Dunlap wrote:
> On Thu, 17 Dec 2009 16:58:40 +1100 Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> My usual call for calm: please do not put stuff destined for 2.6.34 into
>> linux-next trees until after 2.6.33-rc1.
>>
>> Changes since 20091216:
> 
> 
> (repeating:)
> 
> drivers/media/dvb/frontends/dib8000.h:104: error: expected expression before '}' token
> drivers/media/dvb/frontends/dib8000.h:104: warning: left-hand operand of comma expression has no effect
> 
>     return CT_SHUTDOWN,
> 
> 
> s/,/;/ and fix indentation.

The affect patch went into for 2.6.33. I haven't noticed this issue before, since it
appears only if DVB_DIB8000 is not defined.

Anyway, I'm adding today a patch for it.

Thanks,
Mauro.
