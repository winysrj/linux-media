Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37167 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab1LBMtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2011 07:49:04 -0500
Received: by iage36 with SMTP id e36so4143059iag.19
        for <linux-media@vger.kernel.org>; Fri, 02 Dec 2011 04:49:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <752PLBJIM6528S04.1322818538@web04.cms.usa.net>
References: <752PLBJIM6528S04.1322818538@web04.cms.usa.net>
From: Felipe Magno de Almeida <felipe.m.almeida@gmail.com>
Date: Fri, 2 Dec 2011 10:48:41 -0200
Message-ID: <CADfx-VREsXU=p9m0cA4Sus3tEHwvBcx5tC7cwWHyd6uh2ewdeA@mail.gmail.com>
Subject: Re: LinuxTV ported to Windows
To: Issa Gorissen <flop.m@usa.net>
Cc: Abylay Ospan <aospan@netup.ru>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 2, 2011 at 7:35 AM, Issa Gorissen <flop.m@usa.net> wrote:
>> Hello,
>>
>> We have ported linuxtv's cx23885+CAM en50221+Diseq to Windows OS (Vista,
>> XP, win7 tested). Results available under GPL and can be checkout from
>> git repository:
>> https://github.com/netup/netup-dvb-s2-ci-dual
>>
>> Binary builds (ready to install) available in build directory. Currently
>> NetUP Dual DVB-S2 CI card supported (
>> http://www.netup.tv/en-EN/dual_dvb-s2-ci_card.php ).
>>
>> Driver based on Microsoft BDA standard, but some features (DiSEqC, CI)
>> supported by custom API, for more details see netup_bda_api.h file.
>>
>> Any comments, suggestions are welcome.
>>
>> --
>> Abylai Ospan<aospan@netup.ru>
>> NetUP Inc.
>
> Yes indeed, it is a pity but it seems this work is in violation of the GPL.

The GPL has specific provisions for system libraries, which would IMO,
constitute the kernel AFAIU. So it would not violate the GPL.

> --
> This General Public License does not permit incorporating your program into
> proprietary programs. If your program is a subroutine library, you may
> consider it more useful to permit linking proprietary applications with the
> library. If this is what you want to do, use the GNU Library General
> Public License instead of this License.
> --
>
> [http://www.gnu.org/philosophy/why-not-lgpl.html]
> [http://www.gnu.org/copyleft/gpl.html]
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Felipe Magno de Almeida
