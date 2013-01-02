Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50648 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab3ABASB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 19:18:01 -0500
Message-ID: <50E37C95.3020208@iki.fi>
Date: Wed, 02 Jan 2013 02:17:25 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Diorser <diorser@gmx.fr>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi> <op.wp9b661h4bfdfw@quantal>
In-Reply-To: <op.wp9b661h4bfdfw@quantal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2013 02:12 AM, Diorser wrote:
>> Does it show 100% even antenna is unplugged ?
>
> It seems in fact that signal indicator is not reliable.
> I have to sometimes reset dvb with:
>
> for I in dvb_usb_af9035 af9033 tda18218 dvb_usb_v2 dvb_core rc_core; do
> rmmod $I; done
> modprobe dvb-usb-af9035
>
> The antenna signal input is fine, this is at least the point I am sure.
>
>> You mean you see LOCK flag gained, then there is maybe error pid
>> filter timeouts ?
>
> Not sure of that. tzap test seems to show the opposite:
>
> tzap -r TEST
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/home/test_r/.tzap/channels.conf'
> tuning to 586167000 Hz
> video pid 0x0200, audio pid 0x028a
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |

This says it quite clearly, it does not work at all. I don't know why 
you resists to remove antenna or unplug stick, but even you remove 
antenna I am quite sure you will see similar results.

> I also took the kaffeine dvb files perfectly working with saa7134 card,
> but A918R card does not tune on  any channel.
> Then, the lack of signal strength stability / front-end problem is may
> be the root cause.
> Thanks again for your time

Maybe there is some GPIO controlling antenna input or switching some other.

Antti

-- 
http://palosaari.fi/
