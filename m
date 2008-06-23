Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NCbP6D015984
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 08:37:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NCbA71013282
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 08:37:10 -0400
Date: Mon, 23 Jun 2008 09:37:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Paulo Cavalcanti" <promac@gmail.com>
Message-ID: <20080623093701.27071f88@gaivota>
In-Reply-To: <68720af30806221004g65933501p9eded1f072d0940e@mail.gmail.com>
References: <68720af30806221004g65933501p9eded1f072d0940e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux <video4linux-list@redhat.com>
Subject: Re: bttv driver x mythtv x kernel 2.6.25
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

On Sun, 22 Jun 2008 14:04:13 -0300
"Paulo Cavalcanti" <promac@gmail.com> wrote:

> Hi, Mauro
> 
> I almost got mythtv working again with bttv and kernel 2.6.25
> 
> http://mythtv.org/pipermail/mythtv-dev/2008-June/062323.html
> 
> http://mythtv.org/pipermail/mythtv-dev/2008-June/062325.html
> 
> However, I have to run an mplayer (second link above) script before
> using mythtv with Live TV. Otherwise, I get only a green screen.
> 
> Can you give me a clue why the script fix the problem?

Weird. There are some possible reasons for a green screen:

	1) xv troubles. This sometimes happens if you are using a proprietary
driver, like ati or nvidia. Don't use those drivers, or you'll have troubles
displaying tv;

	2) Tuner didn't load firmware properly (if you're using xc2028/xc3028
or xc5000);

	3) Some analog tuners only work if you set it first to a high channel.
Kernel driver already sets freq to 400KHz, so I suspect that this is not the case;

	4) There are some failure at the negotiation process between MythTV and
your board. Since boards like bttv supports several different formats, maybe a
bug at MythTV is preventing it to select the proper format. Maybe some API
non-compliance could prevent MythTV to find the proper format;

	5) a kernel bug ;) Since it is working with other userspace apps, I
don't think this is the issue.

I've just added a small patch at linuxtv repository that will allow you to
enable ioctl debug at the driver.

Please try first to use the non-proprietary driver (if you're using).

If still not working, you'll need to retrieve the last version of the driver at:
	http://linuxtv.org/hg/v4l-dvb

after compiling/installing, you'll need to do:
	modprobe bttv bttv_debug=3

Please try to run mythtv without using the mplayer command and send us the
output of "dmesg" command.

> 
> Thanks, and keep up with the very good work at video4linux.

Anytime.

> PS: Eu também gostaria de convidá-lo para dar uma palestra
> na UFRJ, se você ainda estiver vivendo no Brasil e tiver
> algum tempo livre. Obrigado.

Estou à disposição. Tempo livre sempre é um problema ;) escreva-me diretamente
para conversarmos a respeito.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
