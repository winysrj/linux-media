Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:36005 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727Ab1ESUmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 16:42:05 -0400
Message-ID: <4DD58085.80801@oracle.com>
Date: Thu, 19 May 2011 13:41:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"Igor M. Liplianin" <liplianin@netup.ru>
Subject: Re: Fw: [PATCH -next RESEND/still needed] staging: altera-jtag needs
 delay.h
References: <20110328082305.c6fa41d9.randy.dunlap@oracle.com> <4DD56DDE.6060003@infradead.org> <20110519203916.GA28736@suse.de>
In-Reply-To: <20110519203916.GA28736@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/19/11 13:39, Greg KH wrote:
> On Thu, May 19, 2011 at 04:22:06PM -0300, Mauro Carvalho Chehab wrote:
>> Em 28-03-2011 12:23, Randy Dunlap escreveu:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> altera-jtag.c needs to include <linux/delay.h> to fix a build error:
>>>
>>> drivers/staging/altera-stapl/altera-jtag.c:398: error: implicit declaration of function 'udelay'
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>> Cc: Igor M. Liplianin <liplianin@netup.ru>
>>> ---
>>>  drivers/staging/altera-stapl/altera-jtag.c |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> Somehow I was supposed to know to send this to Mauro instead of to Greg,
>>> but I don't see anything in drivers/staging/altera-stapl/ that says that.
>>
>> Ah, yes, we need to add a readme file there stating about that.
>>
>> Greg, you may add it on your tree, or if you prefer, I can just add here for
>> my next upstream pull.
> 
> I see this in my tree already, git commit
> 92ce52695ccf2b6c4ef7eb02e1bee1bcbf5fde89, what happened to need this
> again?

I think that Mauro is just replying to old emails (guess he's just
trying to catch up...).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
