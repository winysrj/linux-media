Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56218 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab3EELV1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 May 2013 07:21:27 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MLUQ0-1UYP2a0iUE-000ZnV for
 <linux-media@vger.kernel.org>; Sun, 05 May 2013 13:21:26 +0200
Message-ID: <518640B4.908@gmx.de>
Date: Sun, 05 May 2013 13:21:24 +0200
From: Reinhard Nissl <rnissl@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Subject: Re: [linux-media] Re: [linux-media] stb0899: no lock on dvb-s2 transponders
 in SCR environment
References: <517BC11E.50105@gmx.de> <517BE5EE.6050004@tvdr.de>
In-Reply-To: <517BE5EE.6050004@tvdr.de>
Content-Type: multipart/mixed;
 boundary="------------010608020709010809050109"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010608020709010809050109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Am 27.04.2013 16:51, schrieb Klaus Schmidinger:
> On 27.04.2013 14:14, Reinhard Nissl wrote:
>> Hi,
>>
>> my stb0899 card works properly on dvb-s and dvb-s2 transponders
>> when using a direct port on my sat multiswitch.
>>
>> When using a SCR port on that multiswitch and changing VDR's
>> config files accordingly, it only locks on dvb-s transponders.
>>
>> A SCR converts the selected transponder's frequency after the
>> LNB (IF1) to a fixed frequency (for example 1076 MHz) by mixing
>> the signal with a local oscialator frequency above IF1 so that
>> the lower sideband of the mixing product appears at 1076 MHz.
>>
>> The lower sideband's spectrum is mirrored compared to the upper
>> sideband, which is identical to the original spectrum on the
>> original IF1.
>>
>> Could that be the reason why the stb0899 cannot lock on dvb-s2
>> transponders in an SCR environment?
>>
>> Any ideas on how to get a lock on dvb-s2 transponders?
>
> Just wanted to let you know that I can confirm the problem with
> the stb0899. On my TT S2-6400 I can receive DVB-S and DVB-S2 just
> fine with SCR. During development of SCR support for VDR I guess
> I did all tests with the 6400, so I didn't come across this problem.
> However, as a reaction to your posting I explicitly tested it with
> my budget cards, and there I indeed can only tune to DVB-S
> transponders.
>
> No idea how to solve this, though...

Well, as mentioned above, it really has to do with the lower side 
band, which is mirrored compared to the original spectrum.

The phase of the Q component of the signal is usually 90 ° behind 
the I component. Due to the mirroring, the phase changes its sign 
which means, the Q component is now 90 ° ahead of the I component 
with the result that the decoded symbols do not match the 
expected code points.

To fix the phase relationship between I and Q component, I and Q 
inputs need to be swapped. This can done by enabling inversion.

I first thought that VDR's channel parameter inversion could do 
the trick, but it looks to me like it is either not supported by 
the driver or does/means something different (have to learn alot 
more about mixing and signal processing regarding DVB).

Anyway, digging through the code I found that the driver supports 
inversion and that this behaviour is a compiled in configuration 
option for the TT-3200 board. The driver even supports automatic 
inversion, so that's the way I got it finally working for now 
(see attached patch).

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de

--------------010608020709010809050109
Content-Type: text/x-patch;
 name="budget-ci.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="budget-ci.c.diff"

--- pci/ttpci/budget-ci.c.orig	2013-05-05 13:18:16.203930908 +0200
+++ pci/ttpci/budget-ci.c	2013-05-05 13:18:26.576914170 +0200
@@ -1280,7 +1280,7 @@ static struct stb0899_config tt3200_conf
 	.demod_address 		= 0x68,
 
 	.xtal_freq		= 27000000,
-	.inversion		= IQ_SWAP_ON, /* 1 */
+	.inversion		= IQ_SWAP_AUTO, /* 2 */
 
 	.lo_clk			= 76500000,
 	.hi_clk			= 99000000,

--------------010608020709010809050109--
