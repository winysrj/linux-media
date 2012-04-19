Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56130 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab2DSOkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 10:40:10 -0400
Received: by qcro28 with SMTP id o28so5239590qcr.19
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2012 07:40:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F9014CD.1040005@redhat.com>
References: <CAOcJUbxHCo7xfGHJZdeEgReJrpCriweSb9s9+-_NfSODLz_NPQ@mail.gmail.com>
	<4F9014CD.1040005@redhat.com>
Date: Thu, 19 Apr 2012 10:40:09 -0400
Message-ID: <CAHAyoxyhHx8nXhPT0iuKZhcM=bTEaSM=rXfs5P92JXsuOLciCw@mail.gmail.com>
Subject: Re: ATSC-MH driver support for the Hauppauge WinTV Aero-m
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 19, 2012 at 9:36 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 10-04-2012 00:49, Michael Krufky escreveu:
>> These patches have been around and tested for quite some time.  Every
>> few weeks I have to regenerate them in order to stay in sync with the
>> media tree.  I think it's time for some review and possibly merge into
>> the master development repository.  This complies with what was
>> discussed in at the media developer kernel summit in Prague, Oct 2011.
>>  Once merged, I'll have time to work on some userspace utilities.  For
>> now, I have created a very basic ATSC-MH scanning application that
>> demonstrates the API additions.  The app can be found here:
>> http://linuxtv.org/hg/~mkrufky/mhscan
>>
>> Please review:
>>
>> The following changes since commit 296da3cd14db9eb5606924962b2956c9c656dbb0:
>>
>>   [media] pwc: poll(): Check that the device has not beem claimed for
>> streaming already (2012-03-27 11:42:04 -0300)
>>
>> are available in the git repository at:
>>   git://git.linuxtv.org/mkrufky/mxl111sf mh_for_v3.5
>>
>> Michael Krufky (8):
>>       linux-dvb v5 API support for ATSC-MH
>
> This patch is incomplete:
>        - It doesn't increment the version number;
>        - Docbook is untouched.
>
> Also, I didn't see any post of those patches at the ML. Please post the
> patches at the ML for review before sending a pull request, especially
> when API changes are there.

Mauro,

Thanks for the feedback.  I'll make the Docbook changes, then I'll
patchbomb the mailing list (it's just a handful of patches for the API
change) and follow it up with another pull request.

Cheers,

Mike
