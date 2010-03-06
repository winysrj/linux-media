Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab0CFPPn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Mar 2010 10:15:43 -0500
Message-ID: <4B92716E.3080905@redhat.com>
Date: Sat, 06 Mar 2010 12:14:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Darren Hart <dvhltc@us.ibm.com>,
	Mikael Pettersson <mikpe@it.uu.se>,
	Thomas Gleixner <tglx@linutronix.de>,
	Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [git:v4l-dvb/master] futex_lock_pi() key refcnt fix
References: <E1NnuyF-0001D8-AC@www.linuxtv.org> <1267887010.4997.57.camel@laptop>
In-Reply-To: <1267887010.4997.57.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Peter Zijlstra wrote:
> Why is linuxtv sending crap like this?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Sorry!

There's an post update hook script that sends an email to the patch author/SOB's 
for the new patches added at v4l-dvb git tree. Unfortunately, the git mailbomb 
script is doing something wrong: it is handling badly all the upstream patches 
that  were merged back on it. I'll need to figure out a way for it to exclude 
patches that got merged from the normal posts.

For now, I've stopped the exim process at the server. 

-- 

Cheers,
Mauro
