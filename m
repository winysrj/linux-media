Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:33050 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbbFHPbe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 11:31:34 -0400
Received: by qcnj1 with SMTP id j1so25825993qcn.0
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2015 08:31:33 -0700 (PDT)
Message-ID: <5575B48F.5070208@vanguardiasur.com.ar>
Date: Mon, 08 Jun 2015 12:28:15 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: dale.hamel@srvthe.net, michael@stegemann.it
Subject: Re: [PATCH v2 0/2] stk1160: Frame scaling and "de-verbosification"
References: <1433629618-1833-1-git-send-email-ezequiel@vanguardiasur.com.ar> <5575682E.3000209@xs4all.nl>
In-Reply-To: <5575682E.3000209@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/08/2015 07:02 AM, Hans Verkuil wrote:
> Hi Ezequiel,
> 
> On 06/07/2015 12:26 AM, Ezequiel Garcia wrote:
>> I've removed the driver verbosity and fixed the frame scale implementation.
>> In addition to the usual mplayer/vlc/qv4l2, it's tested with v4l2-compliance
>> on 4.1-rc4.
> 
> I recommend you use the media_tree.git master branch: v4l2-compliance is always
> in sync with that one.
> 
> I'm not getting the issues you show below with v4l2-compliance -s (although once
> it starts streaming I get sequence errors, see the patch I posted that fixes that).
> 
> So use the media_tree master branch and use the latest v4l2-compliance. If you still
> get the error you see below, then that needs to be investigated further, since I
> don't see it.
> 
> However, testing with v4l2-compliance -f (which tests scaling) just stalls:
> 
> Test input 0:
> 
> Stream using all formats:
>         test MMAP for Format UYVY, Frame Size 6x4:
> 
> It sits there until I press Ctrl-C.
> 
> This is NTSC input, BTW.
> 

Ouch, sorry about that. I'll re-run with latest v4l2-compliance.

You've marked the "stk1160: Reduce driver verbosity" also as
changes-requested. Do you want any changes on it? I don't think that
patch can introduce any issues, since it's just fixing the level of printks.

-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
