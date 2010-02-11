Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33894 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab0BKTVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 14:21:55 -0500
Received: by bwz19 with SMTP id 19so791419bwz.28
        for <linux-media@vger.kernel.org>; Thu, 11 Feb 2010 11:21:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B745781.2020408@mailbox.hu>
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu>
	 <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu>
	 <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>
	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>
Date: Thu, 11 Feb 2010 14:21:54 -0500
Message-ID: <829197381002111121g5244471bj148d38aa8958800c@mail.gmail.com>
Subject: Re: DTV2000 H Plus issues
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Istanv,

On Thu, Feb 11, 2010 at 2:16 PM, istvan_v@mailbox.hu
<istvan_v@mailbox.hu> wrote:
> Update: the following patch, which should be applied after the previous
> ones, makes a few additional changes to the XC4000 driver:
>  - adds support for DTV7
>  - implements power management
>  - adds a mutex and locking for tuner operations
>  - some unused or unneeded code has been removed

Is the DTV7 support actually tested?  Or are you just blindly adding
the code in the hope that it works?  I'm just asking because the last
time I spoke to you, you actually didn't have access to a DVB-T signal
source.

Also, I'm not sure I'm comfortable with the way the mutex is
implemented here.  Is this logic copied from some other driver (and if
so, which one), or did you come up with it yourself?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
