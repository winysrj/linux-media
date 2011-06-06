Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48488 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab1FFRWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:22:24 -0400
Received: by ewy4 with SMTP id 4so1436789ewy.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 10:22:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DED0BAC.6090400@anevia.com>
References: <4DE65C6D.2060806@anevia.com>
	<BANLkTi=zUfg9hAN8X9nrPEOMgtUzsKrbOw@mail.gmail.com>
	<4DED0412.4030708@anevia.com>
	<BANLkTint7wHxBxc7ZQB4UohJD-7UE09mAQ@mail.gmail.com>
	<4DED0BAC.6090400@anevia.com>
Date: Mon, 6 Jun 2011 13:22:23 -0400
Message-ID: <BANLkTi=UB1nQ_ooEhNd25gv5tD7AbW5prg@mail.gmail.com>
Subject: Re: HVR-1300 analog inputs
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Florent Audebert <florent.audebert@anevia.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 6, 2011 at 1:17 PM, Florent Audebert
<florent.audebert@anevia.com> wrote:
> That's right. RAW output seems clean so far in all cases.
>
>  - When selecting composite input, MPEG encoder output is clean
>  - When selecting s-video input, MPEG encoder output have lines

Oh, that is interesting.  If I had to bet, I would think perhaps
enabling the MPEG encoder is causing a reset of the decoder's register
state, and the defaults are probably appropriate for CVBS input (in
terms of things like the clamp control, comb filter configuration,
etc).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
