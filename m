Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx05.lb01.inode.at ([62.99.145.5] helo=mx.inode.at)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <philipp@kolmann.at>) id 1JvcHP-0004jX-Gu
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 19:57:44 +0200
Date: Mon, 12 May 2008 19:57:39 +0200
From: Philipp Kolmann <philipp@kolmann.at>
To: Igor <goga777@bk.ru>
Message-ID: <20080512175739.GA29838@kolmann.at>
References: <20080510085803.GA30598@kolmann.at>
	<E1JulAl-0001Ho-00.goga777-bk-ru@f53.mail.ru>
	<20080512174441.GB23724@kolmann.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080512174441.GB23724@kolmann.at>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis-08f27ef99d74: Compile error with 2.6.25
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

On Mon, May 12, 2008 at 07:44:41PM +0200, Philipp Kolmann wrote:
> On Sat, May 10, 2008 at 01:15:19PM +0400, Igor wrote:
> > could you try with the latest mantis version
> > http://jusst.de/hg/mantis/rev/b7b8a2a81f3e
> 
> Manits head got fixed (regarding to the hg log). So I tried it. Still the same
> error. Same with v4l tree.
> 
> Now I found a little patch which brought me over this compile error:
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/fix-jdelvare-i2c-i2c-constify-client-address-data.patch

With this patch applied (and one not used module disabled) I was able to
compile latest mantis tree with Debian 2.6.25 kernel and mantis is working now
for me.

Thanks for fixing this issue.
Philipp

-- 
The more I learn about people, the more I like my dog!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
