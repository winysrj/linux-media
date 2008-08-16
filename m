Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KUE7u-0000TO-Do
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 07:14:59 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	4BFF91800F60
	for <linux-dvb@linuxtv.org>; Sat, 16 Aug 2008 05:14:23 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Robert Golding" <robert.golding@gmail.com>
Date: Sat, 16 Aug 2008 15:14:23 +1000
Message-Id: <20080816051423.3B19911581F@ws1-7.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
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
> From: "Robert Golding" <robert.golding@gmail.com>
> To: stev391@email.com
> Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB Only support
> Date: Sat, 16 Aug 2008 13:43:06 +0930
> 
> 
> I have finally got the modules to load the PxDVR 3200 H I bought,
> however, now I am getting "Failed to lock channel" error messages from
> MeTV.
> The 'channels.conf' file is correct as I used for my Dvico DVB-T.
> 
>   I have replaced the Dvico with the Leadtek because I wanted to be
> able to get local radio and also use the PCI-e channel since I have
> many of them and only one PCI slot.
> 
> The card is auto-recognised and loads all dvb modules, including fw
> and frontends.
> 
> One other thing, I attached an MS drive and tried it in windows [that
> is another wholly different story :-) ] and it worked very well.  I
> had occation to compare the channels info to each other and the Linux
> version is OK.
> 
> Any information, no matter how small, to show how I might fix this
> would be greatly apprecited
> 
> --
> Regards,	Robert
> 
> ..... Some people can tell what time it is by looking at the sun, but
> I have never been able to make out the numbers.
> ---
> Errata: Spelling mistakes are not intentional, however, I don't use
> spell checkers because it's too easy to allow the spell checker to
> make the decisions and use words that are out of context for that
> being written, i.e. their/there, your/you're, threw/through and even
> accept/except, not to mention foreign (I'm Australian) English
> spelling, i.e. colour/color, socks/sox, etc,.

Robert,

First things first.
What errors are in the dmesg output? 
(i.e. provide a dmesg output from the line loading the cx23885 driver onwards, ensure that you have tried to tune channels before doing this)

Does it work in Windows on the same computer with the same antenna?

What does the dvb scan program give you when you try to scan for channels?

You said that the fw loads, is it the correct one (there are multiple copies of firmware running around for this tuner, it should state that it loaded 80 images in the dmesg)?

Regards

Stephen

P.S. If you have gotten my email from the linux dvb list, please include it in the cc field in the email. So that others can learn from the problems and hopefully save me from typing the same response over and over. (By the way have checked the mailing list and tried the other solutions to problems people have encountered with this card?).

-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
