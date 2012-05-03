Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38127 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab2ECWbA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 18:31:00 -0400
Message-ID: <a252589f928b0654e1a9cb0ef1abb239.squirrel@webmail.kapsi.fi>
In-Reply-To: <4FA29D6F.3090507@interlinx.bc.ca>
References: <4FA293AA.5000601@iki.fi>
    <CAGoCfiw9h8ZqAnrdpg3J8rtnna=JiXj6JYL-gU58xS2HmMuT_w@mail.gmail.com>
    <4FA29D6F.3090507@interlinx.bc.ca>
Date: Fri, 4 May 2012 01:30:57 +0300
From: "Antti Palosaari" <crope@iki.fi>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org,
	"Antti Palosaari" <antti.palosaari@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Re: common DVB USB issues we has currently
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

to 3.5.2012 17:59 Brian J. Murrell kirjoitti:
> On 12-05-03 10:48 AM, Devin Heitmueller wrote:
>>
>> I doubt this is a dvb-usb problem, but rather something specific to
>> the realtek parts (suspend/resume does work with other devices that
>> rely on dvb-usb).
>
> Dunno if it's at all relevant but I used to be able (circa 2.6.32
> perhaps?  it's a bit foggy now) to suspend/resume with my HVR-950q
> installed and modules loaded.  Now suspending with them loaded hangs the
> suspend and they can't even reliably be rmmod/modprobed pre and post
> suspend/resume.
>
> I just wonder if that change in behavior is pointing at something.

That means HVR-950q is not "DVB-USB" device OR it does not have
DVB-USB-firmware to load by the DVB-USB-driver.

regards
Antti

