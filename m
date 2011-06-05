Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab1FEM4R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jun 2011 08:56:17 -0400
Message-ID: <4DEB7CEC.9090305@redhat.com>
Date: Sun, 05 Jun 2011 09:56:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Istvan Varga <istvan_v@mailbox.hu>
CC: linux-media@vger.kernel.org
Subject: Re: XC4000: setting registers
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com> <4DEA4B6A.70602@mailbox.hu> <4DEB710B.4090704@redhat.com> <4DEB766D.4040509@mailbox.hu>
In-Reply-To: <4DEB766D.4040509@mailbox.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-06-2011 09:28, Istvan Varga escreveu:
> On 06/05/2011 02:05 PM, Mauro Carvalho Chehab wrote:
> 
>> This one breaks compilation:
>>
>> drivers/media/common/tuners/xc4000.c: In function
> ‘xc4000_set_analog_params’:
>> drivers/media/common/tuners/xc4000.c:1340: error: ‘type’ undeclared
> (first use in this function)
>> drivers/media/common/tuners/xc4000.c:1340: error: (Each undeclared
> identifier is reported only once
>> drivers/media/common/tuners/xc4000.c:1340: error: for each function it
> appears in.)
>> make[3]: ** [drivers/media/common/tuners/xc4000.o] Erro 1
>> make[2]: ** [drivers/media/common/tuners] Erro 2
>> make[1]: ** [drivers/media/common] Erro 2
>> make: ** [drivers/media/] Erro 2
> 
> Yes, it depends on the 'unsigned int type = 0;' declaration that is in
> the xc4000_analog.patch posted later. Sorry for this mistake. Although
> perhaps it would have been a better idea to make all the changes to
> xc4000_set_analog_params() in the analog patch as well, since the
> function does not work correctly until that is applied.

Ok.

It is a good idea to number a series of patches, for me to apply them
at the right order ;)
> 
>> I didn't made any review of them. Please let me know when you finish
>> submitting the patches for me to do a review at the resulting code.
> 
> For now, I do not have more patches. I will wait for the modified code
> to appear on GIT, and use that as a base for further patches.

Ok, just pushed it (I forgot to use the -f tag). Please double check
if the code is working on the devices you have.

>> Ah, I'd appreciate if you could fix your emails. It takes me some
>> time to reformat the patches, as you're sending the patches as
>> attachments, but my email scripts aren't ready for patches with
>> multiple mime types. Patchwork might help, but it also got only 4
>> patches from you (not sure if this is due to patchwork bugs or due to
>> the attachments). It also helps if you could add [PATCH] at the email
>> subject. I'm setting a backup process due to the constant patchwork
>> failures, but my alternative logic relies on having [PATCH] at the
>> subject logic, to move the patches into a separate mail directory.
> 
> OK, I have changed the name in "from", and will send any later patches
> as plain text with [PATCH] in the subject. Should I re-send the previous
> patches in this format ?

No, there's no need. I'll get a diff from all those x4000 series any post
a review about the entire series, as if it were just one big patch.

Cheers,
Mauro
