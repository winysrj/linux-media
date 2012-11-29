Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64658 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2K2P3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 10:29:19 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so12214504iea.19
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 07:29:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALF0-+X0yyQEw+jJCxuQO18gDagtyX-RZW_kurMPS69RQHNPMA@mail.gmail.com>
References: <k93vu3$ffi$1@ger.gmane.org>
	<CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com>
	<50B60D54.4010302@interlinx.bc.ca>
	<CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>
	<50B69C08.7050401@interlinx.bc.ca>
	<CALF0-+X0yyQEw+jJCxuQO18gDagtyX-RZW_kurMPS69RQHNPMA@mail.gmail.com>
Date: Thu, 29 Nov 2012 12:29:18 -0300
Message-ID: <CALF0-+XStqJEiPaQjrBu74of9BYRJZS-9F6F7YzgE3LU6x+TVQ@mail.gmail.com>
Subject: Re: ivtv driver inputs randomly "block"
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Brian Murrell <brian@interlinx.bc.ca>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brian,

See my comments below.

On Wed, Nov 28, 2012 at 8:19 PM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> On 12-11-28 08:13 AM, Ezequiel Garcia wrote:
>>
>> Try again with
>> modprobe ivtv ivtv_debug=10
>
> OK.  Happened again.  The kernel log for the whole day since starting
> the module with debug this morning can be found at
> http://brian.interlinx.bc.ca/ivtv-dmesg.txt.bz2.
>
> Associated with that log there was a successful recording from 09:00:00
> until 10:00:00 then another successful recording from 14:00:00 until
> 15:00:00 and then failed recordings starting at 15:00:00 until 18:00:00.
>
> The log cuts off just short of 18:00:00 but there's nothing different
> about the pattern from the end of the log until 18:00:04 from the
> previous 3 hours or so.
>
> It seems that the problem lies in amongst the start of these lines from
> the log, as my best guess:
>
> Nov 28 15:00:05 cmurrell kernel: [868297.536049] ivtv0 encoder MPG: VIDIOC_ENCODER_CMD cmd=0, flags=0
> Nov 28 15:00:07 cmurrell kernel: [868300.039324] ivtv0:  ioctl: V4L2_ENC_CMD_STOP
> Nov 28 15:00:07 cmurrell kernel: [868300.039330] ivtv0:  info: close stopping capture
> Nov 28 15:00:07 cmurrell kernel: [868300.039334] ivtv0:  info: Stop Capture
> Nov 28 15:00:09 cmurrell kernel: [868302.140151] ivtv0 encoder MPG: VIDIOC_ENCODER_CMD cmd=1, flags=1
> Nov 28 15:00:09 cmurrell kernel: [868302.148093] ivtv0:  ioctl: V4L2_ENC_CMD_START
> Nov 28 15:00:09 cmurrell kernel: [868302.148101] ivtv0:  info: Start encoder stream encoder MPG
> Nov 28 15:00:09 cmurrell kernel: [868302.188580] ivtv0:  info: Setup VBI API header 0x0000bd03 pkts 1 buffs 4 ln 24 sz 1456
> Nov 28 15:00:09 cmurrell kernel: [868302.188655] ivtv0:  info: Setup VBI start 0x002fea04 frames 4 fpi 1
> Nov 28 15:00:09 cmurrell kernel: [868302.191952] ivtv0:  info: PGM Index at 0x00180150 with 400 elements
> Nov 28 15:00:10 cmurrell kernel: [868302.544052] ivtv0 encoder MPG: VIDIOC_ENCODER_CMD cmd=0, flags=0
> Nov 28 15:00:12 cmurrell kernel: [868305.047260] ivtv0:  ioctl: V4L2_ENC_CMD_STOP
> Nov 28 15:00:12 cmurrell kernel: [868305.047265] ivtv0:  info: close stopping capture
> Nov 28 15:00:12 cmurrell kernel: [868305.047270] ivtv0:  info: Stop Capture
> ...
>
> FWIW, the recording software here is MythTV completely up to date on the
> 0.25-fixes branch.
>
> Thoughts?
>

Mmm, the log shows this repeating pattern:

---
Nov 28 17:54:46 cmurrell kernel: [878779.229702] ivtv0:  info: Setup
VBI start 0x002fea04 frames 4 fpi 1
Nov 28 17:54:46 cmurrell kernel: [878779.233129] ivtv0:  info: PGM
Index at 0x00180150 with 400 elements
Nov 28 17:54:47 cmurrell kernel: [878779.556039] ivtv0 encoder MPG:
VIDIOC_ENCODER_CMD cmd=0, flags=0
Nov 28 17:54:49 cmurrell kernel: [878782.059204] ivtv0:  ioctl:
V4L2_ENC_CMD_STOP
Nov 28 17:54:49 cmurrell kernel: [878782.059209] ivtv0:  info: close
stopping capture
Nov 28 17:54:49 cmurrell kernel: [878782.059214] ivtv0:  info: Stop Capture
Nov 28 17:54:51 cmurrell kernel: [878784.156135] ivtv0 encoder MPG:
VIDIOC_ENCODER_CMD cmd=1, flags=1
Nov 28 17:54:51 cmurrell kernel: [878784.166157] ivtv0:  ioctl:
V4L2_ENC_CMD_START
Nov 28 17:54:51 cmurrell kernel: [878784.166165] ivtv0:  info: Start
encoder stream encoder MPG
---

And from 15:00 to 18:00 recording fails?

Perhaps it would make sense to restart application upon driver failure,
now that output is more verbose.

Regards,

    Ezequiel

PS: Please don't drop linux-media list from Cc
