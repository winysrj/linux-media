Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:49268 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab0AVLRs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 06:17:48 -0500
Message-ID: <4B598A0D.1000702@crans.org>
Date: Fri, 22 Jan 2010 12:20:45 +0100
From: Brice Dubost <dubost@crans.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, dvbfreaky007@gmail.com
Subject: Re: [linux-dvb] Initial Scan Data for DVB channel scan,	How to get
 Initial DVB Scan 	data
References: <fd9871421001220222w7d6e8f6evd5f30efb52c2c150@mail.gmail.com>
In-Reply-To: <fd9871421001220222w7d6e8f6evd5f30efb52c2c150@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvbfreaky 007 wrote:
> Hi ,
> Can anyone share the information, regarding "How initial scan data will
> generate"
> 
> from "dvb-apps->utils->scan",
> to scan for channels, i executed following command
> "./scan dvb-s/InSat4B-80.5E"
> 
> content of InSat4B-80.5E,
> 1 # Insat 4B-80.5E
> 2 # freq pol sr fec
> 3 S 1000 V 27500000 AUTO
> 4 S 10234234 V 27500000 AUTO
> 5 S 11232300 V 27500000 AUTO
> 6 S 11213343 V 27500000 AUTO
> 7 S 10990000 V 27500000 AUTO
> ~
> 
> My question is,
> who will populate this information and from where they will populate
> this info.
> Is there any standard transponders frequency list.
> 
> like
> http://www.lyngsat.com/in4b.html
> 
> we must follow this , for tuning?
> 
> 
> 
> Is there any tool, which doesnt required any initial data for scanning
> dvb channels?
> 
> 
> please let me know,
> 

Hello

Scan tunes on the transponders given in the initial scanning file, then
get the informations from the DVB descriptors.

The initial tuning information is get on websites like lyngsat and
kingofsat. This information can also found on the channel providers
websites, on the satellite manufacturer website etc ...

In the case of the DVB apps, you will see from time to time people which
proposes patches on the mailing list to update this information
(especially for terrestrial)

For your information scan doesn't need to know about all the
transponders since (normally) in each transponder there is packets to
announce the other transponders of the same satellite

For scanning without initial tuning files this is possible in
terrestrial with w_scan (which basically tries all the possible frequencies)

I don't know any software which do the same for satellite, I think it's
mainly because the number of possible frequencies is too big


I hope this will help you

Best regards

-- 
Brice
