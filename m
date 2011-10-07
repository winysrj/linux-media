Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab1JGPTC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 11:19:02 -0400
Message-ID: <4E8F1860.2050107@redhat.com>
Date: Fri, 07 Oct 2011 12:18:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, Mikael Magnusson <mikachu@gmail.com>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: tvtime at linuxtv.org
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com> <CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com> <CAGoCfixa0pr048=-P3OUkZ2HMaY471eNO79BON0vjSVa1eRcTw@mail.gmail.com> <4E66E532.4050402@redhat.com> <CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com> <CAGoCfiw-QnfVVwOhejwbMmb+K2F0VDwN_L-6E37w+=jKYGGFkg@mail.gmail.com> <CAGoCfixTqXaDU++-k_tn1NMkg4xXNcL=qvezggqe6BqEH+h5xg@mail.gmail.com> <4E8E5CE9.8030604@redhat.com> <CAGoCfixT_DL7nm0zQRYExut8Pd2D9N6rzRKJdoH8oOjJOq9ZFw@mail.gmail.com>
In-Reply-To: <CAGoCfixT_DL7nm0zQRYExut8Pd2D9N6rzRKJdoH8oOjJOq9ZFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-10-2011 10:38, Devin Heitmueller escreveu:
> On Thu, Oct 6, 2011 at 9:59 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> Hi Devin,
>>
>> I had some discussions with Mikael today at the #linuxtv channel about
>> tvtime. Mikael has write access to the tvtime site at sourceforge and he
>> is doing some maintainance on it for some time, and worked on some bugs
>> from Gentoo, and also imported some stuff from Ubuntu.
>>
>> I've merged his patches on my repository:
>>         http://git.linuxtv.org/mchehab/tvtime.git
>>
>> Tvtime is compiling, at least on Fedora 15. I also added your patch there,
>> and changed the latency delay to 50ms. I didn't test it yet. I'll do it
>> later
>> today or tomorrow.
>>
>> Btw, Mikael updated the Related Sites there to point to the LinuxTV site:
>>         http://tvtime.sourceforge.net/links.html
>>
>> He will try to contact Vektor again, in order to get his ack about adding
>> a note at the main page pointing to us.
>>
>> I think we should move those patches to the main repository after testing
>> the
>> merges, and give write rights to the ones that are interested on maintaining
>> tvtime.
>>
>> I'm interested on it, and also Mikael.
>>
>> IMHO, after testing it and applying a few other patches that Mikael might
>> have,
>> it is time for us to rename the version to 1.10 and do a tvtime release.
>>
>> Would that work for you?
>>
>> Thank you!
>> Mauro
>
> Hi Mauro,
>
> It's good to hear that patches are continuing to be merged, and of
> course contributors are always welcome.
>
> The more I think about this, the more I recognize that I'm not really
> adding any value to this process.  While I would really like to put
> more time/energy into tvtime, I just don't have the time and it
> appears I'm actually slowing down a community of contributors who are
> trying to move things forward.
>
> At this point I would recommend the LinuxTV community just take over
> the project, give yourself write access to the main repo, and spin a
> release.  I would indeed recommend calling it 1.10, to prevent
> confusion with the various vendor branches where I believe some of
> which may actually already be calling themselves 1.03.

Ok, I've added myself into it.

I've just pushed everything into:
	http://git.linuxtv.org/tvtime.git

For now, it is showing as version 1.0.4. I'll rename it to 1.1.0 after getting
some feedback and maybe some additional fixes, and add an announcement about
that when we'll be there.

I tested it yesterday, and it seems to be working properly. Mikael patches
were putting it on a borderless mode, with looked weird on my eyes ;)
So, I added a new parameter (-L) to allow selecting the borderless mode
for those that prefer that way. The default is to have borders.

> Regarding expanding the list of individuals with commit rights, I
> might suggest keeping the list of write privileges for the main repo
> to a minimum in the short term (starting with yourself), until
> developers have demonstrated their ability to author coherent patches
> which won't cause breakage as well as the ability to review the work
> of others.

Maybe Hans de Goede would also like to get his hands on it, as he wrote
a few patches for it on Fedora.

Thanks,
Mauro
