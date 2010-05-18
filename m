Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp28.orange.fr ([80.12.242.100]:34805 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0EROj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 10:39:58 -0400
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] new DVB-T initial tuning for fr-nantes
Date: Tue, 18 May 2010 16:39:56 +0200
Cc: matpic <matpic@free.fr>
References: <4BF290A2.1020904@free.fr> <alpine.DEB.2.01.1005181606440.29367@ureoreg>
In-Reply-To: <alpine.DEB.2.01.1005181606440.29367@ureoreg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005181639.56368.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 18 mai 2010 16:25:56, BOUWSMA Barry a écrit :
> On wto (wtorek) 18.maj (maj) 2010, 15:05:00, matpic wrote:
> 
> Salut!
> 
> > hello
> > As from today (18/05/2010) there is new frequency since analogic signal
> > is stopped and is now only numeric.
> > guard-interval has to be set to AUTO or scan find anything
> > 
> >  (1/32, 1/16, 1/8 ,1/4 doesn't work)
> 
> I do not have the CSA data at hand, but I understand that
> presently use is made of single transmitter sites, in a MFN
> (Multi-Frequency Network) and thus a guard interval of 1/32 should
> be correct.
> 
> (I understand though that some filler transmitters may be in
> planning so that a small SFN may be put in service, but I am
> not clear as to these details...  I must research this.)
> 
> > #same frequency + offset 167000000 for some hardware DVB-T tuner
> 
> It was my understanding that the different offsets above or
> below the nominal centre frequency is a result of mixed digital
> and legacy analogue services co-broadcasting, in order to avoid
> interference with adjacent channels.
> 
> So I am wondering whether, in the absence of local analogue
> services, this offset is no longer employed?
> 
> I am afraid that I am not following the conversion to TNT so
> closely to know if a whole geographic region, in this case the
> Loire, is having the remaining analogue services shut down all
> at once, or if it is being done on a site-by-site basis, with
> the potential for interference to a more remote but still
> operational analogue transmitter.
> 
> In any case, all but one of the new frequencies appear to be
> very different from the ones previously used before today.
> 
> 
> Merci, for reporting this change!
> 
> barry bouwsma

All analogic services are all closed at once.
I guess the "offset" is there to help some (buggy?) devices, like cinergy T2, 
not to reflect a real frequency offset.

-- 
Christophe Thommeret


