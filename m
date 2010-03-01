Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab0CAIcs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Mar 2010 03:32:48 -0500
Message-ID: <4B8B7BF2.4070201@redhat.com>
Date: Mon, 01 Mar 2010 09:33:54 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Announcing v4l-utils-0.7.90 (which includes libv4l-0.7.90)
References: <4B882457.1050006@hhs.nl> <201003010845.50657.hverkuil@xs4all.nl>
In-Reply-To: <201003010845.50657.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/01/2010 08:45 AM, Hans Verkuil wrote:
> On Friday 26 February 2010 20:43:19 Hans de Goede wrote:
>> Hi,
>>
>> I'm happy to announce the first (test / beta) release of v4l-utils,
>> v4l-utils is the combination of various v4l and dvb utilities which
>> used to be part of the v4l-dvb mercurial kernel tree and libv4l.
>
> Is it correct that I only see v4l utilities and no dvb?
>

I just went with was already put in the repo by Mauro and Douglas. I'm fine
with adding dvb utilities, but I don't feel it is my place to decide to
do that.

>> I encourage people to give this version a spin. I esp. would like
>> feedback on which v4l / dvb utilities should end up being installed
>> by make install. For now I've stuck with what the Makefile in v4l2-apps
>> did. See README for a list of all utilities and if they are currently
>> installed or not.
>
> qv4l2-qt3 should either be dropped altogether (my preference, although Mauro
> thinks differently), or be moved to contrib. I think it is nuts to keep that
> one around since the qt4 version is much, much better and the qt3 version is
> no longer maintained anyway.
>

Well currently it compiles on recent distro's without issues, so I'm fine with
keeping things as is for now, if this becomes a maintenance burden it can
always be moved to contrib later.

> xc3028-firmware, v4l2-compliance and rds should also be moved to contrib.
>

I'm fine with moving xc3028-firmware and rds there. But v4l2-compliance
sounds like something that could be useful I've no idea how useful it actually
is though, I have not tested it.

> I'm not sure about decode_tm6000, keytable and v4l2-sysfs-path. These too
> may belong to contrib.
>

Ack for decode_tm6000 (if that is useful it should be turned into a lib) and
I have no clue what v4l2-sysfs-path does. keytable might be usefull, well
at least the keycode tables. The tool it self seems to overlap with other
evdev utilities in distro's so maybe we should put the keycode tables in
some sort of standard format, and drop keytable itself ?

> We definitely want to have alevtv here as well (it's currently in dvb-apps).
>

See above.


<snip>

>> You can always find the latest developments here:
>> http://git.linuxtv.org/v4l-utils.git
>
> Hmm, I get errors when I attempt to clone this.
>

Hmm, I had the same issue myself when using ssh+git, I had to use:
git+ssh://hgoede@linuxtv.org/git/v4l-utils

Notice the /git/ (and no .git at the end)

Regards,

Hans
