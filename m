Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1Jchvh-0001wr-MU
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 15:09:12 +0100
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: "Albert Comerma" <albert.comerma@gmail.com>
Date: Fri, 21 Mar 2008 15:08:32 +0100
References: <200803211152.26870.hfvogt@gmx.net>
	<ea4209750803210459i3fe6fddan103931bda885435e@mail.gmail.com>
In-Reply-To: <ea4209750803210459i3fe6fddan103931bda885435e@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803211508.32114.hfvogt@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PATCH Pinnacle 320cx Terratec Cinergy HT USB XE -
	Draft 2
Reply-To: hfvogt@gmx.net
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

Hi Albert,

creating the patch was nothing spectacular: as Mauro suggested, I used
diff -upr orig-file1 new-file1 > patch-file; diff -upr orig-file2 new-file2 >> patch-file
(and because I do not have two full directory trees I changed afterwards the file names in the patch). As the baseline for
v4l-dvb, I use a snapshot of  early march, but I confirmed the relevant files (dib0700_devices.c and dvb-usb-ids.h) are still
the same in the current mercurial repository.
I have no experience so far with hg diff, but will try this command next time.

Cheers,
Hans-Frieder

> Perfect!! it seems great, now I will check it (sorry, I was very busy last
> two days). I also will add support for Felix's card and the two cards I have
> pending (just add device id and small modifications), so it will be easier
> for patrick to add the different patches to the current source. Just one
> comment, how you generated the patch? because mauro suggested it's better to
> use hg diff. In a minutes I will send the modified patch (I hope it will be
> the last version).
> 
> Albert
> 
> 2008/3/21, Hans-Frieder Vogt <hfvogt@gmx.net>:
> >
> > Hi Albert,
> >
> > I have slightly changed the stk7700ph_frontend_attach GPIO sequence to be
> > in line with the Windows behaviour and also add
> > the demod-value in stk7700ph_xc3028_ctrl, to make the driver load the
> > right SCODE file (which seems to have no effect,
> > though). Also, I removed the unused and unneeded xc3028_bw_config_12mhz
> > structure.
> > In addition, I followed Mauro's request for coding style changes and also
> > add some more kernel style changes that
> > checkpatch highlighted (I only introduced changes where they seemed
> > sensible, there are many, many other
> > areas in the file dib0700_devices.c where it does not follow the strict
> > coding guidelines as well).
> >
> > Can you please confirm that I included your changes for the Pinnacle 320cx
> > correctly and perhaps also add a signoff-line?
> > Thanks very much.
> >
> > Hans-Frieder
> >
> > --
> >
> > --
> > Hans-Frieder Vogt                 e-mail: hfvogt <at> gmx .dot. net
> >
> >
> 



-- 
--
Hans-Frieder Vogt                 e-mail: hfvogt <at> gmx .dot. net

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
