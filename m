Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:59771 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3H0HTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 03:19:37 -0400
From: Krishna Kishore <krishna.kishore@sasken.com>
To: Chris Lee <updatelee@gmail.com>,
	Mariusz Bialonczyk <manio@skyboo.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: stv090x vs stv0900 support
Date: Tue, 27 Aug 2013 07:19:32 +0000
Message-ID: <7CC27E99F1636344B0AC7B73D5BB86DE148C0E05@exgmbxfz01.sasken.com>
References: <CAA9z4Lbd5wm0=T=CGHbxga5wOdj+TZQO2BA+spxV_keWS5OmcQ@mail.gmail.com>
	<520DD27F.8020708@skyboo.net>
 <CAA9z4LYD-skCr82WpE5TtAREpKBvtQzD+jk30KpzSTB08dmDYA@mail.gmail.com>
In-Reply-To: <CAA9z4LYD-skCr82WpE5TtAREpKBvtQzD+jk30KpzSTB08dmDYA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

    Does it help me in getting through the problem I am facing?

    On Desktop (Ubuntu 12.04), 7500 does not work. But, on desktop Ubuntu 13.04 it works fine.

    Since it is working well with 13.04, I tried with 3.8.x kernel on my board. It does not work. So, I can see that kernel version does not matter.

    I assume you have 7500 DVB receiver. Can you please try this device with Ubuntu 12.04 and 13.04 and see the difference in the behavior?
    If it helps you, I can send you logs of 12.04 and 13.04.

   Thanks in advance.

Regards,
Kishore.




-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Chris Lee
Sent: Friday, August 16, 2013 6:21 PM
To: Mariusz Bialonczyk
Cc: Linux Media Mailing List
Subject: Re: stv090x vs stv0900 support

Ive found a few bugs in stv090x that I want to get ironed out 100% before I submit the patch, dvb-s2 8psk fec2/3 for example has a slightly higher ber then stv0900, Got that fixed but Im still not happy with the patch, has a few other minor issues with low sr dvb-s qpsk sometimes not locking on the first attempt to tune. The Prof 7500 also seems to have an issue with stb6100 where get_frequency() wont return the correct frequency when other stb6100 devices I have do.
Once I get those figured out to the point Im happy I'll submit it for everyones comments.

Thanks for the link Mariusz, I'll check it out, maybe youve overcome some of the shortfalls Ive found

Chris Lee

On Fri, Aug 16, 2013 at 1:19 AM, Mariusz Bialonczyk <manio@skyboo.net> wrote:
> On 07/24/2013 06:39 PM, Chris Lee wrote:
>> Im looking for comments on these two modules, they overlap support
>> for the same demods. stv0900 supporting stv0900 and stv090x
>> supporting
>> stv0900 and stv0903. Ive flipped a few cards from one to the other
>> and they function fine. In some ways stv090x is better suited. Its a
>> pain supporting two modules that are written differently but do the
>> same thing, a fix in one almost always means it has to be implemented
>> in the other as well.
> I totally agree with you.
>
>> Im not necessarily suggesting dumping stv0900, but Id like to flip a
>> few cards that I own over to stv090x just to standardize it. The Prof
>> 7301 and Prof 7500.
> I did it already for 7301, see here:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure
> /28082 but due to 'political' reasons it doesn't went upstream.
> For private use i am still using this patch on recent kernels, because
> it is working much more stable for my card comparing to stv0900.
> I think that moving prof 7500 should be relative easy, i even prepared
> a patch for this but I was not able to test it due to lack of hardware.
>
>> Whats everyones thoughts on this? It will cut the number of patch''s
>> in half when it comes to these demods. Ive got alot more coming lol
>> :)
> Oh yes, you could also take into account another duplicate code:
> stb6100_cfg.h used for stv090x
> stb6100_proc.h used for stv0900
> In my patch I've successfully switched to stb6100_cfg.h.
>>
>> Chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-media" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> regards,
> --
> Mariusz Bia³oñczyk | xmpp/e-mail: manio@skyboo.net
> http://manio.skyboo.net | https://github.com/manio
>
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

________________________________

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
