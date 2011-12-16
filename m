Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43666 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1LPJrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 04:47:09 -0500
Received: by wgbdr13 with SMTP id dr13so5908574wgb.1
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 01:47:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHG8p1BLVgO1_vN+Wsk1R6awG+uAht1Z9w542naOO53XqVThOQ@mail.gmail.com>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1112160909470.6572@axis700.grange>
	<CAHG8p1AXghgSQNHUQi5V56ROAfS9tOsMRbAMqNogNG0=m7zzkQ@mail.gmail.com>
	<Pine.LNX.4.64.1112161014580.6572@axis700.grange>
	<CAHG8p1BLVgO1_vN+Wsk1R6awG+uAht1Z9w542naOO53XqVThOQ@mail.gmail.com>
Date: Fri, 16 Dec 2011 10:47:07 +0100
Message-ID: <CACKLOr3g94f9_p8yoE8sRzat5tZdNW5u1dnK=VRHuS43CxFHKA@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: javier Martin <javier.martin@vista-silicon.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, saaguirre@ti.com,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 December 2011 10:36, Scott Jiang <scott.jiang.linux@gmail.com> wrote:
>>> How about this implementation? I know it's not for soc, but I post it
>>> to give my idea.
>>> Bridge knows the layout, so it doesn't need to query the subdevice.
>>
>> Where from? AFAIU, we are talking here about subdevice inputs, right? In
>> this case about various inputs of the TV decoder. How shall the bridge
>> driver know about that?
>
> I have asked this question before. Laurent reply me:
>
>> >> ENUMINPUT as defined by V4L2 enumerates input connectors available on
>> >> the board. Which inputs the board designer hooked up is something that
>> >> only the top-level V4L driver will know. Subdevices do not have that
>> >> information, so enuminputs is not applicable there.
>> >>
>> >> Of course, subdevices do have input pins and output pins, but these are
>> >> assumed to be fixed. With the s_routing ops the top level driver selects
>> >> which input and output pins are active. Enumeration of those inputs and
>> >> outputs wouldn't gain you anything as far as I can tell since the
>> >> subdevice simply does not know which inputs/outputs are actually hooked
>> >> up. It's the top level driver that has that information (usually passed
>> >> in through board/card info structures).

But AFAIK, soc-camera does not support passing such kind of information.
Neither any of the host camera drivers currently available expect that
kind of data.



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
