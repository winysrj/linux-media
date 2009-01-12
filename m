Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+f81c9f6d5612c94c69b1+1968+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LMQt8-0007Vg-8Q
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 18:47:46 +0100
Date: Mon, 12 Jan 2009 15:47:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-dvb@linuxtv.org
Message-ID: <20090112154705.64d9d4ab@pedra.chehab.org>
Mime-Version: 1.0
Subject: [linux-dvb] Fw: Introduction
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Forwarding the message, since my other account is not subscribed at the dvb users mailing list.

Forwarded message:


On Mon, 12 Jan 2009 07:33:19 -0800 (PST)
Uri Shkolnik <urishk@yahoo.com> wrote:

> Mauro,
>  
> My name is Uri Shkolnik, I work at Siano Mobile Silicon as a software architect.
>  
> I tried to get in touch with you lately, but I had probably used the wrong email address, so forgive me for contacting by replying to a post of yours to the one of the LinuxTV mailing lists...  

No problem, but I suspect you're suffering some troubles on your anti-spam
filters. I've already answered to you twice on your previous emails, from my
infradead.org account.

> Siano develops DTV chip-sets (multi-standards, multi-interfaces) which are used by Siano's many customers and partners.
> Couple of years ago, our Linux support was minimal, but that situation has changed, and proximately a year ago, we started to get more an more demand for Linux kernel support, and we started to offer a minimal set of drivers.
>  
> At the beginning, we used the excellent services given to us by Michael Krufky, and actually everything we want to publish went through him.
>  
> Recently, the number of Siano-based Linux projects and products increased significantly. 
>  
> With the fast growing number of customers and projects, the number of additional interfaces, DTV standards and changes fast growth we needed a different approach.
>  
> On mid-November, we took the second approach which is suggested at the README.patches file, and submitted the patches to the linux-dvb mailing list, till today, except some people who took those patches and apply them locally on their systems, nothing has been done with those patches, and the main mercurial tree has not been updated with them.  

The current way we work is that we have some driver maintainers. The driver
maintainer is responsible for picking the patch at the mailing lists and apply
on their trees, after their review. They then ask me to pull from your trees.

This year, we've made one change: now, the patches should be sent to
linux-media@vger.kernel.org. This mailing list is monitored by a robot that
picks the patches and add they at a database. the database can be accessed
publicly via http://patchwork.kernel.org. This way, people can check each
patches. This will also help me to have more control of patches that were lost
in the mailing lists.

>From my view, as the subsystem maintainer, I prefer to get the patches directly
from the manufacturer, of course provided that the manufacturer actively
maintains the driver and understands the development model used on Kernel.

> The current state is that a huge gap has been opened between the LinuxTV repository (and from it to the Linux kernel git) offering and what we have at Siano.
>  
> We would like to close this gap ASAP and maintain an on-going, easy synchronizing process.
>  
> It seems that the best method to archive this goal is to have maintainer permissions on media/dvb/siano directory.  

There are two ways for us to work to archive the goal to minimize the gap:

1) you may send the patches via linux-media@vger.kernel.org, c/c me on they;

2) you may create a Mercurial tree for you. From time to time, you sync your
tree with the development one, add your patches there and ask me to pull. It
would be better if you could host the tree on some site from you. If you can't
do it, we may create you an account at linuxtv.org.

If the volume of updates by month is not big, (1) may work better. It also
allows a better patch review from the community, so, it is currently the
preferred way.

Michael,
Please let me know if you have any objections on having the Siano developers
sending us their patches directly.

-- 

Cheers,
Mauro





Cheers,
Mauro

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
