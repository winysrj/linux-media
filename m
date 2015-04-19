Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33578 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbbDSIz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2015 04:55:58 -0400
Received: by oica37 with SMTP id a37so101535067oic.0
        for <linux-media@vger.kernel.org>; Sun, 19 Apr 2015 01:55:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55336719.5000301@xs4all.nl>
References: <CAM_ZknVRzewY23-ZGJrZxEmLa2k6DXyxb1pH-1dJ9tLV7VZ03w@mail.gmail.com>
	<55336719.5000301@xs4all.nl>
Date: Sun, 19 Apr 2015 11:55:57 +0300
Message-ID: <CAM_ZknUvD0=VSMvX-W1fh7MG5Mmj30dTkowER4UVM+RNMqr-Yw@mail.gmail.com>
Subject: Re: On register r/w macros/procedures of drivers/media/pci
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hans.verkuil" <hans.verkuil@cisco.com>, khalasa <khalasa@piap.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 19, 2015 at 11:28 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Check the types of llmio and bbmio:
>
>         u32                     __iomem *lmmio;
>         u8                      __iomem *bmmio;
>
> So the values of the pointers are the same, but the types are not.
>
> So 'lmmio + 1' == 'bmmio + sizeof(u32)' == 'bbmio + 4'.
>
> Since all the registers are defined as byte offsets relative to the start
> of the memory map you cannot just do 'lmmio + reg' since that would be a
> factor 4 off. Instead you have to divide by 4 to get it back in line.
>
> Frankly, I don't think lmmio is necessary at all since readl/writel don't
> need a u32 pointer at all since they use void pointers. I never noticed
> that when I cleaned up the tw68 driver. Using 'void __iomem *mmio' instead
> of lmmio/bmmio and dropping the shifts in the tw_ macros would work just
> as well.

>
> Hope this helps,

Oh, indeed, I have forgot this basic thing of pointer arithmetics.
Thanks a lot for elaboration and the proposed solution.

-- 
Bluecherry developer.
