Return-path: <video4linux-list-bounces@redhat.com>
Date: Sun, 10 Aug 2008 22:37:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Message-ID: <20080810223719.446bf52a@lxorguk.ukuu.org.uk>
In-Reply-To: <489F5F99.1000905@keyaccess.nl>
References: <489F5F99.1000905@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, video4linux-list@redhat.com,
	Ingo Molnar <mingo@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L1: make PMS not autoprobe when builtin.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, 10 Aug 2008 23:37:29 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> Hi Andrew.
> 
> Alternate version of the PMS patch sent yesterday. This one makes it 
> need explicit enabling when builtin and doesn't change anything when 
> modular as per Alan Cox's comments.
> 
> This is a deprecated, unused driver meaning it doesn't matter. It still 
> fixes that (randconfig testing breakage) which it is supposed to fix.


Acked-by: Alan Cox <alan@redhat.com>


Would probably make the printk "pms: not enabled, use pms.enable=1 to
probe"

So you know
a) What is wittering about not being probed
b) How to undo it.

But thats trivia really.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
