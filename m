Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:9037 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZCIU4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 16:56:40 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1181041ywh.1
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2009 13:56:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1767e6740902221745r48506a51ne1f080d8abe7a2f0@mail.gmail.com>
References: <1767e6740902181819i9982865u1dec75b5f337b8a4@mail.gmail.com>
	 <49A1B90B.8080502@rogers.com>
	 <1767e6740902221745r48506a51ne1f080d8abe7a2f0@mail.gmail.com>
Date: Mon, 9 Mar 2009 15:56:37 -0500
Message-ID: <1767e6740903091356u2c87b639idfd23acafb89c766@mail.gmail.com>
Subject: Re: Kworld atsc 110 nxt2004 init
From: Jonathan Isom <jeisom@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 22, 2009 at 8:45 PM, Jonathan Isom <jeisom@gmail.com> wrote:
> On Sun, Feb 22, 2009 at 2:43 PM, CityK <cityk@rogers.com> wrote:
>> Jonathan Isom wrote:
>>> Hi
>>> I was looking over my logs and I'm wondering is
>>> "nxt200x: Timeout waiting for nxt2004 to init"
>>> common

HI all
  I am not sure if this is actually related to my lockups,  however I
think I may have
figured out something. If I boot my system with clocksource equal to
hpet it occurs
right after boot(~8secs in), but if I set it to jiffies I don't see
it(note early testing, may
still end up occuring).  In nxt2004_microcontroller_init there is a
msleep(10) and I'm
wondering if 200 msec(loop)  is long enough.

Any Thoughts?

Jonathan

>> No its not common
>>
>>> or is this womething I need to worry about.  I got one shortly before a
>>> lockup(No backtrace).  Nothing was doing other than dvbstreamer sitting idle.
>>> I'll provide further logs if it should be needed.  I would think that
>>> It would need to
>>> only be initialize at module load.  Am I wrong in this thinking?
>>>
>>> in kernel  drivers 2.6.28.4
> Hi
> Looking at the logs I found that there was a backtrace. However I believe it
> is related to dvbstreamer and the kworld cards.  I cycle thru the channels to
> download epg info.  The previous crash I forgot that I was running the script
> to cycle them and export the xmltv data.
