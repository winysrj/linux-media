Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Yusik Kim <yusikk@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Date: Sat, 26 Jul 2008 12:29:42 -0700
References: <200807260353.23359.yusikk@gmail.com>
	<488B4524.5070203@linuxtv.org>
	<200807261130.39977.yusikk@gmail.com>
In-Reply-To: <200807261130.39977.yusikk@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807261229.42608.yusikk@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1950 digital part
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

On Saturday 26 July 2008 11:30:39 Yusik Kim wrote:
> On Saturday 26 July 2008 08:39:16 Steven Toth wrote:
> > Yusik Kim wrote:
> > > Hi,
> > >
> > > Has anyone got the digital part of this device to work properly?
> > >
> > > Modules are compiled from the latest (7/26) v4l-dvb snapshot with a
> > > 2.6.25.4 kernel. The modules seem to load properly and the analog part
> > > works in mythtv. The digital part kind of works.
> > > The problems I can observe are:
> > > 1. Can only scan 3 digital channels using both the command line scan
> > > and mythtv. My other PCI TV card scans 36 of them.
> > > 2. Only occasionally locks in to a channel.
> > > 3. Takes 5 minutes to lock in to a channel when it actually does
> > > succeed.
> > >
> > > I saw from another mailing list that people were trying to get the
> > > remote control to work so I'm guessing the core of the device functions
> > > properly. If this is the current state of support, I'd be glad to help
> > > testing.
> >
> > What steps did you take to prove your hardware is function properly, or
> > your digital cable feed is reliable?
> >
> > The drivers works for me, it sounds like you have an environmental issue.
> >
> > - Steve
>
> Thank you for replying Steve.
> I have a windows partition on the same machine and it works perfectly
> there. So I don't think there is a problem with the cable feed or hardware
> itself.
>
> Not sure if it has any relevance but I noticed in windows, the red LED
> light in the front is always on whereas in linux, it only turns on right
> before it tries to lock in to a channel.
>
> I should add that the 3 channels that were successfully scaned do not
> always get picked up in subsequent attempts. It seems like it has trouble
> tuning. At least it's good to know it's a problem on my end. Just have to
> find a way to fix it.

Also, I tried re-extracting the firmware with the perl script
http://www.isely.net/downloads/fwextract.pl
I downloaded today and used it on the installation CD to get the following 
files
376836 2008-07-26 11:59 v4l-cx2341x-enc.fw
  12559 2008-07-26 11:59 v4l-cx25840.fw
    8192 2008-07-26 11:59 v4l-pvrusb2-29xxx-01.fw
    8192 2008-07-26 11:59 v4l-pvrusb2-73xxx-01.fw
but still no luck. By the way, the filesize for the old v4l-cx25840.fw was 
16382. Everything else the same.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
