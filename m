Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:48090 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1JOUyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:54:18 -0400
Message-ID: <4E99F2F6.9000307@poczta.onet.pl>
Date: Sat, 15 Oct 2011 22:54:14 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 0/7] Staging submission: PCTV 74e drivers and some cleanup
 (was: Staging submission: PCTV 80e and PCTV 74e drivers)
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein>
In-Reply-To: <20110927213300.6893677a@stein>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[PATCH 1/7] pull as102 driver fromhttp://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
with the only change needed to compile it in git tree[1]: usb_buffer_alloc()
to usb_alloc_coherent() and usb_buffer_free() to usb_free_coherent()

[PATCH 2/7] as102: add new device nBox DVB-T Dongle
adds new device working on this driver


Next patches i made basing on Mauro Carvalho Chehab comments from previous pull try [2].

[PATCH 3/7] as102: cleanup - get rid off typedefs
[PATCH 4/7] as102: cleanup - formatting code
[PATCH 5/7] as102: cleanup - set __attribute__(packed) instead of pragma(pack)
[PATCH 6/7] as102: cleanup - delete vim comments
[PATCH 7/7] as102: cleanup - get rid of unnecessary defines (WIN32, LINUX)


[1] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git kernel-3.1.0-git9+
[2] http://www.spinics.net/lists/linux-media/msg16723.html



W dniu 27.09.2011 21:33, Stefan Richter pisze:
> On Sep 27 Greg KH wrote:
>> On Tue, Sep 27, 2011 at 09:44:09AM +0200, Stefan Richter wrote:
>>> Adding Cc: staging maintainer and mailinglist.
>>>
>>> On Sep 26 Devin Heitmueller wrote:
>>>> On Sun, Sep 25, 2011 at 11:25 PM, Mauro Carvalho Chehab
>>>> <maurochehab@gmail.com>  wrote:
>>>>> In summary, if you don't have a couple hours to make your driver to
>>>>> match Kernel Coding Style, just send it as is to /drivers/staging, c/c
>>>>> me and Greg KH, and that's it.
>>>> PULLhttp://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/
>>>> PULLhttp://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
>> I can't do that as I need some commit messages in a format we can accept
>> (i.e. your directory structure doesn't match what we need in the kernel
>> tree from what I can tell.)
> [...]
>> As the drivers don't seem to be touched in way over a year, odds are the
>> code isn't going to be able to build as-is, so it will require some
>> changes for basic issues.
>>
>> And I'll glady accept patches for the staging tree.  Also note that
>> we've just created a drivers/staging/media/ tree to house lots of
>> different v4l drivers that are being worked on in the staging tree to
>> help coordinate this type of work better.
> The conversion into patches with proper changelog, fitting directory
> structure, and basic build-ability in current staging is exactly
> the first step for which a volunteer is sought (next would then be the
> cleanup associated with staging->mainline transition); Devin noted that he
> is not going to dedicate time for these types of tasks.  (I for one also
> won't; still got plenty to do in some other drivers...)
