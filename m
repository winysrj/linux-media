Return-path: <mchehab@gaivota>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57539 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0KDCbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 22:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <4CD1E232.30406@redhat.com>
References: <20101009224041.GA901@sepie.suse.cz>
	<4CD1E232.30406@redhat.com>
Date: Wed, 3 Nov 2010 22:31:42 -0400
Message-ID: <AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	kyle@redhat.com, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On Wed, Nov 3, 2010 at 6:29 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 09-10-2010 18:40, Michal Marek escreveu:
>>
>> Arnaud Lacombe (1):
>>       kconfig: delay symbol direct dependency initialization
>
> This patch generated a regression with V4L build. After applying it,
> some Kconfig dependencies that used to work with V4L Kconfig broke.
>
of course, but they were all-likely buggy. If a compiler version N
outputs a new legitimate warning because of a bug in the code, you do
not switch back to the previous version because the warning wasn't
there, you fix the code.

That said, please point me to a false positive, eventually with a
minimal testcase, and I'll be happy to fix the issue.

 - Arnaud

> Basically, we have things there like:
>
> config VIDEO_HELPER_CHIPS_AUTO
>        bool "Autoselect pertinent encoders/decoders and other helper chips"
>
> config VIDEO_IVTV
>        select VIDEO_WM8739 if VIDEO_HELPER_CHIPS_AUTO
>
> menu "Encoders/decoders and other helper chips"
>        depends on !VIDEO_HELPER_CHIPS_AUTO
>
> config VIDEO_WM8739
>        tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
>
this is broken.
