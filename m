Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab2GaKJ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 06:09:58 -0400
Message-ID: <5017AEE0.2070603@redhat.com>
Date: Tue, 31 Jul 2012 07:09:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mariusz Bialonczyk <manio@skyboo.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Wojciech Myrda <vojcek@tlen.pl>
Subject: Re: [PATCH] Add support for Prof Revolution DVB-S2 8000 PCI-E card
References: <1343326123-11882-1-git-send-email-manio@skyboo.net> <50174C3A.1070407@redhat.com> <5017983B.9080104@skyboo.net>
In-Reply-To: <5017983B.9080104@skyboo.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-07-2012 05:32, Mariusz Bialonczyk escreveu:
> On 07/31/2012 05:08 AM, Mauro Carvalho Chehab wrote:
>> Em 26-07-2012 15:08, Mariusz Bialonczyk escreveu:
>>> The device is based on STV0903 demodulator, STB6100 tuner
>>> and CX23885 chipset; subsystem id: 8000:3034
>>>
>>> Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
>>
>> This is the second time I see this patch. It seems very similar to the
>> one sent by Wojciech. So, who is the author of this patch?
> Hi!
> Wojciech Myrda's patch was based on original producer patch from here:
> http://www.proftuners.com/sites/default/files/prof8000_0.patch

Hmm... it seems that the original producer worked for the manufacturers
of this board, as the patch is posted there...

An ack from them to allow adding it at Kernel seems to be required.
> 
>  From my diagnose (diff original and his patch) he rebased it to take
> into account later kernel sources.
> 
> You ask him to post it again with Signed-off-by line, but he doesn't
> respond for over a year (at least to linux media mailing list).
> 
> My patch uses stv090x frontend instead and I assumed that I can
> ommit additional signed-off-by lines in this case.

Rebased patches should be mentioning their origin. In a matter of
fact, you need to add a "From:" field at the beginning of the body of
the email, with the original author there, even without his SOB (Signed-off-by).

It should be noticed that SOB means:

        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.

So, in the case of a patch made by someone else who didn't sign, the SOB means:

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file;

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.


> 
> If it is not ok, please tell me and I will prepare second patch
> with additional Signed-off-by lines.
> 
> regards!
> 

Regards,
Mauro
