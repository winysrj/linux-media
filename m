Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx06.syd.iprimus.net.au ([210.50.76.235]:48340 "EHLO
	mx06.syd.iprimus.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0E2JTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 05:19:47 -0400
From: Mike Booth <mike_booth76@iprimus.com.au>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: Re: What ever happened to standardizing signal level?
Date: Sat, 29 May 2010 19:09:36 +1000
Cc: VDR User <user.vdr@gmail.com>,
	"mailing list: linux-media" <linux-media@vger.kernel.org>
References: <AANLkTinPCgrLPdtFgEDa76RnEG85GSLVJv0G6z56z3P1@mail.gmail.com> <AANLkTinU8T0fWHHHS0azFK33Ec8yYLguiZxos9z7hOvP@mail.gmail.com>
In-Reply-To: <AANLkTinU8T0fWHHHS0azFK33Ec8yYLguiZxos9z7hOvP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005291909.36973.mike_booth76@iprimus.com.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 29 May 2010 14:45:40 Konstantin Dimitrov wrote:
> at least in driver for the frontend found on TBS 6980 Dual DVB-S2 card
> i added options "esno" and "dbm" respectively for reporting SNR
> (actually C/N) in EsNo dB and signal strength in dBm, which is at
> least real statistics about the signal and not like almost meaningless
> percents. so, that's one way to go. some DVB-S/S2 demodulators use
> EsNo dB and other EbNo dB and so maybe step toward some
> standardization is routines for conversion between those two. also,
> maybe there will be common agreement how to convert signal strength in
> dBm to percents and SNR (C/N) in EsNo or EbNo dB to percents. i
> believe that will guarantee more standard way to give information
> about the signal, but it's just my opinion.
> 
> On Sat, May 29, 2010 at 6:09 AM, VDR User <user.vdr@gmail.com> wrote:
> > A lot of people were anticipating this happening but it seems to have
> > stalled out.  Does anyone know what the intentions are?  Many users
> > were also hoping to _finally_ get a good signal meter for linux as
> > well.  If anyone has any info, please share!
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



i think someone is too concerned about being precisely accurate. So much so 
that no-one can see the woods for the trees any more.

Its not important to me that accuracy is spot on. I only want to know that 
when tuning the dish I'm getting \better or worse.

A mate has fixed this locally. So will we get a plethora of patches all trying 
to do the same thing.

Mike
