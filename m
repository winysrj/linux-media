Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49107 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab2CTIm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 04:42:56 -0400
Received: by iagz16 with SMTP id z16so10699399iag.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 01:42:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120319114441.5c64574f@dt>
References: <CACKLOr28ECqBhTkMsd=6vSOMPZk2DgbRFWZOZXH39omQRP0fcA@mail.gmail.com>
	<20120319114441.5c64574f@dt>
Date: Tue, 20 Mar 2012 09:42:55 +0100
Message-ID: <CACKLOr0PU40+fc=YDKq-LcTKGkfXsZT4G52RTB8fzu=8sSqRaw@mail.gmail.com>
Subject: Re: [Q] ov7670: green line in VGA resolution
From: javier Martin <javier.martin@vista-silicon.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,
thank you for your attention.

On 19 March 2012 18:44, Jonathan Corbet <corbet@lwn.net> wrote:
> On Mon, 19 Mar 2012 17:27:06 +0100
> javier Martin <javier.martin@vista-silicon.com> wrote:
>
>> I suspect the problem is related to the fact that this sensor has an
>> array of 656 x 488 pixels but only 640 x 480 are active. The datasheet
>> available from Omnivision (Version 1.4, August 21, 2006) is not clear
>> about how to configure the sensor not to show non active pixels but I
>> could find the following patch which addresses a similar problem for
>> QVGA:
>
> Interesting...nobody ever sent that patch anywhere where I've seen it.
>
> Anyway, the ov7670 datasheet is not clear on much of anything, and the
> things it *is* clear on are likely to be wrong.
>
> The comment in the patch makes it clear how this was worked out, anyway:
> "empirically determined."  Unless you can get through to the one person at
> OmniVision who knows how this sensor actually works, the best that can be
> done is to mess with the values for the window.  That's often done at both
> the sensor and the controller level - if you look at the Marvell
> controller, you'll see window tweaking there too.

So, what I understand is that you see the same green line and, due to
the lack of documentation for the ov7670, you solve it adjusting de
video window in the Marvell controller driver. Could you confirm this?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
