Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36470 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab1CUUb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 16:31:57 -0400
Received: by wwa36 with SMTP id 36so7942835wwa.1
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 13:31:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110321131602.36d146b1.rdunlap@xenotime.net>
References: <4D87AB0F.4040908@t-online.de>
	<20110321131602.36d146b1.rdunlap@xenotime.net>
Date: Tue, 22 Mar 2011 02:01:56 +0530
Message-ID: <AANLkTik22=YE-2W4AtO9w_kVm=oro_YM7hJ52Rj83Fmt@mail.gmail.com>
Subject: Re: S2-3200 switching-timeouts on 2.6.38
From: Manu Abraham <abraham.manu@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Rico Tzschichholz <ricotz@t-online.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 22, 2011 at 1:46 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Mon, 21 Mar 2011 20:46:23 +0100 Rico Tzschichholz wrote:
>
>> Hello,
>>
>> I would like to know if there is any intention to include this patch
>> soon? https://patchwork.kernel.org/patch/244201/
>
> There are MANY posted but unmerged patches in patchwork from the linux-media
> mailing list.  What is going on (or not going on) with patch merging?

Actually, quite a lot of effort was put in to get that part right. It
does the reverse thing that's to be done.
The revamped version is here [1] If the issue persists still, then it
needs to be investigated further.

[1] http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09214.html


Best Regards,
Manu
