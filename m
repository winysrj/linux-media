Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab2DTPIQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 11:08:16 -0400
Message-ID: <4F917BD9.5070505@redhat.com>
Date: Fri, 20 Apr 2012 12:08:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Gonzalo A. de la Vega" <gadelavega@gmail.com>
CC: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] TDA9887 PAL-Nc fix
References: <4F8EB1F1.1030801@gmail.com> <1334879437.14608.22.camel@palomino.walls.org> <CADbd7mHbP0YVQSBo4TgF0ZKqEU5VydWOoHZp__owh2b4k8aZsw@mail.gmail.com>
In-Reply-To: <CADbd7mHbP0YVQSBo4TgF0ZKqEU5VydWOoHZp__owh2b4k8aZsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Buenos dias Gonzalo,

Em 20-04-2012 11:01, Gonzalo A. de la Vega escreveu:
> On Thu, Apr 19, 2012 at 8:50 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> On Wed, 2012-04-18 at 09:22 -0300, Gonzalo de la Vega wrote:
>>> The tunner IF for PAL-Nc norm, which AFAIK is used only in Argentina, was being defined as equal to PAL-M but it is not. It actually uses the same video IF as PAL-BG (and unlike PAL-M) but the audio is at 4.5MHz (same as PAL-M). A separate structure member was added for PAL-Nc.
>>>
>>> Signed-off-by: Gonzalo A. de la Vega <gadelavega@gmail.com>
>>
>> Hmmm.
>>
>> The Video IF for N systems is 45.75 MHz according to this popular book
>> (see page 29 of the PDF):
>> http://www.deetc.isel.ipl.pt/Analisedesinai/sm/downloads/doc/ch08.pdf
>>
>> The Video IF is really determined by the IF SAW filter used in your
>> tuner assembly, and how the tuner data sheet says to program the
>> mixer/oscillator chip to mix down from RF to IF.
>>
>> What model analog tuner assembly are you using?  It could be that the
>> linux tuner-simple module is setting up the mixer/oscillator chip wrong.
>>
>> Regards,
>> Andy
> 
> Hi Andy,
> first of all and to clarify things: I could not tune analog TV without
> this patch, or I could barely see a BW image. With the patch applied,
> I can see image in full color and with good sound. So it works with
> the patch, it does not work without it.
> 
> Now, I'm not an expert on TV (I am an electronics engineer thou) so I
> am having some trouble trying to put together what I read in the
> TDA9887 datasheet and the reference you sent. The thing with PAL-Nc is
> that it has a video bandwidth of 4.2MHz not 5.0MHz (page 51) and the
> attenuation of color difference signals for >20dB is at 3.6MHz instead
> of 4MHz (page 54). You can just search for "Argentina" inside the
> document.
> 
> So, this works... but now I'm not sure why. I guess cVideoIF_38_90 is
> compensating for the bandwidth difference. I need to study this.

>From other discussions we've had at the ML, it seems that devices sold in
Argentina with analog tuners sometimes come with a NTSC tuner, and sometimes 
come with an European PAL tuner. They solve the frequency shifts that
happen there via some tda9887 (and/or tuner-simple) adjustments.

It seems that the setup, when using one type, is different than the other.

That's why we need to know exactly what it is the tuner that your device
has.

So, from time to time, we receive patches from someone in Argentina fixing
support for one type, but breaking support for the other type. 

What we need is that someone with technical expertise and with the two types
of devices, with access to real PAL-Nc signals, to work on a solution that
would set it accordingly, depending on the actual tuner used on it.

Regards,
Mauro
