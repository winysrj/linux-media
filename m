Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab2AXNBZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 08:01:25 -0500
Message-ID: <4F1EAB97.6060301@redhat.com>
Date: Tue, 24 Jan 2012 11:01:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "L. Hanisch" <dvb@flensrocker.de>
CC: Christian Brunner <chb@muc.de>, linux-media@vger.kernel.org,
	thomas.schloeter@gmx.net
Subject: Re: [PATCH] dvb: satellite channel routing (unicable) support
References: <20110928190421.GA13539@sir.fritz.box> <4E837ACF.60804@flensrocker.de>
In-Reply-To: <4E837ACF.60804@flensrocker.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Em 28-09-2011 16:51, L. Hanisch escreveu:
> Hi,
> 
> Am 28.09.2011 21:04, schrieb Christian Brunner:
>> This is an updated version of the unicable patch by Thomas Schloeter
>> for linux 3.1.
>>
>> The patch is an addition to the dvb_frontend code, that adds fully
>> transparent support for SCR to arbitrary applications that use the
>> DVB API.
>>
>> I know that this patch has been rejected, because unicable support
>> can be implemented in userspace, too. However I like it anyway,
>> because there is a lot of software without unicable support out
>> there. I'm just sending it, because I think it could be usefull
>> for others.
>>
>> DVB satellite channel routing (aka "SCR", "Unicable", "EN50494") is
>> a standard, where all satellite tuners share the sam cable and each of
>> them has a fixed intermediate frequency it is supposed to tune to.
>> Zapping is done by sending a special DiSEqC message while SEC voltage
>> is temporarily pulled from 14 to 18 volts. This message includes the
>> tuner's ID from 0 to 7, the frequency, band and polarisation to tune
>> to as well as one out of two satellite positions.
>>
>> By default SCR support is disabled and has to be enabled explicitly
>> via an ioctl command. At the same time you set the tuner's ID, the
>> frequency and other parameters. Thomas developed an utility
>> (dvb-scr-setup) to accomplish this task. It can be used unmodified.
>>
>> I'm using this patch successfully with a DUR-LINE UK 101 unicable LNB.
> 
>  That would be awesome to have this functionality in the kernel. I maintained the "unicable"-patch for the vdr (written by some guy from the vdr-portal.de who sadly doesn't seem to respond to mails via that forum anymore).
>  It would be great if all the work could be summarized in one ioctl.

I don't think that SCR/Unicable, bandstacking, LNBf settings, rotor
control, etc. should belong to the Kernel. There are too many variants,
and several of them are not properly standardized or properly implemented.
Also, the actual options to use will depend on what type of DiSEqC components
used on his particular setup. So, it would be very difficult to write
something at the Kernel that will fit in all cases.

What the Kernel should support is the capability of sending/receiving DiSEqC
commands, allowing userspace libraries to do the job of setting it. Such
feature is already there, so there's no need to change anything there.

That's said, I'm working on a library to be used by applications that want
to talk with DVB devices. Together, with the library, there are a scanning
tool and a zapping tool.

So, inspired by this patch, and using a public tech note about SCR/Unicable [1],
I wrote an Unicable patch for such library:

	http://git.linuxtv.org/v4l-utils.git/commit/6c2c00ed3722465ed781ad49567e34dc7a5f92e7

I'm currently without DVB-S/DVB-S2 antennas, so, I was not able to test it.

It would be very nice if you could help us by testing if those tools are
working with DVB-S with SCR, and, if not, help fixing its support.

[1] http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/APPLICATION_NOTE/CD00045084.pdf

Regards,
Mauro
