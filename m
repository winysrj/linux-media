Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37648 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab2JALvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 07:51:08 -0400
Message-ID: <50698393.3080908@iki.fi>
Date: Mon, 01 Oct 2012 14:50:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [GIT PATCHES FOR v3.6] Samsung media driver fixes
References: <5034991F.5040403@samsung.com> <506967F1.7040308@samsung.com>
In-Reply-To: <506967F1.7040308@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I have had similar problems too. We need badly find out better 
procedures for patch handling. Something like parches are updated about 
once per week to the master. I have found I lose quite much time 
rebasing and res-sending stuff all the time.

What I propose:
1) module maintainers sends all patches to the ML with some tag marking 
it will pull requested later. I used lately [PATCH RFC]
2) module maintainer will pick up all the "random" patches and pull 
request those. There is no way to mark patch as handled in patchwork....
3) PULL request are handled more often, like during one week or maximum two

regards
Antti


On 10/01/2012 12:52 PM, Sylwester Nawrocki wrote:
> Hi Mauro,
>
> On 08/22/2012 10:32 AM, Sylwester Nawrocki wrote:
>
> It's been almost 6 weeks since I sent this pull request, now Linus
> released 3.6 kernel and this series is not included there. Moreover,
> I have been waiting with all patches for 3.7 until those get merged.
> Now it seems even too late for all these 3.7 patches. I cannot say
> I'm very happy about this situation. It's rather disappointing it
> takes so long for -rc patches to make it upstream, especially that
> not all of them are supposed to be allowed during late -rc periods.
> I wouldn't bother writing this email but AFAIR it's not the first
> time my -rc patches got missed.
>
> Is there anything I could do to improve this situation ?
>
> Regards,
> Sylwester
>
>> Hi Mauro,
>>
>> The following changes since commit f9cd49033b349b8be3bb1f01b39eed837853d880:
>>
>>    Merge tag 'v3.6-rc1' into staging/for_v3.6 (2012-08-03 22:41:33 -0300)
>>
>> are available in the git repository at:
>>
>>
>>    git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes
>>
>> for you to fetch changes up to 0e59db054e30658c6955d6e27b0a252cef9bfafc:
>>
>>    s5p-mfc: Fix second memory bank alignment (2012-08-16 19:12:19 +0200)
>>
>> ----------------------------------------------------------------
>> Kamil Debski (1):
>>        s5p-mfc: Fix second memory bank alignment
>>
>> Sylwester Nawrocki (7):
>>        s5p-fimc: Enable FIMC-LITE driver only for SOC_EXYNOS4x12
>>        s5p-fimc: Don't allocate fimc-lite video device structure dynamically
>>        s5p-fimc: Don't allocate fimc-capture video device dynamically
>>        s5p-fimc: Don't allocate fimc-m2m video device dynamically
>>        m5mols: Add missing free_irq() on error path
>>        m5mols: Fix cast warnings from m5mols_[set/get]_ctrl_mode
>>        s5p-fimc: Fix setup of initial links to FIMC entities
>>
>>   drivers/media/video/m5mols/m5mols.h          |  4 +--
>>   drivers/media/video/m5mols/m5mols_controls.c |  4 +--
>>   drivers/media/video/m5mols/m5mols_core.c     |  4 ++-
>>   drivers/media/video/s5p-fimc/Kconfig         |  2 +-
>>   drivers/media/video/s5p-fimc/fimc-capture.c  | 31 +++++++-----------
>>   drivers/media/video/s5p-fimc/fimc-core.h     |  4 +--
>>   drivers/media/video/s5p-fimc/fimc-lite-reg.c |  2 +-
>>   drivers/media/video/s5p-fimc/fimc-lite.c     | 42 ++++++++++---------------
>>   drivers/media/video/s5p-fimc/fimc-lite.h     |  2 +-
>>   drivers/media/video/s5p-fimc/fimc-m2m.c      | 40 ++++++++---------------
>>   drivers/media/video/s5p-fimc/fimc-mdevice.c  |  9 ++++--
>>   drivers/media/video/s5p-fimc/fimc-mdevice.h  |  6 ++--
>>   drivers/media/video/s5p-fimc/fimc-reg.c      |  6 ++--
>>   drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  2 +-
>>   14 files changed, 65 insertions(+), 93 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
