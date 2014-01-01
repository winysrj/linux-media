Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37870 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbaAAOM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jan 2014 09:12:29 -0500
Message-ID: <1388585667.1879.15.camel@palomino.walls.org>
Subject: Re: HVR-1800/1850 aka CX23885
From: Andy Walls <awalls@md.metrocast.net>
To: Bob Lightfoot <boblfoot@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Wed, 01 Jan 2014 09:14:27 -0500
In-Reply-To: <52C1E98D.1000905@fedoraproject.org>
References: <52C1E98D.1000905@fedoraproject.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bob:

(CC-ing linux-media mailing list.)

On Mon, 2013-12-30 at 16:45 -0500, Bob Lightfoot wrote:
> Dear Andy:
>    Based on what I read here
> {http://ivtvdriver.org/pipermail/ivtv-users/2009-June/009460.html} you
> are or were maintaining the cx18 driver for Fedora.
>    I have been running a HVR-1600 and an HVR-1850-MCE successfully with
> Centos 6 and Mythtv for some time now.  But I have never seen a
> /dev/radio or had working fm radio in linux.

For an HVR-1600 with an FM antenna connector, FM radio should work under
linux.

/dev/radio0 is the control node.  It switches the card to radio mode and
you can set the FM radio freq using it.  You also can use it for volume
control.  This /dev/node doesn't provide any digitized radio data.

/dev/video24 is an ivtv/cx18 unique device node which provides the PCM
radio data.

Using the cx18-alsa module, the cx18 driver will provide
ALSA /dev/snd/pcm* nodes for the HVR-1600 which also provide the
digitizer audio, the Linux standard way.  The cx18-alsa implementtation
doesn't implement the ALSA mixer controls, IIRC, so you can't use the
ALSA interface to control the HVR-1600 volume directly. 

>   I know the HVR-1850-MCE
> had working fm radio in Vista and that dmesg shows linux as seeing the
> radio.

Analog support for the HVR-1850 in Linux was added late.  It would not
surprise me if FM radio support in that driver didn't exist or was not
tested at all.  I have not looked at that driver lately.  


>    Can you suggest where to look for reading material on getting the
> radio working?

For the cx18 and ivtv based cards, "ivtv-radio" is a simple CLI app that
works in conjuntion with "aplay" to tune to an FM station and play the
audio.

The source for ivtv-radio is in the archive here:

http://dl.ivtvdriver.org/ivtv/stable/ivtv-utils-1.4.1.tar.gz

Save the archive and rename the file to end in ".tar.gz.gz".  The web
server re-gzips the archive (*grumble*) so you need to gunzip it twice.
 
Regards,
Andy

> Sincerely,
> Bob Lightfoot


