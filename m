Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n171iunN024585
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 20:44:56 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n171hgX1011388
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 20:43:43 -0500
Received: by nf-out-0910.google.com with SMTP id d3so177734nfc.21
	for <video4linux-list@redhat.com>; Fri, 06 Feb 2009 17:43:42 -0800 (PST)
Date: Sat, 7 Feb 2009 10:43:54 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20090207104354.55581cdf@glory.loctelecom.ru>
In-Reply-To: <498CDCD9.1010305@eng.wayne.edu>
References: <163227.41578.qm@web35306.mail.mud.yahoo.com>
	<498CDCD9.1010305@eng.wayne.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: Philips saa6752hs mpeg encoder recommendation
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

Hi Brian

> Hello all,
> 
> I'd like to do some mpeg encoder testing on linux with the Philips
> saa6752hs mpeg encoder but I'm having a difficult time finding
> PCI cards that use the chip.
> 
> If anyone has any recommendations on cards that make use of
> the Philips saa6752hs chip and associated linux driver, I'd really
> appreciate the info. Especially cards that are still available new
> or readily available used.

Our TV tuners has hardware MPEG encoder saa6752hs:
BeholdTV M6
BeholdTV M63
BeholdTV M6 Extra

We made support this cards in Linux with Hans Verkuil (big thanks). 
See saa7134-empress.c and saa6752hs.c source code (in media/video/saa7134 folder).

And bad news. You can't buy our card outside of Russia.

With my best regards, Dmitry.

> 
> Thanks,
> Brian
> 
> 
> Curtis Schroeder wrote:
> > I recently picked up a Philips SPC 600 NC web cam on clearance,
> > because I had read in the Ekiga documentation that most Philips web
> > cams were compatible.  Evidently the SPC 600 NC currently is not
> > compatible with Linux.  I've downloaded and installed
> > gspca-4d0827823ebc in my 64-bit Ubuntu 8.10 installation, but it
> > reports in dmesg that it does not recognize the sensor.  Is there a
> > utility I can run and report the results back to this list that
> > would help get this situation corrected?
> >
> > Curt
> >
> >
> >       
> > --
> > video4linux-list mailing list
> > Unsubscribe
> > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
> >   
> 
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
