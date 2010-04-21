Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab0DUEqG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 00:46:06 -0400
Date: Wed, 21 Apr 2010 01:45:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: linux-media@vger.kernel.org
Subject: Re: tm6000: firmware
Message-ID: <20100421014538.59c690ad@pedra>
In-Reply-To: <4BC768E7.8070204@arcor.de>
References: <4BC5ECB8.2060208@arcor.de>
	<4BC5FF15.10605@redhat.com>
	<4BC60C72.6020901@arcor.de>
	<4BC62E69.60600@redhat.com>
	<4BC7249C.9010201@arcor.de>
	<4BC7496A.6090105@redhat.com>
	<4BC768E7.8070204@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 15 Apr 2010 21:28:39 +0200
Stefan Ringel <stefan.ringel@arcor.de> escreveu:

> Am 15.04.2010 19:14, schrieb Mauro Carvalho Chehab:
> > Em 15-04-2010 07:37, Stefan Ringel escreveu:
> >   
> >> Am 14.04.2010 23:06, schrieb Mauro Carvalho Chehab:
> >>     
> >>> Em 14-04-2010 11:41, Stefan Ringel escreveu:
> >>>   
> >>>       
> >>>> Am 14.04.2010 19:44, schrieb Mauro Carvalho Chehab:
> >>>>     
> >>>>         
> >>>>> Hi Stefan,
> >>>>>
> >>>>> Em 14-04-2010 09:26, Stefan Ringel escreveu:
> >>>>>   
> >>>>>       
> >>>>>           
> >>>>>> Hi Mauro,
> >>>>>>
> >>>>>> Can you added these three firmwares? The third is into archive file,
> >>>>>> because I'm extracted for an user (Bee Hock Goh).
> >>>>>>     
> >>>>>>         
> >>>>>>             
> >>>>> Sorry, but for us to put the firmwares at the server and/or add them at linux-firmware 
> >>>>> git tree, we need to get the distribution rights from the manufacturer,
> >>>>> as described on:
> >>>>> 	http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches#Firmware_submission
> >>>>>
> >>>>> So, we need Xceive's ack, in order to add the firmware files somewhere. That's why
> >>>>> currently we're using the procedure described on the comments at the extraction
> >>>>> tool:
> >>>>> 	Documentation/video4linux/extract_xc3028.pl  
> >>>>>
> >>>>> Cheers,
> >>>>> Mauro
> >>>>>   
> >>>>>       
> >>>>>           
> >>>> OK. In the archive is the modified extract_xc3028 tool for
> >>>> tm6000-xc3028.fw . Is that useful?
> >>>>     
> >>>>         
> >>> Yes, but:
> >>>
> >>> 1) Please, send it as a patch, with the proper SOB;
> >>>
> >>> 2) From a diff I did here:
> >>>
> >>> -       my $sourcefile = "UDXTTM6000.sys";
> >>> -       my $hash = "cb9deb5508a5e150af2880f5b0066d78";
> >>> -       my $outfile = "tm6000-xc3028.fw";
> >>> +       my $sourcefile = "hcw85bda.sys";
> >>> +       my $hash = "0e44dbf63bb0169d57446aec21881ff2";
> >>> +       my $outfile = "xc3028-v27.fw";
> >>>
> >>> This version works with another *.sys file. The proper way is to
> >>> check for the hash, and use the proper logic, based on the provided
> >>> sys file;
> >>>
> >>> 3) Please document where to get the UDXTTTM6000.sys file at the 
> >>> comments;
> >>>
> >>> 4) tm6000-xc3028.fw is a really bad name. It made sense only during
> >>> the development of tuner-xc2028.c, since, on that time, it seemed that
> >>> tm6000 had a different firmware version. In fact, the first devices
> >>> appeared with v 1.e firmware. So, a proper name for that version
> >>> would be xc3028-v1e.fw. We should rename it to be consistent.
> >>>
> >>>   
> >>>       
> >> The firmware name is was you write in tm6000-card.c file and yes it can
> >> renamed. This firmware work in tm5600 and tm6000 sticks where the
> >> firmware v2.7 or v3.6 not works. The version isn't v1.e , it is v2.4 see
> >> log file from Bee Hock Goh (
> >>     
> > Ok. then, please send me a patch renaming the firmware used by this card as
> > xc3028-v24.fw.
> >
> > I won't be able to apply any patch until next week (I'm currently abroad for
> > the Collaboration Summit).
> >
> >   
> >> http://www.mail-archive.com/linux-media@vger.kernel.org/msg17378.html ).
> >>     
> >>> It is not clear what version is provided with this version. Is it
> >>> v3.6? On a few cases, we've seen some modified versions of XC3028 firmwares
> >>> shipped with some specific board. Is it the case?
> >>>       
> > With respect to your patch, you need to add some logic to decide to generate
> > either v2.4 or v2.7, based on the *.sys checksum code. So, instead of just
> > renaming things, the proper solution is to create two sub-routines: one for
> > v2.7 and another for v2.4, and decide to use either one, based on the checksum
> > of the *.sys file.
> >
> >   
> I have generated new the patch.

Much better! Yet:

	+verify($sourcefile_24, $hash_24);
	+	verify($sourcefile_27, $hash_27);
	+
	+	open INFILE, "<$sourcefile_24";
	+	main_firmware_24($outfile_24, $name_24, $version_24, $nr_desc_24);
	+	close INFILE;
	+
	+	open INFILE, "<$sourcefile_27";
	+	main_firmware_27($outfile_27, $name_27, $version_27, $nr_desc_27);
	 	close INFILE;
	 }

Users shouldn't be forced to download both files, as just one file is needed for a given device. 
So, instead, the tool should test if the file exists, and handle only the found file(s).

-- 

Cheers,
Mauro
