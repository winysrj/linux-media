Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:36212 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab2AYFgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 00:36:12 -0500
Received: by mail-tul01m020-f181.google.com with SMTP id up10so6092161obb.26
        for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 21:36:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1D7BF4.4040603@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com>
 <4F1D6D3E.7020203@redhat.com> <4F1D6F68.5040202@samsung.com>
 <4F1D7418.50201@redhat.com> <4F1D7BF4.4040603@samsung.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Wed, 25 Jan 2012 11:05:50 +0530
Message-ID: <CAB2ybb8fXUARSriD2x-4TNLVtxpg5hA6NKjrAOOwzHJ0Cko6Ag@mail.gmail.com>
Subject: Re: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,
On Mon, Jan 23, 2012 at 8:55 PM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> Hi Mauro,
>
>
<snip>
>
> Ok. I should have given more details about the patch. I am sorry for missing
> it. My kernel tree failed to compile after applying patches from
>
> [1]
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
>
> I had to generate this patch to compile the code and test it. Most of the
> fixes refer to Sumit's code and I think he will take care of those bugs.
Is your kernel tree a mainline kernel? I am pretty sure I posted out
the RFC after compile testing.

>
<snip>
>
>
> I wanted to post the complete set of patches that produce compilable kernel.
> Therefore most important bugs/issues had to be fixed and attached to the
> patchset. Some of the issues in [1] were mentioned by Laurent and Sakari. I
> hope Sumit will take care of those problems.
I must've misunderstood when you said 'I would like to take care of
these patches'. Please let me know if you'd like me to submit next
version of my RFC separately with fixes for these issues, or would you
manage that as part of your RFC patch series submission.
>
>>
>> Failing to do that will mean that important fixes for upstream
>> will be missed.
>
>
> Ok. It will be fixed.
>
>>
>> Regards,
>> Mauro
>>
>
> Regards,
> Tomasz Stanislawski
>
Best regards,
~Sumit.
