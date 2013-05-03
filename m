Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3ECMIZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 May 2013 08:08:25 -0400
Message-ID: <5183A8B0.3040301@redhat.com>
Date: Fri, 03 May 2013 09:08:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	=?UTF-8?B?Sm9uIA==?= =?UTF-8?B?QXJuZSBKw7hyZ2Vuc2Vu?=
	<jonarne@jonarne.no>
CC: linux-media@vger.kernel.org, jonjon.arnearne@gmail.com
Subject: Re: [PATCH V2 1/3] saa7115: move the autodetection code out of the
 probe function
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no> <1367268069-11429-2-git-send-email-jonarne@jonarne.no> <20130503020913.GB5722@localhost> <20130503065846.GD1232@dell.arpanet.local> <20130503112052.GB2291@localhost>
In-Reply-To: <20130503112052.GB2291@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-05-2013 08:20, Ezequiel Garcia escreveu:
> Hi Jon,
>
> On Fri, May 03, 2013 at 08:58:46AM +0200, Jon Arne Jørgensen wrote:
> [...]
>>> You can read more about this in Documentation/SubmittingPatches.
>>
>> I just re-read SubmittingPatches.
>> I couldn't see that there is anything wrong with multiple sign-off's.
>>
>
> Indeed there isn't anything wrong with multiple SOBs tags, but they're
> used a bit differently than this.
>
>> Quote:
>>    The Signed-off-by: tag indicates that the signer was involved in the
>>    development of the patch, or that he/she was in the patch's delivery
>>    path.
>>
>>
>
> Ah, I see your point.
>
> @Mauro, perhaps you can explain this better then me?

The SOB is used mainly to describe the patch flow. Each one that touched
on a patch attests that:

        "Developer's Certificate of Origin 1.1

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
	    this project or the open source license(s) involved."

In other words, it tracks the custody chain, with is typically one of
the alternatives below[1]:

	Author -> maintainer's tree -> upstream
	Author -> sub-maintainer's tree -> maintainer's tree -> upstream
	Author -> driver's maintainer -> maintainer's tree -> upstream
	Author -> driver's maintainer -> sub-maintainer's tree -> maintainer's tree -> upstream\

In this specific case, as patches 1 and 2 are identical to the ones I submitted,
the right way would be for you both to just reply to my original e-mail with
your tested-by or reviewed-by. That patches will then be applied (either directly
or via Hverkuil's tree, as he is the sub-maintainer for those I2C drivers).

I hope that helps to clarify it.

Regards,
Mauro

[1] when the driver is developed/patched internally on some company's trees,
it is possible to have there also the SOBs for that company's internal
maintainers.

There are also some other corner cases, like patches that are sent in
non-public mailing lists or in private, where everybody in the custody
chain sign it.
