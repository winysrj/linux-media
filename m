Return-path: <mchehab@pedra>
Received: from web25404.mail.ukl.yahoo.com ([217.12.10.138]:35648 "HELO
	web25404.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752754Ab0JYGQ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 02:16:27 -0400
Message-ID: <130335.5569.qm@web25404.mail.ukl.yahoo.com>
References: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com> <201010242055.30799.albin.kauffmann@gmail.com> <AANLkTinwb_7ErteoWcO2VC1nu9uNqUwu6N+HEhrDwwg-@mail.gmail.com> <AANLkTinVas23b2ZMuBxzdY6PUP-4JEMchNup9nSpxsf3@mail.gmail.com>
Date: Mon, 25 Oct 2010 07:16:26 +0100 (BST)
From: fabio tirapelle <ftirapelle@yahoo.it>
Subject: Re: Wintv-HVR-1120 woes
To: Sasha Sirotkin <demiurg@femtolinux.com>,
	Albin Kauffmann <albin.kauffmann@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTinVas23b2ZMuBxzdY6PUP-4JEMchNup9nSpxsf3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

My WinTV-HVR-1120 works if I delete dvb-fe-tda10048-1.0.fw and 
rename dvb-fe-tda10046.fw in dvb-fe-tda10048-1.0.fw
(see cf "Hauppauge  WinTV-HVR-1120 on Unbuntu 10.04" thread).
After reboot my WinTV-HVR-1120 works. Ubuntu recognizes that the firmware isn't 
correct and doesn't load the firmware.
But I know that isn't a good practice.


----- Messaggio originale -----
> Da: Sasha Sirotkin <demiurg@femtolinux.com>
> A: Albin Kauffmann <albin.kauffmann@gmail.com>
> Cc: linux-media@vger.kernel.org
> Inviato: Dom 24 ottobre 2010, 23:45:55
> Oggetto: Re: Wintv-HVR-1120 woes
> 
> On Sun, Oct 24, 2010 at 10:22 PM, Sasha Sirotkin <demiurg@femtolinux.com>  
>wrote:
> > On Sun, Oct 24, 2010 at 8:55 PM, Albin Kauffmann
> > <albin.kauffmann@gmail.com>  wrote:
> >> On Thursday 21 October 2010 23:25:29 Sasha Sirotkin  wrote:
> >>> I'm having all sorts of troubles with Wintv-HVR-1120 on  Ubuntu 10.10
> >>> (kernel 2.6.35-22). Judging from what I've seen on  the net, including
> >>> this mailing list, I'm not the only one not  being able to use this
> >>> card and no solution seem to  exist.
> >>>
> >>> Problems:
> >>> 1. The driver  yells various cryptic error messages
> >>> ("tda18271_write_regs:  [1-0060|M] ERROR: idx = 0x5, len = 1,
> >>> i2c_transfer returned:  -5", "tda18271_set_analog_params: [1-0060|M]
> >>> error -5 on line  1045", etc)
> >>
> >> yes, indeed :(
> >> (cf "Hauppauge  WinTV-HVR-1120 on Unbuntu 10.04" thread)
> >>
> >>> 2. DVB-T  scan (using w_scan) produces no results
> >>
> >> Is this  happening after each reboot? As far as I'm concerned, I've never 
>had
> >>  problems with DVB-T scans.
> >>
> >
> > Almost always. I think I  had a lucky reboot or two, but most of the
> > time DVB-T scan produces  nothing.
> >
> >>> 3. Analog seems to work, but with very poor  quality
> >>
> >> I just tried to use Analog TV in order to  confirm the problem but I cannot 
>get
> >> any picture. Maybe I just don't  know how to use it. I'm using commands 
like
> >> (I'm located in  France):
> >>
> >> mplayer tv:// -tv  driver=v4l2:norm=SECAM:chanlist=france -tvscan autostart
> >>
> >>  ... and just get some "snow" on scanned channels.
> >> As I might have a  problem with my antenna (an interior one), I am going to
> >> test it  under Windows and report back my experience.
> >
> > I'm using  tvtime-scanner
> >>
> >> Cheers,
> >>
> >>  --
> >> Albin Kauffmann
> >>
> >
> >
> > I'm trying to  downgrade the kernel now to see if it helps
> >
> 
> I went back as far as  2.6.30 and I still have this problem. 2.6.29
> does not recognize this card at  all.
> --
> To unsubscribe from this list: send the line "unsubscribe  linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More  majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      
