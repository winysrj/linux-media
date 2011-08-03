Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:31366 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754136Ab1HCFC3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Aug 2011 01:02:29 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] drivers: support new Siano tuner devices.
Date: Wed, 3 Aug 2011 08:06:29 +0300
Message-ID: <D945C405928A9949A0F33C69E64A1A3BB39334@s-mail.siano-ms.ent>
In-Reply-To: <alpine.DEB.2.01.1107310018340.1800@localhost.localdomain>
References: <D945C405928A9949A0F33C69E64A1A3BAFFC82@s-mail.siano-ms.ent> <alpine.DEB.2.01.1107310018340.1800@localhost.localdomain>
From: "Doron Cohen" <doronc@siano-ms.com>
To: "BOUWSMA Barry" <freebeer.bouwsma@gmail.com>
Cc: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Barry,
One thing I need to check before I approve and even extent this change:
What happens if the smsdvb module does not exists.
I assume nothing happens since we are not checking the return code and therefore everything will work as if this call was not exist, but I would like to check that before my final decision.
The reason is that the devices from HAUPPAUGE which currently request for the smsdvb module must use the v4l as defined by HAUPPAUGE. Other device based on other SMS chips (Not just the STELLAR but also the NOVA, VENICE, RIO and other device series) not always uses the v4l but sometimes has proprietary player which used the SMS device directly. 
So I wouldn't like to cause harm for those users.

I seems that requesting the module will not harm, if the module does not exists - the request will fail and everything will keep working, and if the module exists it will load but they still won't have to use it. So in that case I would also add a few more devices to the list (all of Siano devices which supports standards supported by v4l. 
If the change will cause problems for users who doesn't need the v4l I will object to this change. I will run a few tests on that and either add these changes or let you know of a problem in a few days.

Regarding DAB+, it was added to the firmware about a year ago, it is required to change the firmware file with a newer one and nothing is required in the host layers for that support. Bad news is that according to the patch you gave - you are probably using STELLAR device and there is no such firmware for that device. The DAB+ support was added to newer Siano devices (NOVA and up) but not for the STELLAR due to device HW limitations.

Regards,
Doron 


-----Original Message-----
From: BOUWSMA Barry [mailto:freebeer.bouwsma@gmail.com] 
Sent: Tuesday, August 02, 2011 11:19
To: Doron Cohen
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers: support new Siano tuner devices.

On k (kedd) 19.júl (július) 2011, 14:21,  Doron Cohen wrote:

> This is the first time I ever post changes to linux kernel, so excuse me
> if I have errors in the process.
> As Siano team member, I would like to update the drivers for Siano
> devices with the latest and greatest fixes. Unfortunately there is a hug
> gap between the current code in the kernel and the code Siano has which
> is more advanced and supports newer devices. I will try to break down
> the changes into small pieces so each of the changes will be clear and
> isolated.
> Here is the first change which is my "test balloon" and includes simple
> changes which includes support in new devices pulished after the kernel
> source maintenance has stopped.

Thanks for your contribution, and I hope it sees usage.

I have found that for many kernel revisions, I have had to have
some variant of the following added code, for my Siano-based
device to function automatically in DVB-T modus:

--- 3.0.0-rc1-hacks/sms-cards.c.orig    2011-04-06 04:04:12.000000000 +0200
+++ 3.0.0-rc1-hacks/sms-cards.c 2011-07-09 10:17:30.000000000 +0200
@@ -301,6 +301,11 @@
        case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
                request_module("smsdvb");
                break;
+/* XXX HACK */
+       case SMS1XXX_BOARD_SIANO_STELLAR:
+               request_module("smsdvb");
+               break;
+
        default:
                /* do nothing */
                break;


Apologies if this problem has been addressed by your patchset.
If there was a reason for removing this functionality, I have
not been able to follow it over time.


Another thing, as my device is capable of receiving DAB radio
broadcasts and Siano has provided a library to make this possible
under Linux, are there plans to update this library for the DAB+
standard that is now being used, with the Reed-Solomon error
protection and up to HE-AACv2 audio encoding?  (I am aware of the 
960-sample-window incompatibility with many AAC software players.)



barry bouwsma
mails will be delayed due to infrequent internet access
now on the road in croatia
