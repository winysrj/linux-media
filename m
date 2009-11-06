Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58443 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZKFCno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 21:43:44 -0500
Received: by bwz27 with SMTP id 27so713488bwz.21
        for <linux-media@vger.kernel.org>; Thu, 05 Nov 2009 18:43:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <40380.64.213.30.2.1257474692.squirrel@webmail.exetel.com.au>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
	 <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
	 <829197380911050602t30bc69d0sd0b269c39bf759e@mail.gmail.com>
	 <702870ef0911051257k52c142e8ne1b32506f1efb45c@mail.gmail.com>
	 <829197380911051304g1544e277s870f869be14e1a18@mail.gmail.com>
	 <25126.64.213.30.2.1257464759.squirrel@webmail.exetel.com.au>
	 <829197380911051551q3b844c5ek490a5eb7c96783e9@mail.gmail.com>
	 <39786.64.213.30.2.1257466403.squirrel@webmail.exetel.com.au>
	 <40380.64.213.30.2.1257474692.squirrel@webmail.exetel.com.au>
Date: Thu, 5 Nov 2009 21:43:47 -0500
Message-ID: <829197380911051843r4a55bddcje8c014f5548ca247@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Lowery <rglowery@exemail.com.au>
Cc: Vincent McIntyre <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 5, 2009 at 9:31 PM, Robert Lowery <rglowery@exemail.com.au> wrote:
> Devin,
>
> I have confirmed the patch below fixes my issue.  Could you please merge
> it for me?
>
> Thanks
>
> -Rob

Sure.  I'm putting together a patch series for this weekend with a few
different misc fixes.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
