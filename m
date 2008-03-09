Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m295W8sQ008149
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 00:32:08 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m295VJuu004218
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 00:31:19 -0500
Received: by an-out-0708.google.com with SMTP id c31so367517ana.124
	for <video4linux-list@redhat.com>; Sat, 08 Mar 2008 21:31:19 -0800 (PST)
Message-ID: <331d2cab0803082131x70d98855i828c9f1bfb731cff@mail.gmail.com>
Date: Sat, 8 Mar 2008 23:31:19 -0600
From: "Brandon Rader" <brandon.rader@gmail.com>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <bd41c5f0803081850o3b818d0ar633fbf0b50bc5535@mail.gmail.com>
MIME-Version: 1.0
References: <331d2cab0803062218x663ad17ofb79928059a111b@mail.gmail.com>
	<bd41c5f0803081850o3b818d0ar633fbf0b50bc5535@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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

On Sat, Mar 8, 2008 at 8:50 PM, Chaogui Zhang <czhang1974@gmail.com> wrote:

> On Fri, Mar 7, 2008 at 1:18 AM, Brandon Rader <brandon.rader@gmail.com>
> wrote:
> > Hello,
> >
> >  I bought the PCTV HD 800i tuner from woot.com, and waited until drivers
> had
> >  been developed for it. I followed the guide from
> >  LinuxTV<
> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_%28800i%29>
> >  .
> >
> >  My dmesg and lspci outputs are below. The dmesg output has some errors
> in
> >  it, and the lspci looks like it is an entry short compared to some of
> the
> >  other lspci outputs I've seen for this card. When I try to modprobe
> >  cx88_dvb:
> >
> >  $ sudo modprobe cx88_dvb
> >  FATAL: Error inserting cx88_dvb
> >  (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/cx88/cx88-
> dvb.ko):
> >  No such device
> >
> >  lspci output:
> >  lspci | grep -i cx
> >  06:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
> and
> >  Audio Decoder [MPEG Port] (rev 05)
> >  06:07.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
> Audio
> >  Decoder [Audio Port] (rev 05)
> >
> >  dmesg output:
> >  dmesg | grep -i cx
> > <snipped>
>
> Did you reboot after installing the new driver? If not, try that first.
> If you did reboot and got the error, can you paste your *complete*
> dmesg output to http://pastebin.com and post the generated link here?
>
> BTW, I added cc to the linux-dvb list, which is the more appropriate place
> for your question.
>
> --
> Chaogui Zhang
>



I did restart after installing it.  Here is the link to my dmesg output:
http://pastebin.com/m19aa6aa4

Brandon
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
