Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36945 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0INPZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 11:25:38 -0400
Received: by iwn5 with SMTP id 5so6167080iwn.19
        for <linux-media@vger.kernel.org>; Tue, 14 Sep 2010 08:25:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=QujvRkdSLBMm14ZpOy2GCk8Ow3d87FAAz6GGY@mail.gmail.com>
References: <1274978356-25836-1-git-send-email-david@identd.dyndns.org>
	<AANLkTi=QujvRkdSLBMm14ZpOy2GCk8Ow3d87FAAz6GGY@mail.gmail.com>
Date: Tue, 14 Sep 2010 12:25:37 -0300
Message-ID: <AANLkTikHxgTrBq9+8Gm8eTNzXoWA0Br44dQx0eif91q4@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 0/8] dsbr100: driver cleanup and fixes
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	dougsland@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi David,

On Tue, Sep 14, 2010 at 11:56 AM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> Alexey,
>
> Can you review/test this patch series? Patches 2/8, 3/8, and 5/8 are
> bug fixes the rest are mainly cleanups. Patch 2/8 should fix a crash
> in the normal case if the device is disconnected while not in use.

I will also check your patches soon. I have this old hardware at home.

Cheers
Douglas
