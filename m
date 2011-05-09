Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:59168 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1EIKMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 06:12:12 -0400
Message-ID: <4DC7BDF7.1020706@linuxtv.org>
Date: Mon, 09 May 2011 12:12:07 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Thierry LELEGARD <tlelegard@logiways.com>
Subject: Re: [PATCH 2/8] DVB: dtv_property_cache_submit shouldn't modifiy
 the cache
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org> <1304895821-21642-3-git-send-email-obi@linuxtv.org> <4DC7665E.5000202@redhat.com> <4DC769A6.1090100@redhat.com>
In-Reply-To: <4DC769A6.1090100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/09/2011 06:12 AM, Mauro Carvalho Chehab wrote:
> Em 09-05-2011 05:58, Mauro Carvalho Chehab escreveu:
>> Em 09-05-2011 01:03, Andreas Oberritter escreveu:
>>> - Use const pointers and remove assignments.
>>
>> That's OK.
>>
>>> - delivery_system already gets assigned by DTV_DELIVERY_SYSTEM
>>>   and dtv_property_cache_sync.
>>
>> The logic for those legacy params is too complex. It is easy that
>> a latter patch to break the implicit set via dtv_property_cache_sync().
>>
>> Do you actually see a bug caused by the extra set for the delivery system?
>> If not, I prefer to keep this extra re-assignment.

No, but I was suprised to see the dtv_frontend_properties getting
modified in this function. There are three functions converting between
old and new structures:

dtv_property_cache_sync:
  converts from dvb_frontend_parameters to dtv_frontend_properties

dtv_property_legacy_params_sync and dtv_property_adv_params_sync:
  convert from dtv_frontend_properties to dvb_frontend_parameters

Assigning to fields of a source structure indicates a logical error. I
haven't found any comment on why this should be needed in the Git
history or in the mailing list archives.

Btw., I think that two functions should be enough. Any reason for not
merging dtv_property_adv_params_sync into
dtv_property_legacy_params_sync and calling the latter unconditionally?

> Hmm... after applying all patches the logic change, and patch 2 may actually
> make sense. I'll need to re-examine the patch series. 
> 
> On a quick look, if applied as-is, I suspect that git bisect
> will break dvb in the middle of the patch series.

Patches 6 and 8 depend on the patches mentioned in the cover letter. All
other patches should apply and compile cleanly. Which patch do you
suspect to break bisectability?

> Anyway, patch 1/8 is OK. For now, I'll apply only this patch. I'll delay the
> others until I have more time. I'm currently traveling abroad, due to Linaro
> Development Summit, so, I don't have much time for review (and I'm also suffering
> for a 5 hours jet-leg).

OK, there's no hurry.

Regards,
Andreas
