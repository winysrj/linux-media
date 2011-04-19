Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42824 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1DSJ3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 05:29:39 -0400
Received: by iwn34 with SMTP id 34so4620259iwn.19
        for <linux-media@vger.kernel.org>; Tue, 19 Apr 2011 02:29:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1104191118520.16641@axis700.grange>
References: <BANLkTinpwQtRgVvirgm7NdtaSceNbbVLaw@mail.gmail.com>
	<Pine.LNX.4.64.1104191118520.16641@axis700.grange>
Date: Tue, 19 Apr 2011 11:29:38 +0200
Message-ID: <BANLkTi=GE9dEUY1kiTXEq00yw2imQvm93A@mail.gmail.com>
Subject: Re: Let's submit mt9p031 to mainline.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 19 April 2011 11:19, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Tue, 19 Apr 2011, javier Martin wrote:
>
>> Hi,
>> I finally received my LI-5M03 for the Beagleboard which includes mt9p031 sensor.
>>
>> I know Guennadi has somewhere an outdated version of a driver for it.
>> I would like to help you out on updating the driver so that it can be
>> submitted to mainline.
>> Guennadi please, if you could point me out to that code I could start
>> the job myself.
>>
>> Just one question: what GIT repository + branch should I choose to
>> work on, so that we can seamlessly integrate the changes later?
>
> I wanted to update the code, but usb is currently broken on beagle-board,
> so, I cannot work with it. I'm waiting for it to be fixed to continue with
> that.
>
> Thanks
> Guennadi

So you are planning to do it yourself.
Is there anything I can do to help?

What kernel are you using? In 2.6.38 usb works fine for me in the
Beagleboard xM.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
