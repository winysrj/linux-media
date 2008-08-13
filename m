Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KTBKN-00087d-Te
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 10:03:33 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	58AC2180058D
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 08:02:05 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Steven Toth" <stoth@linuxtv.org>
Date: Wed, 13 Aug 2008 18:02:05 +1000
Message-Id: <20080813080205.30823164293@ws1-4.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
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


> ----- Original Message -----
> From: "Steven Toth" <stoth@linuxtv.org>
> To: stev391@email.com
> Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB Only support
> Date: Tue, 12 Aug 2008 12:33:53 -0400
> 
> 
> 
> > ---------Leadtek_Winfast_PxDVR3200_H_Signed_Off.diff---------
> > cx23885: Add DVB support for Leadtek Winfast PxDVR3200 H
> >
> > ---------cx23885_callback_tidyup.diff---------
> > cx23885: Remove Redundant if statements in tuner callback
> 
> Thanks.
> 
> Pull this tree and run a quick test again (I had an odd whitespace merge issue - likely 
> thunderbirds fault - that I have to cleanup):
> 
> http://linuxtv.org/hg/~stoth/v4l-dvb/
> 
> If everything is working then I'll issue the pull request for final merge.
> 
> - Steve

Steve,

I have tested this tree and all (DVB related items) are working with the Leadtek card.

Thanks for your assistance and time in including this driver into your tree.

Now I have to read up on analog support and see if I can get the mpeg encoder going...

Regards,
Stephen


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
