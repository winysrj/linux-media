Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36258 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab1KLPo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:44:26 -0500
Received: by wyh15 with SMTP id 15so4688811wyh.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:44:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB33W8eYnQbKAkNobiez0yH5tgCVN4s84ncT5cmKHxeqHm8P3Q@mail.gmail.com>
References: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
	<CAB33W8eMEG6cxM9x0aGRe+1xx6TwvjBZL4KSdRY4Ti2sTHk9hg@mail.gmail.com>
	<CAL9G6WXq_MSu+6Ogjis43bsszDri0y5JQrhHrAQ8tiTKv09YKQ@mail.gmail.com>
	<CAATJ+ftr76OMckcpf_ceX4cPwv0840C9HL+UuHivAtub+OC+jw@mail.gmail.com>
	<4ebdacc2.04c6e30a.29e4.58ff@mx.google.com>
	<CAB33W8eYnQbKAkNobiez0yH5tgCVN4s84ncT5cmKHxeqHm8P3Q@mail.gmail.com>
Date: Sat, 12 Nov 2011 16:44:24 +0100
Message-ID: <CAL9G6WXHfA-n0u_yB7QvUAN_8TxSSA2M_O0m6kbsOrcgE+nMsA@mail.gmail.com>
Subject: Re: AF9015 Dual tuner i2c write failures
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Tim Draper <veehexx@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/11/12 Tim Draper <veehexx@gmail.com>:
> On 11 November 2011 23:16, Malcolm Priestley <tvboxspy@gmail.com> wrote:
>> On Sat, 2011-11-12 at 09:51 +1100, Jason Hecker wrote:
>>> I concur.  I have been using Malcolm Priestly's patches with both my
>>> AF9015 dual tuner cards (which are PCI but still look like USB to the
>>> kernel) for a few weeks now and have (finally!) got consistently
>>> perfect recordings in MythTV simultaneously with both tuners on a
>>> card. Malcolm, when do you think you'll submit these patches to the
>>> tree for inclusion?  Is there anything else to test?
>>>
>>> I agree about the power cycling.  Every time I reboot I disconnect the
>>> AC supply for 20secs to be sure the cards are power cycled properly -
>>> you do the same thing by pulling out the stick.
>>
>> Yes, this is what is holding up the patches to media_build.
>>
>> The bug appears to be a race condition that appears in get config with
>> some usb controllers.
>>
>> Josu, your patch is for the older hg version on s2, so this will not
>> work on media_build.
>>
>> I have being trying to a way to do it without the bus lock, but can't
>>
>> I will try and finish the patches tomorrow.
>>
>> Regards
>>
>>
>> Malcolm
>>
>>
>
> thanks for the quick responses guys! i look forward to the update.
> since i'm new to this mailing list, and have only used v4l in
> pre-configured linux distro's, how will this fix be distributed to
> people - as a patch i presume?
> are there any how-to's with prerequisites of whats required to apply a patch?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello Tim, I am not expert on this. I use to install this way:

apt-get install linux-headers-`uname -r` build-essential
mkdir /usr/local/src/dvb
cd /usr/local/src/dvb

wget http://mercurial.intuxication.org/hg/s2-liplianin/archive/tip.zip
unzip s2-liplianin-0b7d3cc65161.zip
cd s2-liplianin-0b7d3cc65161

cp /home/lazkano/Dropbox/repository/dvb/af9015_v3.patch.tar.gz .
tar xvzf af9015_v3.patch.tar.gz
patch -p1 < af9015_v3.patch

make CONFIG_DVB_FIREDTV:=n
make install

With this method, I get working the Kworld dual DVB-T and Tevii S660 DVB-S2.

Malcolm, thanks for your work, with this patches you will make useful
3 DVB-T devices I have.

Regards.


-- 
Josu Lazkano
