Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m29JpuYg006713
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 15:51:56 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.242])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m29JpJTv017082
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 15:51:19 -0400
Received: by an-out-0708.google.com with SMTP id c31so424661ana.124
	for <video4linux-list@redhat.com>; Sun, 09 Mar 2008 12:51:16 -0700 (PDT)
Message-ID: <bd41c5f0803091251v33167043v2b874da795ebe09f@mail.gmail.com>
Date: Sun, 9 Mar 2008 15:51:16 -0400
From: "Chaogui Zhang" <czhang1974@gmail.com>
To: "Brandon Rader" <brandon.rader@gmail.com>
In-Reply-To: <331d2cab0803082131x70d98855i828c9f1bfb731cff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <331d2cab0803062218x663ad17ofb79928059a111b@mail.gmail.com>
	<bd41c5f0803081850o3b818d0ar633fbf0b50bc5535@mail.gmail.com>
	<331d2cab0803082131x70d98855i828c9f1bfb731cff@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Subject: Re: Trying to setup PCTV HD Card 800i
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

On Sun, Mar 9, 2008 at 1:31 AM, Brandon Rader <brandon.rader@gmail.com> wrote:
> On Sat, Mar 8, 2008 at 8:50 PM, Chaogui Zhang <czhang1974@gmail.com> wrote:
>
>
>
> > On Fri, Mar 7, 2008 at 1:18 AM, Brandon Rader <brandon.rader@gmail.com>
>  > wrote:
>  > > Hello,
>  > >
>  > >  I bought the PCTV HD 800i tuner from woot.com, and waited until drivers
>  > had
>  > >  been developed for it. I followed the guide from
>  > >  LinuxTV<
>  > http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_%28800i%29>
>  > >  .
>  > >
>  > >  My dmesg and lspci outputs are below. The dmesg output has some errors
>  > in
>  > >  it, and the lspci looks like it is an entry short compared to some of
>  > the
>  > >  other lspci outputs I've seen for this card. When I try to modprobe
>  > >  cx88_dvb:
>  > >
>  > >  $ sudo modprobe cx88_dvb
>  > >  FATAL: Error inserting cx88_dvb
>  > >  (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/cx88/cx88-
>  > dvb.ko):
>  > >  No such device
>  > >
>  > >  lspci output:
>  > >  lspci | grep -i cx
>  > >  06:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
>  > and
>  > >  Audio Decoder [MPEG Port] (rev 05)
>  > >  06:07.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
>  > Audio
>  > >  Decoder [Audio Port] (rev 05)
>  > >
>  > >  dmesg output:
>  > >  dmesg | grep -i cx
>  > > <snipped>
>  >
>  > Did you reboot after installing the new driver? If not, try that first.
>  > If you did reboot and got the error, can you paste your *complete*
>  > dmesg output to http://pastebin.com and post the generated link here?
>  >
>  > BTW, I added cc to the linux-dvb list, which is the more appropriate place
>  > for your question.
>  >
>  > --
>  > Chaogui Zhang
>  >
>
>
>
>  I did restart after installing it.  Here is the link to my dmesg output:
>  http://pastebin.com/m19aa6aa4
>

A couple of strange things showed up in the dmesg output:

1. The i2c bus seems somehow corrupted, as suggested by the repeated
i2c read error and the tveeprom read error
2. The xc5000 driver was never loaded, probably due to the i2c read problems.

At the moment, I don't know what might have gone wrong. Can you try to
use the following repo instead and see what happens?

http://linuxtv.org/hg/~stoth/v4l-dvb/

This is not the most up to date code, but contains most that are
needed for the 800i. I suspect some recent patch might have introduced
minor bugs for the i2c bus. If the above repo proves to be working for
you, then we can start looking at what caused the i2c problem.

-- 
Chaogui Zhang

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
