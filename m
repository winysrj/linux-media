Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:9672 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZAYP0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 10:26:53 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3185690fgg.17
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2009 07:26:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090124203726.GA9808@blorp.plorb.com>
References: <463244.61379.qm@web45416.mail.sp1.yahoo.com>
	 <20090124203726.GA9808@blorp.plorb.com>
Date: Sun, 25 Jan 2009 10:26:51 -0500
Message-ID: <37219a840901250726q7f385702uf33c07ac5b09647d@mail.gmail.com>
Subject: Re: [linux-dvb] HVR-1800 Support
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org, killero_24@yahoo.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 24, 2009 at 3:37 PM, Jeff DeFouw <jeffd@i2k.com> wrote:
> On Tue, Jan 20, 2009 at 10:08:51PM -0800, Killero SS wrote:
>> i'm using ubuntu 8.10 2.6.27-9-generic
>> and tried compiling latest modules with hg-clone but my analog capture got broken, firmware error...
>> so i got back to original kernel modules
>> however, some people claim they get audio with analog on /dev/video1
>> this has never be my case, im using svideo signal so wondering if that may be it.
>> i get analog video on video0 and video1, but some colors look pretty weird, red for example.
>
> The driver in the kernel and hg does not set up the registers properly
> for the video or audio in S-Video mode.  I made some changes to get mine
> working.  I can probably make a patch for you if you can get your source
> build working.

Why not sign it off and send it in to the list, to be merged into the
official sources?

Surely if there is a bug or missing feature that you've fixed, it
should be merged into the repository so that everybody else can
benefit from it.

-Mike
