Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <askvictor@gmail.com>) id 1K4ahY-0000O1-U0
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 14:05:49 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1529793rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 06 Jun 2008 05:05:41 -0700 (PDT)
Message-ID: <8f8b28f10806060505o633a1b27h78f73d9f05b49e73@mail.gmail.com>
Date: Fri, 6 Jun 2008 22:05:41 +1000
From: "victor rajewski" <askvictor@gmail.com>
To: Blacky <linux-dvb@blackdog.shacknet.nu>
In-Reply-To: <000101c8bbab$cda34450$68e9ccf0$@shacknet.nu>
MIME-Version: 1.0
Content-Disposition: inline
References: <000101c8bbab$cda34450$68e9ccf0$@shacknet.nu>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Building v4l-dvb on mythbuntu (kernel
	2.6.24-16-generic)
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

On Thu, May 22, 2008 at 11:33 AM, Blacky <linux-dvb@blackdog.shacknet.nu> wrote:
>
> Hi all
>
> I've been using v4l-dvb build tree for a while, and recently installed
> mythbuntu.
>
> I pulled the latest release from the repository, and after building and
> installing
> the modules I get an error while booting (or specifically, while loading
> module tuner_xc2028
> during start-up)

Apparently the driver is included in 2.6.25. I haven't tried it
though. If you wanted you could pull the kernel out of the PPA
repository. But if you're using nvidia graphics, that has problems
with 2.6.25 - needs a patch to work.

vik

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
