Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36828 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1IFTL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 15:11:58 -0400
Received: by iabu26 with SMTP id u26so68115iab.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 12:11:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E6669E6.5030800@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
	<4E663EE2.3050403@redhat.com>
	<CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
	<4E666417.9090706@redhat.com>
	<CAOcJUbwOFibvKiSNyVt8WZa5HuOqqPqZAbyzkshxdd0fegJuAQ@mail.gmail.com>
	<4E6669E6.5030800@redhat.com>
Date: Tue, 6 Sep 2011 15:11:57 -0400
Message-ID: <CAOcJUbwwc_6mJwFq5_K5aUb-QYgWhO9c=FZ+yTaR8wrRPckRGw@mail.gmail.com>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
From: Michael Krufky <mkrufky@kernellabs.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 2:43 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> On 09/06/2011 08:35 PM, Michael Krufky wrote:
>>
>> On Tue, Sep 6, 2011 at 2:19 PM, Hans de Goede<hdegoede@redhat.com>  wrote:
>>>
>>> Hi,
>>>
>>> On 09/06/2011 06:24 PM, Devin Heitmueller wrote:
>>>
>>> <snip>
>>>
>>>> I've been thinking for a while that perhaps the project should be
>>>> renamed (or I considered prepending "kl" onto the front resulting in
>>>> it being called "kl-tvtime").  This isn't out of vanity but rather my
>>>> concern that the fork will get confused with the original project (for
>>>> example, I believe Ubuntu actually already calls their modified tree
>>>> tvtime 1.0.3).  I'm open to suggestions in this regards.
>>>
>>> I think that what should be done is contact the debian / ubuntu
>>> maintainers,
>>> get any interesting fixes they have which the kl version misses merged,
>>> and then just declare the kl version as being the new official upstream
>>> (with the blessing of the debian / ubuntu guys, and if possible also
>>> with the blessing of the original authors).
>>>
>>> This would require kl git to be open to others for pushing, or we
>>> could move the tree to git.linuxtv.org (which I assume may be
>>> easier then for you to make the necessary changes to give
>>> others push rights on kl.org).
>>
>> Hans,
>>
>> Everybody is welcome to contribute to open source projects, but global
>> contribution doesn't mean that a given server be opened up to commits
>> by the general public.
>
> I didn't write open to commits by the general public, now did I? I wrote
> open to commits by others. For most upstream projects it is quite normal
> that several people have push rights to the master tree. This actually
> is quite a good idea, as it avoids adding a SPOF into the chain. It
> means development can continue if one of the maintainers is on vacation
> for a a few weeks, or just having a period in his/her life where he
> is too busy to actively contribute to a spare time project.

Hans,

Now I understand -- that's completely reasonable.  It looks like Devin
is happy having the tree hosted on linuxtv.org anyway, so no worries
:-)  Sorry for the misunderstanding.

Best Regards,

Mike Krufky
