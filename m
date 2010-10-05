Return-path: <mchehab@pedra>
Received: from c2beaomr07.btconnect.com ([213.123.26.185]:39527 "EHLO
	mail.btconnect.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752926Ab0JEVRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 17:17:22 -0400
From: sibu xolo <sibxol@btconnect.com>
To: linux-media@vger.kernel.org
Subject: Re: udev-161 dvbT kernel-2.6.35.5
Date: Tue, 5 Oct 2010 22:17:47 +0100
References: <201010040116.35961.sibxol@btconnect.com> <201010042026.10301.sibxol@btconnect.com>
In-Reply-To: <201010042026.10301.sibxol@btconnect.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010052217.48029.sibxol@btconnect.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 04 October 2010 20:26:10 sibu xolo wrote:

> I sent the email above  to the list  a day or so ago and received no
> response. If I am on the wrong list I would be grateful if someone  aufait
>    inform me of the appropriate list.   Otherwise suggestions   of where I
> am going wrong would be much apprecuated.
> 
> as an update:-
> I tested  the setup described above  on  a machine with kernel-2.6.31.6 and
> /dev/dvb/adapter0 is generated
> 
> I recall a  while back when DVB  drivers were not in the kernel.   Then
> they were  integrated within  thus requiring only a kernel compilation.  I
> came across the somewhat  ubuntified  wiki
> ( http://www.linuxtv.org/wiki/index.php/Bug_Report )
> (which seems  to suggest the old method    is now needed..  I would  thus
> be grateful for some clarity  as per:-
> 
> Is  compiling the kernel  as up to 2.6.28.8 and  with prior selection of
> the appropriate devices under device/drivers/multimedia/video   sufficient
> or does one  now need  to follow the recipe given by the link above.
> 
> sx


I have two dvbT devices avermedia-dbvT-usb2 (DEVICE1) and Hauppauge wintv 
NovatT-usb2(DEVICE2).  I am not a total novice at installing dvb on linux.  I 
have done so in the past on 

--kernels 2.6.17/2.6.19
--kernel-2.6.27/2.6.31
firmwares in /lib/irmware
AND Both worked  successfully on the above.

NOW after  the post(s) above  which provided no response,  I fiddled around 
like so:-

-------------------------------------------
-----------A) I compiled the kernel  for in-kernel drivers/modern V4L-api/with  
DEVICE1 in situ. On booting -  I obtained  /dev/dvb/adapter0.  Eureka.
I then  tried booting with DEVICE2 and  the machine dwelled   then reported 
that firmware file could not be found.  I  Then rebooted with DEVICE1 only to 
be met with the same message.  
I surmised that perhaps I should use the older api  marked depreciated as 
DECICE{1/2} are ~6 years old.

----------B)So I recompiled the kernel  with both devices attached  selecting 
v4l- depreciated  and compiled all as modules.  
After kernel installation   DEVICES{1/2} registered as /dev/dvb/adapter{0/1). 
Hurray  at last.
I removed the device did something else and rebooted the machine. with one 
device. On booting  I obntained the  'cant find firmware error as reported 
under A).  
I tried the other device  and onbbtained the same error.



I would be most grateful if someone on list could explain what is going on 
please.  I see 'patches' flying  and things looking ever so  busy and 
complicated  but no one seens inclined to  provide a modicum of guidance if 
only as a pointer to the appropriate list or if this is the appropriate list. 

In the words of JKGailbraith 'lets hope that  apparent 'complexities' are not 
devices for avoiding simple truths".


