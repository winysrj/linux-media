Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53610 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1LBTpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2011 14:45:25 -0500
Received: by ywa9 with SMTP id 9so3099177ywa.19
        for <linux-media@vger.kernel.org>; Fri, 02 Dec 2011 11:45:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED929E7.2050808@gmail.com>
References: <4ED929E7.2050808@gmail.com>
Date: Fri, 2 Dec 2011 14:45:24 -0500
Message-ID: <CAGoCfizgkfHJ-0YwcdTEQEhci=7eE7BTuSOj8KmMpLRhc4oqGg@mail.gmail.com>
Subject: Re: Hauppauge HVR-930C problems
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 2, 2011 at 2:41 PM, Fredrik Lingvall
<fredrik.lingvall@gmail.com> wrote:
> The HVR 930C device has three connectors/inputs:  an antenna input, an
> S-video, and a composite video, respectively,
>
> The provider I have here in Norway (Get) has both analog tv and digital
> (DVB-C) so can I get analog tv using the antenna input or is analog only on
> the S-video/composite inputs? And, how do I select which analog input that
>  is used?

The analog support for that device isn't currently supported (due to a
lack of a Linux driver for the analog demodulator).  The digital
should work fine though (and if not, bring it to Mauro's attention
since he has been actively working on it).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
