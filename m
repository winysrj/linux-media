Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:64987 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1HBITF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 04:19:05 -0400
Received: by eye22 with SMTP id 22so5063226eye.2
        for <linux-media@vger.kernel.org>; Tue, 02 Aug 2011 01:19:04 -0700 (PDT)
Date: Tue, 2 Aug 2011 10:18:57 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Doron Cohen <doronc@siano-ms.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers: support new Siano tuner devices.
In-Reply-To: <D945C405928A9949A0F33C69E64A1A3BAFFC82@s-mail.siano-ms.ent>
Message-ID: <alpine.DEB.2.01.1107310018340.1800@localhost.localdomain>
References: <D945C405928A9949A0F33C69E64A1A3BAFFC82@s-mail.siano-ms.ent>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
