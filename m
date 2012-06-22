Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43038 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab2FVPz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 11:55:27 -0400
Received: by pbbrp8 with SMTP id rp8so3723373pbb.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 08:55:27 -0700 (PDT)
Message-ID: <4FE4956D.6040206@gmail.com>
Date: Fri, 22 Jun 2012 08:55:25 -0700
From: Mack Stanley <mcs1937@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Chipset change for CX88_BOARD_PINNACLE_PCTV_HD_800i
References: <4FE24132.4090705@gmail.com> <CAGoCfixL-tEFq4SpjxChH7uc0aDZGtdoO6EqrEH3tzPzoTqK8w@mail.gmail.com> <4FE3A3A6.5050500@gmail.com> <CAGoCfiympaYxeypnq0uuX_azsHhk3OFuLu-=r0yEvOz51Eznqw@mail.gmail.com>
In-Reply-To: <CAGoCfiympaYxeypnq0uuX_azsHhk3OFuLu-=r0yEvOz51Eznqw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/22/2012 07:28 AM, Devin Heitmueller wrote:
> On Thu, Jun 21, 2012 at 6:43 PM, Mack Stanley <mcs1937@gmail.com> wrote:
>> mplayer [various options] dvb://6
>>
>> tunes to different channels different times, sometimes to video from one
>> channel and sound from another, sometimes to video but no sound.
> I would try tuning to the same channel multiple times and see if it
> behaves *consistently*.  In other words, does it always tune to the
> same "wrong" channel or consistently show the same wrong audio/video
> stream.  My guess is this has nothing to do with the card but rather
> is a problem with the scanner putting the right values into the
> channels.conf (wrong video/audio PIDs in the file).
>
>> I'll be interested in what your contacts at pctv suggest.
> I'm going back and forth with my PCTV contact.  He says the chip was
> swapped out and there weren't any other changes to the PCB.  However
> as you discovered, driver changes are required.  Should be pretty easy
> to get working.
>
> Devin
>
Hi Devin,

Your absolutely right about the tuning problem.  The VID's and AID's
were all wrong.  The card seems to have been choosing more at less at
random among the channels on the same frequency.  I copied the correct
VID's and AID's out of the DTA by hand and now everything is A-OK.

So, keeping all of the configuration settings exactly the same and
simply using s5h1411_attach instead of s5h1409_attach works perfectly. 
Maybe the easiest path is just to have the driver try one, if it fails,
try the other.

Thanks again, Mack

