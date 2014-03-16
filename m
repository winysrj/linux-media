Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:33626 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaCPMO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 08:14:59 -0400
Received: by mail-qc0-f182.google.com with SMTP id e16so4842675qcx.13
        for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 05:14:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3611058.9Umk0NSF20@radagast>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
	<1394838259-14260-7-git-send-email-james@albanarts.com>
	<CAKv9HNYgfoAnTHfivgo8tov4nkSZHZ2+qJ=1BJzXUHXDmDSm2w@mail.gmail.com>
	<3611058.9Umk0NSF20@radagast>
Date: Sun, 16 Mar 2014 14:14:58 +0200
Message-ID: <CAKv9HNZipt2RWn1mf_X8Rt+udb-jmDLMDJThRJjYUmkovyCTzA@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] rc: ir-rc5-sz-decoder: Add ir encoding support
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James.

On 16 March 2014 13:50, James Hogan <james@albanarts.com> wrote:
> Hi Antti,
>
> On Sunday 16 March 2014 10:34:31 Antti Seppälä wrote:
>> > +
>> > +       /* all important bits of scancode should be set in mask */
>> > +       if (~scancode->mask & 0x2fff)
>>
>> Do we want to be so restrictive here? In my opinion it's quite nice to
>> be able to encode also the toggle bit if needed. Therefore a check
>> against 0x3fff would be a better choice.
>>
>> I think the ability to encode toggle bit might also be nice to have
>> for rc-5(x) also.
>>
>
> I don't believe the toggle bit is encoded in the scancode though, so I'm not
> sure it makes sense to treat it like that. I'm not an expert on RC-5 like
> protocols or the use of the toggle bit though.
>

Well I'm not an expert either but at least streamzap tends to have the
toggle bit enabled quite often when sending ir pulses.

When decoding the toggle is always removed from the scancode but when
encoding it would be useful to have the possibility to encode it in.
This is because setting the toggle bit into wakeup makes it easier to
wake the system with nuvoton hw as it is difficult to press the remote
key short time enough (less than around 112ms) to generate a pulse
without the toggle bit set.

-Antti
