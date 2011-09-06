Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63125 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1IFSfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 14:35:39 -0400
Received: by iabu26 with SMTP id u26so43552iab.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 11:35:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E666417.9090706@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
	<4E663EE2.3050403@redhat.com>
	<CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
	<4E666417.9090706@redhat.com>
Date: Tue, 6 Sep 2011 14:35:38 -0400
Message-ID: <CAOcJUbwOFibvKiSNyVt8WZa5HuOqqPqZAbyzkshxdd0fegJuAQ@mail.gmail.com>
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

On Tue, Sep 6, 2011 at 2:19 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> On 09/06/2011 06:24 PM, Devin Heitmueller wrote:
>
> <snip>
>
>> I've been thinking for a while that perhaps the project should be
>> renamed (or I considered prepending "kl" onto the front resulting in
>> it being called "kl-tvtime").  This isn't out of vanity but rather my
>> concern that the fork will get confused with the original project (for
>> example, I believe Ubuntu actually already calls their modified tree
>> tvtime 1.0.3).  I'm open to suggestions in this regards.
>
> I think that what should be done is contact the debian / ubuntu maintainers,
> get any interesting fixes they have which the kl version misses merged,
> and then just declare the kl version as being the new official upstream
> (with the blessing of the debian / ubuntu guys, and if possible also
> with the blessing of the original authors).
>
> This would require kl git to be open to others for pushing, or we
> could move the tree to git.linuxtv.org (which I assume may be
> easier then for you to make the necessary changes to give
> others push rights on kl.org).

Hans,

Everybody is welcome to contribute to open source projects, but global
contribution doesn't mean that a given server be opened up to commits
by the general public.  You should feel free to push to your own git
tree hosted on linuxtv.org (or any public git server, for that matter)
and send pull requests to Devin Heitmueller, who is currently
maintaining the kernellabs version of tvtime.

Regards,

Michael Krufky
