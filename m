Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:40864 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761477Ab2COMcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 08:32:07 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Roger =?ISO-8859-1?Q?M=E5rtensson?= <roger.martensson@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add CI support to az6007 driver
Date: Thu, 15 Mar 2012 13:29:05 +0100
Message-ID: <1554005.yI229plrDj@jar7.dominio>
In-Reply-To: <4F60D934.7040006@gmail.com>
References: <1577059.kW45pXQ20M@jar7.dominio> <4F57B520.9070607@gmail.com> <4F60D934.7040006@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Miércoles, 14 de marzo de 2012 18:45:24 Roger Mårtensson escribió:
> Hello!
> 
> Sorry for the top post but this is just to check with you if you have
> experienced the same problem that I have. See below with some additional
> comments.
> 
> Roger Mårtensson skrev 2012-03-07 20:21:
> > Jose Alberto Reguero skrev 2012-03-06 00:23:
> >> On Lunes, 5 de marzo de 2012 21:42:48 Roger Mårtensson escribió:
> >> 
> >> No. I tested the patch with DVB-T an watch encrypted channels with
> >> vdr without
> >> problems. I don't know why you can't. I don't know gnutv. Try with
> >> other
> >> software if you want.
> > 
> > I have done some more testing and it works.. Sort of. :-)
> > 
> > First let me walk through the dmesg.
> > 
> > First I reinsert the CAM-card:
> > 
> > Mar  7 20:12:36 tvpc kernel: [  959.717666] dvb_ca adapter 2: DVB CAM
> > detected and initialised successfully
> > 
> > The next lines are when I start Kaffeine. Kaffeine gets a lock on the
> > encrypted channel and starts viewing it.
> > 
> > Mar  7 20:13:02 tvpc kernel: [  986.359195] mt2063: detected a mt2063 B3
> > Mar  7 20:13:03 tvpc kernel: [  987.368964] drxk: SCU_RESULT_INVPAR
> > while sending cmd 0x0203 with params:
> > Mar  7 20:13:03 tvpc kernel: [  987.368974] drxk: 02 00 00 00 10 00 05
> > 00 03 02                    ..........
> > Mar  7 20:13:06 tvpc kernel: [  990.286628] dvb_ca adapter 2: DVB CAM
> > detected and initialised successfully
> > 
> > And now my "sort of"-comment. When I change the to another encrypted
> > channel in kaffeine I get nothing. To be able to view this channel I
> > need to restart kaffeine.
> > 
> > The only thing that seems different in the logs are that when
> > restarting kaffeine I get the "CAM detected and initialised" but when
> > changing channels I do not get that line.
> > 
> > Maybe there should be another reinit of the CAM somewhere? (just a
> > guess)
> 
> I turned on debugging and I see when changing channels from one
> encrypted to another I get lots of:
> "40 from 0x1read cam data = 0 from 0x1read cam data = 80 from 0x1read
> cam data = "
> 
> So the drivers is doing something except I don't get anything in
> kaffeine until I restart the application.
> Now and then I even have to restart kaffeine twice. Same as above.. I
> see it reading but nothing happens.
> 
> I seem to find some EPG data since it can tell me what programs should
> be shown.

No, I don't have this problem. The only problem I have is when the reception 
is not very good, the cam don't work.
Perhaps is a kaffeine problem, or a cam specific problem.

Jose Alberto
